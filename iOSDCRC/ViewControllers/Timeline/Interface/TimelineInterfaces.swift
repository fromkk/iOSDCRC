//
//  TimelineInterfaces.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/27.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import UIKit

protocol TwitterAccessTokenInteractorProtocol {
    /// アクセストークンを取得する
    ///
    /// - Parameters:
    ///   - consumerKey: Twitterのconsumer_key
    ///   - consumerSecret: Twitterのconsumer_secret
    ///   - completion: (accessToken: String?) -> ()
    func token(with consumerKey: String, and consumerSecret: String, completion: @escaping (String?) -> ())
}


protocol TwitterSearchInteractorProtocol {
    /// 検索を実行する
    ///
    /// - Parameters:
    ///   - accessToken: アクセストークン
    ///   - keyword: 検索ワード
    ///   - count: 件数
    ///   - sinceID: 取得する最小値
    ///   - maxID: 取得する最大値
    ///   - completion: ([Twitter.Response.Status]) -> ()
    func search(with accessToken: String, andKeyword keyword: String, count: Int, sinceID: Int64?, maxID: Int64?, completion: @escaping ([Twitter.Response.Status]) -> ())
}


// FIXME: 長期的には消したい。
protocol TimelineInteractorProtocol: TwitterAccessTokenInteractorProtocol, TwitterSearchInteractorProtocol {}


protocol TimelinePresenterProtocol: class {
    typealias Tweet = Twitter.Response.Status
    
    typealias Dependencies = (
        view: TimelineViewProtocol,
        interactor: TimelineInteractorProtocol,
        model: TokenModelProtocol
    )
    init(dependencies: Dependencies)
    
    /// タイムラインを読み込む
    func loadTimeline()
    
    /// 新しいツイートを検索する
    func findNewTweets()
    
    /// 古いツイートを検索する
    func findOldTweets()
    
    /// 画面が表示されるときに呼ばれる
    func viewWillShow()
    
    /// 画面が非表示になるときに呼ばれる
    func viewWillHide()
    
    /// ツイートの件数を返す
    ///
    /// - Returns: Int
    func numberOfTweets() -> Int
    
    /// 該当のツイートを返す
    ///
    /// - Parameter index: Int
    /// - Returns: Tweet?
    func tweet(at index: Int) -> Tweet?
}

protocol TimelineViewProtocol: class {
    
    /// 画面全体のローディングを表示する
    func showLoading()
    
    /// 画面全体のローディングを非表示にする
    func hideLoading()
    
    /// 古いツイートを読み込む時のローディングを表示する
    func showLoadingBottom()
    
    /// 古いツイートを読み込む時のローディングを非表示する
    func hideLoadingBottom()
    
    /// タイムラインを表示する
    func showTimeline()
    
    /// タイムラインに追加する
    ///
    /// - Parameter indexes: [Int]
    func addTimeline(at indexes: [Int])
    
    /// 日付を更新する
    func updateDate()
    
    /// アクセストークンを取得するのに失敗したアラートを表示する
    func showAlertTokenGetFailed()
    
    /// タイムラインを取得するのに失敗したアラートを表示する
    func showAlertTimelineGetFailed()
}
