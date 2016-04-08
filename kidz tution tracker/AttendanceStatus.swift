//
//  AttendanceStatus.swift
//  kidz tuition tracker
//
//  Created by Sendhil kumar Gurunathan on 2/15/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//

import Foundation
 public enum AttendanceStatus: Int32 {
    case Pending = 0 ,
    Attended = 1,
    Absent = 2
    
    var description: String {
        return "\(rawValue)"
    }
    
    var displaytext : String{
        switch rawValue{
        case 0 :
            return "Pending"
        case 1 :
            return "Attended"
        case 2 :
            return "Absent"
        default :
            return "Pending"
            
        }
    }
}