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
    private var activityIndicator : UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        ai.color = UIColor.darkGray
        return ai
    }()
    private var users = [(User, ChatStatus)]()
    var event: Event!
    var databaseViewModel: FIRBaseViewModel!
    var isOrganizer : Bool!
    
    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseViewModel.fetchAllChatUsers { (data) in
            let userStatus : ChatStatus = ChatStatus(rawValue: data.1) ?? .member
            self.users.append((data.0, userStatus))
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

}

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
}


