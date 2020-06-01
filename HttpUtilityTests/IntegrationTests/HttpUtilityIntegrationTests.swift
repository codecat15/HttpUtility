//
//  HttpUtilityIntegrationTests.swift
//  HttpUtilityTests
//
//  Created by CodeCat15 on 5/31/20.
//  Copyright © 2020 CodeCat15. All rights reserved.
//

import XCTest
@testable import HttpUtility

class HttpUtilityIntegrationTests: XCTestCase {

    private typealias Employees = [EmployeeResponse]
    private let _utility = HttpUtility()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_getApiData_With_Valid_Request_Returns_Success()
    {
        // ARRANGE
        let requestUrl = URL(string: "http://demo0333988.mockable.io/Employees")
        let expectation = XCTestExpectation(description: "Data received from server")

        // ACT
        _utility.getApiData(requestUrl: requestUrl!, resultType: Employees.self) { (response) in

            // ASSERT
            XCTAssertNotNil(response)
            XCTAssertTrue(response?.count == 2)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func test_postApiData_With_Valid_Request_Returns_Success()
    {
        // ARRANGE
        let requestUrl = URL(string: "https://api-dev-scus-demo.azurewebsites.net/api/User/RegisterUser")
        let registerUserRequest = RegisterUserRequest(firstName: "code", lastName: "cat15", email: "codecat15@gmail.com", password: "1234")
        let registerUserBody = try! JSONEncoder().encode(registerUserRequest)
        let expectation = XCTestExpectation(description: "Data received from server")
        // ACT
        _utility.postApiData(requestUrl: requestUrl!, requestBody: registerUserBody, resultType: RegisterResponse.self) { (response) in
            XCTAssertNotNil(response)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
