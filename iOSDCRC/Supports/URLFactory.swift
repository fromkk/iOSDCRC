//
//  URLFactory.swift
//  iOSDCRC
//
//  Created by Kenji Tanaka on 2018/09/18.
//  Copyright © 2018年 Kazuya Ueoka. All rights reserved.
//

import Foundation

struct URLFactory {
    static func createTwitterUserURL(screenName: String) -> URL? {
        guard !screenName.isEmpty else { return nil }
        return URL(string: "twitter://user?screen_name=\(screenName)")
    }
}
