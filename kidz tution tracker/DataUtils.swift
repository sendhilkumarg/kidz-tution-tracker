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
    static func ProcessMissingPayments( numberOfMonths: Int, lastAttendenceDate : NSDate , tuition : Tuition,managedObjectContext: NSManagedObjectContext){
        for i in 1 ... numberOfMonths
        {
        
            if   let dayToProcess = NSCalendar.currentCalendar().dateByAddingUnit(
                .Month,        value: i, toDate: lastAttendenceDate,
                options: NSCalendarOptions(rawValue: 0))
            {
             print("payment day to process \(dayToProcess)")
                CreateNewPayment(tuition,date: dayToProcess,managedObjectContext: managedObjectContext)
            }
        
        }
    }
    
    static func CreateNewPayment(tuition : Tuition , date : NSDate, managedObjectContext: NSManagedObjectContext)
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
    
static func CreateNewAttendance(tuition : Tuition , date : NSDate ,managedObjectContext: NSManagedObjectContext)
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

static func ProcessMissingAttendance(numberOfDays: Int, lastAttendenceDate : NSDate , days : [NSInteger], tuition : Tuition,managedObjectContext: NSManagedObjectContext){
    
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
            
            
            if let date = dateFormatter.dateFromString(tuition.time!) {
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
                            
                            CreateNewAttendance(tuition,date: dayToProcess,managedObjectContext: managedObjectContext)
                        }
                        
                    }
                }
                
                
                
            }
            
        }
 
    }
    
}

}