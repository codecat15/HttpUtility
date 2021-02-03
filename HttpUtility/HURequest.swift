//
//  HURequest.swift
//  HttpUtility
//
//  Created by CodeCat15 on 1/31/21.
//  Copyright © 2021 CodeCat15. All rights reserved.
//

import Foundation

public struct HURequest {
    
    let url : URL
    let method : HUHttpMethods
    let request : Encodable
}
