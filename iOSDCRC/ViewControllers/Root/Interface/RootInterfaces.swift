//
//  RootInterface.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/27.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import UIKit

protocol RootInteractorProtocol {
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
    
    func loadMenu()
    
    func numberOfMenus() -> Int
    
    func menu(at index: Int) -> Menu?
    
    func select(at index: Int)
}

protocol RootWireframeProtocol {
    init(viewController: UIViewController)
    
    func about()
    
    func timeline()
    
    func timetable()
}

protocol RootViewProtocol: class {
    func showMenu()
}
