//
//  UIHelper.swift
//  kidz tuition tracker
//
//  Created by Sendhil kumar Gurunathan on 2/8/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//
//  Utility methods for the UI
//

import Foundation
import UIKit

class Utils{
    

    static let titleError = "Error"
    static let titleCancel = "Cancel"
    static let failedToSave = "Failed to save the changes"
    
    // MARK: Alert helper Methods
    static func showAlertWithTitle(viewControler: UIViewController, title: String, message: String, cancelButtonTitle: String) {
        // Initialize Alert Controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        // Configure Alert Controller
        alertController.addAction(UIAlertAction(title: cancelButtonTitle, style: .Default, handler: nil))
        
        
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
    
     
    static func GetRepeatLabel(daysSelected : [Int] ) -> String
    {
        var dayText = "Never"
        
        if  !daysSelected.isEmpty {
            
            var days = [String]()
            
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
    
    static func GetRepeatLabelInShortFormat(daysSelected : [Int] ) -> String
    {
        var dayText = "Days : Never"
        
        if  !daysSelected.isEmpty {
            
            var days = [String]()
            
            for frequency in daysSelected.sort()
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
                    dayText = ""
                }
                
                days.append(dayText)
            }
            return "Days : \(days.joinWithSeparator("|"))"
        }
        return dayText
        
    }
    



}