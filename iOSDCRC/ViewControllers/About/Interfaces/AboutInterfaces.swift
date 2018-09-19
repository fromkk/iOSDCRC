//
//  AboutInterfaces.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/27.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import UIKit

protocol AboutWireframeProtocol {
    func transitionToTwitterUser(url: URL)
}

protocol AboutInteractorProtocol {
    
    /// コンテンツを取得する
    ///
    /// - Parameter completion: (AboutEntity?) -> ()
    func fetch(_ completion: @escaping (AboutEntity?) -> ())
}

protocol AboutPresenterProtocol {
    typealias Speaker = AboutEntity.TwitterAccount
    typealias Staff = AboutEntity.TwitterAccount
    
    typealias Dependencies = (
        view: AboutViewProtocol,
        interactor: AboutInteractorProtocol,
        router: AboutWireframeProtocol
    )
    init(dependencies: Dependencies)

    func didSelectRowAt(indexPath: IndexPath)

    /// コンテンツを取得する
    func loadAbout()
    
    /// セクションの数を返す
    ///
    /// - Returns: Int
    func numberOfSections() -> Int
    
    /// 該当のセクション情報を返す
    ///
    /// - Parameter index: Int
    /// - Returns: AboutSections?
    func section(at index: Int) -> AboutSections?
    
    /// セクション内のコンテンツの数を返す
    ///
    /// - Parameter section: Int
    /// - Returns: Int
    func numberOfRows(in section: Int) -> Int
    
    /// 日付情報を返す
    ///
    /// - Parameter index: Int
    /// - Returns: AboutEntity.DateRange?
    func date(at index: Int) -> AboutEntity.DateRange?
    
    /// 位置情報を返す
    ///
    /// - Parameter index: Int
    /// - Returns: AboutEntity.Location?
    func location(at index: Int) -> AboutEntity.Location?
    
    /// スタッフの情報を返す
    ///
    /// - Parameter index: Int
    /// - Returns: Staff?
    func staff(at index: Int) -> Staff?
    
    /// 登壇者の情報を返す
    ///
    /// - Parameter index: Int
    /// - Returns: Speaker?
    func speaker(at index: Int) -> Speaker?
    
    /// スポンサーの情報を返す
    ///
    /// - Parameter index: Int
    /// - Returns: AboutEntity.Sponsor?
    func sponsor(at index: Int) -> AboutEntity.Sponsor?
}

protocol AboutViewProtocol: class {
    
    /// コンテンツを表示する
    func showAbout()
}
