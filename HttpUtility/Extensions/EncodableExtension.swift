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
    /// Converts the encodable object to a URL with query string parameters.
    ///
    /// - Parameters:
    ///   - urlString: The base URL string to which query string parameters will be appended.
    /// - Returns: A URL with appended query string parameters, or `nil` if conversion fails.
    ///
    /// This method converts the encodable object to a dictionary and appends the dictionary's key-value pairs as query string parameters to the provided URL string.
    func convertToQueryStringUrl(urlString: String) -> URL?
    {
        var components = URLComponents(string: urlString)
        if(components != nil)
        {
            let requestDictionary = convertToDictionary()
            
            if(requestDictionary != nil)
            {
                var queryItems: [URLQueryItem] = []
                requestDictionary?.forEach({ (key, value) in
                    if(value != nil){
                        let strValue = value.map { String(describing: $0) }
                        if(strValue != nil && strValue?.count != 0){
                            queryItems.append(URLQueryItem(name: key, value: strValue))
                        }
                    }
                })
                
                components?.queryItems = queryItems
                return components?.url!
            }
        }
        
        debugPrint("convertToQueryStringUrl => Error => Conversion failed, please make sure to pass a valid urlString and try again")
        
        return nil
    }
    
    /// Converts the encodable object to a dictionary.
    ///
    /// - Returns: A dictionary representation of the encodable object, or `nil` if conversion fails.
    ///
    /// This method uses JSON encoding to convert the encodable object to a JSON data representation and then deserializes it into a dictionary.
    func convertToDictionary() -> [String: Any?]?
    {
        do {
            let encoder = try JSONEncoder().encode(self)
            let result = (try? JSONSerialization.jsonObject(with: encoder, options: .allowFragments)).flatMap{$0 as? [String: Any?]}
            
            return result
            
        } catch let error {
            debugPrint(error)
        }
        
        return nil
    }
}
