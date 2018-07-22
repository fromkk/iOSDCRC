//
//  TwitterResponse+Token.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/22.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import Foundation

extension Twitter.Response {
    struct Token: Codable {
        let tokenType: String
        let accessToken: String
        
        private enum CodingKeys: String, CodingKey {
            case tokenType = "token_type"
            case accessToken = "access_token"
        }
    }
}
