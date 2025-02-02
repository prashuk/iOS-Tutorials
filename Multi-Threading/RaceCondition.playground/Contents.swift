import UIKit
import Foundation
import os
/*
 
 https://www.linkedin.com/pulse/understanding-managing-race-conditions-swift-6-min-read-essam-fahmy-m77nf/
 
 - Example
 class Counter: @unchecked Sendable {
     private var value = 0

     func increment() {
         value += 1
     }

     func getValue() -> Int {
         return value
     }
 }

 let counter = Counter()
 DispatchQueue.concurrentPerform(iterations: 1000) { _ in
     counter.increment()
 }
 print(counter.getValue()) // Output is not 1000!
 
 /// Increment method is not thread-safe, some increments are lost due to simultaneous access
 
  */
 
// --------------------------------------------------------------------------------------------------------------

// Techniques to Prevent Race Conditions

/*
  
 1. Using DispatchQueue for Thread Safety
 
 class Counter: @unchecked Sendable {
    private var value = 0
    private let queue = DispatchQueue(label: "com.prashuk.increment")
    
    func increment() {
        queue.async {
            value += 1
        }
    }
    
    func getValue() -> Int {
        queue.sync {
            return value
        }
    }
 }

 let counter = Counter()
 DispatchQueue.concurrentPerform(iterations: 100) { _ in
     counter.increment()
 }
 counter.getValue()

  
 Use DispatchQueue when you want simplicity and compatibility with existing code. It’s best for cases where you need thread safety without performance concerns or complex logic.
  
  */

// --------------------------------------------------------------------------------------------------------------
 
 /*
  
 1.1. A Concurrent Queue with .barrier
 The .barrier ensures that a specific task is executed in isolation by blocking all other concurrent tasks from accessing the queue while the barrier task runs. For that moment, it essentially behaves like a serial queue for the task.
 
 class Counter: @unchecked Sendable {
     private var value = 0
     private let queue = DispatchQueue(label: "com.example.counterQueue", attributes: .concurrent)
     
     func increment() {
         queue.async(flags: .barrier) {
             self.value += 1
         }
     }

     func getValue() -> Int {
         queue.sync {
             self.value
         }
     }
 }

 let counter = Counter()

 // Use a DispatchGroup to wait for all increments to finish.
 // Even though we are using a concurrent queue for performance,
 // we still need to ensure that the increment operations are fully completed
 // before accessing the final value. The DispatchGroup will help track
 // when all the increment tasks have finished, even if some write operations
 // overlap due to the concurrent execution. This ensures that we wait
 // for all tasks to finish before printing the final value.
 let dispatchGroup = DispatchGroup()

 // Perform 1000 concurrent increments
 DispatchQueue.concurrentPerform(iterations: 1000) { _ in
     dispatchGroup.enter()
     counter.increment()
     dispatchGroup.leave()
 }

 // Wait for all increments to finish before printing the value
 dispatchGroup.wait() // This makes sure that print only happens after all the concurrent increment operations are finished
 print(counter.getValue()) // Always print 1000
  
  
  Why sync or async?
  Although it’s not our main focus today, here’s a quick hint: Whether you’re using a concurrent queue or a serial queue, the key question is:

  Do you need to wait for the result?
  If the result is needed immediately, such as printing a value, use sync.
  If the result can be handled whenever it is completed, then async.

  For example, in the Counter example:
  getValue uses sync because the value needs to be retrieved and returned immediately.
  increment uses async because the update doesn’t require immediate confirmation.
 
 */

// --------------------------------------------------------------------------------------------------------------

/*
 
 2. Using NSLock for Mutual Exclusion
 NSLock provides a simple way to lock and unlock a critical section.
 Atomic properties are thread safe
 NonAtomic are not thread safe

 class Counter: @unchecked Sendable {
     private var value = 0
     private let lock = NSLock()

     func increment() {
         lock.lock()
         value += 1
         lock.unlock()
     }

     func getValue() -> Int {
         lock.lock()
         let currentValue = value
         lock.unlock()
         return currentValue
     }
 }

 let counter = Counter()
 DispatchQueue.concurrentPerform(iterations: 1000) { _ in
     counter.increment()
 }
 print(counter.getValue()) // Always 1000
 
 
 Use NSLock when you need mutual exclusion in basic scenarios or for simple locking. It’s widely supported, but be cautious of deadlocks if multiple locks are involved.
 
 */

