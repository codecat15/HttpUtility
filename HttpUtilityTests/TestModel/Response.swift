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

// MARK: - MultiPartResponse
struct MultiPartResponse: Decodable {
    let errorMessage: String?
    let data: MultipartMessage?
}

// MARK: - MultipartMessage
struct MultipartMessage: Decodable {
    let message: String?
}
