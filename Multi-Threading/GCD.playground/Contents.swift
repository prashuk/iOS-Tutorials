import UIKit
// MARK:- Step 1 (Simple Queue)
/*:
 In Swift 3, the simplest way to create a new dispatch queue is the following:
 let queue = DispatchQueue(label: "com.appcoda.myqueue")
 
 Once the queue is created, then we can execute code with it, either synchronously using a method called sync, or asynchronously using a method called async.
 
 As we’re just getting started, we’ll provide the code as a block (a closure). Later we’ll initialise and use dispatch work items (DispatchWorkItem) objects instead of a block (note that the block is also considered as a work item for a queue).
 
 We’ll begin with the synchronous execution, and we’ll do nothing more than just displaying numbers from 50 to 59
 
 Watching the Xcode console, you’ll see that nothing fancy happens; you’ll just see some numbers appearing, and that doesn’t help us to make any conclusions about how GCD works. So, update your code in the simpleQueues() method by adding another block of code right after the queue’s closure. Its purpose is to display numbers from 100 to 109 (just to make the difference)
 
 The above for loop will be executed on the main queue, while the first one will be run on the background. The program execution will stop though in the queue’s block; It won’t continue to the main thread’s loop and it won’t display the numbers from 100 to 109 until the queue’s task has finished. And that happens because we make a synchronous execution.
 
 But what will happen if we use the async method and let the queue’s code block be executed asynchronously? Well in that case the program execution won’t stop waiting for the task of the queue to finish; it will immediately return to the main thread and the second for loop will be executed at the same time with the queue’s loop.
 
 Comparing to the synchronous execution, this case is quite more interesting; you see that the code on the main queue (the second for loop) and the code of our dispatch queue run in parallel. Our custom queue could have actually get more running time at the beginning, but that’s just a matter of priorities (and we’ll see it next). The important here is to make clear that our main queue is free to “work” while we have another task running on the background, and this didn’t happen on the synchronous execution of the queue.
 
 Even though the above examples are quite simple, it shows perfectly clear how a program behaves with queues running synchronously and asynchronously.
 */

func simpleQueues() {
    // Custom Queue
    let queue = DispatchQueue(label: "com.prashuk.myqueue")
    
    // Sync Thread -- high priority
    //    queue.sync {
    //        for i in 50..<60 {
    //            print("🟣", i)
    //        }
    //    }
    
    // Async Thread -- low priority
    queue.async {
        for i in 0..<10 {
            print("🔴", i)
        }
    }
    
    // Main Thread
    for i in 100..<110 {
        print("Ⓜ️", i)
    }
}
// simpleQueues()



// MARK:- Step 2 (qos)
/*:
 Quality Of Service (QoS) and Priorities
 
 Tasks running on the main thread have always the highest priority, as the main queue also deals with the UI and keeps the app responsive.
 
 That information regarding the importance and priority of the tasks is called in GCD Quality of Service (QoS). In truth, QoS is an enum with specific cases, and by providing the proper QoS value upon the queue initialisation you specify the desired priority. If no QoS is defined, then a default priority is given by to the queue.
 
 The following list summarises the available QoS cases, also called QoS classes. The first class means the highest priority, the last one the lowest priority:
 userInteractive
 userInitiated
 default
 utility
 background
 unspecified
 
 Back to our project now, we’re going to work on the queuesWithQoS().
 
 Notice that we assign the same QoS class in both of them, so they have the same priority during execution. Like we did previously, the first queue will contain a for loop that displays values from 0 to 9 (plus the red dot). In the second queue we’ll execute another for loop and we’ll display values from 100 to 109 (with a blue dot).
 
 Both tasks are “evenly” executed, and actually this is what we expect to happen.
 
 Now, let’s change the QoS class of the queue2 to utility (lower priority)
 
 Undoubtedly, the first dispatch queue (queue1) is executed faster than the second one, as it’s given a higher priority. Even though the queue2 gets an opportunity of execution while the first one is running, the system provides its resources mostly to the first queue as it was marked as a more important one. Once it gets finished, then the system takes care of the second queue.
 
 Let’s do another experiment, and this time let’s change the QoS class of the first queue to background.
 
 This time the second queue finishes faster, as the utility QoS class gives a higher priority against the background QoS class.
 
 Ok, all the above makes clear how QoS classes work, but what happens if we perform a task on the main queue as well? Let’s add the for loop code at the end of our method
 
 Also, let’s change once again the QoS class of the first queue by setting a higher priority
 
 Once again, we see that the main queue has a high priority by default, and the queue1 dispatch queue is executed in parallel to the main one. The queue2 finishes last and doesn’t get many opportunities in execution while the tasks of the other two queues are being executed, as it has the lowest priority.
 */

