import Foundation

struct Message : Codable{
    var text: String
    var sender: String
    var timestamp: Int64
    
    init(text: String, sender: String, timestamp: Int64){
        self.text = text
        self.sender = sender
        self.timestamp = timestamp
    }
    
    init?(with json: [AnyHashable : Any]){
        if let text = json["text"] as? String, let sender = json["sender"] as? String, let timestamp = json["timestamp"] as? Int64{
            self.text = text
            self.timestamp = timestamp
            self.sender = sender
        } else{
            return nil
        }
    }
    
    func getJSONRepresentation() -> [AnyHashable: Any]{
        return ["sender" : sender, "text" : text, "timestamp" : timestamp]
    }
}

class Chat{
    var uid: String
    var title: String?
    var timestamp: Int64?
    var lastMessage: String?
    
    init(uid: String){
        self.uid = uid
    }
}

enum ChatStatus : String{
    case admin = "admin"
    case member = "member"
    case muted = "muted"
}
