//
//  ViewController.swift
//  GCDSample
//
//  Created by Prashuk Ajmera on 11/1/19.
//  Copyright © 2019 Prashuk Ajmera. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchImage()
    }
    
    func fetchImage() {
        let imageURL: URL = URL(string: "https://www.appcoda.com/wp-content/uploads/2015/12/blog-logo-dark-400.png")!
        
        URLSession.shared.dataTask(with: imageURL, completionHandler: { (imageData, response, error) in
            if let data = imageData {
                print("Did download image data")
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
                
            }
        }).resume()
    }
}
