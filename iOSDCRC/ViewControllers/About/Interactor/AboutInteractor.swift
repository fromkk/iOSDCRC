//
//  AboutInteractor.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/27.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import Foundation

class AboutInteractor: AboutInteractorProtocol {
    func fetch(_ completion: @escaping (AboutEntity?) -> ()) {
        guard let url = Bundle.main.url(forResource: "about", withExtension: "json") else {
            debugPrint(#function, "url get failed")
            completion(nil)
            return
        }
        
        guard let data = try? Data(contentsOf: url) else {
            debugPrint(#function, "data get failed")
            completion(nil)
            return
        }
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        do {
            let entity = try jsonDecoder.decode(AboutEntity.self, from: data)
            completion(entity)
        } catch {
            debugPrint(#function, "decode failed", error)
            completion(nil)
        }
        
    }
}
