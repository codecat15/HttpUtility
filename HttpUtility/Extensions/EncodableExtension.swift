//
//  EncodableExtension.swift
//  HttpUtility
//
//  Created by CodeCat15 on 5/31/20.
//  Copyright © 2020 CodeCat15. All rights reserved.
//

import Foundation

extension Encodable
{
    func convertToQueryStringUrl(urlString: String) -> URL?
    {
        var components = URLComponents(string: urlString)
        if(components != nil)
        {
            do {
                let encoder = try JSONEncoder().encode(self)
                let requestDictionary = (try? JSONSerialization.jsonObject(with: encoder, options: .allowFragments)).flatMap{$0 as? [String: Any?]}

                if(requestDictionary != nil)
                {
                    var queryItems: [URLQueryItem] = []

                    requestDictionary?.forEach({ (key, value) in

                        if(value != nil)
                        {
                            let strValue = value.map { String(describing: $0) }
                            if(strValue != nil && strValue?.count != 0)
                            {
                                queryItems.append(URLQueryItem(name: key, value: strValue))
                            }
                        }
                    })

                    components?.queryItems = queryItems
                    return components?.url!
                }

            } catch let error {
                debugPrint("convertToQueryStringUrl => Error => \(error)")
            }
        }

        debugPrint("convertToQueryStringUrl => Error => Conversion failed, please make sure to pass a valid urlString and try again")

        return nil
    }

    func convertToMultiPartFormData(boundary: String) -> Data
    {
        let lineBreak = "\r\n"
        var requestData = Data()

        do {
            let encoder = try JSONEncoder().encode(self)
            let requestDictionary = (try? JSONSerialization.jsonObject(with: encoder, options: .allowFragments)).flatMap{$0 as? [String: Any?]}

            if(requestDictionary != nil)
            {
                requestDictionary?.forEach({ (key, value) in
                    if(value != nil)
                    {
                        let strValue = value.map { String(describing: $0) }
                        if(strValue != nil && strValue?.isEmpty == false)
                        {
                            requestData.append("\(lineBreak)--\(boundary)\r\n" .data(using: .utf8)!)
                            requestData.append("content-disposition: form-data; name=\"\(key)\" \(lineBreak + lineBreak)" .data(using: .utf8)!)
                            requestData.append("\(strValue!)" .data(using: .utf8)!)
                        }
                    }
                })

                requestData.append("--\(boundary)--\(lineBreak)" .data(using: .utf8)!)
            }

        } catch let error {
            debugPrint(error)
        }

        return requestData
    }
}
