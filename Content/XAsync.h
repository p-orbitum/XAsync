//
//  XAsync.h
//
//  Created by Pavlo Gorb on 4/6/16.
//

#import <Foundation/Foundation.h>

typedef NSString XAsyncID;

typedef void (^XAsyncAction)(void);
typedef id _Nullable (^XAsyncActionResult)(void);

typedef void (^XAsyncActionSignal)(XAsyncID * _Nonnull signal);
typedef id _Nullable (^XAsyncActionSignalResult)(XAsyncID * _Nonnull signal);

NS_ASSUME_NONNULL_BEGIN

@interface XAsync : NSObject

+ (void)awaitAll:(NSSet <XAsyncAction> *)pool;
+ (void)awaitAny:(NSSet <XAsyncAction> *)pool;
+ (void)await:(XAsyncAction)action;
+ (void)awaitSequence:(NSArray <XAsyncAction> *)sequence;
+ (id _Nullable)awaitResult:(XAsyncActionResult)action;

+ (void)awaitSignal:(XAsyncActionSignal)action;
+ (id _Nullable)awaitSignalResult:(XAsyncActionSignalResult)action;

+ (void)fireSignal:(XAsyncID *)signal;

@end

NS_ASSUME_NONNULL_END
