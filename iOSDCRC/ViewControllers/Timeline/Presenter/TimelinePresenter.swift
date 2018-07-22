//
//  TimelinePresenter.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/22.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import Foundation

protocol TimelinePresenterProtocol: class {
    typealias Dependencies = (
        view: TimelineViewProtocol,
        interactor: TimelineInteractorProtocol
    )
    init(dependencies: Dependencies)
    
    func viewDidLoad()
}

class TimelinePresenter: TimelinePresenterProtocol {
    unowned var view: TimelineViewProtocol
    var interactor: TimelineInteractorProtocol
    
    required init(dependencies: Dependencies) {
        self.view = dependencies.view
        self.interactor = dependencies.interactor
    }
    
    let keyword = "#iosdcrc"
    
    var accessToken: String?
    
    func viewDidLoad() {
        interactor.token(with: Constants.Twitter.consumerKey, and: Constants.Twitter.consumerSecret) { [weak self] (accessToken) in
            guard let accessToken = accessToken else {
                self?.view.showAlertTokenGetFailed()
                return
            }
            
            self?.accessToken = accessToken
            self?.search()
        }
    }
    
    func search(count: Int = 100, sinceID: Int? = nil, maxID: Int? = nil) {
        guard let accessToken = accessToken else {
            return
        }
        
        interactor.search(with: accessToken, andKeyword: "#iosdcrc", count: count, sinceID: sinceID, maxID: maxID, completion: {
            
        })
    }
}
