import UIKit
import UserNotifications
import SafariServices

enum Identifiers {
  static let viewAction = "VIEW_IDENTIFIER"
  static let newsCategory = "NEWS_CATEGORY"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    UITabBar.appearance().barTintColor = UIColor.themeGreenColor
    UITabBar.appearance().tintColor = UIColor.white
    
    registerForPushNotification()
    
    let notificationOption = launchOptions?[.remoteNotification]
    if let notification = notificationOption as? [String: AnyObject], let aps = notification["aps"] as? [String: AnyObject] {
      NewsItem.makeNewsItem(aps)
    }
    (window?.rootViewController as? UITabBarController)?.selectedIndex = 1
    
    return true
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    guard let aps = userInfo["aps"] as? [String: AnyObject] else {
      completionHandler(.failed)
      return
    }
    NewsItem.makeNewsItem(aps)
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let tokenPart = deviceToken.map { data in
      String(format: "%02.2hhx", data)
    }
    let token = tokenPart.joined()
    print("Device Token: \(token)")
  }
  
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("Failed to register: \(error)")
  }
  
  func registerForPushNotification() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
      print("Permission granted: \(granted)")
      guard granted else { return }
      
      let viewAction = UNNotificationAction(identifier: Identifiers.viewAction, title: "View", options: [.foreground])
      let newsCategory = UNNotificationCategory(identifier: Identifiers.newsCategory, actions: [viewAction], intentIdentifiers: [], options: [])
      UNUserNotificationCenter.current().setNotificationCategories([newsCategory])
      
      self?.getNotificationSettings()
    }
  }
  
  func getNotificationSettings() {
    UNUserNotificationCenter.current().getNotificationSettings { setting in
      guard setting.authorizationStatus == .authorized else { return }
      DispatchQueue.main.async {
        UIApplication.shared.registerForRemoteNotifications()
      }
    }
  }
}
