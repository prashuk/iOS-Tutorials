This tutorial will show you:

- How to use Xcode’s Test navigator to test an app’s model and asynchronous methods
- How to fake interactions with library or system objects by using stubs and mocks
- How to test UI and performance
- How to use the code coverage tool

Generally, tests should cover:

- Core functionality: Model classes and methods and their interactions with the controller
- The most common UI workflows
- Boundary conditions
- Bug fixes

### Best Practices for Testing

- *Fast*: Tests should run quickly.
- *Independent/Isolated*: Tests should not share state with each other.
- *Repeatable*: You should obtain the same results every time you run a test. External data providers or concurrency issues could cause intermittent failures.
- *Self-validating*: Tests should be fully automated. The output should be either “pass” or “fail”, rather than rely on a programmer’s interpretation of a log file.
- *Timely*: Ideally, tests should be written before you write the production code they test (Test-Driven Development).

##### There are three ways to run the tests:

1. *Product ▸ Test* or *Command-U*. Both of these run *all* test classes.
2. Click the arrow button in the Test navigator.
3. Click the diamond button in the gutter.

It’s good practice creating the SUT (system underr test) in `setUp()` and releasing it in `tearDown()` to ensure every test starts with a clean slate. 

A test method’s name always begins with *test*, followed by a description of what it tests.

##### It’s good practice to format the test into *given*, *when* and *then* sections:

1. *Given*: Here, you set up any values needed.
2. *When*: You’ll execute the code being tested: 
3. *Then*: This is the section where you’ll assert the result you expect with a message that prints if the test *fails*.



### Using XCTestExpectation to Test Asynchronous Operations

Now that you’ve learned how to test models and debug test failures, it’s time to move on to testing asynchronous code.

Suppose you want to modify it to use [AlamoFire](https://www.raywenderlich.com/121540/alamofire-tutorial-getting-started) for network operations. To see if anything breaks, you should write tests for the network operations and run them before and after you change the code.

`URLSession` methods are *asynchronous*: They return right away, but don’t finish running until later. To test asynchronous methods, you use `XCTestExpectation` to make your test wait for the asynchronous operation to complete.

Asynchronous tests are usually slow, so you should keep them separate from your faster unit tests.

This test checks that sending a valid query to iTunes returns a 200 status code. Most of the code is the same as what you’d write in the app, with these additional lines:

1. *expectation(description:)*: Returns an `XCTestExpectation` object, stored in `promise`. The `description` parameter describes what you expect to happen.
2. *promise.fulfill()*: Call this in the success condition closure of the asynchronous method’s completion handler to flag that the expectation has been met.
3. *wait(for:timeout:)*: Keeps the test running until all expectations are fulfilled, or the `timeout` interval ends, whichever happens first.



### Faking Objects and Interactions

Most apps interact with system or library objects — objects you don’t control — and tests that interact with these objects can be slow and unrepeatable, violating two of the *FIRST* principles. Instead, you can *fake* the interactions by getting input from ***stubs*** or by updating ***mock*** objects.

Employ fakery when your code has a *dependency* on a system or library object. You can do this by creating a fake object to play that part and *injecting* this fake into your code.

#### Fake Input From Stub

In this test, you’ll check that the app’s `updateSearchResults(_:)` correctly parses data downloaded by the session, by checking that `searchResults.count` is correct. The SUT is the view controller, and you’ll fake the session with stubs and some pre-downloaded data.

-- CODE --

#### Fake Update to Mock Object

The previous test used a ***stub*** to provide input from a fake object. Next, you’ll use a **mock** **object** to test that your code correctly updates `UserDefaults`.

-- CODE --



### Performance Testing

*A performance test takes a block of code that you want to evaluate and runs it ten times, collecting the average execution time and the standard deviation for the runs. The averaging of these individual measurements form a value for the test run that can then be compared against a baseline to evaluate success or failure.*

Click *Set Baseline* to set a reference time. Then, run the performance test again and view the result — it might be better or worse than the baseline. The *Edit* button lets you reset the baseline to this new result.

Baselines are stored per device configuration, so you can have the same test executing on several different devices, and have each maintain a different baseline dependent upon the specific configuration’s processor speed, memory, etc.

Any time you make changes to an app that might impact the performance of the method being tested, run the performance test again to see how it compares to the baseline.

-- CODE --

The coverage annotations show how many times a test hits each code section; sections that weren’t called are highlighted in red. As you’d expect, the for-loop ran 3 times, but nothing in the error paths was executed.

To increase coverage of this function, you could duplicate *abbaData.json*, then edit it so it causes the different errors. For example, change `"results"` to `"result"` for a test that hits `print("Results key not found in dictionary")`.

### 100% Coverage?

How hard should you strive for 100% code coverage? Google “100% unit test coverage” and you’ll find a range of arguments for and against this, along with debate over the very definition of “100% coverage”. Arguments against it say the last 10-15% isn’t worth the effort. Arguments for it say the last 10-15% is the most important, *because* it’s so hard to test. Google “hard to unit test bad design” to find persuasive arguments