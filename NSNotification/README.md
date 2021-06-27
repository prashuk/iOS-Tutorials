# NSNotification

NSNotificationCenter can be seen as a tool for communicating information within your app. Unlike push or local notifications where you are notifying a user of any content you would like them to receive,

NSNotificationCenter allows us to send and receive information between classes and/or structs based on an action that has occurred in our app.

`NotificationCenter.default` is where all notifications are posted to and are observed from. Each notification must have a unique way to identify themselves, which would then represent the channel we are tuning in to if we continue with our analogy. In this same way, if we were to observe, or listen, to any channel, we would call on the observe method available to us through `NotificationCenter.default` and perform some type of action based on this listening.

### For post:

NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Mumbai"), object: nil)

### For Observer (in viewDidLoad()):

NotificationCenter.default.addObserver(self, selector: #selector(setToMumbai(notification:)), name: NSNotification.Name(rawValue: "Mumbai"), object: nil)

