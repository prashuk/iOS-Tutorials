import UIKit

class NewsItemCell: UITableViewCell {
  func updateWithNewsItem(_ item: NewsItem) {
    textLabel?.text = item.title
    detailTextLabel?.text = DateParser.displayString(for: item.date)
  }
}
