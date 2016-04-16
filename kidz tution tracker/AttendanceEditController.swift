//
//  AttendanceEditController.swift
//  Activity Tracker
//
//  Created by Sendhil kumar Gurunathan on 3/19/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//
//  View controller to edit the status of a payment
//

import UIKit
import CoreData

class AttendanceEditController: UIViewController 
{

    var attendance : Attendance?
    var delegate : AttendanceChangeControllerDelegate?
    var objectId : NSManagedObjectID?
    
    @IBOutlet weak var tuitionLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var attendanceSegemnt: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let attendanceToEdit = attendance {
            if let tuition = attendanceToEdit.relTuition{
                self.navigationItem.title = "Edit Attendance"
                tuitionLabel.text = Utils.getDisplayNameWithTime(tuition)
            }
            dayLabel.text = Utils.toLongDateString( attendanceToEdit.date!)
            
            attendanceSegemnt.selected = false ;
            attendanceSegemnt.selectedSegmentIndex = -1
            if let _ = attendanceToEdit.status  {
                switch attendanceToEdit.CurrentStatus
                {
                case AttendanceStatus.Pending :
                    attendanceSegemnt.selected = false ;
                    break
                    
                case AttendanceStatus.Attended :
                    attendanceSegemnt.selectedSegmentIndex = 0
                    break
                case AttendanceStatus.Absent :
                    attendanceSegemnt.selectedSegmentIndex = 1
                    break
                    
                }
                
            }
            
        }
    }
    
    @IBAction func statusChanged(sender: UISegmentedControl) {
        
        if let _ = attendance{
        
            if let delegate = delegate{
                
                delegate.StatusChanged(  objectId!, status : sender.selectedSegmentIndex == 0 ?AttendanceStatus.Attended  : AttendanceStatus.Absent)
            }
        }
    }
    
}
