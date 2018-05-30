import UIKit
import RealmSwift

class Event: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var image = Data()
    @objc dynamic var timeStart = Date()
    @objc dynamic var timeEnd = Date()
    @objc dynamic var place = ""
    @objc dynamic var eventCategory = ""
    @objc dynamic var eventDescription = ""
    @objc dynamic var organizer: User?
//    var news = LinkingObjects(fromType: News.self, property: "event")
    var news = List<News>()
    var visitors = List<User>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    convenience init(name: String, image: Data, timeStart: Date, timeEnd: Date, place: String, organizer: User, eventCategory: String = "", eventDescription: String = "") {
        self.init()
        self.name = name
        self.image = image
        self.timeStart = timeStart
        self.timeEnd = timeEnd
        self.place = place
        self.organizer = organizer
        self.eventCategory = eventCategory
        self.eventDescription = eventDescription
        
    }
}
