//
//  RestServiceIT.swift
//  CMScheduleExtTests
//
//  Created by Colin Thompson on 2018-12-11.
//  Copyright © 2018 CampusMAppTeam. All rights reserved.
//

import XCTest
import PromiseKit
@testable import CMScheduleExt


class RestServiceIT: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testgivenPath_willGetCourseData() {
        let exp = expectation(description: "get course data")
        _ = RestService.shared.get(path: "/courses/2187", params: [:], resultType: Semester.self).done { (test: Semester) in
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 25, handler: nil)
    }
    
    func testgivenPathAndImage_willUploadImageAndReceveCourses() {
        let exp = expectation(description: "get course data")
        let bundle = Bundle(for: type(of: self))
        guard let pathToImage = bundle.path(forResource: "test_schedule", ofType: "PNG") else {
            print("could not get image path")
            return
        }
        guard let img = UIImage(contentsOfFile: pathToImage) else {
            print("Could not get image from path")
            return
        }
        _ = RestService.shared.postPNG(path: "", params: [:], image: img, responseType: OCRCourses.self).done { (courses: OCRCourses) in
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 30, handler: nil)
    }

}
