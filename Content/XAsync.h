//
//  Async.h
//
//  Created by Pavlo Gorb on 4/6/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XAsync : NSObject

+ (void)await:(void (^)(void))task;
+ (id _Nullable)awaitResult:(id _Nullable (^)(void))task;

@end

NS_ASSUME_NONNULL_END
