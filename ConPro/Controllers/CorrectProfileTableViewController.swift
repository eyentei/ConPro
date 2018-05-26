//
//  CorrectProfileTableViewController.swift
//  ConPro
//
//  Created by Игорь on 26.05.2018.
//  Copyright © 2018 ConPro. All rights reserved.
//

import Foundation
import UIKit

class CorrectProfileTableViewController: UITableViewController {
    //let appDelegate = UIApplication.shared.delegate as? AppDelegate
    @IBAction func signoutAction(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(controller, animated: true, completion: { () -> Void in
        })
        UserDefaults.standard.removeObject(forKey: "token")
    }
    
    @IBOutlet weak var notificationOutlet: UISwitch!
    @IBOutlet weak var soundsOutlet: UISwitch!
    
    @IBAction func notificationEnabled(_ sender: Any) {
    }
    
    override func didReceiveMemoryWarning() {
        didReceiveMemoryWarning()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
