//
//  AboutEntity.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/27.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import Foundation

struct AboutEntity: Codable, Equatable {
    let dates: [DateRange]
    let locations: [Location]
    let sponsors: [Sponsor]
    let speakers: [TwitterAccount]
    let staffs: [TwitterAccount]
    
    private enum CodingKeys: String, CodingKey {
        case dates
        case locations
        case sponsors
        case speakers
        case staffs
    }
    
    struct DateRange: Codable, Equatable {
        let from: Date
        let to: Date
        
        private enum CodingKeys: String, CodingKey {
            case from
            case to
        }
    }
    
    struct Location: Codable, Equatable {
        let name: String
        let postalCode: String
        let address: String
        
        private enum CodingKeys: String, CodingKey {
            case name
            case postalCode = "postal_code"
            case address
        }
    }
    
    struct Sponsor: Codable, Equatable {
        let name: String
        let description: String
        
        private enum CodingKeys: String, CodingKey {
            case name
            case description
        }
    }
    
    struct TwitterAccount: Codable, Equatable {
        let name: String
        let account: String
        
        private enum CodingKeys: String, CodingKey {
            case name
            case account
        }
    }
    
}
