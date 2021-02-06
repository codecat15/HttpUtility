//
//  EmployeeResponse.swift
//  HttpUtilityTests
//
//  Created by CodeCat15 on 5/31/20.
//  Copyright © 2020 CodeCat15. All rights reserved.
//

import Foundation

// MARK: - EmployeeResponse
struct EmployeeResponse: Decodable {
    let id: Int?
    let name, role, joiningDate: String?
    let depID, salary: Int?
    let workPhone: String?

    enum CodingKeys: String, CodingKey {
        case id, name, role
        case joiningDate = "joining_date"
        case depID = "dep_id"
        case salary, workPhone
    }
}

// MARK: - RegisterResponse
struct RegisterResponse: Codable {
    let errorMessage: String?
    let data: EmployeeRegisterResponse?
}

// MARK: - EmployeeRegisterResponse
struct EmployeeRegisterResponse: Codable {
    let name, email, id, joining: String?
}

// MARK: - PhoneResponse
struct PhoneResponse: Decodable {
    let errorMessage: String?
    let data: [Phone]?
}

// MARK: - Phone
struct Phone: Decodable {
    let name, operatingSystem, manufacturer, color: String?
}

// MARK: - DataClass
struct TestMultiPartResponse: Decodable {
    let errorMessage: String
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Decodable {
    let name, lastName: String
}

// MARK: - MultiPartResponse
struct MultiPartResponse: Decodable {
    let errorMessage: String?
    let data: MultipartMessage?
}

// MARK: - MultipartMessage
struct MultipartMessage: Decodable {
    let message: String?
}

// MARK: - Employee
struct Response: Decodable {
    let args: Args?
    let data: String?
    let files, form: Args?
    let headers: Headers?
    let employeeJSON, origin: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case args, data, files, form, headers
        case employeeJSON
        case origin, url
    }
}

// MARK: - Args
struct Args: Decodable {
}

// MARK: - Headers
struct Headers: Decodable {
    let accept, acceptEncoding, acceptLanguage, contentLength: String?
    let host: String?
    let origin, referer: String?
    let secFetchDest, secFetchMode, secFetchSite, userAgent: String?
    let xAmznTraceID: String?

    enum CodingKeys: String, CodingKey {
        case accept
        case acceptEncoding
        case acceptLanguage
        case contentLength
        case host
        case origin
        case referer
        case secFetchDest
        case secFetchMode
        case secFetchSite
        case userAgent
        case xAmznTraceID
    }
}

// MARK: - Multipart image upload model
struct MultiPartImageUploadResponse : Decodable {
    let path : String
}
