import XCTest
@testable import HalfTunes

class HalfTunesFakeTests: XCTestCase {
  
  var sut: SearchViewController!
  
  override func setUp() {
    super.setUp()
    
    sut = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? SearchViewController
    
    let testBundle = Bundle(for: type(of: self))
    let path = testBundle.path(forResource: "abbaData", ofType: "json")
    let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
    
    let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")
    let urlResponse = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: nil, headerFields: nil)
    
    let sessionMock = URLSessionMock(data: data, response: urlResponse, error: nil)
    sut.defaultSession = sessionMock
  }
  
  /*
   
   This sets up the fake data and response and creates the fake session object. Finally, at the end, it injects the fake session into the app as a property of sut.
   Now, you’re ready to write the test that checks whether calling updateSearchResults(_:) parses the fake data.
   
  */
  
  func test_UpdateSearchResults_ParsesData() {
    // Given
    let promise = expectation(description: "Status code: 200")
    
    // When
    XCTAssertEqual(sut.searchResults.count, 0, "searchResults should be empty before the data task runs")
    
    let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")
    let dataTask = sut.defaultSession.dataTask(with: url!) { data, response, error in
      if let error = error {
        print(error.localizedDescription)
      } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
        self.sut.updateSearchResults(data)
      }
      promise.fulfill()
    }
    dataTask.resume()
    wait(for: [promise], timeout: 5)
    
    // Then
    XCTAssertEqual(sut.searchResults.count, 3, "Didn't parse 3 items from fake response")
  }
  /*
   
   You still have to write this as an asynchronous test because the stub is pretending to be an asynchronous method.
   The when assertion is that searchResults is empty before the data task runs. This should be true, because you created a completely new SUT in setUp().
   The fake data contains the JSON for three Track objects, so the then assertion is that the view controller’s searchResults array contains three items.
   
  */
  
  
  override func tearDown() {
    sut = nil
    super.tearDown()
  }
  
  
}
