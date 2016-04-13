//
//  XAsync.m
//
//  Created by Pavlo Gorb on 4/6/16.
//

#import "XAsync.h"

static void __taskPerform(void *info);

NS_ASSUME_NONNULL_BEGIN

@interface XAsyncManager : NSObject

@property (atomic, assign) CFRunLoopSourceRef source;
@property (atomic, strong) NSMutableDictionary *signals;
@property (atomic, strong) NSLock *signalsLock;

+ (XAsyncManager *)sharedManager;

- (void)awaitAll:(NSSet <XAsyncAction> *)pool;
- (void)awaitAny:(NSSet <XAsyncAction> *)pool;
- (void)await:(XAsyncAction)action;
- (void)awaitSequence:(NSArray <XAsyncAction> *)sequence;
- (id _Nullable)awaitResult:(XAsyncActionResult)action;

- (void)awaitSignal:(XAsyncActionSignal)action;
- (id _Nullable)awaitSignalResult:(XAsyncActionSignalResult)action;

- (void)fireSignal:(XAsyncID *)signalId;

@end

NS_ASSUME_NONNULL_END

@implementation XAsyncManager

@synthesize source = _source;
@synthesize signals = _signals;
@synthesize signalsLock = _signalsLock;

- (instancetype)init {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    CFRunLoopSourceContext context;
    memset(&context, 0, sizeof(context));
    context.perform = __taskPerform;
    context.info = NULL;
    
    _source = CFRunLoopSourceCreate(NULL, 0, &context);
    _signals = [[NSMutableDictionary alloc] init];
    _signalsLock = [[NSLock alloc] init];
    
    return self;
}

+ (XAsyncManager *)sharedManager {
    static XAsyncManager *__xa_manager = nil;
    static dispatch_once_t __xa_manager_token;
    dispatch_once(&__xa_manager_token, ^{
        __xa_manager = [[XAsyncManager alloc] init];
    });
    return __xa_manager;
}


- (void)awaitAll:(NSSet<XAsyncAction> *)pool {
    if (pool.count == 0) {
        return;
    }
    
    CFRunLoopRef callerRunLoop = CFRunLoopGetCurrent();
    if (!CFRunLoopContainsSource(callerRunLoop, self.source, kCFRunLoopCommonModes)) {
        CFRunLoopAddSource(callerRunLoop, self.source, kCFRunLoopCommonModes);
    }
    
    NSInteger __block number = [pool count];
    for (XAsyncAction action in pool) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            action();
            if(--number == 0) {
                CFRunLoopSourceSignal(self.source);
                CFRunLoopWakeUp(callerRunLoop);
            }
        });
    }
    
    while(number) {
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, true);
    }
}

- (void)awaitAny:(NSSet<XAsyncAction> *)pool {
    if (pool.count == 0) {
        return;
    }
    
    CFRunLoopRef callerRunLoop = CFRunLoopGetCurrent();
    if (!CFRunLoopContainsSource(callerRunLoop, self.source, kCFRunLoopCommonModes)) {
        CFRunLoopAddSource(callerRunLoop, self.source, kCFRunLoopCommonModes);
    }
    
    NSInteger __block done = 0;
    for (XAsyncAction action in pool) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            action();
            done = 1;
            
            CFRunLoopSourceSignal(self.source);
            CFRunLoopWakeUp(callerRunLoop);
        });
    }
    
    while(!done) {
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, true);
    }
}

- (void)await:(XAsyncAction)action {
    [self awaitAll:[NSSet setWithObject:action]];
}

- (void)awaitSequence:(NSArray <XAsyncAction> *)sequence {
    if (sequence.count == 0) {
        return;
    }
    
    for (XAsyncAction action in sequence) {
        [self await:action];
    }
}

- (id)awaitResult:(XAsyncActionResult)action {
    if (action == nil) {
        return nil;
    }
    
    CFRunLoopRef callerRunLoop = CFRunLoopGetCurrent();
    if (!CFRunLoopContainsSource(callerRunLoop, self.source, kCFRunLoopCommonModes)) {
        CFRunLoopAddSource(callerRunLoop, self.source, kCFRunLoopCommonModes);
    }
    
    id __block result = nil;
    NSInteger __block done = 0;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        result = action();
        done = 1;
        CFRunLoopSourceSignal(self.source);
        CFRunLoopWakeUp(callerRunLoop);
    });
    
    while(!done) {
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, true);
    }
    
    return result;
}

- (void)awaitSignal:(XAsyncActionSignal)action {
    if (action == nil) {
        return;
    }
    
    [self await:^{
        XAsyncID *sid = [[NSUUID UUID] UUIDString];
        dispatch_semaphore_t s = dispatch_semaphore_create(0);
        [self.signalsLock lock];
        self.signals[sid] = s;
        [self.signalsLock unlock];

        action(sid);
        dispatch_semaphore_wait(s, DISPATCH_TIME_FOREVER);
        
        [self.signalsLock lock];
        [self.signals removeObjectForKey:sid];
        [self.signalsLock unlock];
    }];
}

- (id)awaitSignalResult:(XAsyncActionSignalResult)action {
    if (action == nil) {
        return nil;
    }
    
    id __block result = nil;
    [self await:^{
        XAsyncID *sid = [[NSUUID UUID] UUIDString];
        dispatch_semaphore_t s = dispatch_semaphore_create(0);
        [self.signalsLock lock];
        self.signals[sid] = s;
        [self.signalsLock unlock];
        
        result = action(sid);
        dispatch_semaphore_wait(s, DISPATCH_TIME_FOREVER);
        
        [self.signalsLock lock];
        [self.signals removeObjectForKey:sid];
        [self.signalsLock unlock];
    }];
    return result;
}

- (void)fireSignal:(XAsyncID *)signalId {
    if (signalId.length == 0) {
        return;
    }
    
    dispatch_semaphore_t candidate = nil;
    [self.signalsLock lock];
    candidate = self.signals[signalId];
    [self.signalsLock unlock];
    
    if (candidate != nil) {
        dispatch_semaphore_signal(candidate);
    }
}

@end


@implementation XAsync

+ (void)awaitAll:(NSSet <XAsyncAction> *)pool {
    [[XAsyncManager sharedManager] awaitAll:pool];
}

+ (void)awaitAny:(NSSet <XAsyncAction> *)pool {
    [[XAsyncManager sharedManager] awaitAny:pool];
}

+ (void)await:(XAsyncAction)action {
    [[XAsyncManager sharedManager] await:action];
}

+ (void)awaitSequence:(NSArray <XAsyncAction> *)sequence {
    [[XAsyncManager sharedManager] awaitSequence:sequence];
}

+ (id _Nullable)awaitResult:(XAsyncActionResult)action {
    return [[XAsyncManager sharedManager] awaitResult:action];
}


+ (void)awaitSignal:(XAsyncActionSignal)action {
    [[XAsyncManager sharedManager] awaitSignal:action];
}

+ (id _Nullable)awaitSignalResult:(XAsyncActionSignalResult)action {
    return [[XAsyncManager sharedManager] awaitSignalResult:action];
}

+ (void)fireSignal:(XAsyncID *)signal {
    [[XAsyncManager sharedManager] fireSignal:signal];
}

@end

static void __taskPerform(void *info) {
    
}