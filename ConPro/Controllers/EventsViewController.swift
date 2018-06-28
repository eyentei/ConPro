import UIKit
import RealmSwift

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    var appDelegate = UIApplication.shared.delegate as? AppDelegate

    let sections = ["Current & future events", "Past events"]
    var allEvents: Results<Event>?
    
    var pastEvents: AnyRealmCollection<Event>?
    var currentEvents: AnyRealmCollection<Event>?
  
    var organized: AnyRealmCollection<Event>?
    var visited: AnyRealmCollection<Event>?
    
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var eventsSwitch: UISwitch!
    @IBOutlet weak var visitorOrganizerSC: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    var realm: Realm?
    
    
    @IBAction func startReminding(_ sender: Any) {
        appDelegate?.sendNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userid = UserDefaults.standard.string(forKey: "user")
        try! realm = Realm()
        currentUser = realm?.object(ofType: User.self, forPrimaryKey: userid)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        allEvents = realm?.objects(Event.self)
        userName.text = currentUser.firstName + " " + currentUser.lastName
        userImage.image = currentUser.image.image ?? #imageLiteral(resourceName: "cat")
        organized = AnyRealmCollection(currentUser.eventsOrganized)
        visited = AnyRealmCollection(currentUser.eventsVisited)
        visitorOrganizerSC.selectedSegmentIndex = 0
        visitorOrganizerSC.sendActions(for: UIControlEvents.valueChanged)
        checkStatus()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return currentEvents!.count
        case 1:
            return pastEvents!.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventsTableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
        var e: Event?
        
        switch indexPath.section {
        case 0:
            e = currentEvents?[indexPath.row]
        case 1:
            e = pastEvents?[indexPath.row]
        default:
            return cell
        }
        
        cell.eventName.text = e!.name
        cell.eventDates.text = (e!.timeStart.toString())+" - "+(e!.timeEnd.toString())
        cell.eventImage.image = e!.image.image
        cell.eventPlace.text = e!.place
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueToEvent", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "segueToEvent" {
            if let indexPath = eventsTableView.indexPathForSelectedRow {

                let vc = segue.destination as! EventViewController
                switch indexPath.section {
                case 0:
                    vc.selectedEvent = currentEvents?[indexPath.row]
                case 1:
                    vc.selectedEvent = pastEvents?[indexPath.row]
                default:
                    break
                }
            }
        }
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        changeSelection()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if eventsSwitch.isOn || visitorOrganizerSC.selectedSegmentIndex == 1 {
            visited = searchText.isEmpty ? AnyRealmCollection(currentUser.eventsVisited) : AnyRealmCollection(currentUser.eventsVisited.filter("name contains[c] %@", searchText))
            organized = searchText.isEmpty ? AnyRealmCollection(currentUser.eventsOrganized) : AnyRealmCollection(currentUser.eventsOrganized.filter("name contains[c] %@", searchText))
        } else {
            allEvents = searchText.isEmpty ? realm?.objects(Event.self): realm?.objects(Event.self).filter("name contains[c] %@", searchText)
        }
        changeSelection()
    }
    
    @IBAction func switchToggled(_ sender: UISwitch) {
        checkStatus()
    }
    
    func checkStatus() {
        if let visited = visited, let allEvents = allEvents {
            if eventsSwitch.isOn {
                switchLabel.text = "Showing my events"
                pastEvents = AnyRealmCollection(visited.filter("timeEnd < %@", Date()).sorted(byKeyPath: "timeStart", ascending: false))
                currentEvents = AnyRealmCollection(visited.filter("timeEnd >= %@", Date()).sorted(byKeyPath: "timeStart", ascending: true))
            } else {
                switchLabel.text = "Showing all events"
                pastEvents = AnyRealmCollection(allEvents.filter("timeEnd < %@", Date()).sorted(byKeyPath: "timeStart", ascending: false))
                currentEvents = AnyRealmCollection(allEvents.filter("timeEnd >= %@", Date()).sorted(byKeyPath: "timeStart", ascending: true))
            }
            
            eventsTableView.reloadData()
        }
    }
    
    func changeSelection() {
        switch visitorOrganizerSC.selectedSegmentIndex
        {
        case 0:
            checkStatus()
            eventsSwitch.isEnabled = true
        case 1:
            if let organized = organized {
                pastEvents = AnyRealmCollection(organized.filter("timeEnd < %@", Date()).sorted(byKeyPath: "timeStart", ascending: false))
                currentEvents = AnyRealmCollection(organized.filter("timeEnd >= %@", Date()).sorted(byKeyPath: "timeStart", ascending: true))
                eventsSwitch.isEnabled = false
                eventsTableView.reloadData()
            }
        default:
            break
        }
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
