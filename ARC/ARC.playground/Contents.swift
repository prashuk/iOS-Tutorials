import Foundation

class Person {
    var name: String
    var mobile: Mobile?
    
    init(name: String, mobile: Mobile?) {
        self.name = name
        self.mobile = mobile
        print("Person Init")
    }
    
    deinit {
        print("Person deinit")
    }
}

class Mobile {
    var brand: String
    weak var owner: Person?
    
    init(brand: String, owner: Person?) {
        self.brand = brand
        self.owner = owner
        print("Mobile init")
    }
    
    deinit {
        print("Mobile deinit")
    }
}

var person: Person?
var mobile: Mobile?

func createObjects() {
    person = Person(name: "Prashuk", mobile: nil)
    mobile = Mobile(brand: "iPhone", owner: nil)
}

func assignProperties() {
    person?.mobile = mobile
    mobile?.owner = person
    
    person = nil
    
    print(mobile?.owner)
    
    mobile = nil
}

createObjects()
assignProperties()
// by calling this function deinit doesn't called for both the classes but if we make weak any one of the property of mobile or person, deinit will called
// by convention, make weak that variable which is less important

/*
 class Demo {
    var x = 5
    lazy var increase: (Int) -> Void = { by in
        self.x += by
        print("x: \(self.x)")
    }
 }
*/


let demo = Demo()
demo.increase(2)
// demo points to closure and closure points back to self so leak occurs
// So add self to weak as capture list in the closure - lazy var increase: (Int) -> Void = { [weak self] by in
// Every where in the closure

class Demo {
    var x = 5
    lazy var increase: (Int) -> Void = { [weak self] by in
        guard let self = self else { return }
        
        self.x += by
        print("x: \(self.x)")
    }
}