func queuesWithQoS() {
    // Custom Queue with same priority
    let queue1 = DispatchQueue(label: "com.prashuk.q1", qos: .userInitiated)
    //    let queue2 = DispatchQueue(label: "com.prashuk.q2", qos: .userInitiated)
    
    let queue2 = DispatchQueue(label: "com.prashuk.q2", qos: .utility)
    
    //    let queue1 = DispatchQueue(label: "com.prashuk.q1", qos: .background)
    
    // Asyn Call for both queues
    queue1.async {
        for i in 50..<60 {
            print("🟢", i)
        }
    }
    queue2.async {
        for i in 0..<10 {
            print("🔴", i)
        }
    }
    
    // Main Thread
    for i in 100..<110 {
        print("Ⓜ️", i)
    }
}
// queuesWithQoS()



// MARK:- Step 3 (concurrentQueues)
/*:
 Concurrent Queues
 
 So far we’ve seen how dispatch queues work synchronously and asynchronously, and how the Quality of Service class affects the priority that the system gives to them. The common thing to all the previous examples is the fact that our queues are serial. That means that if we would assign more than one tasks to any queue, then those tasks would have been executed one after another, and not all together. In this part we’ll see how we can make multiple tasks (work items) run at the same time, or in other words we’ll see how to make a concurrent queue.
 
 anotherQueue create a queue and assign three async task to it. When this code is run, the tasks will be executed in a serial mode.
 
 Next, let’s modify the initialisation of the anotherQueue queue: attributes: .concurrent
 
 There’s a new argument in the above initialisation: The attributes parameter. When this parameter is present with the concurrent value, then all tasks of the specific queue will be executed simultaneously. If you don’t use this parameter, then the queue is a serial one. Also, the QoS parameter is not required, and we could have omitted it in this initialisation without any problem.
 
 Note that by changing the QoS class the execution of the tasks is affected as well. However, as long as you initialise the queue as a concurrent one, then the parallel execution of the tasks will be respected, and all of them they’ll get their time to run.
 */

func concurrentQueues() {
    //    let anotherQueue = DispatchQueue(label: "com.appcoda.anotherQueue", qos: .utility)
    
    let anotherQueue = DispatchQueue(label: "com.appcoda.anotherQueue", qos: .utility, attributes: .concurrent)
    
    anotherQueue.async {
        for i in 0..<10 {
            print("🔴", i)
        }
    }
    anotherQueue.async {
        for i in 100..<110 {
            print("🔵", i)
        }
    }
    anotherQueue.async {
        for i in 1000..<1010 {
            print("⚪️", i)
        }
    }
}
// concurrentQueues()



// MARK:- Step 3.1 (concurrentQueues with inactiveQueue)
/*:
 The attributes parameter can also accept another value named initiallyInactive. By using that, the execution of the tasks doesn’t start automatically, instead the developer has to trigger the execution. We’ll see that, but a few modifications are required. First of all, declare a class property called inactiveQueue as shown below
 
 The activate() method of the DispatchQueue class will make the tasks run. Note that as the queue has not been marked as a concurrent one, they’ll run in a serial order.
 
 The question now is, how can we have a concurrent queue while it’s initially inactive? Simply, we provide an array with both values, instead of providing a single value as the argument for the attributes parameter: let anotherQueue = DispatchQueue(label: "com.appcoda.anotherQueue", qos: .userInitiated, attributes: [.concurrent, .initiallyInactive])
 */

func concurrentQueuesWithInactiveQueue() {
//    let anotherQueue = DispatchQueue(label: "com.appcoda.anotherQueue", qos: .utility, attributes: .initiallyInactive)
    
    let anotherQueue = DispatchQueue(label: "com.appcode.anotherQueue", qos: .userInitiated, attributes: [.concurrent, .initiallyInactive])
    let inactiveQueue = anotherQueue
    
    inactiveQueue.activate()
    
    anotherQueue.async {
        for i in 0..<10 {
            print("🔴", i)
        }
    }
    anotherQueue.async {
        for i in 100..<110 {
            print("🔵", i)
        }
    }
    anotherQueue.async {
        for i in 1000..<1010 {
            print("⚪️", i)
        }
    }
}
// concurrentQueuesWithInactiveQueue()



// MARK:- Step 4 (queueWithDelay)
/*:
 Delaying the Execution
 
 Sometimes it’s required by the workflow of the app to delay the execution of a work item in a block. CGD allows you to do that by calling a special method and setting the amount of time after of which the defined task will be executed.
 
 Initially, we create a new DispatchQueue as usually; we’ll make use of it right next. Then, we print the current date for future verification of the waiting time of the task, and lastly we specify that waiting time. The delay time is usually a DispatchTimeInterval enum value (internally that’s interpreted as an integer value) that is added to a DispatchTime value to specify the delay (this addition comes next). In our specific example above we set two seconds as the waiting time for the task’s execution. We use the seconds method, but besides that the following ones are also provided:
 microseconds
 milliseconds
 nanoseconds
 
 Indeed, the task of the dispatch queue was executed two seconds later. Note that there’s an alternative to specify the waiting time. If you don’t want to use any of the predefined methods mentioned above, you can directly add a Double value to the current time:
 delayQueue.asyncAfter(deadline: .now() + 0.75) {
     print(Date())
 }
*/

