import Foundation

struct NewsItem: Codable {
  let title: String
  let date: Date
  let link: String

  @discardableResult
  static func makeNewsItem(_ notification: [String: AnyObject]) -> NewsItem? {
    guard
      let news = notification["alert"] as? String,
      let url = notification["link_url"] as? String
    else {
      return nil
    }

    let newsItem = NewsItem(title: news, date: Date(), link: url)
    let newsStore = NewsStore.shared
    newsStore.add(item: newsItem)

    NotificationCenter.default.post(
      name: NewsFeedTableViewController.refreshNewsFeedNotification,
      object: self)

    return newsItem
  }
}
