import UIKit
import RealmSwift
import UserNotifications
import Firebase
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var ref : DatabaseReference!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //logout()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        let realm = try! Realm()
        if realm.objects(Event.self).isEmpty {
            
            let u1 = User(email: "a", password: "a")
            u1.firstName = "John"
            u1.lastName = "Smith"
            u1.image = #imageLiteral(resourceName: "cat").data!
            let u2 = User(email: "b", password: "b")

            let addedEvents = [Event(name: "Comic-Con", image: #imageLiteral(resourceName: "cc").data!, timeStart: Date(date: "19-07-2018 10:00:00")!, timeEnd: Date(date: "21-07-2018 18:00:00")!, place: "San-Diego Convention Center" , organizer: u1, eventCategory: "Convention", eventDescription: "that's comic-con"),
                               Event(name: "Cat Lovers Convention", image: #imageLiteral(resourceName: "kitty").data!, timeStart: Date(date: "10-03-2018 10:00:00")!, timeEnd: Date(date: "11-03-2018 18:00:00")!, place: "Convention Center" , organizer: u2, eventCategory: "Convention",eventDescription: "for those who just adores fluffy creatures"),
                               Event(name: "CocoaHeads", image: #imageLiteral(resourceName: "ch").data!, timeStart: Date(date: "24-04-2018 10:00:00")!, timeEnd: Date(date: "25-04-2018 18:00:00")!, place: "Mail.ru Office" , organizer: u2, eventCategory: "Meetup",eventDescription: "swift lovers meetup"),
                               Event(name: "The International 2018", image: #imageLiteral(resourceName: "ti").data!, timeStart: Date(date: "20-08-2018 11:00:00")!, timeEnd: Date(date: "25-08-2018 18:00:00")!, place: "Rogers Arena" , organizer: u2, eventCategory: "Contest",eventDescription: "The most popular dota competition"),
                               Event(name: "event", image: #imageLiteral(resourceName: "kitty").data!, timeStart: Date(date: "20-05-2018 11:00:00")!, timeEnd: Date(date: "25-05-2018 18:00:00")!, place: "Conference Hall" , organizer: u2, eventCategory: "Other",eventDescription: "huh"),
                               Event(name: "yet another event this time with long name", image: #imageLiteral(resourceName: "kitty").data!, timeStart: Date(date: "28-05-2018 11:00:00")!, timeEnd: Date(date: "30-05-2018 18:00:00")!, place: "ConfeHall" , organizer: u2, eventCategory: "Other",eventDescription: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.")]
            
            addedEvents[1].visitors.append(u1)
            addedEvents[2].visitors.append(u1)
            addedEvents[3].visitors.append(u1)
            
            try! realm.write {
                realm.add(u1)
                realm.add(u2)
                realm.add(addedEvents)
                
            }
        }
        if UserDefaults.standard.string(forKey: "user") != nil {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RootNavigationControllerID")
            self.window?.rootViewController = vc
        }
        UILabel.appearance().adjustsFontSizeToFitWidth = true
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge ]) {
            (authorized:Bool, error:Error?) in
            if !authorized {
                print ("App is useless because you did not allow notifications.")
            }
            //let settings  = UNNotificationSettings(options: [.alert, .sound, .badge], categories: nil)
        }
        application.registerForRemoteNotifications()
        
        //Define Actions
        let firstAction = UNNotificationAction(identifier: "Nothingchange", title: "We're still on for tomorrow", options: [])
        let secondAction = UNNotificationAction(identifier: "LittleChange", title: "I'am late", options: [])
        let thirdAction = UNNotificationAction(identifier: "Cancelling", title: "I'm not coming", options: [])
        
        //Add action to a eventCategory
        let category = UNNotificationCategory(identifier: "eventCategory", actions: [firstAction, secondAction, thirdAction], intentIdentifiers: [], options: [])
        
        //Add the eventCategory to Notification Framework
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        //Firebase configuration
        FirebaseApp.configure()
        ref = Database.database().reference()
        
        //Keyboard manager
        IQKeyboardManager.shared.enable = true
        
        
        return true
    }
    
    
    func logout () {
        UserDefaults.standard.removeObject(forKey: "user")
    }
    
    func sendNotification () {
        let notification = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = " You are welcome"
        content.body = " Just a reminder to visit this event"
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "eventCategory"
        
        let request = UNNotificationRequest(identifier: "eventNotification", content: content, trigger: notification)
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) { (error:Error?)in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

