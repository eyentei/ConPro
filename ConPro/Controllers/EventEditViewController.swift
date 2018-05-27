//
//  EventEditViewController.swift
//  ConPro
//
//  Created by Maxim on 26.05.2018.
//  Copyright © 2018 ConPro. All rights reserved.
//

import UIKit
import RealmSwift

class EventEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var selectedEvent: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TitleTextField.text = selectedEvent?.name
        PlaceTextField.text = selectedEvent?.place
        ImageView.image = UIImage(data: (selectedEvent?.image)!)
        DateStart.text = selectedEvent?.timeStart.toString()
        DateFinish.text = selectedEvent?.timeEnd.toString()
        
    }
    @IBOutlet weak var TitleTextField: UITextField!
    @IBOutlet weak var PlaceTextField: UITextField!
    @IBOutlet weak var ImageView: UIImageView!
    
    @IBOutlet weak var DateStart: UITextField!
    @IBOutlet weak var DateFinish: UITextField!
    
    @IBOutlet weak var DescrTextField: UITextView!
    @IBAction func ChangeImage(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            ImageView.image = image
        }
        else{
            //Error loading image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SaveEdit(_ sender: Any) {
        
        
        let realm = try! Realm()
        
        try! realm.write {
            if let name = TitleTextField.text {
                selectedEvent?.name = name
            }
            if let place = PlaceTextField.text {
                selectedEvent?.place = place
            }
            if let image = ImageView.image {
                selectedEvent?.image = image.resized(toWidth: 100)!.data!
            }
            
            if let timeStart = Date(date: DateStart.text!) {
                selectedEvent?.timeStart = timeStart
            }
            if let timeEnd = Date(date: DateFinish.text!) {
                selectedEvent?.timeEnd = timeEnd
            }
            selectedEvent?.eventDescription = DescrTextField.text
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
