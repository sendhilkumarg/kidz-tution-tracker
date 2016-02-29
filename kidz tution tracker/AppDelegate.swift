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
        // Override point for customization after application launch.
        let settings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
      /*  UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        */
        
                UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(NSTimeInterval(1))
        return true;
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        print("perfroming fetch");
        let start = NSDate();        
        getData();
        let end = NSDate();
        let timeInterval: Double = end.timeIntervalSinceDate(start);
        print("Time to load data: \(timeInterval) seconds");
        completionHandler(UIBackgroundFetchResult.NewData)
        
    }
    
    func getData(){
        
        let managedObjectContext = TuitionTrackerDataController().managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Tuition")
        let sortDescriptor1 = NSSortDescriptor(key: "startdate", ascending: false)
       // let sortDescriptor2 = NSSortDescriptor(key: "relAttendance.date", ascending: true)
       // let sortDescriptor3 = NSSortDescriptor(key: "relPayment.date", ascending: true)
        //fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2,sortDescriptor3]
        fetchRequest.sortDescriptors = [sortDescriptor1]
        do {
            let result = try managedObjectContext.executeFetchRequest(fetchRequest)
            for item in result
            {
                let tuition = item as! Tuition
               /* if  let days = tuition.frequency{
                    //Attendance
                    if let attendenceList = tuition.relAttendance
                    {
                        let sortDescriptor1 = NSSortDescriptor(key: "date", ascending: false)
                        let sortedList = attendenceList.sortedArrayUsingDescriptors([sortDescriptor1])
                        if sortedList.count > 0
                        {
                            //create attendance from the last attendance date
                            let latestAttendenceCreated = sortedList[0] as! Attendance
                            print( "latest attendance date \(latestAttendenceCreated.date!)")
                            
                            let daysDiff = Utils.daysBetweenDate( latestAttendenceCreated.date!, endDate: NSDate());
                            print("number of days to check \( daysDiff)")
                            if daysDiff > 0
                            {
                                DataUtils.ProcessMissingAttendance(daysDiff,lastAttendenceDate: latestAttendenceCreated.date!,days: days,tuition: tuition,managedObjectContext: managedObjectContext)
                            }
 
                            
                        }
                        else
                        {
                            // create new from start date
                            let daysDiff = Utils.daysBetweenDate( tuition.startdate!, endDate: NSDate());
                            print("number of days to check \( daysDiff)")
                            if daysDiff > 0
                            {
                                DataUtils.ProcessMissingAttendance(daysDiff,lastAttendenceDate: tuition.startdate!,days: days,tuition: tuition,managedObjectContext: managedObjectContext)
                            }
                        }

                    }

                }
                */
                //Payment
                
                if let paymentList = tuition.relPayment{
                    
                    let sortDescriptor1 = NSSortDescriptor(key: "date", ascending: false)
                    let sortedList = paymentList.sortedArrayUsingDescriptors([sortDescriptor1])
                    if sortedList.count > 0
                    {
                        let latestPaymentCreated = sortedList[0] as! Payment
                        print( "latest payment date \(latestPaymentCreated.date!)")
                        
                        let monthDiff = Utils.monthsBetweenDate( latestPaymentCreated.date!, endDate: NSDate());
                        print("number of months to check \( monthDiff)")
                        if monthDiff > 0
                        {
                            DataUtils.ProcessMissingPayments(monthDiff,lastAttendenceDate: latestPaymentCreated.date!,tuition: tuition,managedObjectContext: managedObjectContext)
                        }
                    }
                    else
                    {
                        let monthDiff = Utils.monthsBetweenDate( tuition.startdate!, endDate: NSDate());
                        print("number of months to check \( monthDiff)")
                        if monthDiff > 0
                        {
                            DataUtils.ProcessMissingPayments(monthDiff,lastAttendenceDate: tuition.startdate!,tuition: tuition,managedObjectContext: managedObjectContext)
                        }
                    }
                }

            }
            print ("created test data")
        }
        catch {
            
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
        }
    }
}

