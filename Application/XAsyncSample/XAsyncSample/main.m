//
//  main.m
//  XAsyncSample
//
//  Created by Pavel Gorb on 4/6/16.
//  Copyright © 2016 Orbitum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XAsync.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSLog(@"About to start async task 1.");
        [XAsync await:^{
            NSLog(@"Task 1 has been started.");
            for (NSInteger i = 0; i < 1000000000; i++) {
            }
            NSLog(@"Task 1 is about to end.");
        }];
        NSLog(@"Async task 1 has been done.");
        
        NSLog(@"About to start async task 2.");
        NSNumber *result = [XAsync awaitResult:^ id _Nullable {
            NSLog(@"Task 2 has been started.");
            NSInteger i = 0;
            for (i = 0; i < 1000000000; i++) {
            }
            NSLog(@"Task 2 is about to end.");
            return [NSNumber numberWithInteger:i];
        }];
        NSLog(@"Async task 2 has been done with result: %@", [result stringValue]);
    }
    return 0;
}
