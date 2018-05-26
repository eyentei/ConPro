import UIKit

class User: NSObject, Codable {
    var firBaseUid : String?
    var email: String
    //Hash this later
    var password: String
    var id: Int?
    var name: String?
    var image: Data?
    var eventsVisited = [Event]()
    var eventsOrganized = [Event]()
    init(id: Int, name: String, image: Data, email: String, password: String) {
        self.id = id
        self.name = name
        self.image = image
        self.email = email
        self.password = password
    }
}


