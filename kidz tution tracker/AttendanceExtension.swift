//
//  AttendanceExtension.swift
//  kidz tuition tracker
//
//  Created by Sendhil kumar Gurunathan on 2/15/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
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