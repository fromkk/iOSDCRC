//
//  TweetDateConverter.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/23.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import Foundation

class TweetDateConverter {
    static func convert(_ date: Date, with now: Date = Date()) -> String {
        let diffTimeInterval = now.timeIntervalSince1970 - date.timeIntervalSince1970
        
        let day = Int(diffTimeInterval / Constants.Date.day)
        let hour = Int(diffTimeInterval / Constants.Date.hour)
        let minutes = Int(diffTimeInterval / Constants.Date.minutes)
        let sec = Int(diffTimeInterval)
        
        if 7 < day {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .short
            return dateFormatter.string(from: date)
        } else if 0 < day {
            return String(format: "%d%@", day, NSLocalizedString("Tweet.Date.Day", comment: "d"))
        } else if 0 < hour {
            return String(format: "%d%@", hour, NSLocalizedString("Tweet.Date.Hour", comment: "h"))
        } else if 0 < minutes {
            return String(format: "%d%@", minutes, NSLocalizedString("Tweet.Date.Minutes", comment: "m"))
        } else {
            return String(format: "%d%@", sec, NSLocalizedString("Tweet.Date.Seconds", comment: "s"))
        }
    }
}
