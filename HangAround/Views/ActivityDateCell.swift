//
//  ActivityDateCell.swift
//  HangAround
//
//  Created by Jef Malfliet on 10/12/2019.
//  Copyright © 2019 Jef Malfliet. All rights reserved.
//

import UIKit

class ActivityDateCell: UITableViewCell {

    @IBOutlet var datepicker: UIDatePicker!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
