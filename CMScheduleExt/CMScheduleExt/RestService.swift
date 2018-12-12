//
//  RestService.swift
//  CMScheduleExt
//
//  Created by Zach Albers on 12/5/18.
//  Copyright © 2018 CampusMAppTeam. All rights reserved.
//

import Foundation


class RestService {
    
    let APIURL = "http://ec2-35-183-144-123.ca-central-1.compute.amazonaws.com/"
    
    private func get(path: String, success: @escaping (Data) -> Void, failure: @escaping (Error) -> Void) {
        let url = URL(string: APIURL + path)!
        let task = URLSession.shared.dataTask(with: url) { (data, res, err) in
            guard let data = data else {
                failure(err!)
                return
            }
            success(data)
            print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
    
    func getCourse(courseId: Int, success: @escaping (Any) -> Void, failure: @escaping (String) -> Void) {
        get(path: "courses/\(courseId)", success: {(data) in
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            success(json!)
        }, failure: {(err) in
            failure(err.localizedDescription)
        })
    }
    
    
    
    
    
    
}
