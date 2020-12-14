import Foundation

class BullsEyeGame {
  var round = 0
  let startValue = 50
  var targetValue = 50
  var scoreRound = 0
  var scoreTotal = 0
  
  init() {
    startNewGame()
  }
  
  func startNewGame() {
    round = 0
    scoreTotal = 0
    startNewRound()
  }
  
  func startNewRound() {
    round = round + 1
    scoreRound = 0
    targetValue = 1 + (Int(arc4random()) % 100)
  }
  
  @discardableResult
  func check(guess: Int) -> Int {
    let difference = abs(targetValue - guess)
    scoreRound = 100 - difference
    scoreTotal = scoreTotal + scoreRound
    
    return difference
  }
}
