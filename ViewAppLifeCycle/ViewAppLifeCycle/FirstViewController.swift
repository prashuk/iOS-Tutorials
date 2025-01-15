//
//  ViewController.swift
//  ViewAppLifeCycle
//
//  Created by Prashuk Ajmera on 11/23/20.
//

import UIKit

class FirstViewController: UIViewController {
    
    // All these view life cycle methods are called by the system not by the user
    
    // When we create a ViewController, we are subclassing the UIViewController, so inheriting all life cycles methods from the super class that is why every function is overridden and inside it there is super init function called. So along with apple's logic we have written our logic as well
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View Did Load First View Controller")
        // First time call only
        // When the content view loads up/created in the memory/hierarchy for the first time
        // Content view is basically the root view of a screen (see storyboard for reference)
        // Thats why all the IBOutlets are force unwrapped because we know that outlet is present in the storyboard
        // Initial setup
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("View Will Appear")
        // Called just before the content view is shown to app's view hierarchy (but its added to hierarchy)
        // API Call
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("View Will Layout Subviews")
        // Called when the content view's bounds changes, but before it lays out its subviews
        // Portrait to landscape to portrait
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("View Did Layout Subviews")
        // Called when the content view's bounds changes, but after it lays out its subviews
        // Portrait to landscape to portrait
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("View Did Appear")
        // Called just after the content view is added to app's view hierarchy
        // Animations
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("View Will Disappear")
        // Called just before the content view is remove to app's view hierarchy
        // Deallocate any object
        // Save any changes like form
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("View Did Disappear")
        // Called just after the content view is remove to app's view hierarchy
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Did Receive Memory Warning")
        // Dispose of any resources that can be recreated.
    }


}

