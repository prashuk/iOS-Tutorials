import UIKit

protocol NewContactViewControllerDelegate: class {
  func newContactViewController(_ newContactViewController: NewContactViewController, created: Contact)
  func newContactViewControllerDidCancel(_ newContactViewController: NewContactViewController)
}

class NewContactViewController: UIViewController {
  weak var delegate: NewContactViewControllerDelegate?

  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var countryCodeTextField: UITextField!
  @IBOutlet weak var numberTextField: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()

    firstNameTextField.delegate = self
    lastNameTextField.delegate = self
    countryCodeTextField.delegate = self
    numberTextField.delegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    firstNameTextField.becomeFirstResponder()
  }

  private func closeKeyboard() {
    for view in view.subviews where view.isFirstResponder {
        view.resignFirstResponder()
    }
  }

  @IBAction func cancel(_ sender: AnyObject) {
    closeKeyboard()
    delegate?.newContactViewControllerDidCancel(self)
  }

  @IBAction func save(_ sender: AnyObject) {
    // Validation
    guard let firstName = self.firstNameTextField.text,
      let lastName = self.lastNameTextField.text,
      let countryCode = self.countryCodeTextField.text,
      let numberString = self.numberTextField.text, firstName != "" || lastName != "" else {
        return
    }

    closeKeyboard()
    let contact = Contact(firstName: firstName, lastName: lastName)
    let number = Number(countryCode: countryCode, numberString: numberString, contact: contact)
    contact.number = number
    self.delegate?.newContactViewController(self, created: contact)
  }
}

// MARK: - UITextFieldDelegate

extension NewContactViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()

    switch textField {
    case firstNameTextField:
      lastNameTextField.becomeFirstResponder()
    case lastNameTextField:
      countryCodeTextField.becomeFirstResponder()
    case countryCodeTextField:
      numberTextField.becomeFirstResponder()
    case numberTextField:
      save(self)
    default:
      break
    }

    return true
  }
}
