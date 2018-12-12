//
//  EventsTableViewCell.swift
//  CMScheduleExt
//
//  Created by Xian-Meng Low on 2018-12-11.
//  Copyright © 2018 CampusMAppTeam. All rights reserved.
//

import UIKit

class EventsTableViewCell: UITableViewCell {

    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var room: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
