import UIKit

class ChatUsersViewController: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.tableFooterView = UIView(frame: CGRect.zero)
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    //MARK: Fields
    private lazy var muteAction : UITableViewRowAction = {
        let mute = UITableViewRowAction(style: .destructive, title: "Mute", handler: { (action, indexPath) in
            self.databaseViewModel.muteUser(with: self.users[indexPath.row].0.firBaseUid!)
        })
        return mute
    }()
    private lazy var adminAction : UITableViewRowAction = {
        let admin = UITableViewRowAction(style: .default, title: "Admin", handler: { (action, indexPath) in
            self.databaseViewModel.muteUser(with: self.users[indexPath.row].0.firBaseUid!)
        })
        admin.backgroundColor = .green
        return admin
    }()
    private var activityIndicator : UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        ai.color = UIColor.darkGray
        return ai
    }()
    private var users = [(User, ChatStatus)]()
    var event: Event!
    var databaseViewModel: FIRBaseViewModel!{
        didSet{
            databaseViewModel.userDelegate = self
        }
    }
    var currentUser: User!
    
    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelectionDuringEditing = true
        fetchUsers()
    }
    
    private func fetchUsers(){
        activityIndicator.frame = tableView.bounds
        tableView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        databaseViewModel.fetchAllChatUsers { (fetchedUsersData) in
            self.users = fetchedUsersData
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: UserStatusDelegate
extension ChatUsersViewController : UserStatusDelegate{
    func currentUsersStatusDidChange() {
        tableView.reloadData()
    }
}


//MARK: UITableViewDelegate/DataSource
extension ChatUsersViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Chat User Cell", for: indexPath) as! ChatUserTableViewCell
        cell.userNameLabel.text = users[indexPath.row].0.name
        cell.statusLabel.text = users[indexPath.row].1.rawValue
        cell.imageView?.image = UIImage(data: users[indexPath.row].0.image!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        //Cannot edit personal row
        if users[indexPath.row].0.id == currentUser.id{
            return false
        }
        switch databaseViewModel.currentUserChatStatus!{
        case .member, .muted:
            return false
        case .admin, .organizer:
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        switch databaseViewModel.currentUserChatStatus!{
        case .organizer:
            return [adminAction, muteAction]
        case .admin:
            return [muteAction]
        case .muted, .member:
            return nil
        }
    }
}


