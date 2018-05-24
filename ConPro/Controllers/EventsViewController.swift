import UIKit
import Moya

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    let sections = ["Current & future events", "Past events"]
    var pastEvents: [Event] = []
    var currentEvents: [Event] = []
    
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.text = u1.name
        userImage.image = u1.image
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
        
        u1.eventsVisited = [cats,ch,ti,ev]
        u1.eventsOrganized = [cc]
        u2.eventsOrganized = [cats,ch,ti,ev]
        
        pastEvents = u1.eventsVisited.filter({$0.timeEnd! < Date()}).sorted(by: { $0.timeStart! > $1.timeStart! })
        currentEvents = u1.eventsVisited.filter({$0.timeEnd! >= Date()}).sorted(by: { $0.timeStart! < $1.timeStart! })
        
        self.title = "Profile"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Futura-Bold", size: 20)!]
        
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
        cell.eventImage.image = e!.image
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
        switch sender.selectedSegmentIndex
        {
        case 0:
            pastEvents = u1.eventsVisited.filter({$0.timeEnd! < Date()}).sorted(by: { $0.timeStart! > $1.timeStart! })
            currentEvents = u1.eventsVisited.filter({$0.timeEnd! >= Date()}).sorted(by: { $0.timeStart! < $1.timeStart! })
            eventsTableView.reloadData()
        case 1:
            pastEvents = u1.eventsOrganized.filter({$0.timeEnd! < Date()}).sorted(by: { $0.timeStart! > $1.timeStart! })
            currentEvents = u1.eventsOrganized.filter({$0.timeEnd! >= Date()}).sorted(by: { $0.timeStart! < $1.timeStart! })
            eventsTableView.reloadData()
        default:
            break
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // to do later
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
