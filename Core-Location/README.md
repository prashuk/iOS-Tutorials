# Travel-Logger
Core Location - iOS. Reference: Ray Wenderlich

# Core Location

In this tutorial, you’ll make a travel logging app. Imagine you’re traveling to a new city. Instead of keeping a journal, this app will automatically track locations you visit, so you can remember them later and compare them with your friends.

Here’s what this app will do:

- Track the user’s location, even when the app is not open.
- When the app logs a new location, send the user a local notification.
- Save those locations in a file.
- Display a list of logged locations.
- Display a map with user location and logged locations.
- Allow users to manually log their current location.

## Getting Started

```swift
import CoreLocation
import UserNotifications
```

The *CoreLocation* framework listens to user location updates. You’ll use the *UserNotifications* framework to show banner notifications when the app logs a new location.

```swift
let center = UNUserNotificationCenter.current()
let locationManager = CLLocationManager()
```

Through these two properties, you’ll access the API of the two frameworks above.

## Asking for User Locations

The first step is to ask permission to track the user’s location. In the age of privacy scandals, Apple stands pretty strong on keeping users in charge of which data an app can gather. That’s why it is very important to properly ask users to allow the app access to gather the required data.

### Providing a Proper Description

To gather location changes data, you need to set two special strings in the *Info.plist* file:

