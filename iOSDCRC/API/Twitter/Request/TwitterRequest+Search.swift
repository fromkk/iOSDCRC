//
//  TwitterRequest+Search.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/22.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import Foundation
import API

extension Twitter.Request {
    struct Search: TwitterAuthorizedRequestable {
        init(accessToken: String, q: String, count: Int = 100, sinceID: Int64? = nil, maxID: Int64? = nil) {
            self.accessToken = accessToken
            self.q = q
            self.count = count
            self.sinceID = sinceID
            self.maxID = maxID
        }
        
        var accessToken: String
        
        var path: String = "1.1/search/tweets.json"
        
        var method: HTTPMethod = .get
        
        var q: String
        
        var count: Int
        
        var resultType: String = "recent"
        
        var sinceID: Int64? = nil
        
        var maxID: Int64? = nil
        
        var query: [String : String]? {
            var query: [String: String] = [
                "q": q,
                "count": String(count),
                "result_type": resultType
            ]
            
            if let sinceID = sinceID {
                query["since_id"] = String(sinceID)
            }
            
            if let maxID = maxID {
                query["max_id"] = String(maxID)
            }
            
            return query
        }
    }
}
