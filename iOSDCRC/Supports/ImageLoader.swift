//
//  ImageLoader.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/24.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import UIKit

/// URLから画像を読み込むためのクラス
class ImageLoader {
    enum Errors: Error {
        case convertFailed
    }
    
    class Task: Cancellable {
        var urlSessionDataTask: URLSessionDataTask?
        var url: URL
        init(url: URL, urlSessionDataTask: URLSessionDataTask?) {
            self.url = url
            self.urlSessionDataTask = urlSessionDataTask
        }
        
        func cancel() {
            urlSessionDataTask?.cancel()
        }
    }
    
    static func load(with url: URL, completion: @escaping (UIImage?, Error?) -> ()) -> Task? {
        let urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    completion(nil, Errors.convertFailed)
                    return
                }
                
                completion(image, nil)
            }
        }
        task.resume()
        return Task(url: url, urlSessionDataTask: task)
    }
}
