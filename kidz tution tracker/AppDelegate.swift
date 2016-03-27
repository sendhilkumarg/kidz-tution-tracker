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
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
        
         UIApplication.sharedApplication().applicationIconBadgeNumber = DataUtils.PendingAttendanceAndPaymentCount() // set our badge number to number of overdue items
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if UIApplication.sharedApplication().applicationIconBadgeNumber > 0 {
            UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    

    
    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        // Handle any action if the user opens the application throught the notification. i.e., by clicking on the notification when the application is killed/ removed from background.
        if let aLaunchOptions = launchOptions { // Checking if there are any launch options.
            // Check if there are any local notification objects.
            if let notification = (aLaunchOptions as NSDictionary).objectForKey("UIApplicationLaunchOptionsLocalNotificationKey") as? UILocalNotification {
                // Handle the notification action on opening. Like updating a table or showing an alert.
                UIAlertView(title: notification.alertTitle, message: notification.alertBody, delegate: nil, cancelButtonTitle: "OK").show()
            }
      
            
        }
        return   true
    }
    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        //let start = NSDate();
        DataUtils.processMissingData(true, processPayments: true, showErrorMessage: false)
        //let end = NSDate();
        //let timeInterval: Double = end.timeIntervalSinceDate(start);
        //print("Time to load data: \(timeInterval) seconds");
        completionHandler(UIBackgroundFetchResult.NewData)
        
    }
    
    //MARK: - Badge
    

}

