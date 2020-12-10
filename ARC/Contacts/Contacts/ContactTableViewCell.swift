import UIKit

class ContactTableViewCell: UITableViewCell {
  var contact: Contact? {
    didSet {
      nameLabel?.text = contact.map({ String(describing: $0) }) ?? ""
    }
  }

  @IBOutlet weak var nameLabel: UILabel?
}
