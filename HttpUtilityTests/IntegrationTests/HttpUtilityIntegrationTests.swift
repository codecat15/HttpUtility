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

    func test_getApiData_With_Valid_Request_Returns_Success()
    {
        // ARRANGE
        let requestUrl = URL(string: "http://demo0333988.mockable.io/Employees")
        let expectation = XCTestExpectation(description: "Data received from server")

        // ACT
        _utility.getData(requestUrl: requestUrl!, resultType: Employees.self) { (response) in

            switch response
            {
            case .success(let employee):

                // ASSERT
                XCTAssertNotNil(employee)
                XCTAssertTrue(employee?.count == 2)

            case .failure(let error):

                // ASSERT
                XCTAssertNil(error)
            }

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
        _utility.postData(requestUrl: requestUrl!, requestBody: registerUserBody, resultType: RegisterResponse.self) { (response) in
            switch response
            {
            case .success(let registerResponse):

                // ASSERT
                XCTAssertNotNil(registerResponse)

            case .failure(let error):

                // ASSERT
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func test_getApiData_WithQueryItem_Returns_Collection()
    {
        // ARRANGE
        let expectation = XCTestExpectation(description: "Data received from server")
        let request = PhoneRequest(color: "Red", manufacturer: nil)
        let requestUrl = request.convertToQueryStringUrl(urlString:"https://api-dev-scus-demo.azurewebsites.net/api/Product/GetSmartPhone")

        // ACT
        _utility.getData(requestUrl: requestUrl!, resultType: PhoneResponse.self) { (response) in

            switch response
            {
            case .success(let phoneResponse):

                // ASSERT
                XCTAssertNotNil(phoneResponse)
                phoneResponse?.data?.forEach({ (phone) in
                    XCTAssertEqual(request.color,phone.color)
                })

            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()

        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}
