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
        self.tokenModel = dependencies.tokenModel

        super.init()

        self.tokenModel.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(timerActivateIfNeeded(with:)), name: .UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(timerInactivateIfNeeded(with:)), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    let keyword = "#iosdcrc"
    
    let numberOfTweet: Int = 30
    
    let timeInterval: TimeInterval = 30

    private let tokenModel: TwitterAccessTokenModelProtocol
    
    var isLoading: Bool {
        return self.isSearching || self.tokenModel.state.isLoading
    }

    private var isSearching = false
    
    func loadTimeline() {
        self.tokenModel.fetch()
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
        guard let accessToken = self.tokenModel.state.accessToken, !isLoading else {
            return
        }
        
        isSearching = true
        view.showLoading()
        interactor.search(with: accessToken, andKeyword: keyword, count: numberOfTweet, sinceID: nil, maxID: nil, completion: { [weak self] tweets in
            self?.tweets = tweets
            self?.view.showTimeline()
            self?.view.hideLoading()
            self?.isSearching = false
        })
    }
    
    func findNewTweets() {
        guard let accessToken = self.tokenModel.state.accessToken, let sinceID = tweets.map({ $0.id }).max(), !isLoading else {
            return
        }
        
        isSearching = true
        interactor.search(with: accessToken, andKeyword: keyword, count: numberOfTweet, sinceID: sinceID, maxID: nil) { [weak self] (tweets) in
            self?.tweets.insert(contentsOf: tweets, at: 0)
            self?.view.addTimeline(at: (0..<tweets.count).map { $0 })
            self?.view.updateDate()
            self?.isSearching = false
        }
    }
    
    var hasNext: Bool = true
    
    func findOldTweets() {
        guard let accessToken = self.tokenModel.state.accessToken, let maxID = tweets.map({ $0.id }).min(), !isLoading, hasNext else {
            return
        }
        
        isSearching = true
        view.showLoadingBottom()
        interactor.search(with: accessToken, andKeyword: keyword, count: numberOfTweet, sinceID: nil, maxID: maxID - 1) { [weak self] (tweets) in
            guard let _self = self else { return }
            
            defer { _self.hasNext = 0 < tweets.count }
            
            let indexes = (0..<tweets.count).map { _self.tweets.count + $0 }
            _self.tweets.append(contentsOf: tweets)
            
            _self.view.addTimeline(at: indexes)
            _self.view.hideLoadingBottom()
            _self.isSearching = false
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


extension TimelinePresenter: TwitterAccessTokenModelDelegate {
    func twitterAccessTokenModelStateDidChange(state: TwitterAccessTokenModelState) {
        switch state {
        case .notLoadYet, .loading:
            return
        case .loaded:
            self.fetch()
        case .failed:
            self.view.showAlertTokenGetFailed()
        }
    }
}
