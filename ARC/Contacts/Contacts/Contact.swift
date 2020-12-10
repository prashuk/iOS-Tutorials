import UIKit

class Contact {
  var firstName: String
  var lastName: String
  var avatar: UIImage
  var number: Number?

  init(firstName: String, lastName: String, avatar: String = "unknown") {
    self.firstName = firstName
    self.lastName = lastName
    self.avatar = UIImage(named: avatar) ?? UIImage(named: "unknown")!
  }
}

extension Contact: CustomStringConvertible {
  var description: String {
    return [firstName, lastName].joined(separator: " ")
  }
}
