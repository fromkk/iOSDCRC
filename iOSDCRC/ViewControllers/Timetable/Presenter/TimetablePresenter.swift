//
//  TimetablePresenter.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/22.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import Foundation

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

class TimetablePresenter: TimetablePresenterProtocol {
    unowned var view: TimetableViewpProtocol
    var interactor: TimetableInteractorProtocol
    required init(dependencies: Dependencies) {
        self.view = dependencies.view
        self.interactor = dependencies.interactor
    }
    
    var events: [Event] = []
    
    var currentEvent: Event?
    
    func loadEvents() {
        interactor.events { [weak self] (events) in
            self?.events = events
            // TODO: implove some logic
            self?.currentEvent = events.first
            self?.view.showEvents()
            self?.view.updateEvent()
        }
    }
    
    func numberOfEvents() -> Int {
        return events.count
    }
    
    func event(at index: Int) -> Event? {
        guard index < numberOfEvents() else { return nil }
        return events[index]
    }
    
    func selectEvent(at index: Int) {
        guard let event = event(at: index) else { return }
        
        currentEvent = event
        
        view.updateEvent()
    }
    
}
