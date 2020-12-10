# Multithreading-iOS

Two ways to do multitasking:

- ***Grand Central Dispatch (GCD)***
- ***NSOperationQueue***

No matter what, there’s one rule that should be always respected: **The main thread must be always remain free** so it serves the user interface and user interactions. **Any time-consuming or CPU demanding tasks should run on *concurrent* or *background* queues.**

**Any changes you want to apply to the UI must be always done on the main thread.**

For example, you can download the data for an image on a secondary, background dispatch queue, but you’ll update the respective image view on the main thread.

### Grand Central Dispatch (GCD)

It is a low-level API for `managing` concurrent operations.

### GCD Concepts

Concepts of concurrency and threading.

First off, the dominating phrase in GCD is the ***dispatch queue***. A queue is actually a block of code that can be executed ***synchronously*** or ***asynchronously***, either on the main or on a background thread. Once a queue is created, the operating system is the one that manages it and gives it time to be processed on any core of the CPU.

Next, another important concept is the ***work item***. A work item is literally a block of code that is either written along with the queue creation, or it gets assigned to a queue and it can be used more than once (reused).

The work item is what you think of exactly: It’s the code that a dispatch queue will run.

The execution of work items in a queue also follows the FIFO pattern. This execution can be *synchronous* or *asynchronous*.

In the synchronous case, the running app does not exit the code block of the item until the execution finishes.

In the asynchronously case, the running app calls the work item block and it returns at once.

#### Concurrency

In iOS, a process or application consists of one or more threads. The operating system scheduler manages the threads independently of each other. Each thread can execute concurrently, but it’s up to the **system to decide if this happens, when this happens, and how it happens**.

- <u>Single-core</u> devices achieve concurrency through a method called *time-slicing*. They run one thread, perform a context switch, then run another thread.

- <u>Multi-core</u> devices, on the other hand, execute multiple threads at the same time via **parallelism**



<img src="https://koenig-media.raywenderlich.com/uploads/2014/01/Concurrency_vs_Parallelism.png" style="zoom:75%;" />

GCD is built on top of threads. Under the hood it manages a shared thread pool. With GCD you add blocks of code or work items to **dispatch queues** and GCD decides which thread to execute them on.

Note that GCD decides how much **parallelism** it requires based on the system and available system resources.

It’s important to note that parallelism requires concurrency, but concurrency does not guarantee parallelism.

Basically, concurrency is about **structure** while parallelism is about **execution**.

#### Queues

As mentioned before, GCD operates on **dispatch queues** through a class named `DispatchQueue`. You submit units of work to this **queue** and GCD will execute them in a **FIFO** order, guaranteeing that the first task submitted is the first one started.

**Dispatch queues are thread-safe** which means that you can access them from multiple threads simultaneously. The benefits of GCD are apparent when you understand how dispatch queues provide thread safety to parts of your own code. The key to this is to choose the right *kind* of dispatch queue and the right *dispatching function* to submit your work to the queue.

Queues can be either ***serial*** or ***concurrent***. 

* Serial queues guarantee that only one task runs at any given time. GCD controls the execution timing. You won’t know the amount of time between one task ending and the next one beginning:  a work item starts to be executed once the previous one has finished

<img src="https://koenig-media.raywenderlich.com/uploads/2014/09/Serial-Queue-Swift-480x272.png" alt="grand central dispatch tutorial" style="zoom:75%;" />

* Concurrent queues allow multiple tasks to run at the same time. The queue guarantees tasks start in the order you add them. Tasks can finish in any order and you have no knowledge of the time it will take for the next task to start, nor the number of tasks that are running at any given time.

  The work items are executed in parallel

<img src="https://koenig-media.raywenderlich.com/uploads/2014/09/Concurrent-Queue-Swift-480x272.png" alt="grand central dispatch tutorial" style="zoom:75%;" />

The **decision of when to start a task is entirely up to GCD**. If the execution time of one task overlaps with another, it’s up to GCD to determine if it should run on a different core, if one is available, or instead to perform a context switch to run a different task.

