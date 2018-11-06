//
//  Class.swift
//  ScheduleBuilder
//
//  Created by Xian-Meng Low on 2018-11-01.
//  Copyright © 2018 Xian-Meng Low. All rights reserved.
//

import UIKit

class Class{
    
    var name: String
    var section : Int
    var startTime: String
    var endTime: String
    var semester: String
    var days: [String]
    
    init? (name: String, section: Int, startTime: String, endTime: String, semester: String, days: [String]){
        
        if name.isEmpty {
            return nil
        }
        
        self.name = name
        self.section = section
        self.startTime = startTime
        self.endTime = endTime
        self.semester = semester
        self.days = days
    }
}
