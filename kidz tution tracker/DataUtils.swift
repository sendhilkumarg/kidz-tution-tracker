//
//  DataUtil.swift
//  kidz tuition tracker
//
//  Created by Sendhil kumar Gurunathan on 2/26/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//

import Foundation
import CoreData
import UIKit
public class DataUtils
{
    static let managedObjectContext = TuitionTrackerDataController.sharedInstance.managedObjectContext
    static let calendar = NSCalendar.currentCalendar()
    
    //MARK: - Badge

    static func PendingAttendanceAndPaymentCount() -> Int {
         let attendancefetchRequest = NSFetchRequest(entityName: "Attendance")
         attendancefetchRequest.predicate = NSPredicate(format: "status == %@", AttendanceStatus.Pending.description)
         let paymentfetchRequest = NSFetchRequest(entityName: "Payment")
         paymentfetchRequest.predicate = NSPredicate(format: "status == %@", PaymentStatus.Pending.description)
         var error: NSError? = nil
         let attendanceCount =  managedObjectContext.countForFetchRequest(attendancefetchRequest, error: &error)
         let paymentCount =  managedObjectContext.countForFetchRequest(paymentfetchRequest, error: &error)
         return (attendanceCount + paymentCount)

    }
    //MARK: - Scheduling
    
    static func schedulePaymentNotification(tuition : Tuition , payment : Payment) {
        if  let settings = UIApplication.sharedApplication().currentUserNotificationSettings() where
            settings.types != .None {
                
                let payReminderDate =  calendar.dateByAddingUnit(.Hour, value: 7, toDate: payment.date!, options: []) // This is at UTC 13 houra:. so setting up the reminder for 7 AM in the morning
                print(payment.date!)
                print(payReminderDate!)
                let notification = UILocalNotification()
                
                notification.fireDate = payReminderDate! ;// NSDate(timeIntervalSinceNow: 5)
                notification.alertBody = "Update the payment status for \(tuition.personname!)' \(tuition.name!) scheduled \(Utils.ToLongDateString(payment.date!))"
                notification.alertAction = "open"
                notification.soundName = UILocalNotificationDefaultSoundName
                notification.alertTitle = "Tuition Tracker"
                notification.userInfo = ["action": "payment"]
                UIApplication.sharedApplication().scheduleLocalNotification(notification)

        }
    }
    
    static func scheduleAttendanceNotification(tuition : Tuition , attendance : Attendance) {
        if  let settings = UIApplication.sharedApplication().currentUserNotificationSettings() where
            settings.types != .None {
                
                let attendanceReminderDate =  calendar.dateByAddingUnit(.Minute, value: 5, toDate: attendance.date!, options: []) //TODO : this day can be of any hour. so update a logic that might suit . say 7 AM in the morning
                print(attendance.date!)
                print(attendanceReminderDate!)
                let notification = UILocalNotification()
                
                notification.fireDate = attendanceReminderDate! ;// NSDate(timeIntervalSinceNow: 5)
                notification.alertBody = "Update the attendance status for \(tuition.personname!)' \(tuition.name!) scheduled \(Utils.ToLongDateString(attendance.date!)) \(Utils.ToTimeFromString(tuition.time!)) "
                notification.alertAction = "open"
                notification.soundName = UILocalNotificationDefaultSoundName
                notification.alertTitle = "Tuition Tracker"
                notification.userInfo = ["action": "payment"]
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
                
        }
    }
    
    //MARK: - Missing Data processing
    
