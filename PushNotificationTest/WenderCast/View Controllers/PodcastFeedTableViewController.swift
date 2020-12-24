import UIKit

class PodcastFeedTableViewController: UITableViewController {
  let podcastStore = PodcastStore.sharedStore

  override var prefersStatusBarHidden: Bool {
    return true
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 75

    if let patternImage = UIImage(named: "pattern-grey") {
      let backgroundView = UIView()
      backgroundView.backgroundColor = UIColor(patternImage: patternImage)
      tableView.backgroundView = backgroundView
    }

    if podcastStore.items.isEmpty {
      print("Loading podcast feed for the first time")
      podcastStore.refreshItems { didLoadNewItems in
        if didLoadNewItems {
          DispatchQueue.main.async {
            self.tableView.reloadData()
          }
        }
      }
    }
  }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension PodcastFeedTableViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return podcastStore.items.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PodcastItemCell", for: indexPath)

    if let podcastCell = cell as? PodcastItemCell {
      podcastCell.update(with: podcastStore.items[indexPath.row])
    }

    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = podcastStore.items[indexPath.row]

    guard let url = URL(string: item.link) else {
      return
    }

    let safari = WenderSafariViewController(url: url)
    present(safari, animated: true, completion: nil)
  }
}
