import UIKit
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  let center = UNUserNotificationCenter.current()
  let locationManager = CLLocationManager()
  static let geoCoder = CLGeocoder()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    
    center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
    }
    
    locationManager.requestAlwaysAuthorization()
    locationManager.startMonitoringVisits()
    locationManager.delegate = self
    
    // 1
    locationManager.distanceFilter = 35

    // 2
    locationManager.allowsBackgroundLocationUpdates = true

    // 3
    locationManager.startUpdatingLocation()
    
    return true
  }
}

extension AppDelegate: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
    // create CLLocation from the coordinates of CLVisit
    let clLocation = CLLocation(latitude: visit.coordinate.latitude, longitude: visit.coordinate.longitude)

    // Get location description
    AppDelegate.geoCoder.reverseGeocodeLocation(clLocation) { placemarks, _ in
      if let place = placemarks?.first {
        let description = "\(place)"
        self.newVisitReceived(visit, description: description)
      }
    }
  }

  func newVisitReceived(_ visit: CLVisit, description: String) {
    let location = Location(visit: visit, descriptionString: description)

    // Save location to disk
    LocationsStorage.shared.saveLocationOnDisk(location)
    
    // 1
    let content = UNMutableNotificationContent()
    content.title = "New Journal entry 📌"
    content.body = location.description
    content.sound = .default

    // 2
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
    let request = UNNotificationRequest(identifier: location.dateString, content: content, trigger: trigger)

    // 3
    center.add(request, withCompletionHandler: nil)
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      // 1
      guard let location = locations.first else {
        return
      }
      
      // 2
      AppDelegate.geoCoder.reverseGeocodeLocation(location) { placemarks, _ in
      if let place = placemarks?.first {
        // 3
        let description = "Fake visit: \(place)"
          
        //4
        let fakeVisit = FakeVisit(
          coordinates: location.coordinate,
          arrivalDate: Date(),
          departureDate: Date())
        self.newVisitReceived(fakeVisit, description: description)
      }
    }
  }

}


final class FakeVisit: CLVisit {
  private let myCoordinates: CLLocationCoordinate2D
  private let myArrivalDate: Date
  private let myDepartureDate: Date

  override var coordinate: CLLocationCoordinate2D {
    return myCoordinates
  }
  
  override var arrivalDate: Date {
    return myArrivalDate
  }
  
  override var departureDate: Date {
    return myDepartureDate
  }
  
  init(coordinates: CLLocationCoordinate2D, arrivalDate: Date, departureDate: Date) {
    myCoordinates = coordinates
    myArrivalDate = arrivalDate
    myDepartureDate = departureDate
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
