//
//  CorrectPersonalDataViewController.swift
//  ConPro
//
//  Created by Игорь on 26.05.2018.
//  Copyright © 2018 ConPro. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class CorrectPersonalDataViewController: UITableViewController, UITextFieldDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:))))
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.view.endEditing(true)
            for textField in self.view.subviews where textField is UITextField {
                textField.resignFirstResponder()
            }
        }
        sender.cancelsTouchesInView = false
    }
    
    override func didReceiveMemoryWarning() {
        didReceiveMemoryWarning()
    }
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var secondName: UITextField!
    @IBOutlet weak var Age: UITextField!
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phonenumber: UITextField!

    @IBOutlet weak var company: UITextField!
    @IBOutlet weak var presentpost: UITextField!
    @IBOutlet weak var Education: UITextField!
    @IBOutlet weak var Adress: UILabel!

    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var eventsController = segue.destination as! EventsViewController
        eventsController.myString = firstName.text!
    }*/
    
    override func viewDidAppear(_ animated: Bool) {
        
        firstName.text = currentUser.firstName
        // и тд
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let realm = try! Realm()
        try! realm.write {
            if let firstName = firstName.text {
                currentUser.firstName = firstName
            }
            // и так далее
        }
    }
    
    
    
}
