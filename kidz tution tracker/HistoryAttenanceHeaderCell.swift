//
//  HistoryAttenanceHeaderCell.swift
//  kidz tuition tracker
//
//  Created by Sendhil kumar Gurunathan on 2/13/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//

import UIKit

class HistoryAttenanceHeaderCell: UITableViewCell {

    @IBOutlet weak var dayHeaderLabel: UIStackView!
    @IBOutlet weak var statusLabel: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
