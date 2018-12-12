//
//  Class.swift
//  ScheduleBuilder
//
//  Created by Xian-Meng Low on 2018-11-01.
//  Copyright © 2018 Xian-Meng Low. All rights reserved.
//

import UIKit
import os.log

class Class: NSObject, NSCoding{
    
    //MARK: Properties
    
    var name: String
    var type: String
    var semester: [String:String]
    var days: [String: String]
    var room: String
    
    let dateFormatter = DateFormatter()
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("classes")
    
    //MARK: Types
    
    struct PropertyKey{
        static let name = "name"
        static let type = "type"
        static let semester = "semester"
        static let days = "days"
        static let room = "room"
    }
    
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
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(type, forKey: PropertyKey.type)
        aCoder.encode(semester, forKey: PropertyKey.semester)
        aCoder.encode(days, forKey: PropertyKey.days)
        aCoder.encode(room, forKey: PropertyKey.room)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Class object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let type = aDecoder.decodeObject(forKey: PropertyKey.type) as! String
        
        let semester = aDecoder.decodeObject(forKey: PropertyKey.semester) as! [String:String]
        
        let days = aDecoder.decodeObject(forKey: PropertyKey.days) as! [String:String]
        
        let room = aDecoder.decodeObject(forKey: PropertyKey.room) as! String
        
        self.init(name: name, type: type, semester: semester, days: days, room: room)
        
    }
}