![Setting up Info.plist for Core Location](https://koenig-media.raywenderlich.com/uploads/2018/04/Screen-Shot-2018-04-15-at-9.21.50-PM-650x51.png)

The app presents these strings when it asks for permission. Feel free to change the prompts to any text you like as long as the text fulfills the following requirements:

- Encourage users to give you the access.
- Let users know exactly how, and for what reason, the data is being collected.
- The statement is 100% true.

### Asking for Locations Permissions

Open *AppDelegate.swift* and add this line before the return statement in `application(_:didFinishLaunchingWithOptions:)`:

```swift
locationManager.requestAlwaysAuthorization()
```

With this line, you ask users to allow the app to access location data both in the background and the foreground.

### Asking for Notifications Permissions

Just add this code right above the line you just added:

```swift
center.requestAuthorization(options: [.alert, .sound]) { granted, error in
}
```

Here, you pass options to specify what kind of notifications you want to post. You also include an empty closure because you assume, for this tutorial, that users always give you permission. You can handle the denial in this closure.

## Choosing the Most Appropriate Locations Data

The *Core Location* framework has many ways to track a user’s location and each has different characteristics:

- *Standard location services*: High battery impact. High location precision. Great for navigational or fitness apps.
- *Significant location changes*: Medium battery impact. Medium location precision. Low stops precision.
- *Regional monitoring*: Low battery impact. Great location precision. Requires specific regions in order to monitor.

None of these is fully suitable for your app. Low battery impact is a must — a user is unlikely to use the app otherwise. What’s more, regional monitoring is also undesirable because you limit user movement to some specific regions.

Fortunately, there is one other API you can use.

### Visit Monitoring

Visit monitoring allows you to track destinations — places where the user stops for a while. It wakes the app whenever a new visit is detected and is very energy efficient and not tied to any landmark.

## Subscribe to Location Changes

Now that you know which of the many Core Location APIs you’ll use to get the user’s location, it’s time to start implementing it!

### CLLocationManager

In the *AppDelegate.swift*, add the following code:

```swift
locationManager.startMonitoringVisits()
locationManager.delegate = self
```

The first line initiates the listening feature. Core Location uses delegate callbacks to inform you of location changes.

Now, add this extension at the bottom of the file:

```swift
extension AppDelegate: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
    // create CLLocation from the coordinates of CLVisit
    let clLocation = CLLocation(latitude: visit.coordinate.latitude, longitude: visit.coordinate.longitude) 

    // Get location description
  }

  func newVisitReceived(_ visit: CLVisit, description: String) {
    let location = Location(visit: visit, descriptionString: description)

    // Save location to disk
  }
}
```

The first method is the callback from `CLLocationManager` when the new visit is recorded and it provides you with a `CLVisit`.

`CLVisit` has four properties:

1. `arrivalDate`: The date when the visit began.
2. `departureDate`: The date when the visit ended.
3. `coordinate`: The center of the region that the device is visiting.
4. `horizontalAccuracy`: An estimate of the radius (in meters) of the region.

You need to create a `Location` object from this data and, if you recall, there is an initializer that takes the `CLVisit`, date and description string:

```swift
init(_ location: CLLocationCoordinate2D, date: Date, descriptionString: String)
```

The only thing missing in the above is `descriptionString`.

### Location Description

To get the description, you will use `CLGeocoder`. Geocoding is the process of converting coordinates into addresses or place names in the real world. If you want to get an address from a set of coordinates, you use *reverse* geocoding. Thankfully, Core Location gives us a `CLGeocoder` class which does this for us!

Still in *AppDelegate.swift*, add this property at the top of the class:

```swift
static let geoCoder = CLGeocoder()
```

Here, you ask `geoCoder` to get placemarks from the location. The placemarks contain a bunch of useful information about the coordinates, including their addresses. You then create a description string out of the first placemark. Once you have the description string, you call `newVisitReceived(_:description:)`.

### Sending Local Notifications

Now, it’s time to notify a user when the new visit location is logged. At the bottom of `newVisitReceived(_:description:)`, add the following:

```swift
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
```

With the above, you:

1. Create notification content.
2. Create a one second long trigger and notification request with that trigger.
3. Schedule the notification by adding the request to notification center.

The visits are being recorded, but the visits are not yet persisted.

If you are using a real device and have some time for a walk, you can test your work right now. Go some place and stop to have a coffee. Visits require you remain at a place for some period of time.

The visits are being recorded, but the visits are not yet persisted.

## Faking Data (Optional)

Walking is good for your body, but it might be a problem to do it right now in the middle of building this app! To test the app without actually walking, you can use the *Route.gpx* file. This kind of file allows you to simulate the device or simulator GPS location. This particular file will simulate a walk around Apple’s campus in Cupertino.

To use it, in the Debug area, click the “Simulate Location” icon, and then select “Route” from the list:

<img src="https://koenig-media.raywenderlich.com/uploads/2018/04/route-650x333.png" alt="img" style="zoom:50%;" />

You can open the tab with a map or Maps app to see the walking route.

### Faking CLVisits

iOS records `CLVisit`s behind the scenes, and sometimes you might wait for up to 30 minutes in order to get the callback! To avoid this, you’ll need to implement mechanics that fake `CLVisit` recording. You’ll create `CLVisit` instances, and since `CLVisit` has no accessible initializer, you’ll need to make a subclass.

Add this to the end of *AppDelegate.swift*:

```swift
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
```

With this subclass, you can provide initial values for `CLVisit`‘s properties.

### Set Up locationManager

Now you need the `locationManager` to notify you when the location changes. For this, at the end of `application(_:didFinishLaunchingWithOptions:)`, before return statement, add the following:

```swift
// 1
locationManager.distanceFilter = 35

// 2
locationManager.allowsBackgroundLocationUpdates = true

// 3
locationManager.startUpdatingLocation()
```

Here’s what these lines do:

1. Receive location updates when location changes for n meters and more.
2. Allow location tracking in background.
3. Start listening.

You can comment out these 3 lines to turn off the visits faking.

### Handle Fake Visits

It’s time to handle the location callback. For this, add the following code to `AppDelegate`‘s `CLLocationManagerDelegate` extension:

```swift
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
```

1. Discard all locations except for the first one.
2. Grab the location description, as you did before.
3. Mark the visit as a fake one.
4. Create a `FakeVisit` instance and pass it to `newVisitReceived` function.

Build and run the app. Turn on the Route location simulation. Close the app or lock your iPhone and you should get a new notification around once per minute.

## Persisting Location Data

To save the visited locations, you’ll use Swift’s `Codable` protocol to encode the visited locations into JSON and write that to a file.

### Saving Records on Disk

Open *LocationsStorage.swift*. At the bottom of the class, add the following function:

```swift
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
}
```

Here’s what you do with that code:

1. Create the encoder.
2. Get the URL to file; for the file name, you use a date timestamp.
3. Convert the location object to raw data.
4. Write data to the file.
5. Add the saved location to the local array.

Now, open *AppDelegate.swift* and inside `newVisitReceived(_:description:)`, right under this:

```swift
let location = Location(visit: visit, descriptionString: description)
```

add this:

```swift
LocationsStorage.shared.saveLocationOnDisk(location)
```

Now, whenever the app receives a visit, it will grab the location description, create a *Location* object and save it to disk.

To test this, you need to do the following two things:

1. Allow the user to log his or her current location.
2. Display all saved records in a `UITableViewController`.

### Saving a Current Location

To save the current location, open *MapViewController.swift*. Inside of `addItemPressed(_:)`, add this code:

```swift
guard let currentLocation = mapView.userLocation.location else {
  return
}

LocationsStorage.shared.saveCLLocationToDisk(currentLocation)
```

As you can see, there is no `saveCLLocationToDisk(_:)` yet, so open *LocationsStorage.swift* and add this code to the bottom of the class:

```swift
func saveCLLocationToDisk(_ clLocation: CLLocation) {
  let currentDate = Date()
  AppDelegate.geoCoder.reverseGeocodeLocation(clLocation) { placemarks, _ in
    if let place = placemarks?.first {
      let location = Location(clLocation.coordinate, date: currentDate, descriptionString: "\(place)")
      self.saveLocationOnDisk(location)
    }
  }
}
```

Here, you create a `Location` object from `clLocation`, the current date and the location description from `geoCoder`. You save this location the same way as you did before.

Now, inside of the initializer, replace this line:

```swift
self.locations = []
```

with this:

```swift
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
```

With this code, you:

1. Get URLs for all files in the *Documents* folder.
2. Skip the *.DS_Store* file.
3. Read the data from the file.
4. Decode the raw data into `Location` objects — thanks `Codable` 👍.
5. Sort locations by date.

With this code, when the app launches, `LocationsStorage` will have locations taken from disk.

### Updating the List When a Location is Logged

To keep the list updated, you need to post a notification for the app to know that a new location was recorded. Please note, however, that this is not `UNNotification`, but a `Notification`. This notification is for the app's internal usage, not for notifying users.

Open *LocationsStorage.swift*. At the bottom of the file, add this extension:

```swift
extension Notification.Name {
  static let newLocationSaved = Notification.Name("newLocationSaved")
}
```

This is the notification that you will post.

Now, at the end of `saveLocationOnDisk(_:)`, add this code:

```swift
NotificationCenter.default.post(name: .newLocationSaved, object: self, userInfo: ["location": location])
```

Next, you need to listen to this notification in `PlacesTableViewController`.

Navigate to *PlacesTableViewController.swift*, and add the following code at the top of the class:

```swift
override func viewDidLoad() {
  super.viewDidLoad()

  // 1
  NotificationCenter.default.addObserver(
    self, 
    selector: #selector(newLocationAdded(_:)), 
    name: .newLocationSaved, 
    object: nil)
}

// 2
@objc func newLocationAdded(_ notification: Notification) {
  // 3
  tableView.reloadData()
}
```

With the above code, you:

1. Register a method to be called when your notification arrives.
2. Receive the notification as a parameter.
3. Reload the list.

Build and run the app. To save your current location, tap the plus button on the second tab. Opening the first tab, you should see that number of locations has increased:

### Setting up MapView With All Logged Locations

The final part of this tutorial will show you how to display locations on a map with pins.

To add pins to the map, you need to convert locations to `MKAnnotation`, which is a protocol that represents objects on a map.

Open *MapViewController.swift* and add this method to the end of the class:

```swift
func annotationForLocation(_ location: Location) -> MKAnnotation {
  let annotation = MKPointAnnotation()
  annotation.title = location.dateString
  annotation.coordinate = location.coordinates
  return annotation
}
```

This creates a pin annotation with a title and coordinates.

Now, at the end of `viewDidLoad()`, add this:

```swift
let annotations = LocationsStorage.shared.locations.map { annotationForLocation($0) }
mapView.addAnnotations(annotations)
```

This code generates pins from locations that you've already created and adds them to the map.

The only thing left to do is to add a pin when a new location is logged.

To do this, add the following function at the end of `MapViewController`:

```swift
@objc func newLocationAdded(_ notification: Notification) {
  guard let location = notification.userInfo?["location"] as? Location else {
    return
  }

  let annotation = annotationForLocation(location)
  mapView.addAnnotation(annotation)
}
```

Similarly to the first tab, you need to listen for the notification in order to know when this new location is recorded.

To subscribe to this notification, add this code to the end of `viewDidLoad`:

```swift
NotificationCenter.default.addObserver(
  self, 
  selector: #selector(newLocationAdded(_:)), 
  name: .newLocationSaved, 
  object: nil)
```

Build and run the app. Log a new location on the second tab. A pin should appear on the map:

[<img src="https://koenig-media.raywenderlich.com/uploads/2018/07/Simulator-Screen-Shot-iPhone-8-2018-07-20-at-12.11.37-281x500.png" alt="dynamically add a pin" style="zoom:50%;" />

And that's your travel logger done! Feel free to walk around town and see what places it records! This feature enables you to see and react to where the user is going without draining too much battery. Just keep in mind that the data you're collecting is sensitive data, so collect it responsibly.
