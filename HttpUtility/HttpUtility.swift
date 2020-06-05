//
//  HttpUtility.swift
//  HttpUtility
//
//  Created by CodeCat15 on 5/17/20.
//  Copyright © 2020 CodeCat15. All rights reserved.
//

import Foundation

struct HttpMethod : Equatable, Hashable {
    static let get = "GET"
    static let post = "POST"
    static let put = "PUT"
    static let delete = "DELETE"
}

struct HttpHeaderFields
{
    static let contentType = "content-type"
}

struct NetworkError : Error
{
    let reason: String?
    let httpStatusCode: Int?
}

enum HttpMethods
{
    case get
    case post
    case put
    case delete
}

struct HttpUtility
{
    private var _token: String? = nil
    private var _customerJSONDecoder: JSONDecoder? = nil
    
    init(token: String?){
        _token = token
    }

    init(token: String?, decoder: JSONDecoder?){
        _token = token
        _customerJSONDecoder = decoder
    }

    init(WithJsonDecoder decoder: JSONDecoder){
        _customerJSONDecoder = decoder
    }
    
    init(){}

    func request<T:Decodable>(requestUrl: URL, method: HttpMethods, requestBody: Data? = nil,  resultType: T.Type, completionHandler:@escaping(Result<T?, NetworkError>)-> Void)
    {
        switch method
        {
        case .get:
            getData(requestUrl: requestUrl, resultType: T.self) { completionHandler($0)}
            break

        case .post:
            postData(requestUrl: requestUrl, requestBody: requestBody!, resultType: T.self) { completionHandler($0)}
            break

        case .put:
            putData(requestUrl: requestUrl, resultType: T.self) { completionHandler($0)}
            break

        case .delete:
            deleteData(requestUrl: requestUrl, resultType: T.self) { completionHandler($0)}
            break
        }
    }

    // MARK: - Private functions
    private func createJsonDecoder() -> JSONDecoder
    {
        let decoder =  _customerJSONDecoder != nil ? _customerJSONDecoder! : JSONDecoder()
        if(_customerJSONDecoder == nil)
        {
            decoder.dateDecodingStrategy = .iso8601
        }
        return decoder
    }
    
    private func createUrlRequest(requestUrl: URL) -> URLRequest
    {
        var urlRequest = URLRequest(url: requestUrl)
        if(_token != nil)
        {
            urlRequest.addValue(_token!, forHTTPHeaderField: "authorization")
        }
        
        return urlRequest
    }

    private func decodeJsonResponse<T: Decodable>(data: Data, responseType: T.Type) -> T?
    {
        let decoder = self.createJsonDecoder()
        do{
            return try decoder.decode(T.self, from: data)
        }catch let error{
            debugPrint("deocding error =>\(error)")
        }
        return nil
    }

    private func performOperation<T: Decodable>(requestUrl: URLRequest, responseType: T.Type, completionHandler:@escaping(Result<T?, NetworkError>) -> Void)
    {
        URLSession.shared.dataTask(with: requestUrl) { (data, httpUrlResponse, error) in

            let statusCode = (httpUrlResponse as? HTTPURLResponse)?.statusCode
            if(error == nil && data != nil && data?.count != 0)
            {
                let response = self.decodeJsonResponse(data: data!, responseType: T.self)

                if(response != nil){
                    completionHandler(.success(response))
                }else{
                    completionHandler(.failure(NetworkError(reason: "decoding error", httpStatusCode: statusCode)))
                }
            }
            else
            {
                let networkError = NetworkError(reason: error.debugDescription,httpStatusCode: statusCode)
                completionHandler(.failure(networkError))
            }

        }.resume()
    }

    // MARK: - GET Api
    private func getData<T:Decodable>(requestUrl: URL, resultType: T.Type, completionHandler:@escaping(Result<T?, NetworkError>)-> Void)
    {
        var urlRequest = createUrlRequest(requestUrl: requestUrl)
        urlRequest.httpMethod = HttpMethod.get

        performOperation(requestUrl: urlRequest, responseType: T.self) { (result) in
            completionHandler(result)
        }
    }

    // MARK: - POST Api
    private func postData<T:Decodable>(requestUrl: URL, requestBody: Data, resultType: T.Type, completionHandler:@escaping(Result<T?, NetworkError>)-> Void)
    {
        var urlRequest = createUrlRequest(requestUrl: requestUrl)
        urlRequest.httpMethod = HttpMethod.post
        urlRequest.httpBody = requestBody
        urlRequest.addValue("application/json", forHTTPHeaderField: HttpHeaderFields.contentType)

        performOperation(requestUrl: urlRequest, responseType: T.self) { (result) in
            completionHandler(result)
        }
    }

    // MARK: - PUT Api
    private func putData<T:Decodable>(requestUrl: URL, resultType: T.Type, completionHandler:@escaping(Result<T?, NetworkError>)-> Void)
    {
        var urlRequest = createUrlRequest(requestUrl: requestUrl)
        urlRequest.httpMethod = HttpMethod.put

        performOperation(requestUrl: urlRequest, responseType: T.self) { (result) in
            completionHandler(result)
        }
    }

    // MARK: - DELETE Api
    private func deleteData<T:Decodable>(requestUrl: URL, resultType: T.Type, completionHandler:@escaping(Result<T?, NetworkError>)-> Void)
    {
        var urlRequest = createUrlRequest(requestUrl: requestUrl)
        urlRequest.httpMethod = HttpMethod.delete

        performOperation(requestUrl: urlRequest, responseType: T.self) { (result) in
            completionHandler(result)
        }
    }
}
