//
//  ViewController.swift
//  NSNotification
//
//  Created by Prashuk Ajmera on 12/14/19.
//  Copyright © 2019 Prashuk Ajmera. All rights reserved.
//

import UIKit

class ChooseDestinationViewController: UIViewController, CitySelectionDelegate {
    
    @IBOutlet weak var cityLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SourceToDestination" {
            let destinationVC = segue.destination as! DestinationViewController
            destinationVC.selectionDelegate = self
        }
    }
    
    func didCitySelect(name: City) {
        cityLbl.text = name.rawValue
    }
    
}
