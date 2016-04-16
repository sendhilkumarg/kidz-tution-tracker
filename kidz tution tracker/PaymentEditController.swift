//
//  PaymentEditController.swift
//  Activity Tracker
//
//  Created by Sendhil kumar Gurunathan on 3/19/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//
//  View controller to edit the status of a payment
//

import UIKit
import CoreData

class PaymentEditController: UIViewController {

    var delegate : PaymentChangeControllerDelegate?
    var payment : Payment?
    var objectId : NSManagedObjectID?

    @IBOutlet weak var dayLabel: UILabel!

    @IBOutlet weak var updatedOnLabel: UILabel!
    @IBOutlet weak var tuitionLabel: UILabel!
    @IBOutlet weak var paymentStatusSwitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let paymentToEdit = payment{
            if let tuition = paymentToEdit.relTuition{
                self.navigationItem.title = "Edit Payment"
                tuitionLabel.text = Utils.getDisplayNameWithTime(tuition)
            }
            
            
            
            dayLabel.text = Utils.toLongDateString( paymentToEdit.date!)
            if let updatedOnDate = paymentToEdit.updatedon {
                updatedOnLabel.text = "last updated on \( Utils.toLongDateWithTimeString(updatedOnDate))"
            }
            
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
            
            delegate.StatusChanged(  objectId!, status : sender.on  ?PaymentStatus.Paid  : PaymentStatus.Pending)
        }
        
        
    }

}
