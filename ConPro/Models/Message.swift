import Foundation

struct Message{
    var text: String
    var sender: String
    var timestamp: Double
    var firbaseUid: String!
    var isImportant: Bool
    
    init(text: String, sender: String, timestamp: Double, isImportant: Bool){
        self.text = text
        self.isImportant = isImportant
        self.sender = sender
        self.timestamp = timestamp
    }
    
    init?(with json: [AnyHashable : Any]){
        if let text = json["text"] as? String, let sender = json["sender"] as? String, let timestamp = json["timestamp"] as? String, let isImportant = json["isImportant"] as? Bool{
            self.text = text
            self.timestamp = Double(timestamp)!
            self.sender = sender
            self.isImportant = isImportant
        } else{
            return nil
        }
    }
    
    func getJSONRepresentation() -> [AnyHashable: Any]{
        return ["sender" : sender, "text" : text, "timestamp" : String(timestamp), "isImportant" : isImportant]
    }
}

enum ChatStatus : String{
    case admin = "admin"
    case member = "member"
    case muted = "muted"
    case organizer = "organizer"
}
