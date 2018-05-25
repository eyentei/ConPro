import UIKit
import Moya

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
        loadingIndicator.isHidden = false
        provider.request(.login(email: email, password: password)) {
            result in
            switch result {
            case let .success(moyaResponse):
                do {
                    let response = try moyaResponse.map(Response.self)
                    UserDefaults.standard.set(response.data?.toJSON(), forKey:"token")

                    self.performSegue(withIdentifier: "segueToEvents", sender: self)
                }
                catch {
                    let error = error as? MoyaError
                    
                    if let code = error?.response?.statusCode {
                        if code == 404 {
                            self.statusLabel.text = "Wrong email or password"
                        } else {
                            self.statusLabel.text = String(code)
                        }
                    }
                }
                
            case let .failure(error):
                self.statusLabel.text = error.errorDescription
            }
            self.loadingIndicator.isHidden = true
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
