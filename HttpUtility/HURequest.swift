//
//  HURequest.swift
//  HttpUtility
//
//  Created by CodeCat15 on 1/31/21.
//  Copyright © 2021 CodeCat15. All rights reserved.
//

import Foundation

// MARK: - Request Protocol

/// `Request` protocol defines the basic structure for an HTTP request.
protocol Request {
    
    /// The URL for the request.
    var url: URL { get set }
    
    /// The HTTP method for the request.
    var method: HUHttpMethods { get set }
}

// MARK: - HURequest Struct

/// `HURequest` is a struct representing a basic HTTP request conforming to the `Request` protocol.
public struct HURequest: Request {
    
    // MARK: Properties
    
    /// The URL for the request.
    var url: URL
    
    /// The HTTP method for the request.
    var method: HUHttpMethods
    
    /// The body of the HTTP request.
    var requestBody: Data? = nil
    
    // MARK: Initialization
    
    /// Initializes an instance of `HURequest` with the provided parameters.
    /// - Parameters:
    ///   - url: The URL for the request.
    ///   - method: The HTTP method for the request.
    ///   - requestBody: The body of the HTTP request.
    public init(withUrl url: URL, forHttpMethod method: HUHttpMethods, requestBody: Data? = nil) {
        self.url = url
        self.method = method
        self.requestBody = requestBody != nil ? requestBody : nil
    }
}

// MARK: - HUMultiPartRequest Struct

/// `HUMultiPartRequest` is a struct representing an HTTP request with multipart form data conforming to the `Request` protocol.
public struct HUMultiPartRequest: Request {
    
    // MARK: Properties
    
    /// The URL for the request.
    var url: URL
    
    /// The HTTP method for the request.
    var method: HUHttpMethods
    
    /// The body of the HTTP request, represented by an `Encodable` type.
    var request: Encodable
    
    // MARK: Initialization
    
    /// Initializes an instance of `HUMultiPartRequest` with the provided parameters.
    /// - Parameters:
    ///   - url: The URL for the request.
    ///   - method: The HTTP method for the request.
    ///   - requestBody: The body of the HTTP request, represented by an `Encodable` type.
    public init(withUrl url: URL, forHttpMethod method: HUHttpMethods, requestBody: Encodable) {
        self.url = url
        self.method = method
        self.request = requestBody
    }
}

