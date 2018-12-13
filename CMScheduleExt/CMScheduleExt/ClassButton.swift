//
//  ClassButton.swift
//  CMScheduleExt
//
//  Created by Kevin Vo on 2018-12-11.
//  Copyright © 2018 CampusMAppTeam. All rights reserved.
//
// A quick implementation to put values into a button

import Foundation
import UIKit

class ClassButton: UIButton {
    
    var type: ClassType
    var section: String
    var periods: [TimePeriod]
    var room: String
    
    override init(frame: CGRect) {
        self.type = ClassType.lab
        self.section = ""
        self.periods = []
        self.room = ""
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.type = ClassType.lab
        self.section = ""
        self.periods = []
        self.room = ""
        super.init(coder: aDecoder)
    }
}
