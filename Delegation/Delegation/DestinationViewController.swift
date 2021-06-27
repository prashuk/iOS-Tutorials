//
//  DestinationViewController.swift
//  NSNotification
//
//  Created by Prashuk Ajmera on 12/14/19.
//  Copyright © 2019 Prashuk Ajmera. All rights reserved.
//

import UIKit

protocol CitySelectionDelegate {
    func didCitySelect(name: City)
}

class DestinationViewController: UIViewController {
    
    var selectionDelegate: CitySelectionDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func mumbaiBtn(_ sender: Any) {
        selectionDelegate.didCitySelect(name: .Mumbai)
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func bangaloreBtn(_ sender: Any) {
        selectionDelegate.didCitySelect(name: .Bangalore)
        navigationController?.popToRootViewController(animated: true)
    }
    
}

enum City: String {
    case Mumbai
    case Bangalore
}
