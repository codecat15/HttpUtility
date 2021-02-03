//
//  HttpUtilityIntegrationTests.swift
//  HttpUtilityTests
//
//  Created by CodeCat15 on 5/31/20.
//  Copyright © 2020 CodeCat15. All rights reserved.
//

import XCTest
@testable import HttpUtility


struct MyStruct : Encodable
{
    let name, lastName: String
}

class HttpUtilityIntegrationTests: XCTestCase {

    private typealias Employees = [EmployeeResponse]
    private let _utility = HttpUtility.shared

    func test_getApiData_With_Valid_Request_Returns_Success()
    {
        // ARRANGE
        let requestUrl = URL(string: "http://demo0333988.mockable.io/Employees")
        let expectation = XCTestExpectation(description: "Data received from server")

        _utility.request(requestUrl: requestUrl!, method: .get, resultType: Employees.self) { (response) in
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
        _utility.request(requestUrl: requestUrl!, method: .post, requestBody: registerUserBody, resultType: RegisterResponse.self) { (response) in
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
        _utility.request(requestUrl: requestUrl!, method: .get, resultType: PhoneResponse.self) { (response) in

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

    func test_putService_Returns_Success()
    {
        // ARRANGE
        let expectation = XCTestExpectation(description: "Data received from server")
        let requestUrl = URL(string: "https://httpbin.org/put")

        // ACT
        _utility.request(requestUrl: requestUrl!, method: .put, resultType: Response.self) { (response) in

            switch response
            {
            case .success(let serviceResponse):

                // ASSERT
                XCTAssertNotNil(serviceResponse)

            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()

        }

        wait(for: [expectation], timeout: 10.0)
    }

    func test_deleteService_Returns_Success()
    {
        // ARRANGE
        let expectation = XCTestExpectation(description: "Data received from server")
        let requestUrl = URL(string: "https://httpbin.org/delete")

        // ACT
        _utility.request(requestUrl: requestUrl!, method: .delete, resultType: Response.self) { (response) in

            switch response
            {
            case .success(let serviceResponse):

                // ASSERT
                XCTAssertNotNil(serviceResponse)

            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()

        }

        wait(for: [expectation], timeout: 10.0)
    }

    func test_MultiPartFormDataUpload_WithSmallRequestBody_Returns_Success()
    {
        // ARRANGE
        let expectation = XCTestExpectation(description: "Multipart form data test")
        let requestUrl = URL(string: "https://api-dev-scus-demo.azurewebsites.net/TestMultiPart")

        // request parameter structure that inherits from Encodable
        let myStruct = MyStruct(name: "Bruce", lastName: "Wayne")

        // HURequest object containing information about the type of API call with request object
        let huRequest = HURequest(url: requestUrl!, method: .post, request: myStruct)

        // ACT
        _utility.requestWithMultiPartFormData(huRequest: huRequest, responseType: TestMultiPartResponse.self) { (response) in
            switch response
            {
            case .success(let serviceResponse):

                // ASSERT
                XCTAssertNotNil(serviceResponse)
                XCTAssertNotNil(serviceResponse?.data)
                XCTAssertEqual(myStruct.name, serviceResponse?.data.name)
                XCTAssertEqual(myStruct.lastName, serviceResponse?.data.lastName)

            case .failure(let error):
                XCTAssertNil(error.reason)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func test_multiPartFormDataUpload_WithValidRequest_Returns_Success()
    {
        // ARRANGE
        let expectation = XCTestExpectation(description: "Multipart form data test")
        let requestUrl = URL(string: "https://api-dev-scus-demo.azurewebsites.net/api/Employee/MultiPartCodeChallenge")

        let multiPartFormRequest = MultiPartFormRequest(name: "Bruce", lastName: "Wayne", gender: "Male", departmentName: "Tech", managerName: "James Gordan", dateOfJoining: "01-09-2020", dateOfBirth: "07-07-1988")

        let request = HURequest(url: requestUrl!, method: .post, request: multiPartFormRequest)

        // ACT
        _utility.requestWithMultiPartFormData(huRequest: request, responseType: MultiPartResponse.self) { (response) in
            // ASSERT
            switch response
            {
            case .success(let serviceResponse):

                // ASSERT
                XCTAssertNotNil(serviceResponse)
                XCTAssertNotNil(serviceResponse?.data)

            case .failure(let error):
                XCTAssertNil(error.reason)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }
}
