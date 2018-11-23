//
//  CourseData.swift
//  CMScheduleExt
//
//  Created by Zach Albers on 11/22/18.
//  Copyright © 2018 CampusMAppTeam. All rights reserved.
//

import Foundation


class CourseData {
    

    func getData() -> [String:JSON] {
        var courses:JSON? = nil
        if let path = Bundle.main.path(forResource: "courseData", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                courses = try JSON(data: data)
//                print("jsonData:\(courses)")
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
        
        
        var dic = [String:JSON]()
        
        for (_,course) in courses!["courses"] {
            dic["\(course["subject"]) \(course["number"])"] = course
        }
        
        return dic
        
    }

}
