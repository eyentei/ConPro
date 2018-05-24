import Foundation
import UIKit

var u1 = User(id: 1, name: "John Smith", image: "cat")
var u2 = User(id: 2, name: "Asd", image: "cat")

var n1 = News(id: 1, name: "", message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.")

var addedEvents = [Event(id: 1, name: "Comic-Con", image: "cc", timeStart: Date(date: "19-07-2018 10:00:00")!, timeEnd: Date(date: "21-07-2018 18:00:00")!, place: "San-Diego Convention Center" , organizer: u1),
                   Event(id: 2, name: "Cat Lovers Convention", image: "kitty", timeStart: Date(date: "10-03-2018 10:00:00")!, timeEnd: Date(date: "11-03-2018 18:00:00")!, place: "Convention Center" , organizer: u2),
                   Event(id: 3, name: "CocoaHeads", image: "ch", timeStart: Date(date: "24-04-2018 10:00:00")!, timeEnd: Date(date: "25-04-2018 18:00:00")!, place: "Mail.ru Office" , organizer: u2),
                   Event(id: 4, name: "The International 2018", image: "ti", timeStart: Date(date: "20-08-2018 11:00:00")!, timeEnd: Date(date: "25-08-2018 18:00:00")!, place: "Rogers Arena" , organizer: u2),
                   Event(id: 5, name: "event", image: "kitty", timeStart: Date(date: "20-05-2018 11:00:00")!, timeEnd: Date(date: "25-05-2018 18:00:00")!, place: "Conference Hall" , organizer: u2),
                   Event(id: 6, name: "yet another event this time with long name", image: "kitty", timeStart: Date(date: "28-05-2018 11:00:00")!, timeEnd: Date(date: "30-05-2018 18:00:00")!, place: "ConfeHall" , organizer: u2)]

func saveEvents(){
    let encoder = JSONEncoder()
    if let encodedEvents = try? encoder.encode(addedEvents){
        UserDefaults.standard.set(encodedEvents, forKey: "events")
    }
}
func loadEvents() {
    let decoder = JSONDecoder()
    if let events = UserDefaults.standard.value(forKey: "events") as? Data {
        if let decodedEvents = try? decoder.decode(Array.self, from: events) as [Event] {
            addedEvents = decodedEvents
        }
    }
}

