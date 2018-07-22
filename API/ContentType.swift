//
//  ContentType.swift
//  API
//
//  Created by Kazuya Ueoka on 2018/07/08.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import Foundation

public enum ContentType {
    case formUrlEncoded
    case multipartFormData(String)
    
    func toString() -> String {
        switch self {
        case .formUrlEncoded:
            return "application/x-www-form-urlencoded"
        case .multipartFormData(let boundary):
            return "multipart/form-data; boundary=\(boundary)"
        }
    }
}
