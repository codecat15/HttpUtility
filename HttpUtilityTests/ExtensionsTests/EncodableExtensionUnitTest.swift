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

    private let exampleUrl = "https://www.example.com"

    func test_convertToQueryStringUrl_With_SimpleStructure_Returuns_QueryStringUrl()
    {
        // ARRANGE
        struct Simple : Encodable {let name, description: String}
        let objSimple = Simple(name: UUID().uuidString, description: UUID().uuidString)

        // ACT
        let result = objSimple.convertToQueryStringUrl(urlString: exampleUrl)!

        // ASSERT
        XCTAssertNotNil(result)
    }

    func test_convertToQueryStringUrl_With_IntegerValue_Returuns_QueryStringUrl()
    {
        // ARRANGE
        struct simple : Encodable {
            let id: Int
            let name: String

        }
        let objSimple = simple(id: 1, name: UUID().uuidString)

        // ACT
        let result = objSimple.convertToQueryStringUrl(urlString: exampleUrl)

        // ASSERT
        XCTAssertNotNil(result)
        XCTAssertTrue(result!.absoluteString.contains("name=\(objSimple.name)"))
        XCTAssertTrue(result!.absoluteString.contains("id=\(objSimple.id)"))

    }

    //todo: need to test arrays
    func test_convertToQueryStringUrl_With_array_Returuns_QueryStringUrl()
    {
        // ARRANGE
        struct simple : Encodable {
            let id: [Int]
            let name: String

        }
        let objSimple = simple(id: [1,2,3], name: UUID().uuidString)

        // ACT
        let result = objSimple.convertToQueryStringUrl(urlString: exampleUrl)

        // ASSERT
        XCTAssertNotNil(result)
        XCTAssertTrue(result!.absoluteString.contains("name=\(objSimple.name)"))
    }

    func test_convertToQueryStringUrl_With_Multiple_DataType_Returuns_QueryStringUrl()
    {
        // ARRANGE
        struct simple : Encodable {
            let id: Int
            let name: String
            let salary: Double
            let isOnContract: Bool
        }

        let objSimple = simple(id: 1, name: "codecat15", salary: 25000.0, isOnContract: false)

        // ACT
        let result = objSimple.convertToQueryStringUrl(urlString: exampleUrl)

        // ASSERT
        XCTAssertNotNil(result)
        XCTAssertTrue(result!.absoluteString.contains("name=\(objSimple.name)"))
        XCTAssertTrue(result!.absoluteString.contains("id=\(objSimple.id)"))
        XCTAssertTrue(result!.absoluteString.contains("salary=25000"))
        XCTAssertTrue(result!.absoluteString.contains("isOnContract=0"))
    }
}
