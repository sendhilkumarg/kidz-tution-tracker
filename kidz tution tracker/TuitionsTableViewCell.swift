//
//  TutionsTableViewCell.swift
//  kidz tution tracker
//
//  Created by Sendhil kumar Gurunathan on 1/16/16.
//  Copyright © 2016 Sendhil kumar Gurunathan. All rights reserved.
//

import UIKit

class TuitionsTableViewCell: UITableViewCell {

  //  @IBOutlet weak var lblTutionName: UILabel!
  
    
    @IBOutlet weak var tuitionNameLabel: UILabel!
    
    @IBOutlet weak var daysLabel: UILabel!
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
