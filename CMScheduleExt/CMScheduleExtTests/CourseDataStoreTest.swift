//
//  CourseDataStoreTest.swift
//  CMScheduleExtTests
//
//  Created by Colin Thompson on 2018-12-12.
//  Copyright © 2018 CampusMAppTeam. All rights reserved.
//

import XCTest
import PromiseKit
@testable import CMScheduleExt

class CourseDataStoreTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testOCRConversion_shouldConvertToFormalCourses() {
        OCRCourses(dictionaryLiteral: ("asd", OCRCourse(courseNum: "123", section: "adsf", courseCode: "asdf")), ("asdf", OCRCourse(courseNum: "123", section: "adsf", courseCode: "asdf")))
        //tbd
    }

}
