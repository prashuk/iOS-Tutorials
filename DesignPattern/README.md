Before we go any further, there are two very integral parts of any iOS app that you should understand: UI logic and business logic. What is the difference, you ask?

Business logic is the programming that manages the communication between an end user interface and databases. It ensures the models are updated, the data is processed in a way that is human readable, and so on. This includes actions such as updating the data, deleting items from a list, formatting a data type, and that kind of thing. This could be known as “processing” in simpler terms.

UI logic is the part that deals with the user interface, i.e. what the user sees and interacts with. This includes updating the labels, the table, animating the screen components, and all those pretty things we like to look at.

### MVC

- Model: this is where the data lives.
- View: this is what the user interacts with on the screen. (view, gestures, animations)
- Controller (or ViewController): this controls the flow between the view and the model. If the view wants to present an item, it will ask the controller to ask the model for the item. The controller will get the item from the model, then update the view accordingly. If the model changed, it would notify the controller, and the controller would then update the view accordingly.

![img](https://twilio-cms-prod.s3.amazonaws.com/images/JbBrTeO4KRUdKXs0PX8lqoDihF5vUDNLhMWdOxAd1GDah3.width-500.png)

As with anything, there are pros and cons to working with MVC.One of its greatest strengths is that MVC is a design pattern that is learnable. When working with smaller codebases, the effort required to implement MVVM or any other more complex pattern may not be justifiable. 

However, as you may have observed, the view controller has quite a lot of responsibilities. Therefore, it ends up being the dumping ground for a lot of the code. This has led to increasingly massive files. This is why MVC has been referred to as the “Massive View Controller.” This has caused a lot of problems such as the codebase being impossible to navigate and being virtually untestable, which is because when the view is coupled with the controller, you have to mock the view in order to test the controller.

### MVVM

- Model: This is the same as in MVC; this is where the data lives.
- View Controller: The view controller sets up UI views. It does not interact with the model at all. It instead goes through the view model, and asks for what it needs in a format ready for display. It should have absolutely *no business logic*.
- View Model: The view model is basically a representation of the view controller. If the view controller has a label, the view model should have a property to supply it with the text in string form. *It triggers all calls, and sends and receives data*. When dealing with the view model, you should ensure it is as dumb as possible. This means that you should decouple it from the view controller as much as possible. We should ensure that we do not inject instances of the view controller to the view model. *The view model should be completely independent of all the view controller*.

![img](https://twilio-cms-prod.s3.amazonaws.com/images/w0ApU8yEXOQiOaKjv-wYaUGfcWOCtUzTWv8_EmGR5LX5wp.width-500.png)

## Moving from MVC to MVVM

Decide which one of these have UI logic, which ones have business logic, and which ones have a bit of both?

As we mentioned earlier, the goal in MVVM is to separate all the UI logic from the business logic. Looking at the app, we have UI logic and business logic. First things first, we need to have a way to expose the view model data to the view controller. There are a couple of ways to do this:

- Binding: with binding, we use a class that binds the view model class to the view controller. This is a great approach when dealing with more complex classes.
- Closures: here we use closures to expose certain properties of the view model class. These are especially useful when working with networking requests and other tasks that rely on external factors. An example is if we were fetching data from an API, we would use a closure to update the view controller.
- Delegates and protocols: these are used to monitor changes in a property and update the view controller. A great example is when we monitor changes on the data and perform an action based on that change. For instance, if we wanted to present an alert whenever a Wi-Fi network is detected, we would use delegates.
- Variables: this is the simplest method and is the one we will be using. We create properties in the view model and have string or other formatted representations of them in the view controller. The view controller accesses the variable from the viewModel in a ready to use format.

## From MVC to MVVM

As you’ve observed, MVVM does make debugging, testing, and reading code easier. It is therefore essential to master different techniques so that you are able to solve different methods. 

To test a view controller with MVC, you must use `UIKit` to instantiate the view controller. Then, you have to search through the view hierarchy to trigger actions and verify results.

With MVVM, you write more conventional tests. You may still need to wait for some asynchronous events, but most things are easy to trigger and verify.

1. Use an `expectation` to wait for the asynchronous event.
2. Create an instance of `viewModel` to test.
3. Wait for up to eight seconds for the expectation to fulfill. The test only succeeds if the expected result arrives before the timeout.

There is no single architecture that is a one-size-fits-all; each has its use cases where it works best. It is therefore beneficial to be knowledgeable about VIPER, MVVM, and MVC in order to make an informed decision.

## Reviewing The Refactoring to MVVM

- *Reduced complexity*: `ViewController` is now much simpler.
- *Specialized*: `ViewController` no longer depends on any model types and only focuses on the view.
- *Separated*: `ViewController` only interacts with the `ViewModel` by sending inputs
- *Expressive*: `ViewModel` separates the business logic from the low level view logic.
- *Maintainable*: It’s simple to add a new feature with minimal modification to the `ViewController`.
- *Testable*: The `ViewModel` is relatively easy to test.

However, there are some trade-offs to MVVM that you should consider:

- *Extra type*: MVVM introduces an extra view model type to the structure of the app.
- *Binding mechanism*: It requires some means of data binding.
- *Boilerplate*: You need some extra boilerplate to implement MVVM.
- *Memory*: You must be conscious of memory management and memory retain cycles when introducing the view model into the mix.