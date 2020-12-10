import UIKit
import UserNotifications

class PlacesTableViewController: UITableViewController {
  
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
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return LocationsStorage.shared.locations.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath)
    let location = LocationsStorage.shared.locations[indexPath.row]
    cell.textLabel?.numberOfLines = 3
    cell.textLabel?.text = location.description
    cell.detailTextLabel?.text = location.dateString
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 110
  }
}
