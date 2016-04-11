//
//  AppDelegate.swift
//  kidz tution tracker
//
//  Created by Sendhil kumar Gurunathan on 1/13/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        let settings = UIUserNotificationSettings (forTypes: [ UIUserNotificationType.Alert , UIUserNotificationType.Badge , .Sound] , categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
          return true;
    }

    func applicationWillResignActive(application: UIApplication) {
         UIApplication.sharedApplication().applicationIconBadgeNumber = DataUtils.PendingAttendanceAndPaymentCount() // set our badge number to number of overdue items
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {

    }

    func applicationDidBecomeActive(application: UIApplication) {
        if UIApplication.sharedApplication().applicationIconBadgeNumber > 0 {
            UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        }
    }

    func applicationWillTerminate(application: UIApplication) {
    }
    

    
    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        // Handle any action if the user opens the application throught the notification. i.e., by clicking on the notification when the application is killed/ removed from background.
        if let aLaunchOptions = launchOptions { // Checking if there are any launch options.
            // Check if there are any local notification objects.
            if let notification = (aLaunchOptions as NSDictionary).objectForKey("UIApplicationLaunchOptionsLocalNotificationKey") as? UILocalNotification {
                // Handle the notification action on opening. Like updating a table or showing an alert.
               // UIAlertView(title: notification.alertTitle, message: notification.alertBody, delegate: nil, cancelButtonTitle:  "OK").show()
            /*
                
                let alertController = UIAlertController(title: notification.alertTitle, message: notification.alertBody, preferredStyle: .Alert)
                
                // Configure Alert Controller
                alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                
                UIAlertController.
                // Present Alert Controller
                presentViewController(alertController, animated: true, completion: nil)
*/
                application.presentLocalNotificationNow(notification)
            }
      
            
        }
        return   true
    }
    
    //MARK: - Background Fetch
    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        DataUtils.processMissingData(true, processPayments: true, showErrorMessage: false)
        completionHandler(UIBackgroundFetchResult.NewData)
        
    }
    
    

}

