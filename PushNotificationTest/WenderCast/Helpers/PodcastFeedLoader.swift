import Foundation

enum PodcastFeedLoader {
  static let feedURL = "https://www.raywenderlich.com/category/podcast/feed"

  static func loadFeed(_ completion: @escaping ([PodcastItem]) -> Void) {
    guard let url = URL(string: feedURL) else { return }

    let task = URLSession.shared.dataTask(with: url) { data, _, _ in
      guard let data = data else { return }

      let xmlIndexer = SWXMLHash.config { config in
        config.shouldProcessNamespaces = true
      }
      .parse(data)

      let items = xmlIndexer["rss"]["channel"]["item"]

      let feedItems = items.compactMap { (indexer: XMLIndexer) -> PodcastItem? in
        if
          let dateString = indexer["pubDate"].element?.text,
          let date = DateParser.dateWithPodcastDateString(dateString),
          let title = indexer["title"].element?.text,
          let link = indexer["link"].element?.text {
          return PodcastItem(title: title, publishedDate: date, link: link)
        }

        return nil
      }

      completion(feedItems)
    }

    task.resume()
  }
}
