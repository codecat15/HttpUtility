//
//  HUMultiPartFormData.swift
//  HttpUtility
//
//  Created by CodeCat15 on 1/31/21.
//  Copyright © 2021 CodeCat15. All rights reserved.
//

import Foundation


public class HUMultiPartFormData
{
    private var multiPartData : Data = Data()
    private var boundary = "-----------------------------\(UUID().uuidString)"
    private let lineBreak = "\r\n"

    public func appendBodyPart(parameterName: String, WithParameterData data: String, fileName: String? = nil, mimeType: String? = nil) {

        multiPartData.append("Content-Disposition: form-data; name=\"\(parameterName)\" \(lineBreak + lineBreak)" .data(using: .utf8)!)
        multiPartData.append("\(data + lineBreak)".data(using: .utf8)!)
    }

    public func appendInitalBoundary() {
        multiPartData.append("--\(boundary + lineBreak)" .data(using: .utf8)!)
    }

    public func appendLineBreakForNextParameter() {
        multiPartData.append("--\(boundary + lineBreak)" .data(using: .utf8)!)
    }

    public func appendClosingBoundary() {
        multiPartData.append("--\(boundary)--\(lineBreak)" .data(using: .utf8)!)
    }

    public func getMultiPartBody() -> Data {
        multiPartData
    }

    public func getBoundary() -> String {
        boundary
    }
}
