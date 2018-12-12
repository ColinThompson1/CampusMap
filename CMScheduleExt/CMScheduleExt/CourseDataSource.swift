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
    
    func convertAll(cs: OCRCourses, semesterID: Int) -> Promise<[Course?]> {
        return getCourses(semesterID: semesterID).compactMap { (formalCourses: [String : Course]) -> [Course?] in
            var converted = [Course?]()
            for c in cs.values {
                converted.append(
                    CourseDataSource.convert(ocrCourse: c, formalCourses: formalCourses)
                )
            }
            return converted
        }
    }
    
    static func convert(ocrCourse: OCRCourse, formalCourses: [String : Course]) -> Course? {
        let tag = "\(ocrCourse.courseCode) \(ocrCourse.courseNum)"
        return formalCourses[tag]
    }
}
