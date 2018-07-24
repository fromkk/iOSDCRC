//
//  TimelineInteractor.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/22.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import Foundation
import API

protocol TimelineInteractorProtocol {
    func token(with consumerKey: String, and consumerSecret: String, completion: @escaping (String?) -> ())
    func search(with accessToken: String, andKeyword keyword: String, count: Int, sinceID: Int64?, maxID: Int64?, completion: @escaping ([Twitter.Response.Status]) -> ())
}

class TimelineInteractor: TimelineInteractorProtocol {
    func token(with consumerKey: String, and consumerSecret: String, completion: @escaping (String?) -> ()) {
        let token = Twitter.Request.Token(consumerKey: consumerKey, consumerSecret: consumerSecret)
        Session.json(with: token, and: Twitter.Response.Token.self) { (result, error) in
            guard let result = result else {
                return
            }
            
            completion(result.accessToken)
        }
    }
    
    func search(with accessToken: String, andKeyword keyword: String, count: Int = 100, sinceID: Int64? = nil, maxID: Int64? = nil, completion: @escaping ([Twitter.Response.Status]) -> ()) {
        let search = Twitter.Request.Search(accessToken: accessToken, q: keyword, count: count, sinceID: sinceID, maxID: maxID)
        Session.dateDecodingStrategy = Twitter.Response.dateDecodingStrategy
        Session.json(with: search, and: Twitter.Response.Statuses.self) { (result, error) in
            guard let result = result else {
                debugPrint(#function, "error", error)
                completion([])
                return
            }
            
            completion(result.statuses)
        }
    }
}
