import UIKit
import RealmSwift

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatedPasswordTextField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBAction func register(_ sender: UIButton) {
        statusLabel.text = ""
        guard let email = emailTextField.text, let password = passwordTextField.text,
            let rpassword = repeatedPasswordTextField.text,
            !email.isEmpty, !password.isEmpty, !rpassword.isEmpty else {
                statusLabel.text = "Please fill in all fields"
                return
        }
        
        if password != rpassword {
            return
        }
        
        if !email.isEmail() {
            statusLabel.text = "Email is incorrect"
            return
        }
        let realm = try! Realm()
        guard realm.object(ofType: User.self, forPrimaryKey: email) == nil else {
            statusLabel.text = "User already exists"
            return
        }

        let newUser = User(email: email, password: password)
        newUser.image = #imageLiteral(resourceName: "cat").data!

        try! realm.write {
            realm.add(newUser)
            UserDefaults.standard.set(newUser.email, forKey:"user")
            currentUser = newUser
            self.performSegue(withIdentifier: "segueFromRegister", sender: self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        statusLabel.text = ""
        emailTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        repeatedPasswordTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }

    @objc func editingChanged(_ textField: UITextField) {
        
        statusLabel.text = ""

        if passwordTextField.text != repeatedPasswordTextField.text && !(repeatedPasswordTextField.text?.isEmpty)! {
            statusLabel.text = "Passwords are not the same"
        }
        
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
