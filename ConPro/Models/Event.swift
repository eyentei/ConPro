import UIKit

class Event: NSObject, Codable {
    var id: Int?
    var name: String?
    var image: Data?
    var timeStart: Date?
    var timeEnd: Date?
    var place: String?
    var organizer: User?
    var news = [News]()
    init(id: Int, name: String, image: Data, timeStart: Date, timeEnd: Date, place: String, organizer: User) {
        self.id = id
        self.name = name
        self.image = image
        self.timeStart = timeStart
        self.timeEnd = timeEnd
        self.place = place
        self.organizer = organizer
    }
}
