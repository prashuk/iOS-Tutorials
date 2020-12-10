//
//  ViewController.swift
//  ViewAppLifeCycle
//
//  Created by Prashuk Ajmera on 11/23/20.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view Did Load")
        // First time call only
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("view Will Appear")
        // API Call
    }

    override func viewDidAppear(_ animated: Bool) {
        print("view Did Appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("view Will Disappear")
        // Deallocate any object
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("view Did Disappear")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

