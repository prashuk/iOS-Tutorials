# Delegation

### What is the delegation design pattern?

To read that “delegation is a design pattern”

#### Design pattern

First, take the phrase “design pattern”.

**Design** implies architecture. It connotes a strategy for organizing something. Design conveys the method by which components will work together to accomplish an end.

**Pattern** implies that there is some repeatable process that has honed in around a common thread… a common practice… a predictable method for doing something.

A **design pattern** in software terms, then, is a method for architecting, strategizing about, and organizing an application’s code in such a way that has been found to be commonplace, repeatable, and practically sound over time.

#### Delegation

Now take the word delegation. Three things come to my mind:

1. The verb, **to delegate**, meaning “to give control”
2. The noun, **a delegate**, meaning “a person acting for another”
3. The made-up noun, **a delegator**, or more properly, a *principal*, meaning “a person who delegates to another”

In the real world, the word delegation encapsulates relationship and responsibility. A delegator/principal (noun) would delegate (verb) control or responsibility to another person called a delegate.



### How is delegation used?

So yes… delegation is a design pattern. It’s a design pattern that exists on other platforms, but it is one that has been heavily adopted by Apple and is ubiquitous throughout the iOS APIs.

#### Communication

In practice, delegation is most often used as a way for one class to *communicate* to another class. Take the following samples from `UITableViewDelegate` as an example:

- tableView(_:will_SelectRowAtIndexPath:)
- tableView(_:did_SelectRowAtIndexPath:)
- tableView(_:did_HighlightRowAtIndexPath:)

**My observation of Apple’s APIs indicates to me that one of the intended uses for delegation is to allow one instance to communicate back to some *other* instance that something will/did happen.** 

**It’s also worth noting the scope of the communication that delegation is intended to be used for. Whereas `NSNotificationCenter` fits the need for one instance to broadcast a message intended for more than one listening instance, delegation fits the scenario where an instance only needs to send a message to a single listener (the delegate).**

#### Customization

Another common usage for delegation is to provide a delegate instance the opportunity to customize certain aspects of the delegat*ing* instance’s internal state.



### How it works?

#### Introducing the players

For delegation to occur in software, you’d have a situation where one class (a delegat*or* class) would give control or responsibility for some behavioral logic to *another* class called a delegate.

So how does one class delegate behavioral logic to another class? With iOS and Swift, the delegation design pattern is achieved by utilizing an abstraction layer called a [protocol](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Protocols.html).

> A protocol defines a blueprint of methods, properties, and other requirements that suit a particular task or piece of functionality.

#### Protocols as abstractions

Protocols are an “abstraction”, because they do not provide implementation details in their declaration… Only function and property *names*. Like an outline, or as Apple puts it, a blueprint.

##### Protocols as blueprints

With a single blueprint, there can be many homes constructed. The fine details of their construction may differ, but in the end, houses of some similarity that satisfy the blueprint’s specifications are built.

##### Protocols as contracts

Another analogy from the legal world is popular for describing protocols: Protocols are similar to *contracts*. It’s this contractual idea that actually makes the most sense to me when it comes to delegation.

A contract is the “thing” in the middle of two parties who are trying to negotiate a deal. To one party, the contract is a *guarantee* of some terms that will be satisfied. To the *other* party, the contract is a set of *obligations*.

In the delegation design pattern, protocols serve the same kind middle-man role as a contract. To the delegat*or* class, the protocol is a guarantee that some behavior will be supplied by the other party (the delegate). To the delegate class, the protocol is a set of obligations – things it must implement when it “signs the contract”, or in Swift terms, “adopts the protocol”.

## Example

1. Protocol

```swift
protocol RatingPickerDelegate {
    func preferredRatingSymbol(picker: RatingPicker) -> UIImage?
    func didSelectRating(picker: RatingPicker, rating: Int)
    func didCancel(picker: RatingPicker)
}
```



2. Delegator

```swift
class RatingPicker {
    weak var delegate: RatingPickerDelegate?
    
    init(withDelegate delegate: RatingPickerDelegate?) {
        self.delegate = delegate
    }
 
    func setup() {
        let preferredRatingSymbol = delegate?.preferredRatingSymbol(picker: self)
        
        // Set up the picker with the preferred rating symbol if it was specified
    }
    
    func selectRating(selectedRating: Int) {
        delegate?.didSelectRating(picker: self, rating: selectedRating)
        // Other logic related to selecting a rating
    }
    
    func cancel() {
        delegate?.didCancel(picker: self)
        // Other logic related to canceling
    }
}
```



3. Choosing the Delegator

```swift
class RatingPickerHandler: RatingPickerDelegate {
    func preferredRatingSymbol(picker: RatingPicker) -> UIImage? {
        return UIImage(contentsOfFile: "Star.png")
    }
    
    func didSelectRating(picker: RatingPicker, rating: Int) {
        // do something in response to a rating being selected
    }
    
    func didCancel(picker: RatingPicker) {
        // do something in response to the rating picker canceling
    }
}
```