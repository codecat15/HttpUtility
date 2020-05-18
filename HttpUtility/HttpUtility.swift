//
//  HttpUtility.swift
//  HttpUtility
//
//  Created by CodeCat15 on 5/17/20.
//  Copyright © 2020 CodeCat15. All rights reserved.
//

import Foundation

struct HttpMethodType {
    static let GET = "GET"
    static let POST = "POST"
}

struct HttpHeaderFields
{
    static let contentType = "content-type"
}

struct HttpUtility
{
    func getApiData<T:Decodable>(requestUrl: URL, resultType: T.Type, completionHandler:@escaping(_ result: T?)-> Void)
    {
        //todo: move this to a common function
        // need a date formatter to format the date response received
        // use url components for query string
        URLSession.shared.dataTask(with: requestUrl) { (responseData, httpUrlResponse, error) in

            if(error == nil && responseData != nil && responseData?.count != 0)
            {
                //parse the responseData here
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(T.self, from: responseData!)
                    _=completionHandler(result)
                }
                catch let error{
                    debugPrint("error occured while decoding = \(error.localizedDescription)")
                }
            }
            _=completionHandler(nil) //todo: you need to send error that you receive from server

        }.resume()
    }

    func postApiData<T:Decodable>(requestUrl: URL, requestBody: Data, resultType: T.Type, completionHandler:@escaping(_ result: T?)-> Void)
    {
        //todo: make this for posting multi-part form data
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = HttpMethodType.POST
        urlRequest.httpBody = requestBody
        urlRequest.addValue("application/json", forHTTPHeaderField: HttpHeaderFields.contentType)

        URLSession.shared.dataTask(with: urlRequest) { (data, httpUrlResponse, error) in

            if(data != nil && data?.count != 0)
            {
                do {

                    let response = try JSONDecoder().decode(T.self, from: data!)
                    _=completionHandler(response)
                }
                catch let decodingError {
                    debugPrint(decodingError)
                }
            }
            _=completionHandler(nil) //todo: you need to send error that you receive from server
            
        }.resume()
    }
}
