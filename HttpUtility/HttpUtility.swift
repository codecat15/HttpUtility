//
//  HttpUtility.swift
//  HttpUtility
//
//  Created by CodeCat15 on 5/17/20.
//  Copyright © 2020 CodeCat15. All rights reserved.
//

import Foundation

public struct HttpUtility
{
    static let shared = HttpUtility()
    public var authenticationToken : String? = nil
    public var customJsonDecoder : JSONDecoder? = nil

    private init(){}
    
    public func request<T:Decodable>(requestUrl: URL, method: HUHttpMethods, requestBody: Data? = nil,  resultType: T.Type, completionHandler:@escaping(Result<T?, HUNetworkError>)-> Void)
    {
        switch method
        {
        case .get:
            getData(requestUrl: requestUrl, resultType: resultType) { completionHandler($0)}
            break

        case .post:
            postData(requestUrl: requestUrl, requestBody: requestBody!, resultType: T.self) { completionHandler($0)}
            break

        case .put:
            putData(requestUrl: requestUrl, resultType: resultType) { completionHandler($0)}
            break

        case .delete:
            deleteData(requestUrl: requestUrl, resultType: resultType) { completionHandler($0)}
            break
        }
    }

    // MARK: - Multipart
    public func requestWithMultiPartFormData<T:Decodable>(huRequest: HURequest, responseType: T.Type, completionHandler:@escaping(Result<T?, HUNetworkError>)-> Void) {
        postMultiPartFormData(huRequest: huRequest) { completionHandler($0) }
    }

    // MARK: - Private functions
    private func createJsonDecoder() -> JSONDecoder
    {
        let decoder =  customJsonDecoder != nil ? customJsonDecoder! : JSONDecoder()
        if(customJsonDecoder == nil) {
            decoder.dateDecodingStrategy = .iso8601
        }
        return decoder
    }
    
    private func createUrlRequest(requestUrl: URL) -> URLRequest
    {
        var urlRequest = URLRequest(url: requestUrl)
        if(authenticationToken != nil) {
            urlRequest.setValue(authenticationToken!, forHTTPHeaderField: "authorization")
        }
        
        return urlRequest
    }

    private func decodeJsonResponse<T: Decodable>(data: Data, responseType: T.Type) -> T?
    {
        let decoder = createJsonDecoder()
        do{
            return try decoder.decode(responseType, from: data)
        }catch let error{
            debugPrint("deocding error =>\(error.localizedDescription)")
        }
        return nil
    }

    // MARK: - GET Api
    private func getData<T:Decodable>(requestUrl: URL, resultType: T.Type, completionHandler:@escaping(Result<T?, HUNetworkError>)-> Void)
    {
        var urlRequest = self.createUrlRequest(requestUrl: requestUrl)
        urlRequest.httpMethod = HUHttpMethods.get.rawValue

        performOperation(requestUrl: urlRequest, responseType: T.self) { (result) in
            completionHandler(result)
        }
    }

    // MARK: - POST Api
    private func postData<T:Decodable>(requestUrl: URL, requestBody: Data, resultType: T.Type, completionHandler:@escaping(Result<T?, HUNetworkError>)-> Void)
    {
        var urlRequest = self.createUrlRequest(requestUrl: requestUrl)
        urlRequest.httpMethod = HUHttpMethods.post.rawValue
        urlRequest.httpBody = requestBody
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")

        performOperation(requestUrl: urlRequest, responseType: T.self) { (result) in
            completionHandler(result)
        }
    }

    private func postMultiPartFormData<T:Decodable>(huRequest: HURequest, completionHandler:@escaping(Result<T?, HUNetworkError>)-> Void)
    {
        let boundary = "-----------------------------\(UUID().uuidString)"
        let lineBreak = "\r\n"
        var urlRequest = self.createUrlRequest(requestUrl: huRequest.url)
        urlRequest.httpMethod = HUHttpMethods.post.rawValue
        urlRequest.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var postBody = Data()

        let requestDictionary = huRequest.request.convertToDictionary()
        if(requestDictionary != nil)
        {
            requestDictionary?.forEach({ (key, value) in
                if(value != nil) {
                    let strValue = value.map { String(describing: $0) }
                    if(strValue != nil && strValue?.count != 0) {
                        postBody.append("--\(boundary + lineBreak)" .data(using: .utf8)!)
                        postBody.append("Content-Disposition: form-data; name=\"\(key)\" \(lineBreak + lineBreak)" .data(using: .utf8)!)
                        postBody.append("\(strValue! + lineBreak)".data(using: .utf8)!)
                    }
                }
            })

            postBody.append("--\(boundary)--\(lineBreak)" .data(using: .utf8)!)

            urlRequest.addValue("\(postBody.count)", forHTTPHeaderField: "Content-Length")
            urlRequest.httpBody = postBody

            performOperation(requestUrl: urlRequest, responseType: T.self) { (result) in
                completionHandler(result)
            }
        }
    }
    
    // MARK: - PUT Api
    private func putData<T:Decodable>(requestUrl: URL, resultType: T.Type, completionHandler:@escaping(Result<T?, HUNetworkError>)-> Void)
    {
        var urlRequest = self.createUrlRequest(requestUrl: requestUrl)
        urlRequest.httpMethod = HUHttpMethods.put.rawValue

        performOperation(requestUrl: urlRequest, responseType: T.self) { (result) in
            completionHandler(result)
        }
    }

    // MARK: - DELETE Api
    private func deleteData<T:Decodable>(requestUrl: URL, resultType: T.Type, completionHandler:@escaping(Result<T?, HUNetworkError>)-> Void)
    {
        var urlRequest = self.createUrlRequest(requestUrl: requestUrl)
        urlRequest.httpMethod = HUHttpMethods.delete.rawValue

        performOperation(requestUrl: urlRequest, responseType: T.self) { (result) in
            completionHandler(result)
        }
    }

    // MARK: - Perform data task
    private func performOperation<T: Decodable>(requestUrl: URLRequest, responseType: T.Type, completionHandler:@escaping(Result<T?, HUNetworkError>) -> Void)
    {
        URLSession.shared.dataTask(with: requestUrl) { (data, httpUrlResponse, error) in

            let statusCode = (httpUrlResponse as? HTTPURLResponse)?.statusCode
            debugPrint(String(data: data!, encoding: .utf8)!)
            if(error == nil && data != nil && data?.count != 0) {
                let response = self.decodeJsonResponse(data: data!, responseType: responseType)
                if(response != nil) {
                    completionHandler(.success(response))
                }else {
                    let responseJsonString = String(data: data!, encoding: .utf8)
                    completionHandler(.failure(HUNetworkError(reason: "error = \(String(describing: responseJsonString))", httpStatusCode: statusCode)))
                }
            }
            else {
                let networkError = HUNetworkError(reason: error.debugDescription,httpStatusCode: statusCode)
                completionHandler(.failure(networkError))
            }

        }.resume()
    }
}
