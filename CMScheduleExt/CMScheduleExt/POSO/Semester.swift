//
//  Semester.swift
//  CMScheduleExt
//
//  Created by Colin Thompson on 2018-12-12.
//  Copyright © 2018 CampusMAppTeam. All rights reserved.
//

import Foundation

struct Semester: Decodable {
    let courses: [String: Course]
    let semester, version: String
}
