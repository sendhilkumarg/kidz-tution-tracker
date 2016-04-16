//
//  PaymentTuitionTableViewCell.swift
//  Activity Tracker
//
//  Created by Sendhil kumar Gurunathan on 2/20/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//
//  Table View cell to display the list of tutions [ Had to repeat this three times as these are used in 3 different views ]
//  [PaymentTuitionTableViewCell , AttendanceTuitionTableViewCell , TuitionsTableViewCell ]
//  This can be optimised
//

import Foundation
import UIKit

class PaymentTuitionTableViewCell: UITableViewCell {
    @IBOutlet weak var tuitionNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
}
