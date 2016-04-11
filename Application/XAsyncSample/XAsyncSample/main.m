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
        // --------------- AWAIT ------------------- //
//        NSLog(@"About to start async task 1.");
//        [XAsync await:^{
//            NSLog(@"Task 1 has been started.");
//            for (NSInteger i = 0; i < 1000000000; i++) {
//            }
//            NSLog(@"Task 1 is about to end.");
//        }];
//        NSLog(@"Async task 1 has been done.");
        // --------------- AWAIT ------------------- //

        // --------------- AWAIT RESULT ------------ //
//        NSLog(@"About to start async task 2.");
//        NSNumber *result = [XAsync awaitResult:^ id _Nullable {
//            NSLog(@"Task 2 has been started.");
//            NSInteger i = 0;
//            for (i = 0; i < 1000000000; i++) {
//            }
//            NSLog(@"Task 2 is about to end.");
//            return [NSNumber numberWithInteger:i];
//        }];
//        NSLog(@"Async task 2 has been done with result: %@", [result stringValue]);
        // --------------- AWAIT RESULT ------------ //

        // ------------- AWAIT SEQUENCE ---------------- //
//        XAsyncAction action1 = ^ {
//            NSLog(@"Action 1 has been started.");
//            for (NSInteger i = 0; i < 100000000; i++) {
//            }
//            NSLog(@"Action 1 is about to end.");
//        };
//        XAsyncAction action2 = ^ {
//            NSLog(@"Action 2 has been started.");
//            for (NSInteger i = 0; i < 100000000; i++) {
//            }
//            NSLog(@"Action 2 is about to end.");
//        };
//        XAsyncAction action3 = ^ {
//            NSLog(@"Action 3 has been started.");
//            for (NSInteger i = 0; i < 100000000; i++) {
//            }
//            NSLog(@"Action 3 is about to end.");
//        };
//        NSLog(@"About to start sequence.");
//        [XAsync awaitSequence:@[ action1, action2, action3 ]];
//        NSLog(@"Sequence has been finished");
        // ---------------AWAIT SEQUENCE ------------------ //
        
        // ------------- AWAIT ALL ---------------- //
//        XAsyncAction action1 = ^ {
//            NSLog(@"Action 1 has been started.");
//            for (NSInteger i = 0; i < 1000000000; i++) {
//            }
//            NSLog(@"Action 1 is about to end.");
//        };
//        XAsyncAction action2 = ^ {
//            NSLog(@"Action 2 has been started.");
//            for (NSInteger i = 0; i < 1000000; i++) {
//            }
//            NSLog(@"Action 2 is about to end.");
//        };
//        XAsyncAction action3 = ^ {
//            NSLog(@"Action 3 has been started.");
//            for (NSInteger i = 0; i < 1000000; i++) {
//            }
//            NSLog(@"Action 3 is about to end.");
//        };
//        XAsyncAction action4 = ^ {
//            NSLog(@"Action 4 has been started.");
//            for (NSInteger i = 0; i < 1000000; i++) {
//            }
//            NSLog(@"Action 4 is about to end.");
//        };
//        XAsyncAction action5 = ^ {
//            NSLog(@"Action 5 has been started.");
//            for (NSInteger i = 0; i < 100000000; i++) {
//            }
//            NSLog(@"Action 5 is about to end.");
//        };
//        NSSet *pool = [NSSet setWithObjects:action1, action2, action3, action4, action5, nil];
//        NSLog(@"About to start pool.");
//        [XAsync awaitAll:pool];
//        NSLog(@"Pool has been finished");
        // ------------- AWAIT ALL ---------------- //
        
        // ------------- AWAIT ANY ---------------- //
//        XAsyncAction action1 = ^ {
//            NSLog(@"Action 1 has been started.");
//            for (NSInteger i = 0; i < 1000000000; i++) {
//            }
//            NSLog(@"Action 1 is about to end.");
//        };
//        XAsyncAction action2 = ^ {
//            NSLog(@"Action 2 has been started.");
//            for (NSInteger i = 0; i < 1000000; i++) {
//            }
//            NSLog(@"Action 2 is about to end.");
//        };
//        XAsyncAction action3 = ^ {
//            NSLog(@"Action 3 has been started.");
//            for (NSInteger i = 0; i < 1000000; i++) {
//            }
//            NSLog(@"Action 3 is about to end.");
//        };
//        XAsyncAction action4 = ^ {
//            NSLog(@"Action 4 has been started.");
//            for (NSInteger i = 0; i < 1000000; i++) {
//            }
//            NSLog(@"Action 4 is about to end.");
//        };
//        XAsyncAction action5 = ^ {
//            NSLog(@"Action 5 has been started.");
//            for (NSInteger i = 0; i < 100000000; i++) {
//            }
//            NSLog(@"Action 5 is about to end.");
//        };
//        NSSet *pool = [NSSet setWithObjects:action1, action2, action3, action4, action5, nil];
//        NSLog(@"About to start ANY.");
//        [XAsync awaitAny:pool];
//        NSLog(@"Waiting has been finished.");
//        
//        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 5, false);
        // ------------- AWAIT ANY ---------------- //
        
        // --------------- AWAIT SIGNAL ------------------- //
//        NSLog(@"About to start async task 1.");
//        [XAsync awaitSignal:^ (XAsyncID *signal) {
//            NSLog(@"Task 1 has been started.");
//            for (NSInteger i = 0; i < 1000000000; i++) {
//            }
//            NSLog(@"Task 1 is about to end.");
//            [XAsync xaFireSignal:signal];
//        }];
//        NSLog(@"Async task 1 has been done.");
        // --------------- AWAIT SIGNAL ------------------- //
        
        // --------------- AWAIT SIGNAL RESULT ------------ //
//        NSLog(@"About to start async task 2.");
//        NSNumber *result = [XAsync awaitSignalResult:^id _Nullable(XAsyncID * _Nonnull signal) {
//            NSLog(@"Task 2 has been started.");
//            NSNumber *i = [XAsync awaitResult:^id _Nullable{
//                NSInteger i = 0;
//                for (i = 0; i < 1000000000; i++) {
//                }
//                return [NSNumber numberWithInteger:i];
//            }];
//            NSLog(@"Task 2 is about to end.");
//            [XAsync xaFireSignal:signal];
//            return i;
//        }];
//        NSLog(@"Async task 2 has been done with result: %@", [result stringValue]);
        // --------------- AWAIT SIGNAL RESULT ------------ //
    }
    return 0;
}
