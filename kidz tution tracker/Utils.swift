//
//  UIHelper.swift
//  Activity Tracker
//
//  Created by Sendhil kumar Gurunathan on 2/8/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//
//  Utility methods for the UI
//

import Foundation
import UIKit

class Utils{
    

    static let title = "Kidz Tuition Tracker"
    static let titleError = "Error"
    static let failedToSave = "Failed to save the changes"
    static let tuitionNameRequiredPrompt = "Please enter the tuition name"
    static let personNameRequiredPrompt = "Please enter the name of ther person attending the tuition"
    static let repeatDaysRequiredPrompt = "Please select the tuition days"
    static let tuitionFeeRequiredPrompt = "Please enter the fee amount to be paid per class"
    static let tuitionFeeIsInvalidPrompt = "Please enter a valid fee amount"
    static let failedToSaveTuition = "Failed to save the activity details"
    static let failedToUpdateTuition = "Failed to update the tuition details"
    static let failedToDeleteTuition = "Failed to delete the attendance details"
    
    // MARK: Alert helper Methods
    static func showAlertWithTitle(viewControler: UIViewController, title: String, message: String) {
        // Initialize Alert Controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        // Configure Alert Controller
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        
        // Present Alert Controller
        viewControler.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //MARK : Container views swaping
    
    static func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[subView]|",
        options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[subView]|",
        options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewBindingsDict))
        
    }
    
    
    //MARK : Formatting
    
    static func toLongDateString(date : NSDate) -> String
    {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .NoStyle
        
        return formatter.stringFromDate(date)
    }
    
    static func toLongDateWithTimeString(date : NSDate) -> String
    {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .ShortStyle
        
        return formatter.stringFromDate(date)
    }
    
    static func toTimeFromString(time : String) -> String
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
    
     
    static func getRepeatLabel(daysSelected : [Int] ) -> String
    {
        var dayText = "Never"
        
        if  !daysSelected.isEmpty {
            
            var days = [String]()
            if daysSelected.count == 7
            {
                return "Every Day"
            }
            
            for frequency in daysSelected.sort()
            {
                
                switch frequency
                {
                case 0 :
                    dayText = "Sun"
                case 1 :
                    dayText = "Mon"
                case 2 :
                    dayText = "Tue"
                case 3 :
                    dayText = "Wed"
                case 4 :
                    dayText = "Thu"
                case 5 :
                    dayText = "Fri"
                case 6 :
                    dayText = "Sat"
                default:
                    dayText = ""
                }
                
                days.append(dayText)
            }
            return days.joinWithSeparator(" ")
        }
           return dayText

    }
    
    static func getDisplayName( tuition : String,  personName : String) -> String{
       return  "\(personName.firstCharacterUpperCase())'s \(tuition.firstCharacterUpperCase())"
        
    }
    
    static func getDisplayData(tuition :Tuition) -> (String,String,String){
        var header = ""
        var displayTime = ""
        var days = ""
        if let name = tuition.name {
            if let personName = tuition.personname {
                header = getDisplayName(name,personName: personName)
            }
            else{
                header = getDisplayName(name,personName: "")
                
            }
        }
        if let  time = tuition.time  {
            displayTime = Utils.toTimeFromString(time)
        }
        
        if let isEmpty = tuition.frequency?.isEmpty where isEmpty != true {
            days  = getRepeatLabel(tuition.frequency!)
        }
        return (header,displayTime,days)
    }

    static func getDisplayNameWithTime(tuition :Tuition) -> String{
        var header = ""
        if let name = tuition.name {
            if let personName = tuition.personname {
                header = getDisplayName(name,personName: personName)
            }
            else{
                header = getDisplayName(name,personName: "")
                
            }
            if let  time = tuition.time  {
                header = header + " " + toTimeFromString(time)
            }
            
        }
        return header
    }

}