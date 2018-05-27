import Foundation
import UIKit
import Firebase

protocol FIRBaseDelegate : class {
    func didRecieveMessage(_ message: Message)
    func didSendMessage()
    func didRecieveException(title: String, message: String)
}

class FIRBaseViewModel{
    //MARK: Fields
    private var databaseReference = (UIApplication.shared.delegate as? AppDelegate)?.ref
    weak var delegate : FIRBaseDelegate?
    private var event: Event
    private var currentUser: User
    
    init(for user: User, in event: Event){
        self.event = event
        self.currentUser = user
    }
    
    //MARK: Auth
    func authUserInFirebase(with completion: @escaping()->Void){
        Auth.auth().signIn(withEmail: currentUser.email, password: currentUser.password) { (user, error) in
            guard error == nil, user != nil else{
                switch error!.localizedDescription{
                case  "FIRAuthErrorCodeInvalidEmail", "FIRAuthErrorCodeWrongPassword", "There is no user record corresponding to this identifier. The user may have been deleted.":
                    print(error!.localizedDescription)
                    self.createUserInFirebase(with: completion)
                    break
                default:
                    print(error!.localizedDescription)
                    break
                }
                return
            }
            
            self.currentUser.firBaseUid = user!.uid
            completion()
        }
    }
    
    func createUserInFirebase(with completion: @escaping()->Void){
        Auth.auth().createUser(withEmail: currentUser.email, password: currentUser.password) { (user, error) in
            guard error == nil, let uid = user?.uid else{
                self.delegate?.didRecieveException(title: "Error", message: error!.localizedDescription)
                return
            }
            
            self.currentUser.firBaseUid = uid
            var status : ChatStatus!
            switch (self.currentUser == self.event.organizer){
            case true:
                status = ChatStatus.admin
                break
            case false:
                status = ChatStatus.member
                break
            }
            let usersReference = self.databaseReference?.child("users").child(self.event.name!).child(uid)
            usersReference?.updateChildValues(["name" : (self.currentUser.name ?? "Username"), "email" : self.currentUser.email, "password" : self.currentUser.password, "status" : status.rawValue], withCompletionBlock: { (error, ref) in
                if error != nil{
                    print(error!.localizedDescription)
                    return
                }
                completion()
            })
        }
    }
    
    //MARK: Messaging
    func sendMessage(with text: String){
        let timestamp = Date().timeIntervalSince1970
        let message = Message(text: text, sender: currentUser.firBaseUid!, timestamp: timestamp, isImportant: false)
        let messageReference = databaseReference?.child("messages").child(event.name!).childByAutoId()
        messageReference?.updateChildValues(message.getJSONRepresentation(), withCompletionBlock: { (error, ref) in
            guard error == nil else{
                print(error!.localizedDescription)
                return
            }
            //UPDATE UI
            self.delegate?.didSendMessage()
        })
    }
    
    func setMessagesObserver(for chatUid: String){
        let messagesReference = databaseReference?.child("messages").child(chatUid)
        messagesReference?.observe(.childAdded, with: { (snapshot) in
            messagesReference?.child(snapshot.key).observeSingleEvent(of: .value, with: { (messageSnapshot) in
                if var message = Message(with: snapshot.value as! [AnyHashable:Any]){
                    message.firbaseUid = snapshot.key
                    self.delegate?.didRecieveMessage(message)
                }
            })
        })
    }
    
    func removeMessagesObserver(for chatUid: String){
        databaseReference?.child("messages").child(chatUid).removeAllObservers()
    }
    
    //MARK: Users
    func fetchAllChatUsers(completion: @escaping(((User, String)) -> Void)){
        let usersReference = (UIApplication.shared.delegate as? AppDelegate)?.ref.child("users").child(event.name!)
        usersReference?.observeSingleEvent(of: .value, with: { (snapshot) in
            if let usersData = snapshot.value as? [String : Any]{
                for userUid in Array(usersData.keys){
                    let singleUserReference = usersReference?.child(userUid)
                    singleUserReference?.observeSingleEvent(of: .value, with: { (userSnapshot) in
                        if let userJSON = userSnapshot.value as? [String : Any]{
                            if let name = userJSON["name"] as? String, let email = userJSON["email"] as? String, let password = userJSON["password"] as? String, let status = userJSON["status"] as? String{
                                let fetchedUser = User(id: 0, name: name, image: #imageLiteral(resourceName: "cat").data!, email: email, password: password)
                                completion((fetchedUser, status))
                            }
                        }
                    })
                }
            }
        })
    }
    
    //MARK: Manage messages
    func deleteMessage(with id: String){
        let messageReference = databaseReference?.child("messages").child(event.name!).child(id)
        messageReference?.removeValue()
    }
    
    func setMessageImportancy(for id: String, isImportant: Bool){
        let messageReference = databaseReference?.child("messages").child(event.name!).child(id).child("isImportant")
        messageReference?.setValue(isImportant)
    }
}

