//
//  HttpRequestHandler.swift
//  HttpUtility
//
//  Created by Rocket Racoon on 12/25/23.
//  Copyright © 2023 CodeCat15. All rights reserved.
//

import Foundation

final public class HttpRequestHandler {
    
    private let authenticationToken: String?
    private let customJsonDecoder: JSONDecoder?
    
    init(authenticationToken: String?, customJsonDecoder: JSONDecoder?) {
        self.authenticationToken = authenticationToken
        self.customJsonDecoder = customJsonDecoder
    }
    
    // MARK: - Perform Operation
    func performOperation<T: Decodable>(requestUrl: URLRequest,
                                        responseType: T.Type,
                                        completionHandler:@escaping(Result<T?, HUNetworkError>) -> Void)
    {
        URLSession.shared.dataTask(with: requestUrl) { (data, httpUrlResponse, error) in
            
            let statusCode = (httpUrlResponse as? HTTPURLResponse)?.statusCode
            
            if(error == nil && data != nil && data?.isEmpty == false) {
                let response = self.decodeJsonResponse(data: data!, responseType: responseType)
                
                // return success
                if(response != nil) {
                    completionHandler(.success(response))
                }else {
                    
                    // return failure
                    completionHandler(.failure(HUNetworkError(withServerResponse: data, 
                                                              forRequestUrl: requestUrl.url!,
                                                              withHttpBody: requestUrl.httpBody,
                                                              errorMessage: error.debugDescription,
                                                              forStatusCode: statusCode!)))
                }
            }
            else {
                let networkError = HUNetworkError(withServerResponse: data,
                                                  forRequestUrl: requestUrl.url!,
                                                  withHttpBody: requestUrl.httpBody,
                                                  errorMessage:error.debugDescription,
                                                  forStatusCode: statusCode!)
                
                // return failure
                completionHandler(.failure(networkError))
            }
            
        }.resume()
    }
    
    // MARK: Private method
    private func createJsonDecoder() -> JSONDecoder
    {
        let decoder =  customJsonDecoder != nil ? customJsonDecoder! : JSONDecoder()
        if(customJsonDecoder == nil) {
            decoder.dateDecodingStrategy = .iso8601
        }
        return decoder
    }
    
    private func decodeJsonResponse<T: Decodable>(data: Data, responseType: T.Type) -> T?
    {
        let decoder = createJsonDecoder()
        do {
            return try decoder.decode(responseType, from: data)
        }
        catch let error {
            debugPrint("error while decoding JSON response =>\(error.localizedDescription)")
        }
        return nil
    }
}
