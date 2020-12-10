//
//  VC3.swift
//  Unwind-Segue
//
//  Created by Prashuk Ajmera on 12/15/19.
//  Copyright © 2019 Prashuk Ajmera. All rights reserved.
//

import UIKit

class VC3: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backToVC2(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func backToVC1(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToVC1", sender: nil)
    }
    
}
