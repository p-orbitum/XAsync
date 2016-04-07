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
        [XAsync await:action];
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

@end

static void __taskPerform(void *info) {
    
}