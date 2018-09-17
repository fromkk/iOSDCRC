//
//  TimetableEntity.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/22.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import Foundation
import TimetableView

struct Event: Codable, Equatable {
    let title: String
    let description: String
    let startAt: Date
    let endAt: Date
    let tracks: [Track]
    
    private enum CodingKeys: String, CodingKey {
        case title
        case description
        case startAt = "start_at"
        case endAt = "end_at"
        case tracks
    }
    
    struct Track: Codable, Equatable {
        let name: String
        let sessions: [Session]
        
        private enum CodingKeys: String, CodingKey {
            case name
            case sessions
        }
        
        struct Session: Codable, Equatable {
            let title: String
            let description: String
            let author: String?
            let url: URL?
            let startAt: Date
            let endAt: Date
            
            private enum CodingKeys: String, CodingKey {
                case title
                case description
                case author
                case url
                case startAt = "start_at"
                case endAt = "end_at"
            }
        }
    }
}

extension Event.Track.Session: TimetableViewItem {}
