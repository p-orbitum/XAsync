//
//  main.swift
//  XAsyncSampleSwift
//
//  Created by Pavel Gorb on 4/11/16.
//  Copyright © 2016 Orbitum. All rights reserved.
//

import Foundation

// --------------- AWAIT ------------------- //
let t1 = XAsyncTask { (task) in
    print("Task 1 has been started.")
    for _ in 0..<1000000000 {
        
    }
    print("Task 1 is about to end.")
}
print("Task 1 is about to start.")
t1.await()
print("Task 1 has been done.")
print("<<<<<<<<<<<<<<<!!!!!!!!!!>>>>>>>>>>>>>>>>>>")
// --------------- AWAIT ------------------- //
// --------------- AWAIT RESULT ------------ //
let t2 = XAsyncTask { (task) in
    print("Task 2 has been started.")
    var i = 0
    for _ in 0..<1000000000 {
        i += 1;
    }
    print("Task 2 is about to end.")
    task?.result = i;
}
print("Task 2 is about to start.")
t2.await()
print("Task 2 has been done with result: \(t2.result)")
print("<<<<<<<<<<<<<<<!!!!!!!!!!>>>>>>>>>>>>>>>>>>")
// --------------- AWAIT RESULT ------------ //
// --------------- AWAIT SIGNAL ------------------- //
let t3 = XAsyncTask { (task) in
    print("Signal task 3 has been started.");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) {
        var i = 0;
        for _ in 0..<1000000000 {
            i += 1
        }
        task?.result = i
        task?.fireSignal()
    }
    print("Signal task 3 is about to end.")
}
t3.awaitSignal()
print("Signal task 3 has been done: \(t3.result)")
print("<<<<<<<<<<<<<<<!!!!!!!!!!>>>>>>>>>>>>>>>>>>")
// --------------- AWAIT SIGNAL ------------------- //
// ------------- AWAIT SEQUENCE ---------------- //
let one_s = XAsyncTask { (task) in
    print("Sequence task 1 has been started.")
    for _ in 0..<100000000 {
    }
    print("Sequence task 1 is about to end.")
}
let two_s = XAsyncTask { (task) in
    print("Sequence task 2 has been started.")
    for _ in 0..<100000000 {
    }
    print("Sequence task 2 is about to end.")
}
let three_s = XAsyncTask { (task) in
    print("Sequence task 3 has been started.")
    for _ in 0..<100000000 {
    }
    print("Sequence task 3 is about to end.")
}
print("About to start sequence.")
XAsyncTask.awaitSequence([one_s, two_s, three_s])
print("Sequence has been finished")
print("<<<<<<<<<<<<<<<!!!!!!!!!!>>>>>>>>>>>>>>>>>>")
// ---------------AWAIT SEQUENCE ------------------ //
// ------------- AWAIT ALL ---------------- //
let one_all = XAsyncTask { (task) in
    print("Pool task 1 has been started.")
    for _ in 0..<100000000 {
    }
    print("Pool task 1 is about to end.")
}
let two_all = XAsyncTask { (task) in
    print("Pool task 2 has been started.")
    for _ in 0..<100000000 {
    }
    print("Pool task 2 is about to end.")
}
let three_all = XAsyncTask { (task) in
    print("Pool task 3 has been started.")
    for _ in 0..<100000000 {
    }
    print("Pool task 3 is about to end.")
}
let four_all = XAsyncTask { (task) in
    print("Pool task 4 has been started.")
    for _ in 0..<100000000 {
    }
    print("Pool task 4 is about to end.")
}
let five_all = XAsyncTask { (task) in
    print("Pool task 5 has been started.")
    for _ in 0..<100000000 {
    }
    print("Pool task 5 is about to end.")
}
print("About to start all tasks' pool.")
XAsyncTask.awaitAll(Set(arrayLiteral: one_all, two_all, three_all, four_all, five_all))
print("Sequence has been finished")
print("<<<<<<<<<<<<<<<!!!!!!!!!!>>>>>>>>>>>>>>>>>>");
// ---------------AWAIT ALL ------------------ //
// ------------- AWAIT ANY ---------------- //
let one_any = XAsyncTask { (task) in
    print("Pool task 1 has been started.")
    for _ in 0..<100000000 {
    }
    print("Pool task 1 is about to end.")
}
let two_any = XAsyncTask { (task) in
    print("Pool task 2 has been started.")
    for _ in 0..<100000000 {
    }
    print("Pool task 2 is about to end.")
}
let three_any = XAsyncTask { (task) in
    print("Pool task 3 has been started.")
    for _ in 0..<100000000 {
    }
    print("Pool task 3 is about to end.")
}
let four_any = XAsyncTask { (task) in
    print("Pool task 4 has been started.")
    for _ in 0..<100000000 {
    }
    print("Pool task 4 is about to end.")
}
let five_any = XAsyncTask { (task) in
    print("Pool task 5 has been started.")
    for _ in 0..<100000000 {
    }
    print("Pool task 5 is about to end.")
}
print("About to start ANY.")
XAsyncTask.awaitAny(Set(arrayLiteral: one_all, two_all, three_all, four_all, five_all))
print("Waiting has been finished.")
print("<<<<<<<<<<<<<<<!!!!!!!!!!>>>>>>>>>>>>>>>>>>");
// ---------------AWAIT ANY ------------------ //
