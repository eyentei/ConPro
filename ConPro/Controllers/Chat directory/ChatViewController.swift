import UIKit
import Firebase

class ChatViewController: UIViewController{
    //MARK: Outlets
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: Fields
    private var messagePopoverViewController : MessagePopoverViewController?
    private var activityIndicator : UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        ai.color = UIColor.darkGray
        return ai
    }()
    private var databaseViewModel: FIRBaseViewModel?
    private var messages = [Message]()
    var event: Event!
    var currentUser: User!
    
    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettup()
    }
    
    private func initialSettup(){
        collectionView.delegate = self
        collectionView.dataSource = self
        databaseViewModel = FIRBaseViewModel(for: currentUser, in: event)
        databaseViewModel!.delegate = self
        //Set activity indicator before while auth in firebase
        activityIndicator.frame = view.frame
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        databaseViewModel!.authUserInFirebase {
            self.databaseViewModel!.setMessagesObserver(for: self.event.name)
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
        }
    }
    
    private func scrollToBottom(){
        let lastItemIndexPath = IndexPath(item: messages.count - 1,
                                          section: 0)
        collectionView.scrollToItem(at: lastItemIndexPath, at: .bottom, animated: true)
    }
    
    deinit {
        databaseViewModel?.removeMessagesObserver(for: event.name)
    }
    
    //MARK: Actions
    @IBAction func sendMessageButtonPressed(_ sender: UIButton) {
        if let messageText = messageTextField.text, messageText.count != 0{
            databaseViewModel?.sendMessage(with: messageText)
        }
    }

    @IBAction func usersButtonPressed(_ sender: Any) {
        if !activityIndicator.isAnimating{
            performSegue(withIdentifier: "Show Chat Users View Controller", sender: nil)
        }
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "Show Chat Users View Controller":
            let destinationViewController = segue.destination as? ChatUsersViewController
            destinationViewController?.event = event
            destinationViewController?.databaseViewModel = databaseViewModel
            destinationViewController?.currentUser = currentUser
        default:
            break
        }
    }
}

//MARK: UIPopoverPresentationControllerDelegate
extension ChatViewController : UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

//MARK: FIRBaseDelegate
extension ChatViewController : FIRBaseDelegate{
    func didRecieveException(title: String, message: String) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertDefaultAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertViewController.addAction(alertDefaultAction)
        present(alertViewController, animated: true, completion: nil)
    }
    
    func didRecieveMessage(_ message: Message) {
        messages.append(message)
        collectionView.reloadData()
        scrollToBottom()
    }
    
    func didSendMessage() {
        //UI conformation
    }
}

//MARK: ChatMessageDelegate
extension ChatViewController : ChatMessageDelegate{
    func didTapUserImageView(in cell: UICollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: cell){
            print(indexPath.row)
            //Perform segue to user
        }
    }
    
    func didSelectContextMenu(in cell: UICollectionViewCell) {
        if databaseViewModel?.currentUserChatStatus == .admin || databaseViewModel?.currentUserChatStatus == .organizer{
            if let indexPath = collectionView.indexPath(for: cell){
                if messagePopoverViewController == nil{
                    messagePopoverViewController = storyboard?.instantiateViewController(withIdentifier: "Message Popover View Controller") as? MessagePopoverViewController
                    messagePopoverViewController?.modalPresentationStyle = .popover
                    messagePopoverViewController?.modalTransitionStyle = .flipHorizontal
                    messagePopoverViewController?.preferredContentSize = CGSize(width: collectionView.frame.width * 2/3, height: 40)
                    messagePopoverViewController?.delegate = self
                }
                if let popoverPresentationController = messagePopoverViewController?.popoverPresentationController{
                    popoverPresentationController.delegate = self
                    if let messageCell = cell as? ForeignMessageCollectionViewCell{
                        messagePopoverViewController!.selectedIndex = indexPath.row
                        popoverPresentationController.sourceView = messageCell.containerView
                        popoverPresentationController.sourceRect = messageCell.containerView.bounds
                        popoverPresentationController.permittedArrowDirections = [.up, .down]
                        present(messagePopoverViewController!, animated: true, completion: nil)
                    } else if let messageCell = cell as? PersonalMessageCollectionViewCell{
                        messagePopoverViewController!.selectedIndex = indexPath.row
                        popoverPresentationController.sourceView = messageCell.containerView
                        popoverPresentationController.sourceRect = messageCell.containerView.bounds
                        popoverPresentationController.permittedArrowDirections = [.up, .down]
                        present(messagePopoverViewController!, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}


//MARK: MessageEditingProtocol
extension ChatViewController : MessageEditingProtocol{
    func deleteMessage(in index: Int) {
        if let messageUid = messages[index].firbaseUid{
            databaseViewModel?.deleteMessage(with: messageUid)
            messages.remove(at: index)
            collectionView.reloadData()
        }
    }
    
    func setMessageImportancy(in index: Int) {
        messages[index].isImportant = !messages[index].isImportant
        databaseViewModel?.setMessageImportancy(for: messages[index].firbaseUid, isImportant: messages[index].isImportant)
        collectionView.reloadData()
    }
    
    
}

extension ChatViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    //MARK: UICollectinViewDataSource/Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let selectedMessage = messages[indexPath.row]
        //Format date
        let timestampDate = Date(timeIntervalSince1970: messages[indexPath.row].timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timestampString = dateFormatter.string(from: timestampDate)
        
        if selectedMessage.sender == currentUser.firBaseUid{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonalMessageCell", for: indexPath) as! PersonalMessageCollectionViewCell
            cell.messageTextLabel.text = selectedMessage.text
            cell.messageTimeLabel.text = timestampString
            cell.delegate = self
            cell.isImportant = selectedMessage.isImportant
            return cell
        } else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForeignMessageCell", for: indexPath) as! ForeignMessageCollectionViewCell
            cell.messageTextLabel.text = selectedMessage.text
            cell.messageTimeLabel.text = timestampString
            cell.senderAvatarImageView.image = #imageLiteral(resourceName: "cat")
            cell.userNameLabel.text = selectedMessage.sender
            cell.delegate = self
            cell.isImportant = selectedMessage.isImportant
            return cell
        }
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        //Personal message cell shorter
        if messages[indexPath.row].sender == currentUser.firBaseUid{
            let constraintRect = CGSize(width: width * 6/10, height: .greatestFiniteMagnitude)
            let boundingBox = messages[indexPath.row].text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [kCTFontAttributeName as NSAttributedStringKey: UIFont.systemFont(ofSize: 16)], context: nil)
            return CGSize(width:width - 20, height: boundingBox.height + 40)
        } else{
            let constraintRect = CGSize(width: width / 2, height: .greatestFiniteMagnitude)
            let boundingBox = messages[indexPath.row].text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [kCTFontAttributeName as NSAttributedStringKey: UIFont.systemFont(ofSize: 16)], context: nil)
            return CGSize(width:width - 20, height: boundingBox.height + 70)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
}

