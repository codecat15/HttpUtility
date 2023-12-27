//
//  HttpUtility.swift
//  HttpUtility
//
//  Created by CodeCat15 on 5/17/20.
//  Copyright © 2020 CodeCat15. All rights reserved.
//

import Foundation

// MARK: - HttpUtility Class

/// `HttpUtility` is a singleton class responsible for handling HTTP requests.
final public class HttpUtility {
    
    // MARK: Properties
    
    /// Shared instance of `HttpUtility` for singleton pattern.
    public static let shared = HttpUtility()
    
    /// Authentication token to be included in HTTP requests, if applicable.
    public var authenticationToken: String? = nil
    
    /// Custom JSON decoder to be used for decoding JSON responses. If not provided, the default JSONDecoder is used.
    public var customJsonDecoder: JSONDecoder? = nil
    
    /// Lazy initialization of `HttpRequestHandler` with authentication token and custom JSON decoder.
    private lazy var httpRequestHandler: HttpRequestHandler = {
        return HttpRequestHandler(authenticationToken: authenticationToken,
                                  customJsonDecoder: customJsonDecoder)
    }()
    
    // MARK: Initialization
    
    /// Private initializer to enforce singleton pattern.
    private init() {}
    
    // MARK: - Request Methods
    
    /// Handles various HTTP request methods and calls corresponding functions.
    /// - Parameters:
    ///   - huRequest: The HTTP request object containing details like URL, method, and request body.
    ///   - resultType: The type of the expected response (must conform to `Decodable`).
    ///   - completionHandler: A closure to be called upon completion, providing the result as a `Result` type.
    public func request<T: Decodable>(huRequest: HURequest,
                                      resultType: T.Type,
                                      completionHandler: @escaping (Result<T?, HUNetworkError>) -> Void) {
        
        switch huRequest.method {
        case .get:
            getData(requestUrl: huRequest.url, resultType: resultType) { completionHandler($0) }
        case .post:
            postData(request: huRequest, resultType: resultType) { completionHandler($0) }
        case .put:
            putData(requestUrl: huRequest.url, resultType: resultType) { completionHandler($0) }
        case .delete:
            deleteData(requestUrl: huRequest.url, resultType: resultType) { completionHandler($0) }
        }
    }
    
    // MARK: - Multipart Form Data Request
    
    /// Performs an HTTP request with multipart form data.
    /// - Parameters:
    ///   - multiPartRequest: The multipart form data request object.
    ///   - responseType: The type of the expected response (must conform to `Decodable`).
    ///   - completionHandler: A closure to be called upon completion, providing the result as a `Result` type.
    public func requestWithMultiPartFormData<T: Decodable>(multiPartRequest: HUMultiPartRequest,
                                                           responseType: T.Type,
                                                           completionHandler: @escaping (Result<T?, HUNetworkError>) -> Void) {
        
        postMultiPartFormData(request: multiPartRequest) { completionHandler($0) }
    }
    
    // MARK: - Private Functions
    
    /// Creates and returns a URL request with proper headers, including the authentication token if available.
    private func createUrlRequest(requestUrl: URL) -> URLRequest {
        
        var urlRequest = URLRequest(url: requestUrl)
        if let authToken = authenticationToken {
            urlRequest.setValue(authToken, forHTTPHeaderField: "authorization")
        }
        
        return urlRequest
    }
    
    // MARK: - GET API
    
    /// Performs an HTTP GET request.
    private func getData<T: Decodable>(requestUrl: URL,
                                       resultType: T.Type,
                                       completionHandler: @escaping (Result<T?, HUNetworkError>) -> Void) {
        
        var urlRequest = self.createUrlRequest(requestUrl: requestUrl)
        urlRequest.httpMethod = HUHttpMethods.get.rawValue
        
        httpRequestHandler.performOperation(requestUrl: urlRequest, responseType: T.self) { (result) in
            completionHandler(result)
        }
    }
    
    // MARK: - POST API
    
    /// Performs an HTTP POST request.
    private func postData<T: Decodable>(request: HURequest,
                                        resultType: T.Type,
                                        completionHandler: @escaping (Result<T?, HUNetworkError>) -> Void) {
        
        var urlRequest = self.createUrlRequest(requestUrl: request.url)
        urlRequest.httpMethod = HUHttpMethods.post.rawValue
        urlRequest.httpBody = request.requestBody
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        
        httpRequestHandler.performOperation(requestUrl: urlRequest, responseType: T.self) { (result) in
            completionHandler(result)
        }
    }
    
    // MARK: - POST Multipart Form Data
    
    /// Performs an HTTP POST request with multipart form data.
    private func postMultiPartFormData<T: Decodable>(request: HUMultiPartRequest,
                                                     completionHandler: @escaping (Result<T?, HUNetworkError>) -> Void) {
        
        let boundary = "-----------------------------\(UUID().uuidString)"
        let lineBreak = "\r\n"
        var urlRequest = self.createUrlRequest(requestUrl: request.url)
        urlRequest.httpMethod = HUHttpMethods.post.rawValue
        urlRequest.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var postBody = Data()
        
        if let requestDictionary = request.request.convertToDictionary() {
            for (key, value) in requestDictionary {
                if let strValue = value.map({ String(describing: $0) }), !strValue.isEmpty {
                    postBody.append("--\(boundary + lineBreak)".data(using: .utf8)!)
                    postBody.append("Content-Disposition: form-data; name=\"\(key)\" \(lineBreak + lineBreak)".data(using: .utf8)!)
                    postBody.append("\(strValue + lineBreak)".data(using: .utf8)!)
                }
            }
            postBody.append("--\(boundary)--\(lineBreak)".data(using: .utf8)!)
            urlRequest.addValue("\(postBody.count)", forHTTPHeaderField: "Content-Length")
            urlRequest.httpBody = postBody
            
            httpRequestHandler.performOperation(requestUrl: urlRequest, responseType: T.self) { (result) in
                completionHandler(result)
            }
        }
    }
    
    // MARK: - PUT API
    
    /// Performs an HTTP PUT request.
    private func putData<T: Decodable>(requestUrl: URL,
                                       resultType: T.Type,
                                       completionHandler: @escaping (Result<T?, HUNetworkError>) -> Void) {
        
        var urlRequest = self.createUrlRequest(requestUrl: requestUrl)
        urlRequest.httpMethod = HUHttpMethods.put.rawValue
        
        httpRequestHandler.performOperation(requestUrl: urlRequest, responseType: T.self) { (result) in
            completionHandler(result)
        }
    }
    
    // MARK: - DELETE API
    
    /// Performs an HTTP DELETE request.
    private func deleteData<T: Decodable>(requestUrl: URL,
                                          resultType: T.Type,
                                          completionHandler: @escaping (Result<T?, HUNetworkError>) -> Void) {
        
        var urlRequest = self.createUrlRequest(requestUrl: requestUrl)
        urlRequest.httpMethod = HUHttpMethods.delete.rawValue
        
        httpRequestHandler.performOperation(requestUrl: urlRequest, responseType: T.self) { (result) in
            completionHandler(result)
        }
    }
}
