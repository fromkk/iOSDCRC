//
//  TwitterResponse+User.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/22.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import Foundation

extension Twitter.Response {
    struct User: Codable {
        var id: Int
        var name: String
        var screenName: String
        
        private enum CodingKeys: String, CodingKey {
            case id
            case name
            case screenName = "screen_name"
        }
        
    }
}
