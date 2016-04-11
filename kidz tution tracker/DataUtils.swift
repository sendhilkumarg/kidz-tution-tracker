//
//  DataUtil.swift
//  kidz tuition tracker
//
//  Created by Sendhil kumar Gurunathan on 2/26/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//
//  Helper class to create the attendance and payment records and schedule notifications
//

import Foundation
import CoreData
import UIKit
public class DataUtils
{
    static let managedObjectContext = TuitionTrackerDataController.sharedInstance.managedObjectContext
    static let calendar = NSCalendar.currentCalendar()

    //MARK: - Method used to create the attendance and payment record as a background task or when the user pull to refresh pending attendacne / payment. This will also schedule the notifications
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
                        let startDate = calendar.startOfDayForDate( tuition.startdate!)
                        processMissingPayments(startDate, tuition: tuition, managedObjectContext: managedObjectContext, showErrorMessage: showErrorMessage)

                    }
                }
                
            }
        }
        catch {
            
            let saveError = error as NSError
            fatalError(String(saveError.userInfo))
           
        }
    }
    
    //MARK: -  Payment processing
    
    static func processMissingPayments(  lastPaymentDate : NSDate , tuition : Tuition,managedObjectContext: NSManagedObjectContext, showErrorMessage : Bool){
        let currentDateTime : NSDate = calendar.startOfDayForDate(NSDate())
        let payOn = Int(tuition.payon!)
        if var payOnDateToCheck =  calendar.dateBySettingUnit(.Day, value: payOn, ofDate: lastPaymentDate, options: []){
            
            var dateComparisionResult = currentDateTime.compare(payOnDateToCheck)
            

            while (dateComparisionResult == NSComparisonResult.OrderedSame || dateComparisionResult == NSComparisonResult.OrderedDescending)
            {
                createNewPayment(tuition,date: payOnDateToCheck,managedObjectContext: managedObjectContext, showErrorMessage: showErrorMessage)

                if let   nextMonthDate  = calendar.dateByAddingUnit(
                    .Month,        value: 1, toDate: payOnDateToCheck, //options: [])
                    options: NSCalendarOptions(rawValue: 0))
                {
                    
                    payOnDateToCheck = calendar.startOfDayForDate( nextMonthDate)
                    dateComparisionResult = currentDateTime.compare(payOnDateToCheck)
                    
                }
                else
                {
                    dateComparisionResult =  NSComparisonResult.OrderedAscending
                    
                }
                
            }
            

        }
        
    }

    
    static func createNewPayment(tuition : Tuition , date : NSDate, managedObjectContext: NSManagedObjectContext, showErrorMessage : Bool)     {
        // Create Entity
        let entity = NSEntityDescription.entityForName("Payment", inManagedObjectContext: managedObjectContext)
        
        // Initialize Record
        let record = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
        
        
        record.setValue(date , forKey: "date")
        record.setValue( NSInteger( PaymentStatus.Pending.rawValue) , forKey: "status")
        record.setValue(tuition, forKey: "relTuition")
        
        do {
            // Save Record
            try
                record.managedObjectContext?.save()
            schedulePaymentNotification(tuition,payment: record as! Payment)
            
        } catch {
            _ = error as NSError
            
            //throw saveError
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
            _ = error as NSError
            
        }
    }

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
    
    //MARK: - Notifications
    
    static func schedulePaymentNotification(tuition : Tuition , payment : Payment) {
        if  let settings = UIApplication.sharedApplication().currentUserNotificationSettings() where
            settings.types != .None {
            
            let payReminderDate =  calendar.dateByAddingUnit(.Hour, value: 7, toDate: payment.date!, options: [])
            let notification = UILocalNotification() // scheduled for 7 AM on payment date
            notification.fireDate = payReminderDate! ;
            notification.alertBody = "Update the payment status for \(tuition.personname!)' \(tuition.name!) scheduled \(Utils.ToLongDateString(payment.date!))"
            notification.alertAction = "open"
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.alertTitle = Utils.title
            notification.userInfo = ["action": "payment"]
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            
        }
    }
    
    static func scheduleAttendanceNotification(tuition : Tuition , attendance : Attendance) {
        if  let settings = UIApplication.sharedApplication().currentUserNotificationSettings() where
            settings.types != .None {
            
            let attendanceReminderDate =  calendar.dateByAddingUnit(.Minute, value: 5, toDate: attendance.date!, options: [])
            let notification = UILocalNotification()
            notification.fireDate = attendanceReminderDate! ;// NSDate(timeIntervalSinceNow: 5)
            notification.alertBody = "Update the attendance status for \(tuition.personname!)' \(tuition.name!) scheduled \(Utils.ToLongDateString(attendance.date!)) \(Utils.ToTimeFromString(tuition.time!)) "
            notification.alertAction = "open"
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.alertTitle = Utils.title
            notification.userInfo = ["action": "attendance"]
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            
        }
    }


}