//
//  DataUtil.swift
//  kidz tuition tracker
//
//  Created by Sendhil kumar Gurunathan on 2/26/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//

import Foundation
import CoreData

public class DataUtils
{
    static func processMissingData( processAttendance : Bool , processPayments : Bool , showErrorMessage : Bool){
        
        //let managedObjectContext = TuitionTrackerDataController().managedObjectContext
        let managedObjectContext = TuitionTrackerDataController.sharedInstance.managedObjectContext
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
                            
                            let daysDiff = Utils.daysBetweenDate( latestAttendenceCreated.date!, endDate: NSDate());
                            print("number of days to check \( daysDiff)")
                            if daysDiff > 0
                            {
                                DataUtils.processMissingAttendance(daysDiff,lastAttendenceDate: latestAttendenceCreated.date!,days: days,tuition: tuition,managedObjectContext: managedObjectContext, showErrorMessage: showErrorMessage)
                            }
                            
                            
                        }
                        else
                        {
                            // create new from start date
                            let daysDiff = Utils.daysBetweenDate( tuition.startdate!, endDate: NSDate());
                            print("number of days to check \( daysDiff)")
                            if daysDiff > 0
                            {
                                DataUtils.processMissingAttendance(daysDiff,lastAttendenceDate: tuition.startdate!,days: days,tuition: tuition,managedObjectContext: managedObjectContext, showErrorMessage: showErrorMessage)
                            }
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
                        
                        let monthDiff = Utils.monthsBetweenDate( latestPaymentCreated.date!, endDate: NSDate());
                        print("number of months to check \( monthDiff)")
                        if monthDiff > 0
                        {
                            DataUtils.processMissingPayments(monthDiff,lastAttendenceDate: latestPaymentCreated.date!,tuition: tuition,managedObjectContext: managedObjectContext, showErrorMessage: showErrorMessage )
                        }
                    }
                    else
                    {
                        //Todo : work out how to create valid date between 29-31
                        if let payOnDateToCheck =  NSCalendar.currentCalendar().dateBySettingUnit(.Day, value: Int(tuition.payon!), ofDate: tuition.startdate!, options: []){
                           print("payon date \(Int(tuition.payon!))")
                            print("tuition start day \(tuition.startdate!)")
                             print("payOnDateToCheck day \(payOnDateToCheck)")
                            //calendar.startOfDayForDate(tuition.startdate!)
                            let monthDiff = Utils.monthsBetweenDate( payOnDateToCheck, endDate: NSDate());
                            print("number of months to check \( monthDiff)")
                            if monthDiff > 0
                            {
                                DataUtils.processMissingPayments(monthDiff,lastAttendenceDate: payOnDateToCheck,tuition: tuition,managedObjectContext: managedObjectContext, showErrorMessage: showErrorMessage)
                            }
                        }
                        

                    }
                }
                
            }
            //print ("created test data")
        }
        catch {
            
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
        }
    }
    
    static func processMissingPayments( numberOfMonths: Int, lastAttendenceDate : NSDate , tuition : Tuition,managedObjectContext: NSManagedObjectContext, showErrorMessage : Bool){
        for i in 1 ... numberOfMonths
        {
        
            if   let dayToProcess = NSCalendar.currentCalendar().dateByAddingUnit(
                .Month,        value: i, toDate: lastAttendenceDate,
                options: NSCalendarOptions(rawValue: 0))
            {
             print("payment day to process \(dayToProcess)")
                createNewPayment(tuition,date: dayToProcess,managedObjectContext: managedObjectContext, showErrorMessage: showErrorMessage)
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
            
        } catch {
            let saveError = error as NSError
            print("\(saveError), \(saveError.userInfo)")
            
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
        
        
    } catch {
        let saveError = error as NSError
        print("\(saveError), \(saveError.userInfo)")
        
    }
}

static func processMissingAttendance(numberOfDays: Int, lastAttendenceDate : NSDate , days : [NSInteger], tuition : Tuition,managedObjectContext: NSManagedObjectContext, showErrorMessage : Bool){
    
    for i in 1 ... numberOfDays
    {
        if   let dayToProcess = NSCalendar.currentCalendar().dateByAddingUnit(
            .Day,
            value: i,
            toDate: lastAttendenceDate,
            options: NSCalendarOptions(rawValue: 0))
        {
            print(dayToProcess)
            print(dayToProcess.dayOfWeek())
            print(days.contains(dayToProcess.dayOfWeek()! - 1))
            // find whether the time has crossed ?
            
            print (tuition.time!)
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat =  "HH:mm"
            
            
            if days.contains(dayToProcess.dayOfWeek()! - 1) ,let date = dateFormatter.dateFromString(tuition.time!) {
                print("retrieved time with date \(date)")
                let time = dateFormatter.stringFromDate(NSDate())
                print("current time \(time)")
                let  timeArray = tuition.time!.componentsSeparatedByString(":")
                if(timeArray.count == 2 ) {
                    
                    
                    if let dateTimeToCheck =  NSCalendar.currentCalendar().dateBySettingHour(Int(timeArray[0])!, minute: Int(timeArray[1])!, second: 0, ofDate: NSDate(), options: [])
                    {
                        print("retrieved time with date updated \(dateTimeToCheck)")
                        let currentDateTime : NSDate = NSDate()
                        
                        let dateComparisionResult = currentDateTime.compare(dateTimeToCheck)
                        if( dateComparisionResult == NSComparisonResult.OrderedSame || dateComparisionResult == NSComparisonResult.OrderedDescending){
                            
                            createNewAttendance(tuition,date: dayToProcess,managedObjectContext: managedObjectContext, showErrorMessage: showErrorMessage)
                        }
                        
                    }
                }
                
                
                
            }
            
        }
 
    }
    
}

}