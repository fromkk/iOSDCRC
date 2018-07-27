//
//  TimelineInterfaces.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/27.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import UIKit

protocol TimelineInteractorProtocol {
    func token(with consumerKey: String, and consumerSecret: String, completion: @escaping (String?) -> ())
    func search(with accessToken: String, andKeyword keyword: String, count: Int, sinceID: Int64?, maxID: Int64?, completion: @escaping ([Twitter.Response.Status]) -> ())
}

protocol TimelinePresenterProtocol: class {
    typealias Tweet = Twitter.Response.Status
    
    typealias Dependencies = (
        view: TimelineViewProtocol,
        interactor: TimelineInteractorProtocol
    )
    init(dependencies: Dependencies)
    
    func loadTimeline()
    
    func findNewTweets()
    
    func findOldTweets()
    
    func viewWillShow()
    
    func viewWillHide()
    
    func numberOfTweets() -> Int
    
    func tweet(at index: Int) -> Tweet?
}

protocol TimelineViewProtocol: class {
    func showLoading()
    func hideLoading()
    func showLoadingBottom()
    func hideLoadingBottom()
    
    func showTimeline()
    func addTimeline(at indexes: [Int])
    func updateDate()
    
    func showAlertTokenGetFailed()
    func showAlertTimelineGetFailed()
}
