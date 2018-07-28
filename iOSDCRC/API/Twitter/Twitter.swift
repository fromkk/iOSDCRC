//
//  Twitter.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/22.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import Foundation
import API

/// Twitter APIとの接続を賄う
struct Twitter {}

extension Twitter {
    struct Request {}
    struct Response {}
}

extension Twitter.Response {
    static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        return JSONDecoder.DateDecodingStrategy.formatted(dateFormatter)
    }
}

protocol TwitterRequestable: RequestRepresentable {}

extension TwitterRequestable {
    var domain: String { return "https://api.twitter.com" }
    var query: [String : String]? { return nil }
    var headers: [String : String]? { return nil }
    var httpBody: Data? { return nil }
}

protocol TwitterAuthorizedRequestable: TwitterRequestable {
    var accessToken: String { get }
}

extension TwitterAuthorizedRequestable {
    var bearer: String { return String(format: "Bearer %@", accessToken) }
    
    var headers: [String : String]? {
        return [
            "Authorization": bearer
        ]
    }
}
