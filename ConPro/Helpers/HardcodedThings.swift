import Foundation
import UIKit

var u1 = User(id: 1, name: "John Smith", image: #imageLiteral(resourceName: "cat"))
var u2 = User(id: 2, name: "Asd", image: #imageLiteral(resourceName: "cat"))

var n1 = News(id: 1, name: "", message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.")

var cc = Event(id: 1, name: "Comic-Con", image: #imageLiteral(resourceName: "cc"), timeStart: Date(date: "19-07-2018 10:00:00")!, timeEnd: Date(date: "21-07-2018 18:00:00")!, place: "San-Diego Convention Center" , organizer: u1)
var cats = Event(id: 2, name: "Cat Lovers Convention", image: #imageLiteral(resourceName: "kitty"), timeStart: Date(date: "10-03-2018 10:00:00")!, timeEnd: Date(date: "11-03-2018 18:00:00")!, place: "Convention Center" , organizer: u2)
var ch = Event(id: 3, name: "CocoaHeads", image: #imageLiteral(resourceName: "ch"), timeStart: Date(date: "24-04-2018 10:00:00")!, timeEnd: Date(date: "25-04-2018 18:00:00")!, place: "Mail.ru Office" , organizer: u2)
var ti = Event(id: 4, name: "The International 2018", image: #imageLiteral(resourceName: "ti"), timeStart: Date(date: "20-08-2018 11:00:00")!, timeEnd: Date(date: "25-08-2018 18:00:00")!, place: "Rogers Arena" , organizer: u2)
var ev = Event(id: 5, name: "event", image: #imageLiteral(resourceName: "clock"), timeStart: Date(date: "20-05-2018 11:00:00")!, timeEnd: Date(date: "25-05-2018 18:00:00")!, place: "Conference Hall" , organizer: u2)
var addedEvents = [Event]()