    static func processMissingData( processAttendance : Bool , processPayments : Bool , showErrorMessage : Bool){

        
        let fetchRequest = NSFetchRequest(entityName: "Tuition")
        let sortDescriptor1 = NSSortDescriptor(key: "startdate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor1]
        do {
            let result = try managedObjectContext.executeFetchRequest(fetchRequest)
            for item in result
            {
                let tuition = item as! Tuition
                if  processAttendance , let days = tuition.frequency{
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
                            

                            if let   nextDate  = calendar.dateByAddingUnit(
                                .Day,        value: 1, toDate: latestAttendenceCreated.date!,
                                options: NSCalendarOptions(rawValue: 0))
                            {

                                DataUtils.processMissingAttendance( nextDate,days: days,tuition: tuition,managedObjectContext: managedObjectContext, showErrorMessage: showErrorMessage)
                            }

                            
                        }
                        else
                        {
                            let startDate = calendar.startOfDayForDate( tuition.startdate!)
                            DataUtils.processMissingAttendance( startDate,days: days,tuition: tuition,managedObjectContext: managedObjectContext, showErrorMessage: showErrorMessage)

                        }
                        
                    }
                    
                }
                
                //Payment
                
                if processPayments , let paymentList = tuition.relPayment{
                    
                    let sortDescriptor1 = NSSortDescriptor(key: "date", ascending: false)
                    let sortedList = paymentList.sortedArrayUsingDescriptors([sortDescriptor1])
                    if sortedList.count > 0
                    {
                        let latestPaymentCreated = sortedList[0] as! Payment
                        print( "latest payment date \(latestPaymentCreated.date!)")
                        let startDate = calendar.startOfDayForDate( latestPaymentCreated.date!)
                        if let   nextMonthDate  = calendar.dateByAddingUnit(
                        .Month,        value: 1, toDate: startDate,
                        options: NSCalendarOptions(rawValue: 0))
                        {
                            processMissingPayments(nextMonthDate, tuition: tuition, managedObjectContext: managedObjectContext, showErrorMessage: showErrorMessage)
                        }

                    }
                    else
                    {
                        print("payon date \(Int(tuition.payon!))")
                        print("tuition start day \(tuition.startdate!)")
                        let startDate = calendar.startOfDayForDate( tuition.startdate!)
                        processMissingPayments(startDate, tuition: tuition, managedObjectContext: managedObjectContext, showErrorMessage: showErrorMessage)

                    }
                }
                
            }
        }
        catch {
            
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
        }
    }
    
    //MARK: -  Payment processing
    
    static func processMissingPayments(  lastPaymentDate : NSDate , tuition : Tuition,managedObjectContext: NSManagedObjectContext, showErrorMessage : Bool){
        let currentDateTime : NSDate = calendar.startOfDayForDate(NSDate())
        let payOn = Int(tuition.payon!)
        if var payOnDateToCheck =  calendar.dateBySettingUnit(.Day, value: payOn, ofDate: lastPaymentDate, options: []){
            
            var dateComparisionResult = currentDateTime.compare(payOnDateToCheck)
            
            print("payOnDateToCheck day \(payOnDateToCheck)")
            print("dateComparisionResult = \(dateComparisionResult.rawValue)")

            while (dateComparisionResult == NSComparisonResult.OrderedSame || dateComparisionResult == NSComparisonResult.OrderedDescending)
            {
                createNewPayment(tuition,date: payOnDateToCheck,managedObjectContext: managedObjectContext, showErrorMessage: showErrorMessage)

                if let   nextMonthDate  = calendar.dateByAddingUnit(
                    .Month,        value: 1, toDate: payOnDateToCheck, //options: [])
                    options: NSCalendarOptions(rawValue: 0))
                {
                    
                    payOnDateToCheck = calendar.startOfDayForDate( nextMonthDate)
                    dateComparisionResult = currentDateTime.compare(payOnDateToCheck)
                    print("payOnDateToCheck day updated \(payOnDateToCheck)")
                    
                    print("dateComparisionResult = \(dateComparisionResult.rawValue)")
                    
                }
                else
                {
                    print("invalid")
                    dateComparisionResult =  NSComparisonResult.OrderedAscending
                    
                }
                
            }
            

        }
        
    }

    
    static func createNewPayment(tuition : Tuition , date : NSDate, managedObjectContext: NSManagedObjectContext, showErrorMessage : Bool)
    {
        // Create Entity
        let entity = NSEntityDescription.entityForName("Payment", inManagedObjectContext: managedObjectContext)
        
        // Initialize Record
        let record = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        
        
        record.setValue(date , forKey: "date")
        record.setValue( NSInteger( PaymentStatus.Pending.rawValue) , forKey: "status")
        record.setValue(tuition, forKey: "relTuition")
        
        do {
            // Save Record
            try record.managedObjectContext?.save()
            schedulePaymentNotification(tuition,payment: record as! Payment)
            
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
            
        }
    }
    
//MARK: - Attendance processing
    
static func processMissingAttendance( lastAttendenceDate : NSDate , days : [NSInteger], tuition : Tuition,managedObjectContext: NSManagedObjectContext, showErrorMessage : Bool){
    

    let  timeArray = tuition.time!.componentsSeparatedByString(":")
    if(timeArray.count == 2 ) {
        var dayToProcess = lastAttendenceDate;
        if let dateTimeToCheck =  calendar.dateBySettingHour(Int(timeArray[0])!, minute: Int(timeArray[1])!, second: 0, ofDate: dayToProcess, options: [])
        {
            dayToProcess = dateTimeToCheck
            print("retrieved time with date updated \(dateTimeToCheck)")

            var dateComparisionResult = NSDate().compare(dayToProcess)
            while( dateComparisionResult == NSComparisonResult.OrderedSame || dateComparisionResult == NSComparisonResult.OrderedDescending){
                    
                if days.contains(dayToProcess.dayOfWeek()! - 1)  {
                    createNewAttendance(tuition,date: dayToProcess,managedObjectContext: managedObjectContext, showErrorMessage: showErrorMessage)
                }
                if   let updatedDayToProcess = calendar.dateByAddingUnit(
                        .Day,
                        value: 1,
                        toDate: dayToProcess,
                        options:[]) // construct the next date
                    {
                        dayToProcess = updatedDayToProcess
                        dateComparisionResult = NSDate().compare(updatedDayToProcess)
                         print("retrieved time with date updated \(updatedDayToProcess)")

                    }
                    else
                    {
                        dateComparisionResult = NSComparisonResult.OrderedAscending
                    }
                }
                
            }

    }

    }
    
    static func createNewAttendance(tuition : Tuition , date : NSDate ,managedObjectContext: NSManagedObjectContext, showErrorMessage : Bool)
    {
        // Create Entity
        let entity = NSEntityDescription.entityForName("Attendance", inManagedObjectContext: managedObjectContext)
        
        // Initialize Record
        let record = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        
        record.setValue(date , forKey: "date")
        record.setValue( NSInteger( AttendanceStatus.Pending.rawValue) , forKey: "status")
        record.setValue(tuition, forKey: "relTuition")
        
        do {
            // Save Record
            try record.managedObjectContext?.save()
            scheduleAttendanceNotification(tuition, attendance : record as! Attendance)
            
            
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
            
        }
    }


}