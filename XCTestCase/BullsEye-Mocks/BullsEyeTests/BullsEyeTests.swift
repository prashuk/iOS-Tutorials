import XCTest
@testable import BullsEye

class BullsEyeTests: XCTestCase {
  
  var sut: BullsEyeGame!
  
  override func setUp() {
    super.setUp()
    sut = BullsEyeGame()
    sut.startNewGame()
  }
  
  func testScoreIsCompleted() {
    // 1. Given
    let guess = sut.targetValue + 5
    
    // 2. When
    sut.check(guess: guess)
    
    // 3. Then
    XCTAssertEqual(sut.scoreRound, 95, "Score computed from guess is wrong")
  }
  
  func testScoreIsComputedWhenGuessLTTarget() {
    // 1. Given
    let guess = sut.targetValue - 5

    // 2. When
    sut.check(guess: guess)

    // 3. Then
    XCTAssertEqual(sut.scoreRound, 95, "Score computed from guess is wrong")
  }
  
  override func tearDown() {
    sut = nil
    super.tearDown()
  }
  
}
