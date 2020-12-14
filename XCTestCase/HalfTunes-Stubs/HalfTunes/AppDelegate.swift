import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  let tintColor =  UIColor(red: 242/255, green: 71/255, blue: 63/255, alpha: 1)
  var backgroundSessionCompletionHandler: (() -> Void)?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    customizeAppearance()
    return true
  }
  
  // wakes up the app to deal with the completed background task. you need to handle two things in this event
  // 1. the app needs to reconnect to the appropriate background session with the identifier provided by the delegate method. But since you create and use one background session every time you instantiate SearchViewController, you're already reconnected at this point
  // 2. you'll need to capture the completion handler provided by the delegate method. Invoking the completion handler causes the OS to snapshot your updated UI for display in the app switcher, as well as tells the OS that your app's done working with all background activities for the current session.
  func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
    // save the provided completionHandler as a variable in your app delegate for later use
    backgroundSessionCompletionHandler = completionHandler
  }
  
  // MARK - App Theme Customization
  
  private func customizeAppearance() {
    window?.tintColor = tintColor
    UISearchBar.appearance().barTintColor = tintColor
    UINavigationBar.appearance().barTintColor = tintColor
    UINavigationBar.appearance().tintColor = .white
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
  }
}
