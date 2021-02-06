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
        let request = HURequest(url: requestUrl!, method: .get)

        _utility.request(huRequest: request, resultType: Employees.self) { (response) in
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

        let request = HURequest(url: requestUrl!, method: .post, requestBody: registerUserBody)

        // ACT
        _utility.request(huRequest: request, resultType: RegisterResponse.self) { (response) in
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
        let huRequest = HURequest(url: requestUrl!, method: .get)

        // ACT
        _utility.request(huRequest: huRequest, resultType: PhoneResponse.self) { (response) in

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
        let huRequest = HURequest(url: requestUrl!, method: .put)

        // ACT
        _utility.request(huRequest: huRequest, resultType: Response.self) { (response) in

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
        let huRequest = HURequest(url: requestUrl!, method: .delete)

        // ACT
        _utility.request(huRequest: huRequest, resultType: Response.self) { (response) in

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

    func test_requestWithMultiPartFormData_WithSmallRequestBody_Returns_Success()
    {
        // ARRANGE
        let expectation = XCTestExpectation(description: "Multipart form data test")
        let requestUrl = URL(string: "https://api-dev-scus-demo.azurewebsites.net/TestMultiPart")

        let myStruct = MyStruct(name: "Bruce", lastName: "Wayne")
        let multiPartRequest = HUMultiPartRequest(url: requestUrl!, method: .post, request: myStruct)
        
        // ACT
        _utility.requestWithMultiPartFormData(multiPartRequest: multiPartRequest, responseType: TestMultiPartResponse.self) { (response) in
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

    func test_requestWithMultiPartFormData_WithValidRequest_Returns_Success()
    {
        // ARRANGE
        let expectation = XCTestExpectation(description: "Multipart form data test")
        let requestUrl = URL(string: "https://api-dev-scus-demo.azurewebsites.net/api/Employee/MultiPartCodeChallenge")

        let multiPartFormRequest = MultiPartFormRequest(name: "Bruce", lastName: "Wayne", gender: "Male", departmentName: "Tech", managerName: "James Gordan", dateOfJoining: "01-09-2020", dateOfBirth: "07-07-1988")

        let multiPartRequest = HUMultiPartRequest(url: requestUrl!, method: .post, request: multiPartFormRequest)

        // ACT
        _utility.requestWithMultiPartFormData(multiPartRequest: multiPartRequest, responseType: MultiPartResponse.self) { (response) in
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

    func test_requestWithMultiPartFormData_WithMediaImage_Returns_Success()
    {
        // ARRANGE
        let expectation = XCTestExpectation(description: "Multipart form data test media upload")
        let requestUrl = URL(string: "https://api-dev-scus-demo.azurewebsites.net/api/Image/UploadImageMultiPartForm")
        let testImageFile = Bundle(for: type(of: self)).path(forResource: "batman", ofType: ".jpg")
        let imageData = UIImage(contentsOfFile: testImageFile!)?.jpegData(compressionQuality: 0.7)

        let fileUploadRequest = MultiPartFormFileUploadRequest(attachment: imageData!, fileName: "utilityTest")

        let multiPartRequest = HUMultiPartRequest(url: requestUrl!, method: .post, request: fileUploadRequest)

        // ACT
        _utility.requestWithMultiPartFormData(multiPartRequest: multiPartRequest, responseType: MultiPartImageUploadResponse.self) { (response) in
            // ASSERT
            switch response
            {
            case .success(let serviceResponse):

                // ASSERT
                XCTAssertNotNil(serviceResponse)
                XCTAssertNotNil(serviceResponse?.path)

            case .failure(let error):
                XCTAssertNil(error.reason)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }
}
