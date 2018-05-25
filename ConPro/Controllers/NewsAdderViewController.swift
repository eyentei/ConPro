
import UIKit

class NewsAdderViewController: UIViewController, UITextViewDelegate {

    var selectedEvent: Event?
    var newsViewController: NewsViewController!

    @IBOutlet weak var publishButton: UIButton!
    @IBOutlet weak var newsMessage: UITextView!
    @IBOutlet weak var modalWindow: UIView!
    @IBOutlet weak var symbolsLeft: UILabel!
    
    @IBAction func publishAction(_ sender: Any) {
        
        self.self.selectedEvent?.news.append(News(id: (self.selectedEvent?.news.count)!+1, name: (self.self.selectedEvent?.name)!, message: self.newsMessage.text))
        
        self.selectedEvent?.news.last?.eventIcon = self.selectedEvent?.image
        
        newsViewController.newsTableView.reloadData()
        
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsMessage.becomeFirstResponder()
        newsMessage.delegate = self
        symbolsLeft.text = "230"
        
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
        
        symbolsLeft.text = String(230 - updatedText.count + 1)
        
        return updatedText.count <= 230
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
