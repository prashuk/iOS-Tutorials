# Push Notifications

Push notifications allow developers to reach users, even when users aren’t actively using an app!

- Configure your app to receive push notifications.
- Display them to your users or perform other tasks.



What are push notifications? They are messages sent to your app through the Apple Push Notification service (APNs) even if your app isn’t running or the phone is sleeping.

- Display a short text message, called an alert, that draws attention to something new in your app.
- Play a notification sound.
- Set a badge number on the app’s icon to let the user know there are new items.
- Provide actions the user can take without opening the app.
- Show a media attachment.
- Be silent, allowing the app to perform a task in the background.
- Group notifications into threads.
- Edit or remove delivered notifications.
- Run code to change your notification before displaying it.
- Display a custom, interactive UI for your notification.
- And probably more.

An Apple Developer Program membership to be able to compile the app with the Push Notifications entitlement.

To send and receive push notifications, you must perform three main tasks:

1. Configure your app and register it with the APNs.
2. Send a push notification from a server to specific devices via APNs. You’ll simulate that with Xcode.
3. Use callbacks in the app to receive and handle push notifications.



## Sending and Receiving Push Notifications

### Configuring the App

Security is very important for push notifications.

### Enabling the Push Notification Service

First, you have to change the bundle identifier. In Xcode, highlight *WenderCast* in the Project navigator, then select the *WenderCast* target. Select *General*, then change *Bundle Identifier* to something unique so Apple’s push notification server can direct pushes to this app.

