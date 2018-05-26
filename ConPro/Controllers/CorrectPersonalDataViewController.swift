//
//  CorrectPersonalDataViewController.swift
//  ConPro
//
//  Created by Игорь on 26.05.2018.
//  Copyright © 2018 ConPro. All rights reserved.
//

import Foundation
import UIKit

class CorrectPersonalDataViewController: UITableViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var secondName: UITextField!
    @IBOutlet weak var Age: UITextField!
    
    override func viewDidAppear(_ animated: Bool) {
        //if let firstName = UserDefaults.standard.object(forKey: "myName") as? String {
        //    secondName. = firstName
        //}
        
    }
    
    
    
}
