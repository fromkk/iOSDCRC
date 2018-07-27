//
//  Constants.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/22.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import Foundation

struct Constants {}

extension Constants {
    struct Twitter {
        static let consumerKey = "YOUR CUSTOMER KEY"
        static let consumerSecret = "YOUR CUSTOMER SECRET KEY"
    }
    
    class Date {
        public static let minutes: Double = 60.0
        public static let hour = Constants.Date.minutes * 60.0
        public static let day = Constants.Date.hour * 24.0
        public static let week = Constants.Date.day * 7.0
        public static let month = Constants.Date.day * 30.0
        public static let year = Constants.Date.day * 365.0
    }
}
