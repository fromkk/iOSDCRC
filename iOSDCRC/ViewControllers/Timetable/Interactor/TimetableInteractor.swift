//
//  TimetableInteractor.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/22.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import Foundation

protocol TimetableInteractorProtocol {
    func events(_ completion: @escaping ([Event]) -> ())
}

class TimetableInteractor: TimetableInteractorProtocol {
    func events(_ completion: @escaping ([Event]) -> ()) {
        guard let path = Bundle.main.path(forResource: "iosdcrc", ofType: "json") else {
            completion([])
            return
        }
        
        let fileManager = FileManager.default
        
        guard let data = fileManager.contents(atPath: path) else {
            completion([])
            return
        }
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        do {
            let events = try jsonDecoder.decode([Event].self, from: data)
            completion(events)
        } catch {
            completion([])
            return
        }
    }
}
