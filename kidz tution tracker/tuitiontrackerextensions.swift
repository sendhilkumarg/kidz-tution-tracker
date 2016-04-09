//
//  tuitiontrackerextensions.swift
//  kidz tuition tracker
//
//  Created by Sendhil kumar Gurunathan on 2/25/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//
//  Placeholder for possible extension methods

import Foundation
extension NSDate {
    func dayOfWeek() -> Int? {
        if
            let cal: NSCalendar = NSCalendar.currentCalendar(),
            let comp: NSDateComponents = cal.components(.Weekday, fromDate: self) {
                return comp.weekday
        } else {
            return nil
        }
    }
}
