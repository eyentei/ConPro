
import UIKit

class NewsAdderViewController: UIViewController, UITextViewDelegate {

    var selectedEvent: Event?
    
    @IBOutlet weak var eventIcon: UIImageView!
    @IBOutlet weak var publishButton: UIButton!
    @IBOutlet weak var newsMessage: UITextView!
    
    @IBAction func addNews(_ sender: Any) {
        
        selectedEvent?.news.append(News(id: (selectedEvent?.news.count)!+1, name: (selectedEvent?.name)!, message: newsMessage.text))
        
        selectedEvent?.news.last?.eventIcon = selectedEvent?.image
        
        performSegue(withIdentifier: "backSegueToNews", sender: self)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventIcon.image = selectedEvent?.image!.image
        newsMessage.becomeFirstResponder()
        newsMessage.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if segue.identifier == "backSegueToNews" {
            
            let vc = segue.destination as! NewsViewController
            vc.selectedEvent = selectedEvent
            
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text as NSString
        let updatedText = currentText.replacingCharacters(in: range, with: text)
        
        return updatedText.count <= 230
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
