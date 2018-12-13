//
//  ClassTableViewCell.swift
//  CMScheduleExt
//
//  Created by Zach Albers on 11/22/18.
//  Copyright © 2018 CampusMAppTeam. All rights reserved.
//

import UIKit

class ClassTableViewCell: UITableViewCell {

    @IBOutlet weak var courseName: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
