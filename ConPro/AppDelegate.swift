import UIKit
import Moya
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        provider = MoyaProvider<APIService>()
        //UserDefaults.standard.removeObject(forKey: "token")
        //UserDefaults.standard.removeObject(forKey: "events")
        if UserDefaults.standard.data(forKey: "token") != nil {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RootNavigationControllerID")
            self.window?.rootViewController = vc
        }
        UILabel.appearance().adjustsFontSizeToFitWidth = true
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge ]) {
            (authorized:Bool, error:Error?) in
            if !authorized {
                print ("App is useless because you did not allow notifications.")
            }
            // let settings  = UNNotificationSettings(options: [.alert, .sound, .badge], categories: nil)
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
        
        
        return true
    }
    
    //func logout () {
      //  UserDefaults.standard.removeObject(forKey: "token")
   // }
    
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

