//
//  TutionsTableViewCell.swift
//  kidz tution tracker
//
//  Created by Sendhil kumar Gurunathan on 1/16/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//
//  Table View cell to display the list of tutions [ Had to repeat this three times as these are used in 3 different views ]
//  [PaymentTuitionTableViewCell , AttendanceTuitionTableViewCell , TuitionsTableViewCell ]
//  This can be optimised
//

import UIKit

class TuitionsTableViewCell: UITableViewCell {
    @IBOutlet weak var tuitionNameLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!


}
