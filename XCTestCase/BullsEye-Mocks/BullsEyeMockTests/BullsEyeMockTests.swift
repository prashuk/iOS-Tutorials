import XCTest
@testable import BullsEye

class MockUserDefaults: UserDefaults {
  var gameStyleChanged = 0
  override func set(_ value: Int, forKey defaultName: String) {
    if defaultName == "gameStyle" {
      gameStyleChanged += 1
    }
  }
}
/*
 This creates the SUT and the mock object and injects the mock object as a property of the SUT.
*/

class BullsEyeMockTests: XCTestCase {
  
  var sut: ViewController!
  var mockUserDefault: MockUserDefaults!
  
  override func setUp() {
    super.setUp()

    sut = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? ViewController
    
    mockUserDefault = MockUserDefaults(suiteName: "testing")
    sut.defaults = mockUserDefault
  }
  
  func testGameStyleChanged() {
    // Given
    let segmentControl = UISegmentedControl()
    
    // When
    XCTAssertEqual(mockUserDefault.gameStyleChanged, 0)
    segmentControl.addTarget(sut, action: #selector(ViewController.chooseGameStyle(_:)), for: .valueChanged)
    segmentControl.sendActions(for: .valueChanged)
    
    // Then
    XCTAssertEqual(mockUserDefault.gameStyleChanged, 1)
  }
  
  override func tearDown() {
    sut = nil
    mockUserDefault = nil
    
    super.tearDown()
  }
  
}
