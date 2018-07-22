//
//  Session.swift
//  API
//
//  Created by Kazuya Ueoka on 2018/07/08.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import Foundation

public class Session {
    private init() {}
    
    public static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy?
    
    @discardableResult
    public static func data(with request: RequestRepresentable, callback: @escaping (Data?, Error?) -> ()) -> Task {
        let request = request._request
        let task: URLSessionTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            DispatchQueue.main.async {
                callback(data, error)
            }
        }
        task.resume()
        
        return Task(urlSessionTask: task)
    }
    
    @discardableResult
    public static func json<T: Decodable>(with request: RequestRepresentable, and type: T.Type, callback: @escaping (T?, Error?) -> ()) -> Task {
        return data(with: request, callback: { (data, error) in
            guard let data = data else {
                callback(nil, error)
                return
            }
            
            let jsonDecoder = JSONDecoder()
            if let dateDecodingStrategy = dateDecodingStrategy {
                jsonDecoder.dateDecodingStrategy = dateDecodingStrategy
            }
            
            do {
                let result = try jsonDecoder.decode(type, from: data)
                callback(result, nil)
            } catch {
                callback(nil, error)
            }
        })
    }
}
