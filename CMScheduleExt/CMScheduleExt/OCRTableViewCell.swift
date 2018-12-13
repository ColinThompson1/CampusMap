//
//  OCRTableViewCell.swift
//  CMScheduleExt
//
//  Created by Zach Albers on 12/12/18.
//  Copyright © 2018 CampusMAppTeam. All rights reserved.
//

import UIKit

class OCRTableViewCell: UITableViewCell {

    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var courseInfo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
