import Foundation
import CoreLocation

class LocationsStorage {
  static let shared = LocationsStorage()
  
  private(set) var locations: [Location]
  private let fileManager: FileManager
  private let documentsURL: URL
  
  init() {
    let fileManager = FileManager.default
    documentsURL = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)    
    self.fileManager = fileManager
    
    
    let jsonDecoder = JSONDecoder()

    // 1
    let locationFilesURLs = try! fileManager
      .contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
    locations = locationFilesURLs.compactMap { url -> Location? in
      // 2
      guard !url.absoluteString.contains(".DS_Store") else {
        return nil
      }
      // 3
      guard let data = try? Data(contentsOf: url) else {
        return nil
      }
      // 4
      return try? jsonDecoder.decode(Location.self, from: data)
      // 5
      }.sorted(by: { $0.date < $1.date })
  }
  
  func saveLocationOnDisk(_ location: Location) {
    // 1
    let encoder = JSONEncoder()
    let timestamp = location.date.timeIntervalSince1970

    // 2
    let fileURL = documentsURL.appendingPathComponent("\(timestamp)")

    // 3
    let data = try! encoder.encode(location)

    // 4
    try! data.write(to: fileURL)

    // 5
    locations.append(location)
    
    NotificationCenter.default.post(name: .newLocationSaved, object: self, userInfo: ["location": location])
  }
  
  func saveCLLocationToDisk(_ clLocation: CLLocation) {
    let currentDate = Date()
    AppDelegate.geoCoder.reverseGeocodeLocation(clLocation) { placemarks, _ in
      if let place = placemarks?.first {
        let location = Location(clLocation.coordinate, date: currentDate, descriptionString: "\(place)")
        self.saveLocationOnDisk(location)
      }
    }
  }

}

extension Notification.Name {
  static let newLocationSaved = Notification.Name("newLocationSaved")
}
