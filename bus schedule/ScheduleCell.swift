//
//  ScheduleCell.swift
//  BusSchedule
//
//  Created by admin on 3/27/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class ScheduleCell: UITableViewCell {
    
    
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var fromDate: UILabel!
    @IBOutlet weak var toDate: UILabel!
    @IBOutlet weak var price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
