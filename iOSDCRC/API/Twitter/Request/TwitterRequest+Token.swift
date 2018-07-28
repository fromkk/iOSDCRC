//
//  TwitterRequest+Token.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/22.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import Foundation
import API

extension Twitter.Request {
    
    /// アクセストークンを取得する
    struct Token: TwitterRequestable {
        var path: String = "oauth2/token"
        
        var method: HTTPMethod = .post
        
        let consumerKey: String
        let consumerSecret: String
        init(consumerKey: String, consumerSecret: String) {
            self.consumerKey = consumerKey
            self.consumerSecret = consumerSecret
        }
        
        var query: [String : String]? { return nil }
        
        var headers: [String : String]? {
            let data = String(format: "%@:%@", consumerKey, consumerSecret).data(using: .utf8)!
            let credential = data.base64EncodedString()
            
            return [
                "Authorization": "Basic \(credential)"
            ]
        }
        
        var httpBody: Data? {
            return QueryStringsBuilder(dictionary: ["grant_type": "client_credentials"]).build().data(using: .utf8)
        }
    }
}
