//
//  TimelinePresenter.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/22.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import Foundation

class TimelinePresenter: NSObject, TimelinePresenterProtocol {
    unowned var view: TimelineViewProtocol
    var interactor: TimelineInteractorProtocol
    
    required init(dependencies: Dependencies) {
        self.view = dependencies.view
        self.interactor = dependencies.interactor
        
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(timerActivateIfNeeded(with:)), name: .UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(timerInactivateIfNeeded(with:)), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    let keyword = "#iosdcrc"
    
    let numberOfTweet: Int = 30
    
    let timeInterval: TimeInterval = 30
    
    var accessToken: String?
    
    var isLoading: Bool = false
    
    func loadTimeline() {
        guard !isLoading else { return }
        
        isLoading = true
        interactor.token(with: Constants.Twitter.consumerKey, and: Constants.Twitter.consumerSecret) { [weak self] (accessToken) in
            guard let accessToken = accessToken else {
                self?.view.showAlertTokenGetFailed()
                return
            }
            self?.isLoading = false
            self?.accessToken = accessToken
            self?.fetch()
        }
    }
    
    func viewWillShow() {
        timerActivateIfNeeded(with: nil)
    }
    
    func viewWillHide() {
        timerInactivateIfNeeded(with: nil)
    }
    
    var timer: Timer?
    
    @objc func timerActivateIfNeeded(with notification: Notification?) {
        if let timer = timer, timer.isValid {
            return
        }
        
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
    }
    
    @objc func timerInactivateIfNeeded(with notification: Notification?) {
        timer?.invalidate()
    }
    
    @objc private func handleTimer() {
        findNewTweets()
    }
    
    var tweets: [Tweet] = []
    
    func fetch() {
        guard let accessToken = accessToken, !isLoading else {
            return
        }
        
        isLoading = true
        view.showLoading()
        interactor.search(with: accessToken, andKeyword: keyword, count: numberOfTweet, sinceID: nil, maxID: nil, completion: { [weak self] tweets in
            self?.tweets = tweets
            self?.view.showTimeline()
            self?.view.hideLoading()
            self?.isLoading = false
        })
    }
    
    func findNewTweets() {
        guard let accessToken = accessToken, let sinceID = tweets.map({ $0.id }).max(), !isLoading else {
            return
        }
        
        isLoading = true
        interactor.search(with: accessToken, andKeyword: keyword, count: numberOfTweet, sinceID: sinceID, maxID: nil) { [weak self] (tweets) in
            self?.tweets.insert(contentsOf: tweets, at: 0)
            self?.view.addTimeline(at: (0..<tweets.count).map { $0 })
            self?.view.updateDate()
            self?.isLoading = false
        }
    }
    
    var hasNext: Bool = true
    
    func findOldTweets() {
        guard let accessToken = accessToken, let maxID = tweets.map({ $0.id }).min(), !isLoading, hasNext else {
            return
        }
        
        isLoading = true
        view.showLoadingBottom()
        interactor.search(with: accessToken, andKeyword: keyword, count: numberOfTweet, sinceID: nil, maxID: maxID - 1) { [weak self] (tweets) in
            guard let _self = self else { return }
            
            defer { _self.hasNext = 0 < tweets.count }
            
            let indexes = (0..<tweets.count).map { _self.tweets.count + $0 }
            _self.tweets.append(contentsOf: tweets)
            
            _self.view.addTimeline(at: indexes)
            _self.view.hideLoadingBottom()
            _self.isLoading = false
        }
    }
    
    func numberOfTweets() -> Int {
        return tweets.count
    }
    
    func tweet(at index: Int) -> TimelinePresenterProtocol.Tweet? {
        guard index < numberOfTweets() else { return nil }
        return tweets[index]
    }
}
