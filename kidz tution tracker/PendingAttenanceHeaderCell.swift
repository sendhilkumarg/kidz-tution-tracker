//
//  PendingAttenanceHeaderCell.swift
//  kidz tuition tracker
//
//  Created by Sendhil kumar Gurunathan on 2/11/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//

import UIKit

class PendingAttenanceHeaderCell: UITableViewCell {

    @IBOutlet weak var tuitionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
