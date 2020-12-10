import UIKit

class DetailViewController: UIViewController {
  // Must be set before the view loads
  var contact: Contact!

  @IBOutlet weak var firstNameLabel: UILabel!
  @IBOutlet weak var lastNameLabel: UILabel!
  @IBOutlet weak var numberLabel: UILabel!
  @IBOutlet weak var avatarImageView: UIImageView!

  override func viewDidLoad() {
    super.viewDidLoad()
    firstNameLabel.text = contact.firstName
    lastNameLabel.text = contact.lastName
    numberLabel.text = contact.number.map({ String(describing: $0) }) ?? ""
    avatarImageView.image = contact.avatar
  }
}
