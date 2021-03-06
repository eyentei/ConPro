import UIKit
import RealmSwift

class EventAdderViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var categoryTextField: UITextField!
    let eventCategories = ["Category","IT","Business","Nature", "Videogames", "Innovations", "Sports", "Music"]
    var pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        categoryTextField.inputView = pickerView
        
        dateStartSelection()
        dateFinishSelection()
        
    }
    
    @IBOutlet weak var ImageView: UIImageView!
    
    @IBAction func AddingImage(_ sender: Any) {
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
    
    @IBOutlet weak var DateStart: UITextField!
    @IBOutlet weak var DateFinish: UITextField!
    
    let datePicker = UIDatePicker()
    
    func dateStartSelection(){
        datePicker.datePickerMode = .dateAndTime
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedStart))
        toolbar.setItems([doneButton], animated: false)
        DateStart.inputAccessoryView = toolbar
        DateStart.inputView = datePicker
    }
    
    func dateFinishSelection(){
        datePicker.datePickerMode = .dateAndTime
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedFinish))
        toolbar.setItems([doneButton], animated: false)
        DateFinish.inputAccessoryView = toolbar
        DateFinish.inputView = datePicker
    }
    
    @objc func donePressedStart(){
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        DateStart.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    @objc func donePressedFinish(){
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        DateFinish.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var TitleTextField: UITextField!
    @IBOutlet weak var PlaceTextField: UITextField!
    @IBOutlet weak var DescriptionTextView: UITextView!
    
    @IBAction func CreateEvent(_ sender: Any) {

        if(!(TitleTextField.text?.isEmpty)! && !(PlaceTextField.text?.isEmpty)! && !(DateStart.text?.isEmpty)! && !(DateFinish.text?.isEmpty)!){
            var image = #imageLiteral(resourceName: "kitty")
            if let img = ImageView.image {
                image = img.resized(toWidth: 100)!
            }
            
            let realm = try! Realm()
            try! realm.write {
                let newEvent = Event(name: TitleTextField.text!, image: image.data!, timeStart: Date(date: DateStart.text!)!, timeEnd: Date(date: DateFinish.text!)!, place: PlaceTextField.text! , organizer: currentUser, eventDescription: DescriptionTextView.text )
                
                realm.add(newEvent)
                navigationController?.popViewController(animated: true)
            }
        }
        else{
            TitleTextField.backgroundColor = UIColor.red
            PlaceTextField.backgroundColor = UIColor.red
            DateStart.backgroundColor = UIColor.red
            DateFinish.backgroundColor = UIColor.red
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return eventCategories.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return eventCategories[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryTextField.text = eventCategories[row]
        categoryTextField.resignFirstResponder()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
