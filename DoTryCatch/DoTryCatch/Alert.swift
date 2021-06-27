//
//  Alert.swift
//  DoTryCatch
//
//  Created by Prashuk Ajmera on 6/26/21.
//

import UIKit
import Foundation

class Alert {
    class func showBasic(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
}
