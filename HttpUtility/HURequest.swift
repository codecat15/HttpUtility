//
//  HURequest.swift
//  HttpUtility
//
//  Created by CodeCat15 on 1/31/21.
//  Copyright © 2021 CodeCat15. All rights reserved.
//

import Foundation

protocol Request {
    var url: URL { get set }
    var method: HUHttpMethods { get set }
}

public struct HURequest : Request {
    var url: URL
    var method: HUHttpMethods
    var requestBody: Data? = nil

    public init(withUrl url: URL, forHttpMethod method: HUHttpMethods, requestBody: Data? = nil) {
        self.url = url
        self.method = method
        self.requestBody = requestBody != nil ? requestBody : nil
    }
}

public struct HUMultiPartRequest : Request {

    var url: URL
    var method: HUHttpMethods
    var request : Encodable

    public init(withUrl url: URL, forHttpMethod method: HUHttpMethods, requestBody: Encodable) {
        self.url = url
        self.method = method
        self.request = requestBody
    }
}
