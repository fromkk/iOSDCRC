//
//  Task.swift
//  API
//
//  Created by Kazuya Ueoka on 2018/07/08.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import Foundation

public protocol Cancellable {
    func cancel()
}

public class Task: Cancellable {
    var urlSessionTask: URLSessionTask
    init(urlSessionTask: URLSessionTask) {
        self.urlSessionTask = urlSessionTask
    }
    
    public func cancel() {
        urlSessionTask.cancel()
    }
}
