//
//  RootPresenter.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/22.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import Foundation

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

class RootPresenter: RootPresenterProtocol {
    unowned var view: RootViewProtocol
    var interactor: RootInteractorProtocol
    var router: RootWireframeProtocol
    required init(dependencies: Dependencies) {
        self.view = dependencies.view
        self.interactor = dependencies.interactor
        self.router = dependencies.router
    }
    
    var menuList: [Menu] = []
    
    func loadMenu() {
        interactor.menu { [weak self] (menuList) in
            self?.menuList = menuList
            self?.view.showMenu()
        }
    }
    
    func numberOfMenus() -> Int {
        return menuList.count
    }
    
    func menu(at index: Int) -> Menu? {
        guard index < numberOfMenus() else { return nil }
        return menuList[index]
    }
    
    func select(at index: Int) {
        guard let menu = self.menu(at: index) else { return }
        
        switch menu {
        case .about:
            router.about()
        case .timetable:
            router.timetable()
        case .timeline:
            router.timeline()
        case .speaker:
            router.speaker()
        case .sponsor:
            router.sponsor()
        }
    }
}