[![Change the bundle identifier](https://koenig-media.raywenderlich.com/uploads/2020/06/Change-bundle-identifier-650x206.png)](https://koenig-media.raywenderlich.com/uploads/2020/06/Change-bundle-identifier.png)

Next, you need to create an App ID in your developer account and enable the push notification entitlement. Xcode has a simple way to do this: With the *WenderCast* target still selected, click the *Signing & Capabilities* tab and then click the *+ Capability button*. Type “push” in the filter field and press *Enter*.

[![Add the push notifications capability](https://koenig-media.raywenderlich.com/uploads/2020/06/Add-push-notifications-capability-650x240.png)](https://koenig-media.raywenderlich.com/uploads/2020/06/Add-push-notifications-capability.png)

After adding the push notifications entitlement, your project should look like this:

[![Project with push notifications entitlement](https://koenig-media.raywenderlich.com/uploads/2020/06/After-adding-push-notifications-entitlement-2-650x180.png)](https://koenig-media.raywenderlich.com/uploads/2020/06/After-adding-push-notifications-entitlement-2.png)

Behind the scenes, this creates the App ID and then adds the push notifications entitlement to it. You can log into the Apple Developer Center to verify this:

[![App ID configuration showing push notifications entitlement](https://koenig-media.raywenderlich.com/uploads/2020/06/Apple-developer-App-ID-configuration-528x500.png)](https://koenig-media.raywenderlich.com/uploads/2020/06/Apple-developer-App-ID-configuration.png)





### Asking for User Notifications Permission

There are two steps you take to register for push notifications.

- First, you must get the user’s permission to show notifications.
- Then, you can register the device to receive remote (push) notifications.

If all goes well, the system will then provide you with a *device token*, which you can think of as an “address” to this device.



You’ll register for push notifications immediately after the app launches. Ask for user permissions first.

Open *AppDelegate.swift* and add the following to the top of the file:

```swift
import UserNotifications
```

Then, add the following method to the end of `AppDelegate`:

```swift
func registerForPushNotifications() {
  UNUserNotificationCenter
  	.current() 
    .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
      print("Permission granted: \(granted)")
    }
}
```

Build and run. When the app launches, you should receive a prompt that asks for permission to send you notifications.

Tap *Allow*, and poof! The app can now display notifications. Great!

But what if the user declines the permissions? Add this method inside `AppDelegate`:

```swift
func getNotificationSettings() {
  UNUserNotificationCenter.current().getNotificationSettings { settings in
    print("Notification settings: \(settings)")
  }
}
```

First, you specified the settings you *want*. This method returns the settings the user has *granted*. For now, you’re printing them, but you’ll circle back here shortly to do more with this.

In `registerForPushNotifications()`, replace the call to `requestAuthorization(options:completionHandler:)` with the following:

```swift
UNUserNotificationCenter.current()
  .requestAuthorization(
    options: [.alert, .sound, .badge]) { [weak self] granted, _ in
    print("Permission granted: \(granted)")
    guard !granted else { return }
    self?.getNotificationSettings()
  }
```



### Registering With APNs

Now that you have permissions, you’ll register for remote notifications!

In `getNotificationSettings()`, add the following beneath the `print` inside the closure:

```swift
guard settings.authorizationStatus == .authorized else { return }
DispatchQueue.main.async {
  UIApplication.shared.registerForRemoteNotifications()
}
```

Here, you verify the `authorizationStatus` is `.authorized`: The user has granted notification permissions. If so, you call `UIApplication.shared.registerForRemoteNotifications()` to kick off registration with the Apple Push Notification service. You need to call this on the main thread, or you’ll receive a runtime warning.

Add the following to the end of `AppDelegate`:

```swift
func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
  let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
  let token = tokenParts.joined()
  print("Device Token: \(token)")
}
```

**This method is called by iOS whenever a call to `registerForRemoteNotifications()` succeeds. The device token is the fruit of this process. It’s provided by APNs and uniquely identifies this app on this particular device.**

**When sending a push notification, the server uses tokens as “addresses” to deliver to the correct devices. In your app, you would now send this token to your server to save and use later on for sending notifications.**

Now add the following:

```swift
func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
  print("Failed to register: \(error)")
}
```

This method is called by iOS if `registerForRemoteNotifications()` fails. You’re just printing the error for now.

That’s it! Build and run. Because you are on a simulator, you’ll see a `Failed to register` error. You can ignore that for now. Later, when you run on a real device, you should receive a token in the console output. 



## Sending a Simulated Push Notification

Use a text editor to create a file called *first.apn*, which you’ll pass to Xcode’s *simctl* utility.

```json
{
  "aps": {
    "alert": "Breaking News!",
    "sound": "default",
    "link_url": "https://raywenderlich.com"
  }
}
```

Build and run the app again on the simulator, then background the app or lock the device. The app is not yet able to process push notifications while in the foreground.

To use *simctl*, you’ll need to know the device identifier for the simulator that you are running the app in. If there is only one device running in the simulator, you can use *booted* instead of an identifier. To get the identifier, in Xcode, select *Windows ▸ Devices and Simulators*, then select the *Simulators* tab at the top and select the simulator you’re using from the list on the left.

[![Finding the device identifier in Xcode](https://koenig-media.raywenderlich.com/uploads/2020/07/Finding-device-identifier-650x387.gif)](https://koenig-media.raywenderlich.com/uploads/2020/07/Finding-device-identifier.gif)

Open the *Terminal* app and type in the following command using either *booted* or the device identifier from Xcode in place of *device_identifier*: `xcrun simctl push device_identifier bundle_identifier first.apn`. Replace `device_identifier` with the device identifier you copied from Xcode and replace `bundle_identifier` with the app’s bundle identifier

[![Using xcrun simctl to send a push notification from the terminal](https://koenig-media.raywenderlich.com/uploads/2020/07/Sending-push-with-xcrun-simctl-650x411.png)](https://koenig-media.raywenderlich.com/uploads/2020/07/Sending-push-with-xcrun-simctl.png)

Run the command and you’ll see the push notification appear on the simulator!

[![Push notification appears on simulator](https://koenig-media.raywenderlich.com/uploads/2020/07/Push-notification-appears-238x500.png)](https://koenig-media.raywenderlich.com/uploads/2020/07/Push-notification-appears.png)

Tap on the notification to launch the app.



### Understanding What Happens When You Receive a Push Notification

When your app receives a push notification, iOS calls a method in `UIApplicationDelegate`.

You’ll need to handle a notification differently depending on what state your app is in when the notification is received:

- If your app wasn’t running and the user launches it by tapping the push notification, iOS passes the notification to your app in the `launchOptions` of `application(_:didFinishLaunchingWithOptions:)`.
- If your app was running either in the foreground or the background, the system notifies your app by calling `application(_:didReceiveRemoteNotification:fetchCompletionHandler:)`. When the user opens the app by tapping the push notification, iOS may call this method again, so you can update the UI and display relevant information.

In the first case, WenderCast will create the news item and open directly to the News tab. In *AppDelegate.swift*, add the following code to the end of `application(_:didFinishLaunchingWithOptions:)`, just before the return statement:

```swift
// Check if launched from notification
let notificationOption = launchOptions?[.remoteNotification]

if 
  let notification = notificationOption as? [String: AnyObject],
  let aps = notification["aps"] as? [String: AnyObject] {
  NewsItem.makeNewsItem(aps)
  (window?.rootViewController as? UITabBarController)?.selectedIndex = 1
}
```

To test this, you need to edit the scheme of WenderCast. First, build and run to install the latest code on the simulator. Then, click the *WenderCast* scheme and select *Edit Scheme…*:

![Edit the Scheme](https://koenig-media.raywenderlich.com/uploads/2018/09/Edit-Scheme-650x207.png)

Select *Run* from the sidebar, then in the *Info* tab select *Wait for executable to be launched*:

[![Choose wait for the executable to be launched](https://koenig-media.raywenderlich.com/uploads/2020/06/Edit-scheme-650x203.png)](https://koenig-media.raywenderlich.com/uploads/2020/06/Edit-scheme.png)

This option will make the debugger wait for the app to be launched for the first time after installing to attach to it.

Build and run. Once it’s done installing, send out more breaking news using `xcrun simctl` as before. Tap the notification, and the app will open to news



To handle the situation where your app is running when a push notification is received, add the following to `AppDelegate`:

```swift
func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
  guard let aps = userInfo["aps"] as? [String: AnyObject] else {
    completionHandler(.failed)
    return
  }
  NewsItem.makeNewsItem(aps)
}
```

Since iOS calls this method when the app is running, you need to change the scheme back to launching the app automatically to test it. In the Scheme editor, under *Launch*, select *Automatically*. Build and run.



## Working With Actionable Notifications

Your app can define actionable notifications when you register for notifications by using ***categories***. Each category of notification can have a few preset custom actions.

Once registered, your server can set the category of a push notification. The corresponding actions will be available to the user when received.

For WenderCast, you’ll define a *News* category with a custom action named *View*. This action will allow users to view the news article in the app if they choose to.

In `registerForPushNotifications()`

```swift
// 1
let viewAction = UNNotificationAction(
  identifier: Identifiers.viewAction,
  title: "View",
  options: [.foreground])

// 2
let newsCategory = UNNotificationCategory(
  identifier: Identifiers.newsCategory,
  actions: [viewAction],
  intentIdentifiers: [],
  options: [])

// 3
UNUserNotificationCenter.current().setNotificationCategories([newsCategory])
```

Going through this, step-by-step:

1. Create a new notification action, with the title ***View*** on the button, that opens the app in the foreground when triggered. The action has a distinct identifier, which iOS uses to differentiate between other actions on the same notification.
2. Define the news category, which will contain the view action. This also has a distinct identifier that your payload will need to contain to specify that the push notification belongs to this category.
3. Register the new actionable notification by calling `setNotificationCategories`.

Build and run the app to register the new notification settings.

Background the app and then send the following payload via the `xcrun simctl` utility:

```json
{
  "aps": {
    "alert": "Breaking News!",
    "sound": "default",
    "link_url": "https://raywenderlich.com",
    "category": "NEWS_CATEGORY"
  }
}
```



### Handling Notification Actions

Whenever a notification action gets triggered, `UNUserNotificationCenter` informs its delegate. Back in *AppDelegate.swift*, add the following class extension to the bottom of the file:

```swift
// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    // 1
    let userInfo = response.notification.request.content.userInfo
    
    // 2
    if 
      let aps = userInfo["aps"] as? [String: AnyObject],
      let newsItem = NewsItem.makeNewsItem(aps) {
      (window?.rootViewController as? UITabBarController)?.selectedIndex = 1
      
      // 3
      if response.actionIdentifier == Identifiers.viewAction,
        let url = URL(string: newsItem.link) {
        let safari = SFSafariViewController(url: url)
        window?.rootViewController?
          .present(safari, animated: true, completion: nil)
      }
    }
    
    // 4
    completionHandler()
  }
}
```

This is the callback you get when the app opens because of a custom action. It might look like there’s a lot going on, but there’s not much new here:

1. Get the `userInfo` dictionary.
2. Create a `NewsItem` from the `aps` dictionary and navigate to the News tab.
3. Check the `actionIdentifier`. If it is the “View” action and the link is a valid URL, it displays the link in an `SFSafariViewController`.
4. Call the completion handler the system passes to you.

There is one last bit: You have to set the delegate on `UNUserNotificationCenter`. Add this line to the top of `application(_:didFinishLaunchingWithOptions:)`:

```swift
UNUserNotificationCenter.current().delegate = self
```

Build and run. Close the app again, then send another news notification with the following payload:

```json
{
  "aps": {
    "alert": "New Posts!",
    "sound": "default",
    "link_url": "https://raywenderlich.com",
    "category": "NEWS_CATEGORY"
  }
}
```

Pull down the notification and tap the View action, and you’ll see WenderCast present a Safari View controller right after it launches:

[![Notification link URL opened in a Safari view](https://koenig-media.raywenderlich.com/uploads/2020/06/Safari-view-of-link-url-231x500.jpeg)](https://koenig-media.raywenderlich.com/uploads/2020/06/Safari-view-of-link-url.jpeg)

Congratulations, you’ve implemented an actionable notification! Send a few more and try opening the notification in different ways to see how it behaves.

## Sending to a Real Device

However, if you want to get a feel for how to send push notifications to a real device and try silent push, then you need to do some additional setup. Download the [PushNotifications](https://github.com/onmyway133/PushNotifications/releases) utility. You’ll use this utility app to send notifications to a real device. To install it, follow the instructions under [How to install](https://github.com/onmyway133/PushNotifications#how-to-install). Pay special attention to [how to open the app](https://github.com/onmyway133/PushNotifications#opening-app-on-macos-catalina-1015) because you’ll have to change some settings to run this utility.

Head over to the [Apple Developer Member Center](https://developer.apple.com/account) and log in.

Sending push notifications requires an *Authentication Key*. In the member center, select *Certificates, Identifiers & Profiles*, then find *Keys* on the left pane. To the right of the *Keys* title is a *+* button. Click it to create a new key.

Give the key a name, such as *Push Notification Key*. Under *Key Services*, select *Apple Push Notifications service (APNs)*.

[![Example push notification key](https://koenig-media.raywenderlich.com/uploads/2020/06/Create-a-push-notification-key-650x275.png)](https://koenig-media.raywenderlich.com/uploads/2020/06/Create-a-push-notification-key.png)

Click *Continue* and then *Register* on the next screen to create your new key. Tap *Download*. The downloaded file will have a name something like *AuthKey_4SVKWF966R.p8*. Keep track of this file — you’ll need it to send your notifications! The *4SVKWF966R* part of the file name is the *Key ID*. You’ll also need this.

The final piece that you need is your *Team ID*. Navigate to the [Membership Details](https://developer.apple.com/account/#/membership) page of the member center to find it.

You did it! With your new key, you are now ready to send your first push notification! You need just one more thing.

Run the app on your real device and copy the device token from the debugger console and have it ready.

Launch *PushNotifications* and complete the following steps:

1. Under *Authentication*, select *Token*.
2. Click the *Select P8* button and select the .p8 file from the previous section.
3. Enter your Key ID and Team ID in the relevant fields.
4. Under *Body*, enter your app’s Bundle ID and your device token.
5. Change the request body to look like this:

```json
{
  "aps": {
    "alert": "Breaking News!",
    "sound": "default",
    "link_url": "https://raywenderlich.com"
  }
}
```

Click the *Send* button in PushNotifications.

[![Push notifications tester](https://koenig-media.raywenderlich.com/uploads/2020/09/Push-notifications-tester-571x500.png)](https://koenig-media.raywenderlich.com/uploads/2020/09/Push-notifications-tester.png)

You should receive your push notification:

![Your First Push Notification](https://koenig-media.raywenderlich.com/uploads/2018/10/IMG_2818-281x500.png)

### Troubleshooting Common Issues

Here are a couple problems you might encounter:

- *Some notifications arrive, but not all*: If you’re sending many push notifications simultaneously but you receive only a few, fear not! That is by design. APNs maintains a QoS (Quality of Service) queue for each device. The size of this queue is 1, so if you send multiple notifications, the last notification is overridden.
- *Problem connecting to Push Notification Service*: One possibility could be that there is a firewall blocking the ports used by APNs. Make sure you unblock these ports.

## Using Silent Push Notifications

Silent push notifications can wake your app up silently to perform some tasks in the background. WenderCast can use this feature to quietly refresh the podcast list.

With a proper server component this can be very efficient. Your app won’t need to constantly poll for data. You can send it a silent push notification whenever new data is available.

To get started, select the *WenderCast* target again. Now click the *Signing & Capabilities* tab and add the *Background Modes* capability. Then check the *Remote notifications* option:

[![Check the remote notifications option for background modes entitlement](https://koenig-media.raywenderlich.com/uploads/2020/06/Background-modes-remote-notifications-1-650x335.png)](https://koenig-media.raywenderlich.com/uploads/2020/06/Background-modes-remote-notifications-1.png)

Now, your app will wake up in the background when it receives one of these push notifications.

In *AppDelegate.swift*, find `application(_:didReceiveRemoteNotification:fetchCompletionHandler:)`. Replace the call to `NewsItem.makeNewsItem()` with the following:

```swift
// 1
if aps["content-available"] as? Int == 1 {
  let podcastStore = PodcastStore.sharedStore
  // 2
  podcastStore.refreshItems { didLoadNewItems in
    // 3
    completionHandler(didLoadNewItems ? .newData : .noData)
  }
} else {
  // 4
  NewsItem.makeNewsItem(aps)
  completionHandler(.newData)
}
```

Going over the code:

1. You check to see if `content-available` is set to 1. If so, this is a silent notification.
2. You refresh the podcast list, which is an asynchronous network call.
3. When the refresh is complete, call the completion handler to let the system know whether the app loaded any new data.
4. If it isn’t a silent notification, then it is a news item, so make a news item.

Be sure to call the completion handler with the honest result. The system measures the battery consumption and time that your app uses in the background and may throttle your app if needed.

That’s all there is to it. To test it, build and run, foreground the app and push the following payload via the *PushNotifications* utility:

```json
{
  "aps": {
    "content-available": 1
  }
}
```

If all goes well, nothing should happen, unless a new podcast was just added to the remote database. To confirm the code ran as expected, set a breakpoint in `application(_:didReceiveRemoteNotification:fetchCompletionHandler:)` and step through it after the notification is sent.