import XCTest
@testable import HalfTunes

class HalfTunesSlowTests: XCTestCase {
  var sut: URLSession!
  
  override func setUp() {
    super.setUp()
    sut = URLSession(configuration: .default)
  }
  
  func testValidCallToiTunesGetsHTTPStatusCode200() {
    // Given
    // 1
    let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")
    // 2
    let promise = expectation(description: "Status code: 200")
    
    // When
    let dataTask = sut.dataTask(with: url!) { data, response, error in
      // Then
      if let error = error {
        XCTFail("Error: \(error.localizedDescription)")
        return
      } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
        if statusCode == 200 {
          // 1
          promise.fulfill()
        } else {
          XCTFail("Status code: \(statusCode)")
        }
      }
    }
    
    dataTask.resume()
    
    // 2
    wait(for: [promise], timeout: 5)
  }
  
  func testValidCallToiTune() {
    // Given
    // 1
    let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")
    // 2
    let promise = expectation(description: "Completetion handle invoke")
    
    var statusCode: Int?
    var responseError: Error?
    
    // When
    let dataTaks = sut.dataTask(with: url!) { (data, response, error) in
      statusCode = (response as? HTTPURLResponse)?.statusCode
      responseError = error
      promise.fulfill()
    }
    
    dataTaks.resume()
    wait(for: [promise], timeout: 5)
    
    // Then
    XCTAssertNil(responseError)
    XCTAssertEqual(statusCode, 200)
  }
  
  override func tearDown() {
    sut = nil
    super.tearDown()
  }
  
}
