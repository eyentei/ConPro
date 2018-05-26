//
//  CorrectPersonalDataViewController.swift
//  ConPro
//
//  Created by Игорь on 26.05.2018.
//  Copyright © 2018 ConPro. All rights reserved.
//

import Foundation
import UIKit

class CorrectPersonalDataViewController: UITableViewController, UITextFieldDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:))))
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            // Do your thang here!
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
    
    @IBAction func ChangeUserName(_ sender: Any) {
        if firstName.text != "" {
            //performSegue(withIdentifier: "EventsViewController", sender: self)
            //print("OK")
            u1.name = firstName.text
            navigationController?.popViewController(animated: true)
        }
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var eventsController = segue.destination as! EventsViewController
        eventsController.myString = firstName.text!
    }*/
    
    override func viewDidAppear(_ animated: Bool) {
        if let x1 = UserDefaults.standard.object(forKey: "firstName") as? String {
            firstName.text = x1
        }
        if let x2 = UserDefaults.standard.object(forKey: "secondName") as? String {
            secondName.text = x2
        }
        if let x3 = UserDefaults.standard.object(forKey: "Age") as? String {
            Age.text = x3
        }
        //if let y1 = UserDefaults.standard.object(forKey: "email") as? String {
           // email.text = y1
        //}
        //if let y2 = UserDefaults.standard.object(forKey: "phonenumber") as? String {
            //phonenumber.text = y2
        //}
        //if let z1 = UserDefaults.standard.object(forKey: "company") as? String {
            //company.text = z1
        //}
        //if let z2 = UserDefaults.standard.object(forKey: "presentpost") as? String {
            //presentpost.text = z2
        //}
        
        
        
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UserDefaults.standard.set(firstName.text, forKey: "firstName")
        UserDefaults.standard.set(secondName.text, forKey: "secondName")
        UserDefaults.standard.set(Age.text, forKey: "Age")
        
        //UserDefaults.standard.set(email.text, forKey: "email")
        //UserDefaults.standard.set(phonenumber.text, forKey: "phonenumber")
        
        //UserDefaults.standard.set(company.text, forKey: "company")
        //UserDefaults.standard.set(presentpost.text, forKey: "presentpost")

    }
    
    
    
}
