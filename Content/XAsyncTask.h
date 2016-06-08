//
//  XAsyncTask.h
//  XAsyncSample
//
//  Created by Pavel Gorb on 4/13/16.
//  Copyright © 2016 Orbitum. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XAsyncTask;
typedef void (^XAsyncTaskAction)(XAsyncTask __weak * _Nullable task);

NS_ASSUME_NONNULL_BEGIN

@interface XAsyncTask : NSObject

@property (nonatomic, copy, readonly) XAsyncTaskAction action;
@property (nonatomic, strong) id _Nullable result;

- (NSError * _Nullable)error;

- (instancetype)initWithAction:(XAsyncTaskAction)action;
+ (instancetype)taskWithAction:(XAsyncTaskAction)action;

- (void)await;

+ (void)awaitAll:(NSSet<XAsyncTask *> *)pool;
+ (void)awaitAny:(NSSet<XAsyncTask *> *)pool;
+ (void)awaitSequence:(NSArray <XAsyncTask *> *)sequence;

- (void)awaitSignal;
- (void)fireSignal;

@end

NS_ASSUME_NONNULL_END
