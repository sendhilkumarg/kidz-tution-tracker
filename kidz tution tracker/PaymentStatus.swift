//
//  PaymentStatus.swift
//  kidz tuition tracker
//
//  Created by Sendhil kumar Gurunathan on 2/16/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//

import Foundation
public enum PaymentStatus: Int32 {
    case Pending = 0
    case Paid = 1
    
    var description: String {
        return "\(rawValue)"
    }
    
    var displaytext : String{
        switch rawValue{
        case 0 :
            return "Pending"
            break
        case 1 :
            return "Paid"
            break

        default :
            return "Pending"
            
        }
    }
}
