//
//  kidz_tution_trackerTests.swift
//  kidz tution trackerTests
//
//  Created by Sendhil kumar Gurunathan on 1/13/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//

import XCTest
//@testable import kidz_tution_tracker
import Foundation

class kidz_tution_trackerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let calendar = NSCalendar.currentCalendar()
        let valentinesDayComponents = NSDateComponents()
        valentinesDayComponents.year = 2015
        valentinesDayComponents.month = 2
        valentinesDayComponents.day = 1
        let theDay = calendar.dateFromComponents(valentinesDayComponents)!
        
        print("theDay \(toLongDateString(theDay))")
        
        
        if let payOnDateToCheck =  NSCalendar.currentCalendar().dateBySettingUnit(.Day, value: Int(31), ofDate: NSDate(), options: []){
            //this gives the exact date or the first of next month of it exceeeds the 28,29,30,31 for the months. if the number is 32 it ll be invalid
            
             print("valid \(payOnDateToCheck)")
            print("valid \(toLongDateString(payOnDateToCheck))")
        }
        else
        {
            print("invalid")
        }
        
        /*
        let components = calendar.components([.Year, .Month], fromDate: theDay)
        let startOfMonth = calendar.dateFromComponents(components)!
        print ("startOfMonth \(toLongDateString(startOfMonth))")
        //print ( startOfMonth.dateBySettingUnit(.Month,value: 1,options: []))
        let comps2 = NSDateComponents()
        //comps2.year = 0
        comps2.month = 1
        comps2.day = -1
        let endOfMonth = calendar.dateByAddingComponents(comps2, toDate: startOfMonth, options: [])!
        print ("endOfMonth \(toLongDateString(endOfMonth))")
        print(  calendar.startOfDayForDate(NSDate()))
        
        

        let dateComponents = calendar.components([.Day, .Year, .Month], fromDate: NSDate())
        print("datecomponents day \(calendar.dateFromComponents(dateComponents))")
        print("day \(dateComponents.day)")
        print("month \(dateComponents.month)")
        
        
        
        let dayComponents = NSDateComponents()
        dayComponents.year = 2001
        dayComponents.month = 2
        dayComponents.day = 31

         print("dayComponents day \(calendar.dateFromComponents(dayComponents))")
        */

            
    }
    
     func toLongDateString(date : NSDate) -> String
    {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .NoStyle
        
        return formatter.stringFromDate(date)
    }
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
