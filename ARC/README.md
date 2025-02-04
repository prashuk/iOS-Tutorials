# ARC-Memory Management in Swift

- How to code in Swift for optimal memory management.
- What reference cycles are.
- How to break them using an example of a reference cycle.

Swift handles much of the memory management of your apps and allocates or deallocates memory on your behalf. It does so using a feature of the Clang compiler called ***Automatic Reference Counting***, or ***ARC***

With an understanding of this system, you can influence when the **life of a heap object** ends. Swift uses ARC to be predictable and efficient in resource-constrained environments.

ARC works automatically, so you don’t need to participate in reference counting, but you do need to **consider relationships between objects to avoid memory leaks**. This is an important requirement that is often overlooked by new developers.

### An Object’s Lifetime

1. ***Allocation***: Takes memory from a stack or heap.
2. ***Initialization***: `init` code runs.
3. ***Usage***.
4. ***Deinitialization***: `deinit` code runs.
5. ***Deallocation***: Returns memory to a stack or heap.

There are no direct hooks into allocation and deallocation, but you can use `print` statements in `init` and `deinit` as a proxy for monitoring those processes.

***Reference counts*, also known as *usage counts*, determine when an object is no longer needed. This count indicates how many “things” reference the object. The object is no longer needed when its usage count reaches zero and no clients of the object remain. The object then deinitializes and deallocates.**

**At the end of function(), object goes out of scope and the reference count decrements to 0. As a result, object deinitializes and subsequently deallocates**.

## Reference Cycles

In most cases, ARC works like a charm. As an app developer, you don’t usually have to worry about memory leaks, where unused objects stay alive indefinitely. Leaks can happen!

How can these leaks occur? Imagine a situation where two objects are no longer required, but each references the other. Since each has a non-zero reference count, *neither* object can deallocate.

![img](https://koenig-media.raywenderlich.com/uploads/2016/05/ReferenceCycle-650x208.png)

This is a **strong reference cycle**. It fools ARC and prevents it from cleaning up.

As you can see, the reference count at the end is not zero, and even though neither is still required, `object1` and `object2` are never deallocated.

## Weak References

To break strong reference cycles, you can specify the relationship between reference counted objects as `weak`.

- Unless otherwise specified, all references are strong and impact reference counts.
- Weak references, however, don’t increase the reference count of an object.
- Weak references don’t participate in the lifecycle management of an object.
- Weak references are always declared as *optional* types. This means when the reference count goes to zero, the reference can automatically be set to `nil`.

![WeakReference](https://koenig-media.raywenderlich.com/uploads/2016/05/WeakReference-650x279.png)

In the image above, the dashed arrow represents a weak reference. Notice how the reference count of `object1` is 1 because `variable1` refers to it. The reference count of `object2` is 2, because both `variable2` and `object1` refer to it.

While `object2` references `object1`, it does so weakly, meaning it doesn’t affect the strong reference count of `object1`.

When both `variable1` and `variable2` go away, `object1` will have a reference count of zero and `deinit` will run. This removes the strong reference to `object2`, which subsequently deinitializes.

## Unowned References

There is another reference modifier you can use that doesn’t increase the reference count: `unowned`.

`unowned` vs `weak`? A weak reference is *always* optional and automatically becomes `nil` when the referenced object goes away.

Unowned references, by contrast, are never optional types. If you try to access an unowned property that refers to a deinitialized object, you’ll trigger a runtime error comparable to force unwrapping a `nil` optional type.

Because a weak reference can be set to `nil`, it is always declared as an optional. That is the second difference between weak and unowned references. The value of a weak reference needs to be unwrapped before it can be accessed whereas you can directly access the value of an unowned reference.

![Table](https://koenig-media.raywenderlich.com/uploads/2016/05/Table-480x227.png)

```swift
class A {
    weak var a: A?
//    weak let b: A? // error - It should be var
//    weak var c: A // error - It should be nil
}
// W O V (wow)

class B {
//    unowned var a: A? // runtime error - unwrapping nil
    unowned let b: A
    unowned var c: A
    
    init(b: A, c: A) {
        self.b = b
        self.c = c
    }
}
// U V L NO (UV Light -> NO)
```

## Reference Cycles With Closures

Reference cycles for objects occur when properties reference each other. Like objects, closures are also reference types and can cause cycles. Closures ***capture***, or close over, the objects they operate on.

For example, if you assign a closure to a property of a class, and that closure uses instance properties of that same class, you have a reference cycle. In other words, the object holds a reference to the closure via a stored property. The closure holds a reference to the object via the captured value of `self`.

![Closure Reference](https://koenig-media.raywenderlich.com/uploads/2016/06/Closure-Referene-1-480x202.png)

### Capture Lists

Swift has a simple, elegant way to **break strong reference cycles in closures**. You declare a ***capture list*** in which you define the relationships between the closure and the objects it captures.

```swift
var x = 5, y = 5
let someClosure = { [x] in
  print("Value inside closure x: \(x), y: \(y)")
}
x = 6; y = 6

someClosure()
print("Value after closure x: \(x), y: \(y)")
```

```swift
Output:
Value inside closure x: 5, y: 6
Value after closure x: 6, y: 6
```

`x` is in the closure capture list, so you copy `x` at the definition point of the closure. It’s ***captured by value***.

`y` is not in the capture list, and is instead ***captured by reference***. This means that `y` will be whatever it is when the closure runs, rather than what it was at the point of capture.

Capture lists come in handy for defining a `weak` or `unowned` relationship between objects used in a closure. In this case, `unowned` is a good fit, since the closure cannot exist if the instance of has gone away.

### Using Unowned With Care

If you are sure that a referenced object from a closure will never deallocate, you can use `unowned`. However, if it does deallocate, you are in trouble.

```swift
lazy var greetingMaker: () -> String = { [weak self] in
  guard let self = self else {
    return "No greeting available."
  }
  return "Hello \(self.who)."
}
```

The guard statement binds `self` from `weak self`. If `self` is `nil`, the closure returns *“No greeting available.”*

On the other hand, if `self` is not `nil`, it makes `self` a strong reference, so the object is *guaranteed* to live until the end of the closure.

## Cycles With Value Types and Reference Types

**Swift types are *reference types*, like classes, or *value types*, like structures or enumerations.** You copy a value type when you pass it, whereas reference types share a single copy of the information they reference.

This means that you can’t have cycles with value types. Everything with value types is a copy, not a reference, meaning that they can’t create cyclical relationships. You need at least two references to make a cycle.

```swift
struct Node { // Error
  var payload = 0
  var next: Node?
}
```

Hmm, the compiler’s not happy. A `struct` value type cannot be recursive or use an instance of itself. Otherwise, a `struct` of this type would have an infinite size.

Change `struct` to a class:

```swift
class Node {
  var payload = 0
  var next: Node?
}
```

Self reference is not an issue for classes (i.e. reference types), so the compiler error disappears.
