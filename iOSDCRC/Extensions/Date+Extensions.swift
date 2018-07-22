//
//  Date+Extensions.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/22.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import Foundation

extension Date {
    func toString(with format: String, andLocale locale: Locale = Locale.current, andTimzone timezone: TimeZone = .current) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.timeZone = timezone
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
