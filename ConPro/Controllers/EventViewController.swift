import UIKit

class EventViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var selectedEvent: Event?
    var currentUser: User?

    var menu = [[#imageLiteral(resourceName: "info"),"Info"],[#imageLiteral(resourceName: "news"),"News Feed"],[#imageLiteral(resourceName: "people"),"Participants"],[#imageLiteral(resourceName: "calendar"),"Schedule"],[#imageLiteral(resourceName: "map"),"Map"],[#imageLiteral(resourceName: "mic"),"Speakers"],[#imageLiteral(resourceName: "chat"),"Chat"],[#imageLiteral(resourceName: "list"),"Subevents"]]
    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var statusButton: UIBarButtonItem!
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as! MenuCollectionViewCell
        cell.menuItemIcon.image = menu[indexPath.row][0] as? UIImage
        cell.menuItemLabel.text = menu[indexPath.row][1] as? String
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if menu[indexPath.row][1] as! String == "News Feed" || menu[indexPath.row][1] as! String == "Info"||menu[indexPath.row][1] as! String == "Statistics"{
            performSegue(withIdentifier: menu[indexPath.row][1] as! String, sender: self)
        }// after every window is created if statement can be deleted
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        switch segue.identifier {
        case "News Feed":
            let vc = segue.destination as! NewsViewController
            vc.selectedEvent = selectedEvent
            vc.currentUser = currentUser
        case "Info":
            let vc = segue.destination as! InfoViewController
            vc.selectedEvent = selectedEvent
        case "EventEdit":
            let vc = segue.destination as! EventEditViewController
            vc.selectedEvent = selectedEvent
        case "Statistics":
            if #available(iOS 11.0, *) {
                let vc = segue.destination as! EventStatsViewController
                vc.selectedEvent = selectedEvent
            } else {
                // Fallback on earlier versions
            }
        default:
            break
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusButton.title = currentUser?.eventsVisited.filter({$0.id == selectedEvent?.id}) != [] ? "Unsubscribe" : "Subscribe"

        if selectedEvent?.organizer?.id == currentUser?.id {
            menu.append([#imageLiteral(resourceName: "stats"),"Statistics"])
            statusButton.title = "Edit"
        }
        eventNameLabel.text = selectedEvent?.name
        eventImage.image = selectedEvent?.image?.image

    }

    @IBAction func subscribeOrUnsubscribe( _ sender: UIBarButtonItem) {
        switch sender.title {
        case "Subscribe":
            currentUser?.eventsVisited.append(selectedEvent!)
            sender.title = "Unsubscribe"
        case "Unsubscribe":
            currentUser?.eventsVisited = (currentUser?.eventsVisited.filter({$0.id != selectedEvent?.id}))!
            sender.title = "Subscribe"
        case "Edit":
            //segue to event edit screen
            performSegue(withIdentifier: "EventEdit", sender: self)
        default:
            break
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
