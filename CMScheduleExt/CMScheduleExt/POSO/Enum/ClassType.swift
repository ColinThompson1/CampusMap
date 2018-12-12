//
//  ClassType.swift
//  CMScheduleExt
//
//  Created by Colin Thompson on 2018-12-12.
//  Copyright © 2018 CampusMAppTeam. All rights reserved.
//

import Foundation

enum ClassType: String, Decodable {
    case lab = "Lab"
    case lecture = "Lecture"
    case seminar = "Seminar"
    case tutorial = "Tutorial"
}
