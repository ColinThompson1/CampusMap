//
//  OCRCourse.swift
//  CMScheduleExt
//
//  Created by Colin Thompson on 2018-12-12.
//  Copyright © 2018 CampusMAppTeam. All rights reserved.
//

import Foundation

typealias OCRCourses = [String: OCRCourse]

struct OCRCourse: Decodable {
    let courseNum, section, courseCode: String
    
    enum CodingKeys: String, CodingKey {
        case courseNum = "CourseNum"
        case section = "Section"
        case courseCode = "CourseCode"
    }
}
