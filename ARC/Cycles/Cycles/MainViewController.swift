import UIKit

class MainViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    runScenario()
  }
  
  func runScenario() {
    let user = User(name: "Prashuk")
    let iphone = Phone(model: "iPhone X")
    
    user.add(phone: iphone)
    /*
     Here, you add iPhone to user. add(phone:) also sets the owner property of iPhone to user.
     
     Now build and run, and you’ll see user and iPhone do not deallocate. A strong reference cycle between the two objects prevents ARC from deallocating either of them.
     
     https://koenig-media.raywenderlich.com/uploads/2016/05/UserIphoneCycle.png
     */
    
    let subscription = CarrierSubscription(name: "TelBel", countryCode: "0032", number: "31415728", user: user)
    iphone.provision(carrierSubscription: subscription)
    
    print(subscription.completePhoneNumber())
    /*
     CarrierSubscription does not deallocates, due to the strong reference cycle between the object and the closure.
     
     https://koenig-media.raywenderlich.com/uploads/2019/02/Closure-472x320.png
     */
    
    let greetingMaker: () -> String
    do {
      let mermaid = WWDCGreeting(who: "caffeinated")
      greetingMaker = mermaid.greeting
    }
    print(greetingMaker())
    /*
     Fatal Error of unowned
     The app hit a runtime exception because the closure expected self.who to still be valid, but you deallocated it when mermaid went out of scope at the end of the do block.
     */
    
    do {
      let ernie = Person(name: "Ernie")
      let bert = Person(name: "Bert")
      
//      ernie.friends.append(bert) // Not deallocated
//      bert.friends.append(ernie) // Not deallocated
      
      ernie.friends.append(Unowned(bert))
      bert.friends.append(Unowned(ernie))
    }
    /*
     ernie and bert stay alive by keeping a reference to each other in their friends array, although the array itself is a value type.
     
     Make the friends array unowned and Xcode will show an error: unowned only applies to class types.
     
     To break the cycle here, you’ll have to create a generic wrapper object and use it to add instances to the array.
     
     The friends array isn’t a collection of Person objects anymore, but instead a collection of Unowned objects that serve as wrappers for the Person instances.
     */
  }
}

class User {
  let name: String
  private(set) var phones: [Phone] = []
  var subscription: [CarrierSubscription] = []
  
  init(name: String) {
    self.name = name
    print("User \(name) was initialized")
  }
  
  deinit {
    print("Deallocation user named: \(name)")
  }
  
  func add(phone: Phone) {
    phones.append(phone)
    phone.owner = self
  }
  /*
   This adds a phones array property to hold all phones owned by a user. The setter is private, so clients have to use add(phone:). This method ensures that owner is set properly when you add it.
   */
}

class Phone {
  let model: String
  weak var owner: User?
  /*
   Build and run again. Now user and phone deallocate properly once the runScenario() method exits scope.
   */
  var carrierSubscription: CarrierSubscription?
  
  init(model: String) {
    self.model = model
    print("Phone \(model) was initialized")
  }
  
  deinit {
    print("Deallocating phone named: \(model)")
  }
  
  func provision(carrierSubscription: CarrierSubscription) {
    self.carrierSubscription = carrierSubscription
  }
  
  func decomission() {
    carrierSubscription = nil
  }
}

class CarrierSubscription {
  let name: String
  let countryCode: String
  let number: String
  unowned let user: User
  /*
   Break the Chain
   Either the reference from user to subscription or the reference from subscription to user should be unowned to break the cycle. The question is, which of the two to choose. This is where a little bit of knowledge of your domain helps.
   
   A user owns a carrier subscription, but, contrary to what carriers may think, the carrier subscription does not own the user.
   
   Moreover, it doesn’t make sense for a CarrierSubscription to exist without an owning User. This is why you declared it as an immutable let property in the first place.
   
   Since a User with no CarrierSubscription can exist, but no CarrierSubscription can exist without a User, the user reference should be unowned.
   */
  
  lazy var completePhoneNumber: () -> String = { [unowned self] in
    self.countryCode + " " + self.number
  }
  /*
   The property is lazy, meaning that you’ll delay its assignment until the first time you use the property.
   */
  /* After adding unowned to self in capture list of closure
   This adds [unowned self] to the capture list for the closure. It means that you’ve captured self as an unowned reference instead of a strong reference.
   */
  
  init(name: String, countryCode: String, number: String, user: User) {
    self.name = name
    self.countryCode = countryCode
    self.number = number
    self.user = user
    
    user.subscription.append(self)
    
    print("CarrierSubscription \(name) intialized")
  }
  
  deinit {
    print("Deallocation CarrierSubscription named: \(name)")
  }
}

class WWDCGreeting {
  let who: String
  
  init(who: String) {
    self.who = who
  }
  
  lazy var greeting: () -> String = { [weak self] in
    guard let self = self else {
      return "No greeting available."
    }
    return "Hello \(self.who)."
  }
}

class Unowned<T: AnyObject> {
  unowned var value: T
  init (_ value: T) {
    self.value = value
  }
}


class Person {
  var name: String
  var friends: [Unowned<Person>] = []
  
  init(name: String) {
    self.name = name
    print("New person instance: \(name)")
  }
  
  deinit {
    print("Person instance \(name) is being deallocated")
  }
}
