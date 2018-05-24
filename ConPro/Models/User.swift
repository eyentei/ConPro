import UIKit

class User: NSObject, Codable {
    var id: Int?
    var name: String?
    var image: String?
    var eventsVisited = [Event]()
    var eventsOrganized = [Event]()
    init(id: Int, name: String, image: String) {
        self.id = id
        self.name = name
        self.image = image
    }
}


