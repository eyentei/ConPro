import UIKit
import Moya

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    let sections = ["Current & future events", "Past events"]
    var pastEvents: [Event] = []
    var currentEvents: [Event] = []
    var currentUser: User!
    var allEvents: [Event] = []
    var organized: [Event] = []
    var visited: [Event] = []
    
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var eventsSwitch: UISwitch!
    @IBOutlet weak var visitorOrganizerSC: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadEvents()
        currentUser = u1
        allEvents = addedEvents
        u1.eventsVisited = Array(addedEvents[1...3])
        u1.eventsOrganized = addedEvents.filter({$0.organizer?.id == u1.id})
        u2.eventsOrganized = addedEvents.filter({$0.organizer?.id == u2.id})
        userName.text = currentUser.name
        userImage.image = currentUser.image?.image
        organized = currentUser.eventsOrganized
        visited = currentUser.eventsVisited
        /*let data = UserDefaults.standard.data(forKey: "token")
        let token = Token().fromJSON(json: data!).authToken!
        let authPlugin = AccessTokenPlugin(tokenClosure: token)
        let provider = MoyaProvider<APIService>(plugins: [authPlugin])
        provider.request(.getUser) {
            result in
            switch result {
            case let .success(moyaResponse):
                do {
                    let response = try moyaResponse.map(Response.self)
                    print(response.data!)
                }
                catch {
                    let error = error as? MoyaError
                    print(error!)
                }
                
            case let .failure(error):
                print(error)
            }
        }*/
        checkStatus()        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return currentEvents.count
        case 1:
            return pastEvents.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventsTableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
        var e: Event?
        
        switch indexPath.section {
        case 0:
            e = currentEvents[indexPath.row]
        case 1:
            e = pastEvents[indexPath.row]
        default:
            return cell
        }
        
        cell.eventName.text = e!.name
        cell.eventDates.text = (e!.timeStart?.toString())!+" - "+(e!.timeEnd?.toString())!
        cell.eventImage.image = e!.image?.image
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
                vc.currentUser = currentUser
                switch indexPath.section {
                case 0:
                    vc.selectedEvent = currentEvents[indexPath.row]
                case 1:
                    vc.selectedEvent = pastEvents[indexPath.row]
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
        visited = searchText.isEmpty ? currentUser.eventsVisited : currentUser.eventsVisited.filter( { ($0.name?.localizedCaseInsensitiveContains(searchText))! })
        organized = searchText.isEmpty ? currentUser.eventsOrganized : currentUser.eventsOrganized.filter( { ($0.name?.localizedCaseInsensitiveContains(searchText))! })
        allEvents = searchText.isEmpty ? addedEvents : addedEvents.filter( { ($0.name?.localizedCaseInsensitiveContains(searchText))! })
        changeSelection()
    }
    
    
    @IBAction func switchToggled(_ sender: UISwitch) {
        checkStatus()
    }
    
    func checkStatus() {
        if eventsSwitch.isOn {
            switchLabel.text = "Showing my events"
            pastEvents = visited.filter({$0.timeEnd! < Date()}).sorted(by: { $0.timeStart! > $1.timeStart! })
            currentEvents = visited.filter({$0.timeEnd! >= Date()}).sorted(by: { $0.timeStart! < $1.timeStart! })
        } else {
            switchLabel.text = "Showing all events"
            pastEvents = allEvents.filter({$0.timeEnd! < Date()}).sorted(by: { $0.timeStart! > $1.timeStart! })
            currentEvents = allEvents.filter({$0.timeEnd! >= Date()}).sorted(by: { $0.timeStart! < $1.timeStart! })
        }
        
        eventsTableView.reloadData()
    }
    
    func changeSelection() {
        switch visitorOrganizerSC.selectedSegmentIndex
        {
        case 0:
            checkStatus()
            eventsSwitch.isEnabled = true
        case 1:
            pastEvents = organized.filter({$0.timeEnd! < Date()}).sorted(by: { $0.timeStart! > $1.timeStart! })
            currentEvents = organized.filter({$0.timeEnd! >= Date()}).sorted(by: { $0.timeStart! < $1.timeStart! })
            eventsSwitch.isEnabled = false
            eventsTableView.reloadData()
        default:
            break
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
