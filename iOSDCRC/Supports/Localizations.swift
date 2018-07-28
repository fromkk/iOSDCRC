//
//  Localizations.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/28.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import Foundation

protocol Localizable: RawRepresentable where RawValue == String {}

extension Localizable {
    func localize(tableName: String? = nil, bundle: Bundle = Bundle.main, value: String = "", comment: String = "") -> String {
        return NSLocalizedString(rawValue, tableName: tableName, bundle: bundle, value: value, comment: comment)
    }
}

enum Localizations {
    enum General: String, Localizable {
        case ok = "General.OK"
    }
    
    enum Tweet: String, Localizable {
        case seconds = "Tweet.Date.Seconds"
        case minutes = "Tweet.Date.Minutes"
        case hour = "Tweet.Date.Hour"
        case day = "Tweet.Date.Day"
    }
    
    enum Timeline {
        enum Alert {
            enum AccessTokenGetFailed: String, Localizable {
                case title = "Timeline.Alert.TokenGetFailed.Title"
                case message = "Timeline.Alert.TokenGetFailed.Message"
            }
            
            enum TweetGetFailed: String, Localizable {
                case title = "Timeline.Alert.TweetGetFailed.Title"
                case message = "Timeline.Alert.TweetGetFailed.Message"
            }
        }
    }
}
