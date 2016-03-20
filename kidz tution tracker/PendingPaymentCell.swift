//
//  PendingPaymentCell.swift
//  kidz tuition tracker
//
//  Created by Sendhil kumar Gurunathan on 2/17/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//

import UIKit
import CoreData
class PendingPaymentCell: UITableViewCell {
  var delegate : PaymentChangeControllerDelegate?
  var objectId : NSManagedObjectID?
  var atIndexPath : NSIndexPath?
    
    @IBOutlet weak var dayLabel: UILabel!
    
  
    @IBOutlet weak var statusSwitch: UISwitch!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func statusChanged(sender: UISwitch) {
        if let delegate = delegate {
            
            delegate.StatusChanged( atIndexPath! , objectId: objectId!, status : sender.on  ?PaymentStatus.Paid  : PaymentStatus.Pending)
        }
        

    }
 
}
