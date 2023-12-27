//
//  HUNetworkError.swift
//  HttpUtility
//
//  Created by CodeCat15 on 1/22/21.
//  Copyright © 2021 CodeCat15. All rights reserved.
//

import Foundation

// MARK: - HUNetworkError Struct

/// `HUNetworkError` is a struct representing an error that can occur during a network request.
public struct HUNetworkError: Error {
    
    // MARK: Properties
    
    /// A human-readable reason for the error.
    let reason: String?
    
    /// The HTTP status code associated with the error.
    let httpStatusCode: Int?
    
    /// The URL for which the network error occurred.
    let requestUrl: URL?
    
    /// The body of the HTTP request that resulted in the network error.
    let requestBody: String?
    
    /// The server response data in string format, if available.
    let serverResponse: String?
    
    // MARK: Initialization
    
    /// Initializes an instance of `HUNetworkError` with the provided parameters.
    /// - Parameters:
    ///   - response: The server response data in raw Data format.
    ///   - url: The URL for which the network error occurred.
    ///   - body: The body of the HTTP request that resulted in the network error.
    ///   - message: A human-readable error message.
    ///   - statusCode: The HTTP status code associated with the error.
    init(withServerResponse response: Data? = nil,
         forRequestUrl url: URL,
         withHttpBody body: Data? = nil,
         errorMessage message: String,
         forStatusCode statusCode: Int) {
        
        // Convert server response data to a string if available
        self.serverResponse = response != nil ? String(data: response!, encoding: .utf8) : nil
        
        // Set other properties with provided values
        self.requestUrl = url
        self.requestBody = body != nil ? String(data: body!, encoding: .utf8) : nil
        self.httpStatusCode = statusCode
        self.reason = message
    }
}
