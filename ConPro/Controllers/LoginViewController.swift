import UIKit
import RealmSwift

class LoginViewController: UIViewController, UITextFieldDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        statusLabel.text = ""
        emailTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBAction func logIn(_ sender: UIButton) {
        statusLabel.text = ""
        guard let email = emailTextField.text, let password = passwordTextField.text,
            !email.isEmpty, !password.isEmpty else {
                statusLabel.text = "Please fill in both fields"
                return
        }
        
        let realm = try! Realm()
        if let user = realm.object(ofType: User.self, forPrimaryKey: email), user.password == password {
            currentUser = user
            UserDefaults.standard.set(user.email, forKey:"user")
            self.performSegue(withIdentifier: "segueToEvents", sender: self)
        } else {
            statusLabel.text = "Wrong login or password"
        }
    }

    @objc func editingChanged(_ textField: UITextField) {
        
        statusLabel.text = ""

        textField.text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (textField.text?.isEmpty)!
        {
            textField.layer.cornerRadius = 8.0;
            textField.layer.masksToBounds = true;
            textField.layer.borderColor = UIColor.red.cgColor;
            textField.layer.borderWidth = 2.0;
        }
        else
        {
            textField.layer.borderColor = UIColor.clear.cgColor;
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
