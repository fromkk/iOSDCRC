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
        self.model = dependencies.model
        
        super.init()

        self.model.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(timerActivateIfNeeded(with:)), name: .UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(timerInactivateIfNeeded(with:)), name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    
    let keyword = "#iosdcrc"
    
    let numberOfTweet: Int = 30
    
    let timeInterval: TimeInterval = 30

    private let model: TokenModelProtocol

    var accessToken: String? {
        return self.model.state.accessToken
    }
    
    var isLoading: Bool {
        return self.model.state.isFetching || self.isSearching
    }

    private var isSearching: Bool = false


    func loadTimeline() {
        self.model.fetch()
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
        guard let accessToken = accessToken, let sinceID = tweets.map({ $0.id }).max(), !isLoading else {
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
        guard let accessToken = accessToken, let maxID = tweets.map({ $0.id }).min(), !isLoading, hasNext else {
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


extension TimelinePresenter: TokenModelDelegate {
    func tokenModelStateDidChange(state: TokenModelState) {
        switch state {
        case .notFetchedYet, .fetching:
            return

        case .fetched(accessToken: let accessToken):
            self.fetch()

        case .failed(because: let reason):
            self.view.showAlertTokenGetFailed()
        }
    }
}


protocol TokenModelProtocol: class {
    weak var delegate: TokenModelDelegate? { get set }
    var state: TokenModelState { get }

    func fetch()
}


enum TokenModelState: Equatable {
    case notFetchedYet
    case fetching
    case fetched(accessToken: String)
    case failed(because: Reason)


    var isFetching: Bool {
        switch self {
        case .fetching:
            return true
        case .fetched, .failed, .notFetchedYet:
            return false
        }
    }


    var accessToken: String? {
        switch self {
        case .fetching, .notFetchedYet, .failed:
            return nil
        case .fetched(accessToken: let accessToken):
            return accessToken
        }
    }


    enum Reason: Equatable {
        case unspecified(debugInfo: String)
    }
}


protocol TokenModelDelegate: class {
    func tokenModelStateDidChange(state: TokenModelState)
}


class TokenModel: TokenModelProtocol {
    weak var delegate: TokenModelDelegate? {
        didSet {
            self.delegate?.tokenModelStateDidChange(state: self.state)
        }
    }
    private(set) var state: TokenModelState = .notFetchedYet
    private let interactor: TwitterAccessTokenInteractorProtocol


    init(interactor: TwitterAccessTokenInteractorProtocol) {
        self.interactor = interactor
    }


    func fetch() {
        guard !self.state.isFetching else { return }
        self.state = .fetching
        self.delegate?.tokenModelStateDidChange(state: self.state)

        self.interactor.token(with: Constants.Twitter.consumerKey, and: Constants.Twitter.consumerSecret) { [weak self] accessToken in
            guard let strongSelf = self else { return }

            if let accessToken = accessToken {
                strongSelf.state = .fetched(accessToken: accessToken)
            }
            else {
                // FIXME: エラーはもうちょっとわかりやすくしたいね
                strongSelf.state = .failed(because: .unspecified(debugInfo: "nil"))
            }

            strongSelf.delegate?.tokenModelStateDidChange(state: strongSelf.state)
        }
    }
}
