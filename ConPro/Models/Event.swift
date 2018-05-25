import UIKit

class Event: NSObject, Codable {
    var id: Int?
    var name: String?
    var image: Data?
    var timeStart: Date?
    var timeEnd: Date?
    var place: String?
    var organizer: User?
    var eventCategory: String?
    var eventDescription: String?
    var news = [News]()
    override init(){}
    init(id: Int, name: String, place: String, timeStart: Date?, timeEnd: Date?){
        self.id = id
        self.name = name
        self.place = place
        self.timeStart = timeStart
        self.timeEnd = timeEnd
    }
    init(id: Int, name: String, image: Data, timeStart: Date, timeEnd: Date, place: String, organizer: User, eventCategory: String, eventDescription: String?) {
        self.id = id
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
