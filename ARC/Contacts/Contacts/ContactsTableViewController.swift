import UIKit

class ContactsTableViewController: UITableViewController {
  var database = Database.sharedInstance

  override func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
    return database.contacts.count
  }

  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell",
                                                   for: indexPath) as? ContactTableViewCell else {
        fatalError("Invalid cell type")
    }

    cell.contact = database.contacts[indexPath.row]
    return cell
  }

  override func tableView(_ tableView: UITableView,
                          canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }

  override func tableView(_ tableView: UITableView,
                          commit editingStyle: UITableViewCell.EditingStyle,
                          forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      database.contacts.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else {
      return
    }

    switch identifier {
    case "showDetailSegue":
      if let contactTableViewCell = sender as? ContactTableViewCell,
        let detailViewController = segue.destination as? DetailViewController {
          detailViewController.contact = contactTableViewCell.contact
        }
    case "addContactSegue":
      if let navcon = segue.destination as? UINavigationController,
        let newContactViewController = navcon.topViewController as? NewContactViewController {
          newContactViewController.delegate = self
        }
    default:
      break
    }
  }
}

extension ContactsTableViewController: NewContactViewControllerDelegate {
  func newContactViewControllerDidCancel(_ newContactViewController: NewContactViewController) {
    newContactViewController.dismiss(animated: true, completion: nil)
  }
  
  func newContactViewController(_ newContactViewController: NewContactViewController, created contact: Contact) {
    let insertIndexPath = IndexPath(row: 0, section: 0)

    newContactViewController.dismiss(animated: true) {
      self.tableView.scrollToRow(at: insertIndexPath, at: .top, animated: true)
      self.database.contacts.insert(contact, at: insertIndexPath.row)
      self.tableView.insertRows(at: [insertIndexPath], with: .automatic)
    }
  }
}
