//
//  TwitterResponse+Status.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/22.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import Foundation

extension Twitter.Response {
    struct Statuses: Codable {
        var statuses: [Status]
        
        private enum CodingKeys: String, CodingKey {
            case statuses
        }
    }
    
    struct Status: Codable {
        var createdAt: Date
        var id: Int
        var text: String
        var user: Twitter.Response.User
        
        private enum CodingKeys: String, CodingKey {
            case createdAt = "created_at"
            case id
            case text
            case user
        }
    }
}
