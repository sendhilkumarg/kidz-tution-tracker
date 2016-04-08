//
//  PaymentExtension.swift
//  kidz tuition tracker
//
//  Created by Sendhil kumar Gurunathan on 2/20/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//

import Foundation
extension Payment {
    
    var CurrentStatus: PaymentStatus {
        get {
            return PaymentStatus(rawValue: status!.intValue)!
        }
        set {
            status = NSNumber(int: newValue.rawValue)
        }
        
    }
    
}