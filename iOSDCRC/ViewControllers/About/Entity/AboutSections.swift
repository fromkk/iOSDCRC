//
//  AboutSections.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/27.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import Foundation

enum AboutSections: CustomStringConvertible {
    case dates
    case locations
    case sponsors
    case speakers
    case staffs
    
    var description: String {
        switch self {
        case .dates:
            return "Date"
        case .locations:
            return "Locations"
        case .sponsors:
            return "Sponsors"
        case .speakers:
            return "Speakers"
        case .staffs:
            return "Staffs"
        }
    }
    
    static let allCases: [AboutSections] = [.dates, .locations, .sponsors, .speakers, .staffs]
}
