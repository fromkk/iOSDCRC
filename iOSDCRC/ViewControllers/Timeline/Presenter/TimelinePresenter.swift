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
    private let tweetsModel: TweetsModelProtocol = TweetsModel()
    private let accessToken: String

    required init(dependencies: Dependencies) {
        self.view = dependencies.view
        self.interactor = dependencies.interactor

        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(timerActivateIfNeeded(with:)), name: .UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(timerInactivateIfNeeded(with:)), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    

    let timeInterval: TimeInterval = 30

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
        guard let accessToken = accessToken else { return }

        self.tweetsModel.fetch()
        
        view.showLoading()
        interactor.search(with: accessToken, andKeyword: keyword, count: numberOfTweet, sinceID: nil, maxID: nil, completion: { [weak self] tweets in
            self?.tweets = tweets
            self?.view.showTimeline()
            self?.view.hideLoading()
            self?.isLoading = false
        })
    }
    
    func findNewTweets() {
        guard let accessToken = accessToken else { return }
        
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


extension TimelinePresenter: TweetsModelDelegate {
    func stateDidChange(_ state: TweetsModelState) {
        switch state {
        case .notInitialized, .fetched, .fetching:
            state.tweets
        }
    }
}


protocol TweetsModelProtocol {
    var state: TweetsModelState { get }
    weak var delegate: TweetsModelDelegate?

    func findOldTweets()
    func fetch()
}


enum TweetsModelState {
    typealias Tweet = Twitter.Response.Status

    case notInitialized
    case firstFetching
    case fetched(tweets: [Tweet])
    case fetching(tweets: [Tweet])


    var isFetching: Bool {
        switch self {
        case .fetched, .notInitialized:
            return false
        case .fetching, .firstFetching:
            return true
        }
    }


    var isNotInitialized: Bool {
        switch self {
        case .notInitialized:
            return true
        case .firstFetching, .fetched, .fetching:
            return false
        }
    }


    var tweets: [Tweet] {
        switch self {
        case .notInitialized, .firstFetching:
            return []
        case .fetched(tweets: let tweets), .fetching(tweets: let tweets):
            return tweets
        }
    }
}



class TweetsModel: TweetsModelProtocol {
    private(set) var state: TweetsModelState = .notInitialized
    weak var delegate: TweetsModelDelegate?

    private let keyword = "#iosdcrc"
    private let numberOfTweet: Int = 30
    private let count: Int


    func findOldTweets(accessToken: String) {
        guard !self.state.isFetching else { return }
        self.state = .fetching(tweets: self.state.tweets)

        interactor.search(
            with: self.accessToken,
            andKeyword: self.keyword,
            count: self.numberOfTweet,
            sinceID: sinceID,
            maxID: nil
        ) { [weak self] (tweets) in
            guard let strongSelf = self else { return }
            var tweets = strongSelf.state.tweets
            tweets.insert(contentsOf: tweets, at: 0)
            strongSelf.state = .fetched(tweets: tweets)
        }
    }


    func fetch(accessToken: String) {
        guard !self.state.isFetching else { return }
        self.state = self.state.isNotInitialized
            ? .firstFetching
            : .fetching(tweets: self.state.tweets)

        interactor.search(
            with: self.accessToken,
            andKeyword: self.keyword,
            count: self.numberOfTweet,
            sinceID: self.state.tweets.map { $0.id } .max(),
            maxID: nil
        ) { [weak self] (tweets) in
            guard let strongSelf = self else { return }
            var tweets = strongSelf.state.tweets
            tweets.insert(contentsOf: tweets, at: 0)
            strongSelf.state = .fetched(tweets: tweets)
        }
    }
}



protocol TweetsModelDelegate: class {
    func stateDidChange(_ state: TweetsModelState)
}
