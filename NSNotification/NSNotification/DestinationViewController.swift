//
//  DestinationViewController.swift
//  NSNotification
//
//  Created by Prashuk Ajmera on 12/14/19.
//  Copyright © 2019 Prashuk Ajmera. All rights reserved.
//

import UIKit

class DestinationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func mumbaiBtn(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Mumbai"), object: nil)
    }
    
    @IBAction func bangaloreBtn(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Dehli"), object: nil)
    }
    
}
