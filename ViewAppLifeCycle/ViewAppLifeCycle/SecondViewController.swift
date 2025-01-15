//
//  SecondViewController.swift
//  ViewAppLifeCycle
//
//  Created by Prashuk Ajmera on 6/28/21.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("View Did Load Second View Controller")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("View Will Appear Second View Controller")
        // Called just before the content view is shown to app's view hierarchy (but its added to hierarchy)
        // API Call
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("View Did Appear Second View Controller")
        // Called just after the content view is added to app's view hierarchy
        // Animations
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("View Will Disappear Second View Controller")
        // Called just before the content view is remove to app's view hierarchy
        // Deallocate any object
        // Save any changes like form
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("View Did Disappear Second View Controller")
        // Called just after the content view is remove to app's view hierarchy
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Did Receive Memory Warning Second View Controller")
        // Dispose of any resources that can be recreated.
    }

}
