import UIKit


// https://www.linkedin.com/pulse/understanding-managing-race-conditions-swift-6-min-read-essam-fahmy-m77nf/



class Counter {
    private var value = 0
    private let queue = DispatchQueue(label: "com.prashuk.increment")
    
    func increment() {
        queue.async {
            self.value += 1
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