// --------------------------------------------------------------------------------------------------------------

/*
 
 3. Using os_unfair_lock for High Performance
 os_unfair_lock is a lightweight, low-level lock suitable for performance-critical tasks.

 class Counter: @unchecked Sendable {
     private var value = 0
     private var lock = os_unfair_lock_s()

     func increment() {
         os_unfair_lock_lock(&lock)
         value += 1
         os_unfair_lock_unlock(&lock)
     }

     func getValue() -> Int {
         os_unfair_lock_lock(&lock)
         let currentValue = value
         os_unfair_lock_unlock(&lock)
         return currentValue
     }
 }

 let counter = Counter()
 DispatchQueue.concurrentPerform(iterations: 1000) { _ in
     counter.increment()
 }
 print(counter.getValue()) // Always 1000
 
 
 Choose os_unfair_lock when performance is paramount, especially in high-frequency or low-latency operations. It’s faster than NSLock, but requires careful handling as it’s a low-level API.
 
 */

// --------------------------------------------------------------------------------------------------------------

/*
 
 4. Using Actors in Swift Concurrency
 - Actors are designed to isolate mutable states, providing the simplest and most modern solution for avoiding race conditions.
 - Using Actors we can protect shared resources from data race
 - Responsibility of the framework to isolate changes to shared resources
 - Reference type - can have properties, functions, generics
 - Class vs Actor - No inheritance in actor
 - Actor confirms to protocol as well
 
 actor Counter {
     private var value = 0

     func increment() {
         value += 1
     }

     func getValue() -> Int {
         value
     }
 }
 let counter = Counter()
 Task {
     await withTaskGroup(of: Void.self) { group in
         for _ in 1...1000 {
             group.addTask {
                 await counter.increment()
             }
         }
     }

     print(await counter.getValue()) // Always 1000
 }
 
 Use actors when you’re working with Swift 5.5+ and Swift Concurrency. They offer the safest, most modern solution for managing state across threads and are perfect for new codebases.
 
 See another example of actor at the end.
 
 */

// --------------------------------------------------------------------------------------------------------------

/*
 
 5. Using NSRecursiveLock for Reentrant Code
 NSRecursiveLock allows the same thread to acquire the lock multiple times without deadlocking, making it useful for recursive methods.

 class Counter {
     private var value = 0
     private let lock = NSRecursiveLock()

     func increment() {
         lock.lock()
         value += 1
         lock.unlock()
     }

     func getValue() -> Int {
         lock.lock()
         let currentValue = value
         lock.unlock()
         return currentValue
     }
 }
 let counter = Counter()
 DispatchQueue.concurrentPerform(iterations: 1000) { _ in
     counter.increment()
 }
 print(counter.getValue()) // Always 1000
 
 */

// Another example from Actor/Await/Task/Async

actor Flight {
    let company = "Airline"
    var availableSeats = ["1A", "1B", "1C"]
    
    func getAvailableSeats() -> [String] {
        return availableSeats
    }
    
    func bookSeat() -> String {
        let bookedSeat = availableSeats.first ?? ""
        availableSeats.removeFirst()
        return bookedSeat
    }
}

let flight = Flight()
let queue1 = DispatchQueue(label: "queue1")
let queue2 = DispatchQueue(label: "queue2")
queue1.async {
    Task {
        let bookedSeats = await flight.bookSeat()
        print(bookedSeats)
    }
}
queue2.async {
    Task {
        let availableSeats = await flight.availableSeats
        print(availableSeats)
    }
}

// If there is an any updates on the UI side. Previously we used DispatchQueue.main.async
// But now from Swift 5.5, We can use @MainActor
// @MainActor -> Singleton actor whose4 execution equivalent to main dispatch queue

@MainActor
func updateLable(seat: String) {
//    seatLabel.text = seat
}
