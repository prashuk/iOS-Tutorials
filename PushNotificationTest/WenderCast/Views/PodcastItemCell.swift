import UIKit

class PodcastItemCell: UITableViewCell {
  func update(with newsItem: PodcastItem) {
    textLabel?.text = newsItem.title
    detailTextLabel?.text = DateParser.displayString(for: newsItem.publishedDate)
  }
}
