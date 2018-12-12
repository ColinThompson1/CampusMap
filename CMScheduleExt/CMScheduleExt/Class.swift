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
    var type: String
    var semester: String
    var days: [String: String]
    
    init? (name: String, type: String,  semester: String, days: [String:String]){
        
        if name.isEmpty {
            return nil
        }
        
        self.name = name
        self.type = type
        self.semester = semester
        self.days = days
    }
    
    public func getStartTime(_ day: String) -> String{
        let time = days[day]
        let timeSplitter = time?.components(separatedBy: " - ")
        
        return (timeSplitter?[0])!
    }
    
    public func getEndTime(_ day: String) -> String{
        let time = days[day]
        let timeSplitter = time?.components(separatedBy: " - ")
        
        return (timeSplitter?[1])!
    }
}
