
import UIKit

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var currentUser: User?
    var selectedEvent: Event?    
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var newsTableView: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.selectedEvent?.news.count)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsTableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell
        var n: News?
        
        n = selectedEvent?.news[indexPath.row]
        
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd, HH:mm"
        
        cell.newsHeader.text = n!.name
        cell.newsMessage.text = n!.message
        cell.eventIcon.image = n!.eventIcon!.image
        cell.dateTime.text = dateFormatter.string(from: n!.dateTime!)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if selectedEvent?.organizer != currentUser {
            
            addButton.isEnabled = false
            
        }
        
        for news in (selectedEvent?.news)! {
            news.eventIcon = selectedEvent?.image
            news.name = selectedEvent?.name
        }
        
        self.navigationItem.title = "News"
        
        
        
        // wrap by checking if user is organizer
        //if true {
        //    addButton.isHidden = false
        //}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    

}
