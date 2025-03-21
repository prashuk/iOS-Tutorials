import Foundation


/*
 Concurrency -
 Multiple instruction at same time, but one task at a time
 
 Parallelism -
 Multiple processing simultaneously
 */

/*
 
 Serial Queue -
 One task at a time
 
 Concurrent Queue -
 Multiple task at a time
 
 */

/*
 
 Manner of execution
 Synchronous -
 Block the execution till the task is completed
 
 Asynchronous -
 Don't block the current execution. Continue the execution of current task, while new task execute asynchronously
 
 */

/*
 Even for concurrent, task will be dequeued serially. In fixed order i.e. FIFO
 */


// Main Queue
var counter = 1
DispatchQueue.main.async { // DispatchQueue.main is a serial queue, so one task at a time, but executing in async way, will not block the current task
    for i in 0...3 {
        counter = i
        print("\(counter)")
    }
}
for i in 4...6 {
    counter = i
    print("\(counter)")
}
DispatchQueue.main.async {
    counter = 9
    print("\(counter)")
}


// Global Queue
DispatchQueue.main.async {
    print(Thread.isMainThread ? "A" :  "B")
}
DispatchQueue.global(qos: .userInteractive).async {
    print(Thread.isMainThread ? "C" : "D")
}


// QoS

