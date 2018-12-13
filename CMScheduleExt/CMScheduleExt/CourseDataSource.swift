//
//  CourseDataSource.swift
//  CMScheduleExt
//
//  Created by Colin Thompson on 2018-12-11.
//  Copyright © 2018 CampusMAppTeam. All rights reserved.
//

import PromiseKit
import Foundation

class CourseDataSource {
    
    static let shared = CourseDataSource()
    
    private var courses: [Int : [String : Course]] = [:]
    
    private init() {}
    
    
    func getCourses(semesterID: Int) -> Promise<[String : Course]> {
        // If we already got the data, use that.
        if (hasLoaded(semesterID: semesterID)) {
            return Promise<[String : Course]> { seal in
                seal.fulfill(courses[semesterID]!)
            }
        } else { // Otherwise get it
            return RestService.shared.get(path: "/courses/\(semesterID)", params: [:], resultType: Semester.self)
                .compactMap({ (s: Semester) -> [String : Course] in
                    self.courses[semesterID] = s.courses
                    return s.courses
                })
        }
    }
    
    func hasLoaded(semesterID: Int) -> Bool {
        return courses[semesterID] != nil
    }
    
    func convertAll(cs: OCRCourses, semesterID: Int) -> Promise<[Class?]> {
        return getCourses(semesterID: semesterID).compactMap { (formalCourses: [String : Course]) -> [Class?] in
            var converted = [Class?]()
            for c in cs.values {
                converted.append(
                    CourseDataSource.convert(ocrCourse: c, formalCourses: formalCourses)
                )
            }
            return converted
        }
    }
    
    static func convert(ocrCourse: OCRCourse, formalCourses: [String : Course]) -> Class? {
        let tag = "\(ocrCourse.courseCode) \(ocrCourse.courseNum)"
        
        guard let formalCourse: Course = formalCourses[tag] else {
            print("Could not find course from ocr")
            return Optional.none
        }
        
        let letter = ocrCourse.section.replacingOccurrences(of: "[0-9]", with: "", options: [.regularExpression])
        
        let number = String(ocrCourse.section.split(separator: "T")[0])
        
        var type: ClassType
        switch letter {
            case "T":
                type = ClassType.tutorial
            case "B":
                type = ClassType.lab
            default:
                //todo add Seminar to here and ocr
                type = ClassType.lecture
        }
        
        guard let periodic = formalCourse.periodics["\(type.rawValue) \(number)"] else {
            print("Could not find periodic from ocr")
            return Optional.none
        }
        
        var days: [String : String] = [:]
        var semesters: [String : String] = [:]
        for tp: TimePeriod in periodic.timePeriods {
            days[tp.day.rawValue] = tp.time
            semesters[tp.day.rawValue] = tp.date
        }
        
        return Class(name: tag, type: "\(type.rawValue) \(number)", semester: semesters, days: days, room: periodic.room)
    }
}
