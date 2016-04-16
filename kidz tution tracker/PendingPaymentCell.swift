//
//  PendingPaymentCell.swift
//  Activity Tracker
//
//  Created by Sendhil kumar Gurunathan on 2/17/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//
//  Table View cell to display the pending payments
//

import UIKit
import CoreData
class PendingPaymentCell: UITableViewCell {
  var delegate : PaymentChangeControllerDelegate?
  var objectId : NSManagedObjectID?
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var statusSwitch: UISwitch!
    


    @IBAction func statusChanged(sender: UISwitch) {
        if let delegate = delegate {
            
            delegate.StatusChanged( objectId!, status : sender.on  ?PaymentStatus.Paid  : PaymentStatus.Pending)
        }
        

    }
 
}