**GCD provides three main types of queues**:

1. ***Main queue***: runs on the main thread and is a **serial** queue.
2. ***Global queues***: **concurrent** queues that are shared by the whole system. 
   * Four such queues with priorities : high, default, low, and background. 
   * The background priority queue has the lowest priority and is throttled in any I/O activity to minimize negative system impact.
3. ***Custom queues***: queues that you create which can be **serial** or **concurrent**. Requests in these queues actually end up in one of the global queues.

When sending tasks to the global concurrent queues, you **don’t specify the priority directly. Instead, you specify a Quality of Service (QoS) class property**. This indicates the task’s importance and guides GCD in determining the priority to give to the task.

The **QoS** classes are:

- ***User-interactive***: This represents tasks that must complete immediately in order to provide a nice user experience. Use it for **UI updates**, **event handling** and **small workloads** that require **low latency**. The total amount of work done in this class during the execution of your app should be small. This should run on the main thread.
- ***User-initiated***: The user initiates these asynchronous tasks from the UI. Use them when the user is waiting for **immediate results** and for tasks required to continue user interaction. They execute in the high priority global queue.
- ***Utility***: This represents long-running tasks, typically with a user-visible progress indicator. Use it for **computations, I/O, networking, continuous data feeds** and **similar tasks**. This class is designed to be **energy efficient**. This will get mapped into the **low priority** global queue.
- ***Background***: This represents tasks that the user is not directly aware of. Use it for prefetching, maintenance, and other tasks that **don’t require user interaction** and **aren’t time-sensitive**. This will get mapped into the **background priority** global queue.

#### Synchronous vs. Asynchronous

With GCD, you can dispatch a task either synchronously or asynchronously.

A ***synchronous*** function **returns control to the caller after the task completes**. You can schedule a unit of work synchronously by calling `DispatchQueue.sync(execute:)`.

An ***asynchronous*** function returns immediately, ordering the task to start but not waiting for it to complete. Thus, an asynchronous function **does not block the current thread** of execution from proceeding on to the next function. You can schedule a unit of work asynchronously by calling `DispatchQueue.async(execute:)`.

#### Managing Tasks

