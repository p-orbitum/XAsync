//
//  main.m
//  XAsyncSample
//
//  Created by Pavlo Gorb on 4/6/16.
//

#import <Foundation/Foundation.h>
#import "XAsync.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // --------------- AWAIT ------------------- //
        NSLog(@"About to start async task 1.");
        [XAsync await:^{
            NSLog(@"Task 1 has been started.");
            for (NSInteger i = 0; i < 1000000000; i++) {
            }
            NSLog(@"Task 1 is about to end.");
        }];
        NSLog(@"Async task 1 has been done.");
        // --------------- AWAIT ------------------- //
        NSLog(@"<<<<<<<<<<<<<<<!!!!!!!!!!>>>>>>>>>>>>>>>>>>");
        // --------------- AWAIT RESULT ------------ //
        NSLog(@"About to start async task 2.");
        NSNumber *result1 = [XAsync awaitResult:^ id _Nullable {
            NSLog(@"Task 2 has been started.");
            NSInteger i = 0;
            for (i = 0; i < 1000000000; i++) {
            }
            NSLog(@"Task 2 is about to end.");
            return [NSNumber numberWithInteger:i];
        }];
        NSLog(@"Async task 2 has been done with result: %@", [result1 stringValue]);
        // --------------- AWAIT RESULT ------------ //
        NSLog(@"<<<<<<<<<<<<<<<!!!!!!!!!!>>>>>>>>>>>>>>>>>>");
        // ------------- AWAIT SEQUENCE ---------------- //
        XAsyncAction action1 = ^ {
            NSLog(@"Action 1 has been started.");
            for (NSInteger i = 0; i < 100000000; i++) {
            }
            NSLog(@"Action 1 is about to end.");
        };
        XAsyncAction action2 = ^ {
            NSLog(@"Action 2 has been started.");
            for (NSInteger i = 0; i < 100000000; i++) {
            }
            NSLog(@"Action 2 is about to end.");
        };
        XAsyncAction action3 = ^ {
            NSLog(@"Action 3 has been started.");
            for (NSInteger i = 0; i < 100000000; i++) {
            }
            NSLog(@"Action 3 is about to end.");
        };
        NSLog(@"About to start sequence.");
        [XAsync awaitSequence:@[ action1, action2, action3 ]];
        NSLog(@"Sequence has been finished");
        // ---------------AWAIT SEQUENCE ------------------ //
        NSLog(@"<<<<<<<<<<<<<<<!!!!!!!!!!>>>>>>>>>>>>>>>>>>");
        // ------------- AWAIT ALL ---------------- //
        XAsyncAction action11 = ^ {
            NSLog(@"Action 1 has been started.");
            for (NSInteger i = 0; i < 1000000000; i++) {
            }
            NSLog(@"Action 1 is about to end.");
        };
        XAsyncAction action12 = ^ {
            NSLog(@"Action 2 has been started.");
            for (NSInteger i = 0; i < 1000000; i++) {
            }
            NSLog(@"Action 2 is about to end.");
        };
        XAsyncAction action13 = ^ {
            NSLog(@"Action 3 has been started.");
            for (NSInteger i = 0; i < 1000000; i++) {
            }
            NSLog(@"Action 3 is about to end.");
        };
        XAsyncAction action14 = ^ {
            NSLog(@"Action 4 has been started.");
            for (NSInteger i = 0; i < 1000000; i++) {
            }
            NSLog(@"Action 4 is about to end.");
        };
        XAsyncAction action15 = ^ {
            NSLog(@"Action 5 has been started.");
            for (NSInteger i = 0; i < 100000000; i++) {
            }
            NSLog(@"Action 5 is about to end.");
        };
        NSSet *pool1 = [NSSet setWithObjects:action11, action12, action13, action14, action15, nil];
        NSLog(@"About to start pool.");
        [XAsync awaitAll:pool1];
        NSLog(@"Pool has been finished");
        // ------------- AWAIT ALL ---------------- //
        NSLog(@"<<<<<<<<<<<<<<<!!!!!!!!!!>>>>>>>>>>>>>>>>>>");
        // ------------- AWAIT ANY ---------------- //
        XAsyncAction action21 = ^ {
            NSLog(@"Action 1 has been started.");
            for (NSInteger i = 0; i < 1000000000; i++) {
            }
            NSLog(@"Action 1 is about to end.");
        };
        XAsyncAction action22 = ^ {
            NSLog(@"Action 2 has been started.");
            for (NSInteger i = 0; i < 1000000; i++) {
            }
            NSLog(@"Action 2 is about to end.");
        };
        XAsyncAction action23 = ^ {
            NSLog(@"Action 3 has been started.");
            for (NSInteger i = 0; i < 1000000; i++) {
            }
            NSLog(@"Action 3 is about to end.");
        };
        XAsyncAction action24 = ^ {
            NSLog(@"Action 4 has been started.");
            for (NSInteger i = 0; i < 1000000; i++) {
            }
            NSLog(@"Action 4 is about to end.");
        };
        XAsyncAction action25 = ^ {
            NSLog(@"Action 5 has been started.");
            for (NSInteger i = 0; i < 100000000; i++) {
            }
            NSLog(@"Action 5 is about to end.");
        };
        NSSet *pool2 = [NSSet setWithObjects:action21, action22, action23, action24, action25, nil];
        NSLog(@"About to start ANY.");
        [XAsync awaitAny:pool2];
        NSLog(@"Waiting has been finished.");
        
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 5, false);
        // ------------- AWAIT ANY ---------------- //
        NSLog(@"<<<<<<<<<<<<<<<!!!!!!!!!!>>>>>>>>>>>>>>>>>>");
        // --------------- AWAIT SIGNAL ------------------- //
        NSLog(@"About to start signal task 1.");
        [XAsync awaitSignal:^ (XAsyncID *signal) {
            NSLog(@"Signal task 1 has been started.");
            for (NSInteger i = 0; i < 1000000000; i++) {
            }
            NSLog(@"Signal task 1 is about to end.");
            [XAsync fireSignal:signal];
        }];
        NSLog(@"Signal task 1 has been done.");
        // --------------- AWAIT SIGNAL ------------------- //
        NSLog(@"<<<<<<<<<<<<<<<!!!!!!!!!!>>>>>>>>>>>>>>>>>>");
        // --------------- AWAIT SIGNAL RESULT ------------ //
        NSLog(@"About to start signal task 2.");
        NSNumber *result2 = [XAsync awaitSignalResult:^id _Nullable(XAsyncID * _Nonnull signal) {
            NSLog(@"Signal task 2 has been started.");
            NSNumber *i = [XAsync awaitResult:^id _Nullable{
                NSInteger i = 0;
                for (i = 0; i < 1000000000; i++) {
                }
                return [NSNumber numberWithInteger:i];
            }];
            NSLog(@"Signal task 2 is about to end.");
            [XAsync fireSignal:signal];
            return i;
        }];
        NSLog(@"Signal task 2 has been done with result: %@", [result2 stringValue]);
        // --------------- AWAIT SIGNAL RESULT ------------ //
        NSLog(@"<<<<<<<<<<<<<<<!!!!!!!!!!>>>>>>>>>>>>>>>>>>");
    }
    return 0;
}
