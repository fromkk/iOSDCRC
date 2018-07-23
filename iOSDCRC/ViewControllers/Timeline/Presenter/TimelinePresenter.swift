//
//  TimelinePresenter.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/22.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import Foundation

protocol TimelinePresenterProtocol: class {
    typealias Tweet = Twitter.Response.Status
    
    typealias Dependencies = (
        view: TimelineViewProtocol,
        interactor: TimelineInteractorProtocol
    )
    init(dependencies: Dependencies)
    
    func loadTimeline()
    
    func numberOfTweets() -> Int
    
    func tweet(at index: Int) -> Tweet?
}

class TimelinePresenter: TimelinePresenterProtocol {
    unowned var view: TimelineViewProtocol
    var interactor: TimelineInteractorProtocol
    
    required init(dependencies: Dependencies) {
        self.view = dependencies.view
        self.interactor = dependencies.interactor
    }
    
    let keyword = "#iosdcrc"
    
    var accessToken: String?
    
    func loadTimeline() {
        interactor.token(with: Constants.Twitter.consumerKey, and: Constants.Twitter.consumerSecret) { [weak self] (accessToken) in
            guard let accessToken = accessToken else {
                self?.view.showAlertTokenGetFailed()
                return
            }
            
            self?.accessToken = accessToken
            self?.search()
        }
    }
    
    var tweets: [Tweet] = []
    
    func search(count: Int = 100, sinceID: Int? = nil, maxID: Int? = nil) {
        guard let accessToken = accessToken else {
            return
        }
        
        interactor.search(with: accessToken, andKeyword: keyword, count: count, sinceID: sinceID, maxID: maxID, completion: { [weak self] tweets in
            self?.tweets = tweets
            self?.view.showTimeline()
        })
    }
    
    func numberOfTweets() -> Int {
        return tweets.count
    }
    
    func tweet(at index: Int) -> TimelinePresenterProtocol.Tweet? {
        guard index < numberOfTweets() else { return nil }
        return tweets[index]
    }
}
