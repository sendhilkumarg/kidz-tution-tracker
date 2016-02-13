//
//  UIHelper.swift
//  kidz tuition tracker
//
//  Created by Sendhil kumar Gurunathan on 2/8/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//

import Foundation
import UIKit

class Utils{
    // MARK: -
    // MARK: Helper Methods
    static func showAlertWithTitle(viewControler: UIViewController, title: String, message: String, cancelButtonTitle: String) {
        // Initialize Alert Controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        // Configure Alert Controller
        alertController.addAction(UIAlertAction(title: cancelButtonTitle, style: .Default, handler: nil))
        
        // Present Alert Controller
        viewControler.presentViewController(alertController, animated: true, completion: nil)
    }
    
    static func ToLongDateString(date : NSDate) -> String
    {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .NoStyle
        
        return formatter.stringFromDate(date)
    }
    
    static func ToTimeFromString(time : String) -> String
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat =  "HH:mm"
        
        if let  time = dateFormatter.dateFromString(time as String) {
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "h:mm a" //"h:mm a 'on' MMMM dd, yyyy"
            formatter.AMSymbol = "AM"
            formatter.PMSymbol = "PM"
            
            return formatter.stringFromDate(time)
            
        }
        return ""
    }
    
    static     func configureTuitionsTableViewCellCell(cell: TuitionsTableViewCell, tuition : Tuition , atIndexPath indexPath: NSIndexPath) {
        // Fetch Record
       // let tuition = fetchedResultsController.objectAtIndexPath(indexPath) as! Tuition
        
        // Update Cell
        if let name = tuition.name {
            if let personName = tuition.personname {
                cell.tuitionNameLabel.text = "\(personName)'s \(name)"
            }
            else{
                cell.tuitionNameLabel.text = name
                
            }
            
        }
        
        if let  time = tuition.time  {
            cell.timeLabel.text = Utils.ToTimeFromString(time)
        }
        else
        {
            cell.timeLabel.text = "";
        }
        
        
        if let isEmpty = tuition.frequency?.isEmpty where isEmpty != true {
            
            var days = [String]()
            var dayText = "S"
            
            for frequency in tuition.frequency!
            {
                
                switch frequency
                {
                case 0 :
                    dayText = "S"
                case 1 :
                    dayText = "M"
                case 2 :
                    dayText = "T"
                case 3 :
                    dayText = "W"
                case 4 :
                    dayText = "T"
                case 5 :
                    dayText = "F"
                case 6 :
                    dayText = "S"
                default:
                    dayText = "S"
                }
                
                days.append(dayText)
            }
            
            cell.daysLabel.text  = "Days : " + days.joinWithSeparator("|")
        }
        
    }
    
    static     func configureAttendanceTuitionTableViewCell(cell: AttendanceTuitionTableViewCell, tuition : Tuition , atIndexPath indexPath: NSIndexPath) {
        // Fetch Record
        // let tuition = fetchedResultsController.objectAtIndexPath(indexPath) as! Tuition
        
        // Update Cell
        if let name = tuition.name {
            if let personName = tuition.personname {
                cell.tuitionNameLabel.text = "\(personName)'s \(name)"
            }
            else{
                cell.tuitionNameLabel.text = name
                
            }
            
        }
        
        if let  time = tuition.time  {
            cell.timeLabel.text = Utils.ToTimeFromString(time)
        }
        else
        {
            cell.timeLabel.text = "";
        }
        
        
        if let isEmpty = tuition.frequency?.isEmpty where isEmpty != true {
            
            var days = [String]()
            var dayText = "S"
            
            for frequency in tuition.frequency!
            {
                
                switch frequency
                {
                case 0 :
                    dayText = "S"
                case 1 :
                    dayText = "M"
                case 2 :
                    dayText = "T"
                case 3 :
                    dayText = "W"
                case 4 :
                    dayText = "T"
                case 5 :
                    dayText = "F"
                case 6 :
                    dayText = "S"
                default:
                    dayText = "S"
                }
                
                days.append(dayText)
            }
            
            cell.daysLabel.text  = "Days : " + days.joinWithSeparator("|")
        }
        
    }


}