//
//  AttendanceExtension.swift
//  Activity Tracker
//
//  Created by Sendhil kumar Gurunathan on 2/15/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//
//  Extension for Attendance
//

import Foundation
extension Attendance {
    
    var CurrentStatus: AttendanceStatus {
        get {
            return AttendanceStatus(rawValue: status!.intValue)!
        }
        set {
            status = NSNumber(int: newValue.rawValue)
        }
        
    }
    
}