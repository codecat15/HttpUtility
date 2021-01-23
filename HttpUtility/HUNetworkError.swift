//
//  HUNetworkError.swift
//  HttpUtility
//
//  Created by CodeCat15 on 1/22/21.
//  Copyright © 2021 CodeCat15. All rights reserved.
//

import Foundation

public struct HUNetworkError : Error
{
    let reason: String?
    let httpStatusCode: Int?
}
