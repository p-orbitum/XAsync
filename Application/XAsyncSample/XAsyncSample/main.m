//
//  main.m
//  XAsyncSample
//
//  Created by Pavlo Gorb on 4/6/16.
//

#import <Foundation/Foundation.h>
#import "XAsyncTask.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // --------------- AWAIT ------------------- //
        XAsyncTask *t1 = [XAsyncTask taskWithAction:^(XAsyncTask * __weak _Nonnull task) {
            NSLog(@"Task 1 has been started.");
            for (NSInteger i = 0; i < 1000000000; i++) {
            }
            NSLog(@"Task 1 is about to end.");
        }];
        NSLog(@"About to start async task 1.");
        [t1 await];
        NSLog(@"Async task 1 has been done.");
        NSLog(@"<<<<<<<<<<<<<<<!!!!!!!!!!>>>>>>>>>>>>>>>>>>");
        // --------------- AWAIT ------------------- //
        // --------------- AWAIT RESULT ------------ //
        XAsyncTask *t2 = [XAsyncTask taskWithAction:^(XAsyncTask * __weak _Nonnull task) {
                NSLog(@"Task 2 has been started.");
                NSInteger i = 0;
                for (i = 0; i < 1000000000; i++) {
                }
                NSLog(@"Task 2 is about to end.");
                task.result = [NSNumber numberWithInteger:i];
        }];
        NSLog(@"About to start async task 2.");
        [t2 await];
        NSLog(@"Async task 2 has been done with result: %@", [(NSNumber *)t2.result stringValue]);
        // --------------- AWAIT RESULT ------------ //
        // --------------- AWAIT SIGNAL ------------------- //
        NSLog(@"About to start signal task 3.");
        XAsyncTask *t3 = [XAsyncTask taskWithAction:^(XAsyncTask *__weak  _Nonnull task) {
            NSLog(@"Signal task 3 has been started.");
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                NSInteger i = 0;
                for (i = 0; i < 1000000000; i++) {
                }
                task.result = [NSNumber numberWithInteger:i];
                [task fireSignal];
            });
            NSLog(@"Signal task 3 is about to end.");
        }];
        [t3 awaitSignal];
        NSLog(@"Signal task 3 has been done: %@", [(NSNumber *)t3.result stringValue]);
        NSLog(@"<<<<<<<<<<<<<<<!!!!!!!!!!>>>>>>>>>>>>>>>>>>");
        // --------------- AWAIT SIGNAL ------------------- //
        // ------------- AWAIT SEQUENCE ---------------- //
        XAsyncTask *one_s = [XAsyncTask taskWithAction:^(XAsyncTask *__weak  _Nullable task) {
            NSLog(@"Sequence task 1 has been started.");
            for (NSInteger i = 0; i < 100000000; i++) {
            }
            NSLog(@"Sequence task 1 is about to end.");
        }];
        XAsyncTask *two_s = [XAsyncTask taskWithAction:^(XAsyncTask *__weak  _Nullable task) {
            NSLog(@"Sequence task 2 has been started.");
            for (NSInteger i = 0; i < 100000000; i++) {
            }
            NSLog(@"Sequence task 2 is about to end.");
        }];
        XAsyncTask *three_s = [XAsyncTask taskWithAction:^(XAsyncTask *__weak  _Nullable task) {
            NSLog(@"Sequence task 3 has been started.");
            for (NSInteger i = 0; i < 100000000; i++) {
            }
            NSLog(@"Sequence task 3 is about to end.");
        }];
        NSLog(@"About to start sequence.");
        [XAsyncTask awaitSequence:@[ one_s, two_s, three_s ]];
        NSLog(@"Sequence has been finished");
        NSLog(@"<<<<<<<<<<<<<<<!!!!!!!!!!>>>>>>>>>>>>>>>>>>");
        // ---------------AWAIT SEQUENCE ------------------ //
        // ------------- AWAIT ALL ---------------- //
        XAsyncTask *one_all = [XAsyncTask taskWithAction:^(XAsyncTask *__weak  _Nullable task) {
            NSLog(@"Pool task 1 has been started.");
            for (NSInteger i = 0; i < 100000000; i++) {
            }
            NSLog(@"Pool task 1 is about to end.");
        }];
        XAsyncTask *two_all = [XAsyncTask taskWithAction:^(XAsyncTask *__weak  _Nullable task) {
            NSLog(@"Pool task 2 has been started.");
            for (NSInteger i = 0; i < 100000000; i++) {
            }
            NSLog(@"Pool task 2 is about to end.");
        }];
        XAsyncTask *three_all = [XAsyncTask taskWithAction:^(XAsyncTask *__weak  _Nullable task) {
            NSLog(@"Pool task 3 has been started.");
            for (NSInteger i = 0; i < 100000000; i++) {
            }
            NSLog(@"Pool task 3 is about to end.");
        }];
        XAsyncTask *four_all = [XAsyncTask taskWithAction:^(XAsyncTask *__weak  _Nullable task) {
            NSLog(@"Pool task 4 has been started.");
            for (NSInteger i = 0; i < 100000000; i++) {
            }
            NSLog(@"Pool task 4 is about to end.");
        }];
        XAsyncTask *five_all = [XAsyncTask taskWithAction:^(XAsyncTask *__weak  _Nullable task) {
            NSLog(@"Pool task 5 has been started.");
            for (NSInteger i = 0; i < 100000000; i++) {
            }
            NSLog(@"Pool task 5 is about to end.");
        }];
        NSSet *poolAll = [NSSet setWithObjects:one_all, two_all, three_all, four_all, five_all, nil];
        NSLog(@"About to start pool.");
        [XAsyncTask awaitAll:poolAll];
        NSLog(@"Pool has been finished");
        NSLog(@"<<<<<<<<<<<<<<<!!!!!!!!!!>>>>>>>>>>>>>>>>>>");
        // ------------- AWAIT ALL ---------------- //
        // ------------- AWAIT ANY ---------------- //
        XAsyncTask *one_any = [XAsyncTask taskWithAction:^(XAsyncTask *__weak  _Nullable task) {
            NSLog(@"Pool task 1 has been started.");
            for (NSInteger i = 0; i < 100000000; i++) {
            }
            NSLog(@"Pool task 1 is about to end.");
        }];
        XAsyncTask *two_any = [XAsyncTask taskWithAction:^(XAsyncTask *__weak  _Nullable task) {
            NSLog(@"Pool task 2 has been started.");
            for (NSInteger i = 0; i < 100000000; i++) {
            }
            NSLog(@"Pool task 2 is about to end.");
        }];
        XAsyncTask *three_any = [XAsyncTask taskWithAction:^(XAsyncTask *__weak  _Nullable task) {
            NSLog(@"Pool task 3 has been started.");
            for (NSInteger i = 0; i < 100000000; i++) {
            }
            NSLog(@"Pool task 3 is about to end.");
        }];
        XAsyncTask *four_any = [XAsyncTask taskWithAction:^(XAsyncTask *__weak  _Nullable task) {
            NSLog(@"Pool task 4 has been started.");
            for (NSInteger i = 0; i < 100000000; i++) {
            }
            NSLog(@"Pool task 4 is about to end.");
        }];
        XAsyncTask *five_any = [XAsyncTask taskWithAction:^(XAsyncTask *__weak  _Nullable task) {
            NSLog(@"Pool task 5 has been started.");
            for (NSInteger i = 0; i < 100000000; i++) {
            }
            NSLog(@"Pool task 5 is about to end.");
        }];
        NSSet *poolAny = [NSSet setWithObjects:one_any, two_any, three_any, four_any, five_any, nil];
        NSLog(@"About to start ANY.");
        [XAsyncTask awaitAny:poolAny];
        NSLog(@"Waiting has been finished.");
        
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 5, false);
        NSLog(@"<<<<<<<<<<<<<<<!!!!!!!!!!>>>>>>>>>>>>>>>>>>");
        // ------------- AWAIT ANY ---------------- //
    }
    return 0;
}
