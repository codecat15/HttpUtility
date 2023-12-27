//
//  HUHttpMethods.swift
//  HttpUtility
//
//  Created by CodeCat15 on 1/22/21.
//  Copyright © 2021 CodeCat15. All rights reserved.
//

import Foundation

// MARK: - HUHttpMethods Enum

/// `HUHttpMethods` is an enumeration representing various HTTP methods.
///
/// For more information on HTTP methods, refer to [MDN Web Docs - HTTP Methods](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods).
public enum HUHttpMethods: String {
    
    // MARK: Cases
    
    /// HTTP GET method.
    case get = "GET"
    
    /// HTTP POST method.
    case post = "POST"
    
    /// HTTP PUT method.
    case put = "PUT"
    
    /// HTTP DELETE method.
    case delete = "DELETE"
}

