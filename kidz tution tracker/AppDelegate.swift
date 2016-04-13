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
    

    //MARK: - Background Fetch
    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        DataUtils.processMissingData(true, processPayments: true, showErrorMessage: false)
        completionHandler(UIBackgroundFetchResult.NewData)
        
    }
    
    

}

