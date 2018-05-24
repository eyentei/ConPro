
import UIKit

class News: NSObject,Codable {
    var id: Int?
    var name: String?
    var message: String?
    var eventIcon: Data?
    var dateTime: Date?
    init(id: Int, name: String, message: String) {
        self.id = id
        self.name = name
        self.message = message
        self.dateTime = Date()
    }
}