You’ve heard about tasks quite a bit by now. For the purposes of this tutorial you can consider a task to be a [closure](https://docs.swift.org/swift-book/LanguageGuide/Closures.html). Closures are self-contained, callable blocks of code you can store and pass around.

Each task you submit to a `DispatchQueue` is a `DispatchWorkItem`. You can configure the behavior of a `DispatchWorkItem` such as its QoS class or whether to spawn a new detached thread.





### Handling Background Tasks

With all this pent up GCD knowledge, it’s time for your first app improvement!

Overloading a view controller’s `viewDidLoad()` is easy to do, resulting in long waits before the view appears. It’s best to offload work to the background if it’s not absolutely essential at load time.

This sounds like a job for `DispatchQueue`‘s `async`!

```swift
let overlayImage = faceOverlayImageFrom(image)
fadeInNewImage(overlayImage)

// Replace these two lines with below code
```

```swift
// 1
DispatchQueue.global(qos: .userInitiated).async { [weak self] in
  guard let self = self else { return }
  let overlayImage = self.faceOverlayImageFrom(self.image)
  // 2
  DispatchQueue.main.async { [weak self] in
    // 3
    self?.fadeInNewImage(overlayImage)
  }
}
```

Here’s what the code’s doing step by step:

1. You move the work to a background global queue and run the work in the **closure asynchronously**. This lets `viewDidLoad()` finish earlier on the main thread and makes the loading feel more snappy. Meanwhile, the face detection processing is started and will finish at some later time.
2. At this point, the face detection processing is complete and you’ve generated a new image. Since you want to use this new image to update your `UIImageView`, you add a new closure to the main queue. Remember – anything that modifies the UI must run on the main thread!
3. Finally, you update the UI with `fadeInNewImage(_:)` which performs a fade-in transition of the new googly eyes image.

In two spots, you add `[weak self]` to capture a weak reference to `self` in each closure.

**In general, you want to use `async` when you need to perform a network-based or CPU-intensive task in the background and not block the current thread.**

Here’s a quick guide of how and when to use the various queues with `async`:

- ***Main Queue***: This is a common choice to update the UI after completing work in a task on a concurrent queue. To do this, you code one closure inside another. Targeting the main queue and calling `async` guarantees that this new task will execute sometime after the current method finishes.
- ***Global Queue***: This is a common choice to perform non-UI work in the background.
- ***Custom Serial Queue***: A good choice when you want to perform background work serially and track it. This eliminates resource contention and race conditions since you know only one task at a time is executing. Note that if you need the data from a method, you must declare another closure to retrieve it or consider using `sync`.

### Delaying Task Execution

`DispatchQueue` allows you to delay task execution. Use this when you want a task to run at a specific time.

Consider the user experience of your app for a moment. It’s possible that users might be confused about what to do when they open the app for the first time

It would be a good idea to display a prompt to the user if there aren’t any photos. You should also consider how users’ eyes will navigate the home screen. If you display a prompt too quickly, they might miss it as their eyes linger on other parts of the view. A two-second delay should be enough to catch users’ attention and guide them.

```swift
// 1
let delayInSeconds = 2.0
// 2
DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) { [weak self] in
  guard let self = self else { return }
  if PhotoManager.shared.photos.count > 0 {
    self.navigationItem.prompt = nil
  } else {
    self.navigationItem.prompt = "Add photos with faces to Googlyify them!"
  }
  // 3
  self.navigationController?.viewIfLoaded?.setNeedsLayout()
}
```

Here’s what’s going on above:

1. You specify the amount of time to delay.
2. You then wait for the specified time then asynchronously run the block which updates the photos count and updates the prompt.
3. Force the navigation bar to lay out after setting the prompt to make sure it looks kosher.

**Why not use *Timer*?** You could consider using it if you have repeated tasks which are easier to schedule with `Timer`. Here are two reasons to stick with dispatch queue’s `asyncAfter()`.

* Readability. To use `Timer` you have to define a method, then create the timer with a selector or invocation to the defined method. With `DispatchQueue` and `asyncAfter()`, you simply add a closure.

* `Timer` is scheduled on run loops so you would also have to make sure you scheduled it on the correct run loop (and in some cases for the correct run loop modes). In this regard, working with dispatch queues is easier.

### Managing Singletons

One frequent concern with singletons is that often they’re not thread safe. This concern is justified given their use: singletons are often used from multiple controllers accessing the singleton instance at the same time. Your `PhotoManager` class is a singleton, so you’ll need to consider this issue.

Thread safe code can be safely called from multiple threads or concurrent tasks without causing any problems such as data corruption or app crashes. Code that is not thread safe can only run in one context at a time.

There are two thread safety cases to consider: during initialization of the singleton instance and during reads and writes to the instance.

Initialization turns out to be the easy case because of how Swift initializes static variables. It initializes static variables when they are first accessed, and it guarantees initialization is atomic. That is, Swift treats the code performing initialization as a critical section and guarantees it completes before any other thread gets access to the static variable.

A critical section is a piece of code that must *not* execute concurrently, that is, from two threads at once. This is usually because the code manipulates a shared resource such as a variable that can become corrupt if it’s accessed by concurrent processes.

Open *PhotoManager.swift* to see how you initialize the singleton:

```swift
class PhotoManager {
  private init() {}
  static let shared = PhotoManager()
}
```

The private initializer makes sure that the only `PhotoManager` is then one assigned to `shared`. This way, you don’t have to worry about syncing changes to your photo store between different managers.

You still have to deal with thread safety when accessing code in the singleton that manipulates shared internal data. You can handle this through methods such as synchronizing data access. You’ll see one approach in the next section.
