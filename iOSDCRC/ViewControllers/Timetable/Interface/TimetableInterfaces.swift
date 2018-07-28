//
//  TimetableInterfaces.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/27.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import UIKit

protocol TimetableInteractorProtocol {
    
    /// イベントを取得する
    ///
    /// - Parameter completion: ([Event]) -> ()
    func events(_ completion: @escaping ([Event]) -> ())
}

protocol TimetablePresenterProtocol: class {
    typealias Dependencies = (
        view: TimetableViewpProtocol,
        interactor: TimetableInteractorProtocol
    )
    init(dependencies: Dependencies)
    
    /// イベントを取得する
    func loadEvents()
    
    /// イベントの件数を返す
    ///
    /// - Returns: Int
    func numberOfEvents() -> Int
    
    /// 該当のイベントを返す
    ///
    /// - Parameter index: Int
    /// - Returns: Event?
    func event(at index: Int) -> Event?
    
    /// 現在設定中のイベントを返す
    var currentEvent: Event? { get }
    
    /// イベントを選択する
    ///
    /// - Parameter index: Int
    func selectEvent(at index: Int)
}

protocol TimetableViewpProtocol: class {
    
    /// イベントを表示する
    func showEvents()
    
    /// イベントを更新する
    func updateEvent()
}
