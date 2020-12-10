//
//  ViewController.swift
//  Xylophone
//
//  Created by Prashuk Ajmera on 12/14/19.
//  Copyright © 2019 Prashuk Ajmera. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var player: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func keyPressed(_ sender: UIButton) {
        
//        print(sender)
//        print(sender.backgroundColor!)
        
        playSound(soundName: sender.currentTitle!)
        
        sender.alpha = 0.5
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            sender.alpha = 1
        }
    }
    
    func playSound(soundName: String) {
        let url = Bundle.main.url(forResource: soundName, withExtension: "wav")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
    }
    
//    func playSound() {
//        guard let url = Bundle.main.url(forResource: "soundName", withExtension: "mp3") else { return }
//
//        do {
//            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
//            try AVAudioSession.sharedInstance().setActive(true)
//
//            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
//
//            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
//
//            guard let player = player else { return }
//
//            player.play()
//
//        } catch let error {
//            print(error.localizedDescription)
//        }
//    }
    
}
