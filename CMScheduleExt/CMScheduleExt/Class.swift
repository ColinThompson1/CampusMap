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
    var semester: [String:String]
    var days: [String: String]
    var room: String
    
    let dateFormatter = DateFormatter()
    
    init? (name: String, type: String,  semester: [String:String], days: [String:String], room: String){
        
        if name.isEmpty {
            return nil
        }
        
        self.name = name
        self.type = type
        self.semester = semester
        self.days = days
        self.room = room
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
    
    public func getStartDate(_ day: String) -> Date{
        
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dayString = semester[day]
        let timeSplitter = dayString?.components(separatedBy: " - ")
        
        return dateFormatter.date(from:(timeSplitter?[0])!)!
    }
    
    public func getEndDate(_ day: String) -> Date{
        
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dayString = semester[day]
        let timeSplitter = dayString?.components(separatedBy: " - ")
        
        return dateFormatter.date(from:(timeSplitter?[1])!)!
    }
}
