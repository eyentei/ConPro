import UIKit

protocol MessageEditingProtocol : class{
    func deleteMessage(in index: Int)
    func setMessageImportancy(in index: Int)
}

class MessagePopoverViewController: UIViewController {
    
    var selectedIndex: Int!
    weak var delegate : MessageEditingProtocol?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        delegate?.deleteMessage(in: selectedIndex)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func importantButtonPressed(_ sender: Any) {
        delegate?.setMessageImportancy(in: selectedIndex)
        dismiss(animated: true, completion: nil)
    }
}
