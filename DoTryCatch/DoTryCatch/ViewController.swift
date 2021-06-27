//
//  ViewController.swift
//  DoTryCatch
//
//  Created by Prashuk Ajmera on 6/26/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        do {
            try login()
        } catch LoginError.incompleteForm {
            Alert.showBasic(title: "Incomplete Form", message: "Fill out both email and password.", vc: self)
        } catch LoginError.invalidEmail {
            Alert.showBasic(title: "Wrong Email", message: "Enter correct email id.", vc: self)
        } catch LoginError.incorrectPasswordLength {
            Alert.showBasic(title: "Invalid Password", message: "Enter password of length more than 8.", vc: self)
        } catch {
            Alert.showBasic(title: "Unable to login", message: "Something went wrong.", vc: self)
        }
    }
    
    func login() throws {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        if email.isEmpty || password.isEmpty {
            throw LoginError.incompleteForm
        }
        
        if !email.isValidEmail {
            throw LoginError.invalidEmail
        }
        
        if password.count < 8 {
            throw LoginError.incorrectPasswordLength
        }
        
        Alert.showBasic(title: "Yeah", message: "Login Successful", vc: self)
    }

}
