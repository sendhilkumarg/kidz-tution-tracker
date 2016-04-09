//
//  PaymentEditController.swift
//  kidz tuition tracker
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

    @IBOutlet weak var tuitionLabel: UILabel!
    @IBOutlet weak var paymentStatusSwitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let paymentToEdit = payment{
            if let tuition = paymentToEdit.relTuition{
                var header = ""
                if let name = tuition.name {
                    if let personName = tuition.personname {
                        header = "\(personName)'s \(name)"
                    }
                    else{
                        header = name
                        
                    }
                    
                }
                
                if let  time = tuition.time  {
                    header = header + " " + Utils.ToTimeFromString(time)
                }
                self.navigationItem.title = "Edit Payment"
                tuitionLabel.text = header
            }
            
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
            
            delegate.StatusChanged(  objectId!, status : sender.on  ?PaymentStatus.Paid  : PaymentStatus.Pending)
        }
        
        
    }

}
