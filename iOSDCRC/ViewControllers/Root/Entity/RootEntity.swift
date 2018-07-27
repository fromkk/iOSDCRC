//
//  RootEntity.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/22.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import Foundation

enum RootEntity {
    case about
    case timetable
    case timeline
    
    func toString() -> String {
        switch self {
        case .about:
            return "About"
        case .timetable:
            return "Timetable"
        case .timeline:
            return "Timeline"
        }
    }
    
    static let allCases: [RootEntity] = [.about, .timetable, .timeline]
}
