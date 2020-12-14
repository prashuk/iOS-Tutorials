//
//  ViewController.swift
//  FaceIDTouchID
//
//  Created by Prashuk Ajmera on 12/14/20.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Identify Yourself") { [weak self] (success, error) in
                DispatchQueue.main.async {
                    if success {
                        print("Authenticated")
                    } else {
                        print("Not Authenticated")
                    }
                }
            }
        } else {
            print("Not Permitted")
        }
    }


}

