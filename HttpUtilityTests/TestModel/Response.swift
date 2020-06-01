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

// MARK: - RegisterUserRequest
struct RegisterUserRequest: Encodable
{
    let firstName, lastName, email, password: String

    enum CodingKeys: String, CodingKey {
        case firstName = "First_Name"
        case lastName = "Last_Name"
        case email = "Email"
        case password = "Password"
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
