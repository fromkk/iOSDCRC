//
//  Request.swift
//  TypeNews
//
//  Created by Kazuya Ueoka on 2018/07/06.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import Foundation

public protocol RequestRepresentable {
    var domain: String { get }
    
    var path: String { get }
    
    var method: HTTPMethod { get }
    
    var httpBody: Data? { get }
    
    var query: [String: String]? { get }
    
    var headers: [String: String]? { get }
}

public extension RequestRepresentable {
    var cachePolicy: URLRequest.CachePolicy { return .reloadIgnoringCacheData }
    
    var timeoutInterval: TimeInterval { return 60 }
    
    var contentType: ContentType { return .formUrlEncoded }
    
    var httpBody: Data? { return nil }
    
    var query: [String: String]? { return nil }
    
    var headers: [String: String]? { return nil }
}

extension RequestRepresentable {
    var _request: URLRequest {
        var url = URL(string: domain)!.appendingPathComponent(path)
        
        if let query = query {
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
            urlComponents.queryItems = query.map({ (item) -> URLQueryItem in
                return URLQueryItem(name: item.key, value: item.value)
            })
            url = urlComponents.url!
        }
        
        var urlRequest = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = httpBody
        
        var headers: [String: String] = self.headers ?? [:]
        if case .post = method {
            headers["Content-Type"] = contentType.toString()
            headers["Content-Length"] = String(httpBody?.count ?? 0)
        }
        urlRequest.allHTTPHeaderFields = headers
        
        return urlRequest
    }
}
