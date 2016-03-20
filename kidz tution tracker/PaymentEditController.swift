//
//  PaymentEditController.swift
//  kidz tuition tracker
//
//  Created by Sendhil kumar Gurunathan on 3/19/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//

import UIKit
import CoreData

class PaymentEditController: UIViewController {

    var delegate : PaymentChangeControllerDelegate?
    var payment : Payment?
    @IBOutlet weak var dayLabel: UILabel!
    var atIndexPath : NSIndexPath?
    var objectId : NSManagedObjectID?

    @IBOutlet weak var paymentStatusSwitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let paymentToEdit = payment{
            dayLabel.text = Utils.ToLongDateString( paymentToEdit.date!)
            
            if let _ = paymentToEdit.status  {
                switch paymentToEdit.CurrentStatus
                {
                case PaymentStatus.Pending :
                    paymentStatusSwitch.on = false ;
                    break
                    
                case PaymentStatus.Paid :
                    paymentStatusSwitch.on = true ;
                    break
                    
                }
                
            }
            

        }
    }
    @IBAction func statusChanged(sender: UISwitch) {
        if let delegate = delegate {
            
            delegate.StatusChanged( atIndexPath! , objectId: objectId!, status : sender.on  ?PaymentStatus.Paid  : PaymentStatus.Pending)
        }
        
        
    }

}
