//
//  EncodableExtensionUnitTest.swift
//  HttpUtilityTests
//
//  Created by CodeCat15 on 5/31/20.
//  Copyright © 2020 CodeCat15. All rights reserved.
//

import XCTest
@testable import HttpUtility

class EncodableExtensionUnitTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_convertToURLQueryItems_With_SimpleStructure_Returuns_URLQueryItemCollection()
    {
        // ARRANGE
        struct Simple : Encodable {let name, description: String}
        let objSimple = Simple(name: UUID().uuidString, description: UUID().uuidString)

        // ACT
        let result = objSimple.convertToURLQueryItems()

        // ASSERT
        XCTAssertNotNil(result)
        XCTAssertTrue(result?.count == 2)
    }

    func test_convertToURLQueryItems_With_IntegerValue_Returuns_URLQueryItemCollection()
    {
        // ARRANGE
        struct simple : Encodable {
            let id: Int
            let name: String

        }
        let objSimple = simple(id: 1, name: UUID().uuidString)

        // ACT
        let result = objSimple.convertToURLQueryItems()

        // ASSERT
        XCTAssertNotNil(result)
        XCTAssertTrue(result?.count == 2)
    }

    func test_convertToURLQueryItems_With_array_Returuns_URLQueryItemCollection()
    {
        // ARRANGE
        struct simple : Encodable {
            let id: [Int]
            let name: String

        }
        let objSimple = simple(id: [1,2,3], name: UUID().uuidString)

        // ACT
        let result = objSimple.convertToURLQueryItems()

        // ASSERT
        XCTAssertNotNil(result)
        XCTAssertTrue(result?.count == 2)
    }

    func test_convertToURLQueryItems_With_Multiple_DataType_Returuns_URLQueryItemCollection()
    {
        // ARRANGE
        struct simple : Encodable {
            let id: Int
            let name: String
            let salary: Double
            let isOnContract: Bool
        }

        let objSimple = simple(id: 1, name: "codecat15", salary: 25000.0, isOnContract: false)
        var components = URLComponents(string: "https://www.example.com")
       // let expectedQueryString = "https://www.example.com?id=1&name=codecat15&salary=25000&isOnContract=0"

        // ACT
        let result = objSimple.convertToURLQueryItems()
        components?.queryItems = result

        // ASSERT
        XCTAssertNotNil(result)
        XCTAssertTrue(result?.count == 4)
    }
    

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
