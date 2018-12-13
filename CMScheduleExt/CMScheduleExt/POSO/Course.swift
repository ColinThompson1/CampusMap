//
//  Course.swift
//  CMScheduleExt
//
//  Created by Colin Thompson on 2018-12-12.
//  Copyright © 2018 CampusMAppTeam. All rights reserved.
//

import Foundation

struct Course: Decodable {
    let description: String
    let periodics: [String: Periodic]
    let number, subject: String
}
