//
//  PendingAttendanceCell.swift
//  kidz tuition tracker
//
//  Created by Sendhil kumar Gurunathan on 2/8/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//

import UIKit
import CoreData
class PendingAttendanceCell: UITableViewCell {
    var delegate : AttendanceChangeControllerDelegate?
    var atIndexPath : NSIndexPath?
    var objectId : NSManagedObjectID?
    @IBOutlet weak var dayLabel: UILabel!

    @IBOutlet weak var attendanceSegemnt: UISegmentedControl!
    
    
    @IBAction func statusChanged(sender: UISegmentedControl) {
        if let delegate = delegate {
           
            delegate.StatusChanged( atIndexPath! , objectId: objectId!, status : sender.selectedSegmentIndex == 0 ?AttendanceStatus.Attended  : AttendanceStatus.Absent)
        }

    }
    

}
