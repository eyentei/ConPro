import UIKit
import RealmSwift

class User: Object {
    @objc dynamic var email = ""
    @objc dynamic var password = ""
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var age = 0
    @objc dynamic var phone = ""
    @objc dynamic var company = ""
    @objc dynamic var post = ""
    @objc dynamic var gender = ""
    @objc dynamic var address = ""
    @objc dynamic var image = Data()
    @objc dynamic var firBaseUid : String?
    var eventsVisited = LinkingObjects(fromType: Event.self, property: "visitors")
    var eventsOrganized = LinkingObjects(fromType: Event.self, property: "organizer")
    override class func primaryKey() -> String? {
        return "email"
    }
    convenience init(email: String, password: String) {
        self.init()
        self.email = email
        self.password = password
    }
    
    convenience init(name: String, image: Data, email: String, password: String){
        self.init()
        self.firstName = name
        self.image = image
        self.password = password
        self.email = email
    }
}


