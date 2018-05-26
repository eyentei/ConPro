import UIKit
import Firebase

class ChatViewController: UIViewController{
    //MARK: Outlets
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: Fields
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
            self.databaseViewModel!.setMessagesObserver(for: self.event.name!)
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
        databaseViewModel?.removeMessagesObserver(for: event.name!)
    }
    
    //MARK: Actions
    @IBAction func sendMessageButtonPressed(_ sender: UIButton) {
        if let messageText = messageTextField.text, messageText.count != 0{
            databaseViewModel?.sendMessage(with: messageText)
        }
    }
    
    //MARK: Transition
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Chat Users View Controller"{
            let destinationViewController = segue.destination as? ChatUsersViewController
            destinationViewController?.event = event
            destinationViewController?.databaseViewModel = databaseViewModel
            destinationViewController?.isOrganizer = (event.organizer == currentUser)
        }
    }
}

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

extension ChatViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    //MARK: UICollectinViewDataSource/Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if messages[indexPath.row].sender == currentUser.firBaseUid{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonalMessageCell", for: indexPath) as! PersonalMessageCollectionViewCell
            cell.messageTextLabel.text = messages[indexPath.row].text
            cell.messageTimeLabel.text = String(messages[indexPath.row].timestamp)
            return cell
        } else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForeignMessageCell", for: indexPath) as! ForeignMessageCollectionViewCell
            cell.messageTextLabel.text = messages[indexPath.row].text
            cell.messageTimeLabel.text = String(messages[indexPath.row].timestamp)
            cell.senderAvatarImageView.image = #imageLiteral(resourceName: "cat")
            cell.userNameLabel.text = messages[indexPath.row].sender
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
            return CGSize(width:width, height: boundingBox.height + 40)
        } else{
            let constraintRect = CGSize(width: width/2, height: .greatestFiniteMagnitude)
            let boundingBox = messages[indexPath.row].text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [kCTFontAttributeName as NSAttributedStringKey: UIFont.systemFont(ofSize: 16)], context: nil)
            return CGSize(width:width, height: boundingBox.height + 60)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
    
}

