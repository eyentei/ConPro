import UIKit

class EventAdderViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBOutlet weak var TitleTextField: UITextField!
    @IBOutlet weak var PlaceTextField: UITextField!
    @IBOutlet weak var DescriptionTextView: UITextView!
    
    @IBAction func CreateEvent(_ sender: Any) {
        //waiting for api
        var newEvent = Event()
        if(!(TitleTextField.text?.isEmpty)! && !(PlaceTextField.text?.isEmpty)! && !(DateStart.text?.isEmpty)! && !(DateFinish.text?.isEmpty)!){
            newEvent = Event(id: addedEvents.count, name: TitleTextField.text!, place: PlaceTextField.text!, timeStart: Date(date: DateStart.text!), timeEnd: Date(date: DateFinish.text!))
        
            if let image = ImageView.image?.data {
                newEvent.image = image
            }
            if let descr = DescriptionTextView.text {
                newEvent.eventDescription = descr
            }
            newEvent.organizer = u1
            addedEvents.append(newEvent)
            u1.eventsOrganized.append(newEvent)
            navigationController?.popViewController(animated: true)
        }
        else{
            TitleTextField.backgroundColor = UIColor.red
            PlaceTextField.backgroundColor = UIColor.red
            DateStart.backgroundColor = UIColor.red
            DateFinish.backgroundColor = UIColor.red
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
