//
//  ViewController.swift
//  Quizzler-iOS13
//
//  Created by Angela Yu on 12/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var choice1Btn: UIButton!
    @IBOutlet weak var choice2Btn: UIButton!
    @IBOutlet weak var choice3Btn: UIButton!
    @IBOutlet weak var scoreLbl: UILabel!
    
    var quizBrain = QuizBrain()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }

    @IBAction func answerBtnPressed(_ sender: UIButton) {
        
        let userAnswer = sender.currentTitle!
        let userGotItRight = quizBrain.checkAnswer(userAnswer)
        
        if userGotItRight {
            sender.backgroundColor = UIColor.green
        } else {
            sender.backgroundColor = UIColor.red
        }
        
        quizBrain.nextQuestion()
        
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
    }
    
    @objc func updateUI() {
        questionLbl.text = quizBrain.getQuestion()
        
        let answerChoices = quizBrain.getChoices()
        choice1Btn.setTitle(answerChoices[0], for: .normal)
        choice2Btn.setTitle(answerChoices[1], for: .normal)
        choice3Btn.setTitle(answerChoices[2], for: .normal)
        
        progressBar.progress = quizBrain.getProgress()
        
        scoreLbl.text = "Score \(quizBrain.getScore())"
        
        choice1Btn.backgroundColor = UIColor.clear
        choice2Btn.backgroundColor = UIColor.clear
        choice3Btn.backgroundColor = UIColor.clear
    }
    
}