func queueWithDelay() {
    let delayQueue = DispatchQueue(label: "com.appcoda.delayqueue", qos: .userInitiated)

    print(Date())

    let additionalTime: DispatchTimeInterval = .seconds(2)
    
    delayQueue.asyncAfter(deadline: .now() + additionalTime) {
        print(Date())
    }
}
// queueWithDelay()



// MARK:- Step 5 (Main and Global Queues)
/*:
 In all the previous examples we manually created the dispatch queues we used. However, it’s not always necessary to do that, especially if you don’t desire to change the properties of the dispatch queue.
 
 As I have already said in the beginning of this post, the system creates a collection of background dispatch queues, also named global queues. You can freely use them like you would do with custom queues, just keep in mind not to abuse the system by trying to use as many global queues as you can.
 
 Accessing a global queue is as simple as that: let globalQueue = DispatchQueue.global()
 
 You can use it as any other queue we’ve seen so far:
 globalQueue.async {
     for-in loop {
         print("🔴", i)
     }
 }
 There are not many properties that you can change when using global queues. However, you can specify the Quality of Service class that you want to be used:
 let globalQueue = DispatchQueue.global(qos: .userInitiated)
 If you don’t specify a QoS class (like we did in the first case), then the default case is used by default.
 
 Using or not global queues, it’s almost out of the question the fact that you’ll need to access the main queue quite often; most probably to update the UI. Accessing the main queue from any other queue is simple as shown in the next snippet, and upon call you specify if it’s a synchronous or an asynchronous execution:

 DispatchQueue.main.async {
     // Do something
 } // need most of the times
 
 fetchImage() - Xcode proj
 We’ll go to the fetchImage() method, and we’ll the required code to download the Appcoda logo and show it on the image view. The following code does that think exactly (I won’t discuss anything at this point about the URLSession class and how it’s used):
 
 Notice that we are not actually updating the UI on the main queue, instead we’re trying to do so on the background thread that the completion handler block of the dataTask(...) method runs to. Compile and run the app now and see what happens (don’t forget to make a call to the fetchImage() method):
 
 Even though we get the information that the image has been downloaded, we’re unable to see it in the image view because the UI has not been updated. Most probably, the image will be displayed several moments later after the initial message (something that is not guaranteed that will happen if other tasks are being executed in the app as well), but problems don’t stop there; you’ll also get a really long error log complaining about the UI updates made on a background thread.
 
 Now, let’s change that problematic behaviour -- add
 DispatchQueue.main.async {
     // Do something
 }
 
 Run the app again, and see that the image view gets its image this time right after it gets downloaded. The main queue was really invoked and updated our UI.
*/



// MARK:- Step 6 (DispatchWorkItem)
/*:
 Using DispatchWorkItem Objects

 A DispatchWorkItem is a block of code that can be dispatched on any queue and therefore the contained code to be executed on a background, or the main thread. Think of it really simply; as a bunch of code that you just invoke, instead of writing the code blocks in the way we’ve seen in the previous parts.

 The simplest way to use such a work item is illustrated right below:
 let workItem = DispatchWorkItem {
     // Do something
 }
 
 Let’s see a small example to understand how DispatchWorkItem objects are used.
 
 The purpose of our work item is to increase the value of the value variable by 5. We use the workItem object by calling the perform() method as shown: workItem.perform()
 
 That line will dispatch the work item on the main thread, but you can always use other queues as well.
 
 Let’s see the following example:
 let queue = DispatchQueue.global()
 queue.async {
     workItem.perform()
 }
 
 This will also perfectly work. However, there’s a faster way to dispatch a work item like that one; The DispatchQueue class provides a convenient method for that purpose:
 queue.async(execute: workItem)
 
 When a work item is dispatched, you can notify your main queue (or any other queue if you want) about that as shown next:
 workItem.notify(queue: DispatchQueue.main) {
     print("value = ", value)
 }
 
 
*/
func useWorkItem() {
    var value = 10
 
    let workItem = DispatchWorkItem {
        value += 5
    }
    workItem.perform()
    
    let queue = DispatchQueue.global(qos: .utility)
    queue.async(execute: workItem)
    workItem.notify(queue: queue) {
        print("Value \(value)")
    }
}
// useWorkItem()

