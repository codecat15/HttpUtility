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
    func convertToURLQueryItems() -> [URLQueryItem]?
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

                return queryItems
            }

        } catch let error {
            debugPrint(error)
        }

        return nil
    }
}
