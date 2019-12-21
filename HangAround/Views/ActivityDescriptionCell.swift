//
//  ActivityDescriptionCell.swift
//  HangAround
//
//  Created by Jef Malfliet on 12/12/2019.
//  Copyright © 2019 Jef Malfliet. All rights reserved.
//

import UIKit

class ActivityDescriptionCell: UITableViewCell {

    @IBOutlet var textviewDescription: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
