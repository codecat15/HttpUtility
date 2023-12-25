//
//  HttpUtility.swift
//  HttpUtility
//
//  Created by CodeCat15 on 5/17/20.
//  Copyright © 2020 CodeCat15. All rights reserved.
//

import Foundation

final public class HttpUtility
{
    public static let shared = HttpUtility()
    public var authenticationToken : String? = nil
    public var customJsonDecoder : JSONDecoder? = nil
    
    private lazy var httpRequestHandler: HttpRequestHandler = {
        return HttpRequestHandler(authenticationToken: authenticationToken, 
                                  customJsonDecoder: customJsonDecoder)
    }()
    
    private init(){}
    
    public func request<T:Decodable>(huRequest: HURequest, resultType: T.Type, completionHandler:@escaping(Result<T?, HUNetworkError>)-> Void)
    {
        switch huRequest.method
        {
        case .get:
            getData(requestUrl: huRequest.url, resultType: resultType) { completionHandler($0)}
            break
            
        case .post:
            postData(request: huRequest, resultType: resultType) { completionHandler($0)}
            break
            
        case .put:
            putData(requestUrl: huRequest.url, resultType: resultType) { completionHandler($0)}
            break
            
        case .delete:
            deleteData(requestUrl: huRequest.url, resultType: resultType) { completionHandler($0)}
            break
        }
    }
    
    // MARK: - Multipart
    public func requestWithMultiPartFormData<T:Decodable>(multiPartRequest: HUMultiPartRequest, responseType: T.Type, completionHandler:@escaping(Result<T?, HUNetworkError>)-> Void) {
        postMultiPartFormData(request: multiPartRequest) { completionHandler($0) }
    }
    
    // MARK: - Private functions
    private func createUrlRequest(requestUrl: URL) -> URLRequest
    {
        var urlRequest = URLRequest(url: requestUrl)
        
        if let authToken = authenticationToken {
            urlRequest.setValue(authToken, forHTTPHeaderField: "authorization")
        }
        
        return urlRequest
    }
    
    // MARK: - GET Api
    private func getData<T:Decodable>(requestUrl: URL, resultType: T.Type, completionHandler:@escaping(Result<T?, HUNetworkError>)-> Void)
    {
        var urlRequest = self.createUrlRequest(requestUrl: requestUrl)
        urlRequest.httpMethod = HUHttpMethods.get.rawValue
        
        httpRequestHandler.performOperation(requestUrl: urlRequest, responseType: T.self) { (result) in
            completionHandler(result)
        }
    }
    
    // MARK: - POST Api
    private func postData<T:Decodable>(request: HURequest, resultType: T.Type, completionHandler:@escaping(Result<T?, HUNetworkError>)-> Void)
    {
        var urlRequest = self.createUrlRequest(requestUrl: request.url)
        urlRequest.httpMethod = HUHttpMethods.post.rawValue
        urlRequest.httpBody = request.requestBody
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        
        httpRequestHandler.performOperation(requestUrl: urlRequest, responseType: T.self) { (result) in
            completionHandler(result)
        }
    }
    
    private func postMultiPartFormData<T:Decodable>(request: HUMultiPartRequest, completionHandler:@escaping(Result<T?, HUNetworkError>)-> Void)
    {
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
    
    // MARK: - PUT Api
    private func putData<T:Decodable>(requestUrl: URL, resultType: T.Type, completionHandler:@escaping(Result<T?, HUNetworkError>)-> Void)
    {
        var urlRequest = self.createUrlRequest(requestUrl: requestUrl)
        urlRequest.httpMethod = HUHttpMethods.put.rawValue
        
        httpRequestHandler.performOperation(requestUrl: urlRequest, responseType: T.self) { (result) in
            completionHandler(result)
        }
    }
    
    // MARK: - DELETE Api
    private func deleteData<T:Decodable>(requestUrl: URL, resultType: T.Type, completionHandler:@escaping(Result<T?, HUNetworkError>)-> Void)
    {
        var urlRequest = self.createUrlRequest(requestUrl: requestUrl)
        urlRequest.httpMethod = HUHttpMethods.delete.rawValue
        
        httpRequestHandler.performOperation(requestUrl: urlRequest, responseType: T.self) { (result) in
            completionHandler(result)
        }
    }
}
