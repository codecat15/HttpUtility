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

    func test_convertToQueryStringUrl_With_SimpleStructure_Returuns_URLQueryItemCollection()
    {
        // ARRANGE
        struct Simple : Encodable {let name, description: String}
        let objSimple = Simple(name: UUID().uuidString, description: UUID().uuidString)

        // ACT
        let result = objSimple.convertToQueryStringUrl(urlString: exampleUrl)!

        // ASSERT
        XCTAssertNotNil(result)
    }

    func test_convertToQueryStringUrl_With_IntegerValue_Returuns_URLQueryItemCollection()
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
    }

    func test_convertToQueryStringUrl_With_array_Returuns_URLQueryItemCollection()
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
    }

    func test_convertToQueryStringUrl_With_Multiple_DataType_Returuns_URLQueryItemCollection()
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
    }

    // MARK: - convert to multipart form data
    //todo: need to write more solid test
    func test_convertToMultiPartFormData_Returns_Valid_MultiFormData()
    {
        // ARRANGE
        let request = MultiPartFormRequest(name: UUID().uuidString, lastName: UUID().uuidString, dateOfJoining: UUID().uuidString, dateOfBirth: UUID().uuidString, gender: UUID().uuidString, departmentName: UUID().uuidString, managerName: UUID().uuidString)

         let boundary = "---------------------------------\(UUID().uuidString)"

        // ACT
        let formData = request.convertToMultiPartFormData(boundary: boundary)

        // ASSERT
        XCTAssertNotNil(formData)
    }
}
