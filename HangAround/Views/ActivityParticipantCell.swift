//
//  ActivityParticipantCell.swift
//  HangAround
//
//  Created by Jef Malfliet on 12/12/2019.
//  Copyright © 2019 Jef Malfliet. All rights reserved.
//

import UIKit

class ActivityParticipantCell: UITableViewCell {

    @IBOutlet var labelName: UILabel!
    @IBOutlet var labelRole: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
