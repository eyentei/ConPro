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
    @IBAction func signoutAction(_ sender: Any) {
        print("yes")
        //appDelegate?.logout()
        //appDelegate?.sendNotification()
        
        //let signInPage = self.storyboard?.instantiateInitialViewController() as! LoginViewController
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
        //UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)

        //let appDelegate?.window??.rootViewController = signInPage
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
