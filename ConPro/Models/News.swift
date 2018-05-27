import RealmSwift
import UIKit

class News: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var message = ""
    @objc dynamic var eventIcon = Data()
    @objc dynamic var dateTime = Date()
    convenience init(name: String, message: String, eventIcon: Data = Data(), dateTime: Date = Date()) {
        self.init()
        self.name = name
        self.message = message
        self.eventIcon = eventIcon
        self.dateTime = dateTime
    }
}
