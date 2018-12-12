//
//  TimePeriod.swift
//  CMScheduleExt
//
//  Created by Colin Thompson on 2018-12-12.
//  Copyright © 2018 CampusMAppTeam. All rights reserved.
//

import Foundation

struct TimePeriod: Decodable {
    let date: String
    let day: Day
    let time: String
}
