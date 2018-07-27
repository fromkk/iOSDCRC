//
//  TimetableInterfaces.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/27.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import UIKit

protocol TimetableInteractorProtocol {
    func events(_ completion: @escaping ([Event]) -> ())
}

protocol TimetablePresenterProtocol: class {
    typealias Dependencies = (
        view: TimetableViewpProtocol,
        interactor: TimetableInteractorProtocol
    )
    init(dependencies: Dependencies)
    
    func loadEvents()
    
    func numberOfEvents() -> Int
    
    func event(at index: Int) -> Event?
    
    var currentEvent: Event? { get }
    
    func selectEvent(at index: Int)
}

protocol TimetableViewpProtocol: class {
    func showEvents()
    func updateEvent()
}
