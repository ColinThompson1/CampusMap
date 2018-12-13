//
//  Periodic.swift
//  CMScheduleExt
//
//  Created by Colin Thompson on 2018-12-12.
//  Copyright © 2018 CampusMAppTeam. All rights reserved.
//

import Foundation

struct Periodic: Decodable {
    let group, name: String
    let timePeriods: [TimePeriod]
    let topic, instructor: String
    let type: ClassType
    let room: String
    
    enum CodingKeys: String, CodingKey {
        case group, name
        case timePeriods = "time-periods"
        case topic, instructor, type, room
    }
}
