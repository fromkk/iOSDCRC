//
//  RootInterface.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/27.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import UIKit

protocol RootInteractorProtocol {
    
    /// メニューを取得する
    ///
    /// - Parameter completion: ([RootEntity]) -> ()
    func menu(completion: @escaping ([RootEntity]) -> ())
}

protocol RootPresenterProtocol: class {
    typealias Menu = RootEntity
    
    typealias Dependencies = (
        view: RootViewProtocol,
        interactor: RootInteractorProtocol,
        router: RootWireframeProtocol
    )
    
    init(dependencies: Dependencies)
    
    /// メニューを取得する
    func loadMenu()
    
    /// メニューの数を返す
    ///
    /// - Returns: Int
    func numberOfMenus() -> Int
    
    /// 該当するメニューを返す
    ///
    /// - Parameter index: Int
    /// - Returns: Menu?
    func menu(at index: Int) -> Menu?
    
    /// 該当のメニューを選択する
    ///
    /// - Parameter index: Int
    func select(at index: Int)
}

protocol RootWireframeProtocol {
    init(viewController: UIViewController)
    
    /// Aboutページへ遷移する
    func about()
    
    /// Timelineページへ遷移する
    func timeline()
    
    /// Timetableページへ遷移する
    func timetable()
}

protocol RootViewProtocol: class {
    
    /// メニューを表示する
    func showMenu()
}
