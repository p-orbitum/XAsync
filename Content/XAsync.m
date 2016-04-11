//
//  Async.m
//
//  Created by Pavel Gorb on 4/6/16.
//

#import "XAsync.h"

static void __taskPerform(void *info);

NS_ASSUME_NONNULL_BEGIN

@interface XAsync ()

+ (CFRunLoopSourceRef)source;
+ (NSMutableDictionary *)signals;

@end

NS_ASSUME_NONNULL_END

@implementation XAsync

#pragma mark - Public logic

+ (void)await:(XAsyncAction)action {
    if (action == nil) {
        return;
    }
    
    [XAsync awaitAll:[NSSet setWithObject:action]];
}

+ (id _Nullable)awaitResult:(XAsyncActionResult)action {
    if (action == nil) {
        return nil;
    }
    
    CFRunLoopRef callerRunLoop = CFRunLoopGetCurrent();
    CFRunLoopSourceRef source = [self source];
    
    if (!CFRunLoopContainsSource(callerRunLoop, source, kCFRunLoopCommonModes)) {
        CFRunLoopAddSource(callerRunLoop, source, kCFRunLoopCommonModes);
    }
    
    id __block result = nil;
    NSInteger __block done = 0;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        result = action();
        done = 1;
        CFRunLoopSourceSignal(source);
        CFRunLoopWakeUp(callerRunLoop);
    });
    
    while(!done) {
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, true);
    }
    
    return result;
}

+ (void)awaitSequence:(NSArray <XAsyncAction> *)sequence {
    if (sequence.count == 0) {
        return;
    }
    
    for (XAsyncAction action in sequence) {
        [self await:action];
    }
}

+ (void)awaitAll:(NSSet <XAsyncAction> *)pool {
    if (pool.count == 0) {
        return;
    }
    
    CFRunLoopRef callerRunLoop = CFRunLoopGetCurrent();
    CFRunLoopSourceRef source = [self source];
    
    if (!CFRunLoopContainsSource(callerRunLoop, source, kCFRunLoopCommonModes)) {
        CFRunLoopAddSource(callerRunLoop, source, kCFRunLoopCommonModes);
    }
    
    NSInteger __block number = [pool count];
    for (XAsyncAction action in pool) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            action();
            if(--number == 0) {
                CFRunLoopSourceSignal(source);
                CFRunLoopWakeUp(callerRunLoop);
            }
        });
    }
    
    while(number) {
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, true);
    }
}

+ (void)awaitAny:(NSSet <XAsyncAction> *)pool {
    if (pool.count == 0) {
        return;
    }
    
    CFRunLoopRef callerRunLoop = CFRunLoopGetCurrent();
    CFRunLoopSourceRef source = [self source];
    
    if (!CFRunLoopContainsSource(callerRunLoop, source, kCFRunLoopCommonModes)) {
        CFRunLoopAddSource(callerRunLoop, source, kCFRunLoopCommonModes);
    }
    
    NSInteger __block done = 0;
    for (XAsyncAction action in pool) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            action();
            done = 1;

            CFRunLoopSourceSignal(source);
            CFRunLoopWakeUp(callerRunLoop);
        });
    }
    
    while(!done) {
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, true);
    }
}

+ (void)awaitSignal:(XAsyncActionSignal)action {
    if (action == nil) {
        return;
    }
    
    [self await:^{
        XAsyncID *sid = [[NSUUID UUID] UUIDString];
        dispatch_semaphore_t s = dispatch_semaphore_create(0);
        NSMutableDictionary *signals = [self signals];
        @synchronized (signals) {
            signals[sid] = s;
        }
        action(sid);
        dispatch_semaphore_wait(s, DISPATCH_TIME_FOREVER);
        @synchronized (signals) {
            [signals removeObjectForKey:sid];
        }
    }];
}

+ (id _Nullable)awaitSignalResult:(XAsyncActionSignalResult)action {
    if (action == nil) {
        return nil;
    }
    
    id __block result = nil;
    [self await:^{
        XAsyncID *sid = [[NSUUID UUID] UUIDString];
        dispatch_semaphore_t s = dispatch_semaphore_create(0);
        NSMutableDictionary *signals = [self signals];
        @synchronized (signals) {
            signals[sid] = s;
        }
        result = action(sid);
        dispatch_semaphore_wait(s, DISPATCH_TIME_FOREVER);
        @synchronized (signals) {
            [signals removeObjectForKey:sid];
        }
    }];
    return result;
}

+ (void)fireSignal:(XAsyncID *)signal {
    if (signal.length == 0) {
        return;
    }
    
    dispatch_semaphore_t candidate = nil;
    NSMutableDictionary *signals = [self signals];
    @synchronized (signals) {
        candidate = signals[signal];
    }
    if (candidate != nil) {
        dispatch_semaphore_signal(candidate);
    }
}

#pragma mark - Private logic

+ (CFRunLoopSourceRef)source {
    static CFRunLoopSourceRef __source;
    static dispatch_once_t __sourceToken;
    dispatch_once(&__sourceToken, ^{
        CFRunLoopSourceContext context;
        memset(&context, 0, sizeof(context));
        context.perform = __taskPerform;
        context.info = NULL;
        
        __source = CFRunLoopSourceCreate(NULL, 0, &context);
    });
    return __source;
}

+ (NSMutableDictionary *)signals {
    static NSMutableDictionary * __xa_signals = nil;
    static dispatch_once_t __signalToken;
    dispatch_once(&__signalToken, ^{
        __xa_signals = [[NSMutableDictionary alloc] init];
    });
    return __xa_signals;
}

@end

static void __taskPerform(void *info) {
    
}