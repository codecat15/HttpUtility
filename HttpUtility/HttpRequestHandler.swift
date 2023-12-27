//
//  HttpRequestHandler.swift
//  HttpUtility
//
//  Created by Rocket Racoon on 12/25/23.
//  Copyright © 2023 CodeCat15. All rights reserved.
//

import Foundation

// MARK: - HttpRequestHandler Class

/// `HttpRequestHandler` is a class responsible for handling HTTP requests.
final public class HttpRequestHandler {
    
    // MARK: Properties
    
    /// The authentication token to be included in the HTTP requests, if applicable.
    private let authenticationToken: String?
    
    /// Custom JSON decoder to be used for decoding JSON responses. If not provided, the default JSONDecoder is used.
    private let customJsonDecoder: JSONDecoder?
    
    // MARK: Initialization
    
    /// Initializes an instance of `HttpRequestHandler`.
    /// - Parameters:
    ///   - authenticationToken: The authentication token to be included in the HTTP requests.
    ///   - customJsonDecoder: Custom JSON decoder to be used for decoding JSON responses.
    init(authenticationToken: String?, customJsonDecoder: JSONDecoder?) {
        self.authenticationToken = authenticationToken
        self.customJsonDecoder = customJsonDecoder
    }
    
    // MARK: - Perform Operation
    
    /// Performs an HTTP request operation.
    /// - Parameters:
    ///   - requestUrl: The URL request to be executed.
    ///   - responseType: The type of the expected response (must conform to `Decodable`).
    ///   - completionHandler: A closure to be called upon completion, providing the result as a `Result` type.
    func performOperation<T: Decodable>(requestUrl: URLRequest,
                                        responseType: T.Type,
                                        completionHandler: @escaping (Result<T?, HUNetworkError>) -> Void) {
        
        URLSession.shared.dataTask(with: requestUrl) { (data, httpUrlResponse, error) in
            
            // Extracting status code from HTTP response
            let statusCode = (httpUrlResponse as? HTTPURLResponse)?.statusCode
            
            if (error == nil && data != nil && data?.isEmpty == false) {
                let response = self.decodeJsonResponse(data: data!, responseType: responseType)
                
                // Return success
                if (response != nil) {
                    completionHandler(.success(response))
                } else {
                    // Return failure
                    completionHandler(.failure(HUNetworkError(withServerResponse: data,
                                                              forRequestUrl: requestUrl.url!,
                                                              withHttpBody: requestUrl.httpBody,
                                                              errorMessage: error.debugDescription,
                                                              forStatusCode: statusCode!)))
                }
            } else {
                // Handle failure with network error
                let serverError = HUNetworkError(withServerResponse: data,
                                                  forRequestUrl: requestUrl.url!,
                                                  withHttpBody: requestUrl.httpBody,
                                                  errorMessage: error.debugDescription,
                                                  forStatusCode: statusCode!)
                // Return failure
                completionHandler(.failure(serverError))
            }
            
        }.resume()
    }
    
    // MARK: - Private Methods
    
    /// Creates and returns a JSON decoder based on the availability of a custom decoder.
    /// If a custom decoder is not provided, the default JSONDecoder is used with ISO8601 date decoding strategy.
    private func createJsonDecoder() -> JSONDecoder {
        let decoder = customJsonDecoder != nil ? customJsonDecoder! : JSONDecoder()
        if (customJsonDecoder == nil) {
            decoder.dateDecodingStrategy = .iso8601
        }
        return decoder
    }
    
    /// Decodes the JSON response data using the provided decoder.
    /// - Parameters:
    ///   - data: The JSON data to be decoded.
    ///   - responseType: The type of the expected response (must conform to `Decodable`).
    /// - Returns: The decoded response object or `nil` if decoding fails.
    private func decodeJsonResponse<T: Decodable>(data: Data, responseType: T.Type) -> T? {
        let decoder = createJsonDecoder()
        do {
            return try decoder.decode(responseType, from: data)
        } catch let error {
            debugPrint("Error while decoding JSON response =>\(error.localizedDescription)")
        }
        return nil
    }
}
