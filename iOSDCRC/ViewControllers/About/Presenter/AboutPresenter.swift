//
//  AboutPresenter.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/27.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import Foundation

class AboutPresenter: AboutPresenterProtocol {
    unowned var view: AboutViewProtocol
    var interactor: AboutInteractorProtocol
    
    required init(dependencies: Dependencies) {
        self.view = dependencies.view
        self.interactor = dependencies.interactor
    }
    
    var aboutEntity: AboutEntity?
    
    func loadAbout() {
        interactor.fetch { [weak self] (entity) in
            self?.aboutEntity = entity
            self?.view.showAbout()
        }
    }
    
    func numberOfSections() -> Int {
        return AboutSections.allCases.count
    }
    
    func section(at index: Int) -> AboutSections? {
        guard index < numberOfSections() else { return nil }
        return AboutSections.allCases[index]
    }
    
    func numberOfRows(in section: Int) -> Int {
        guard let section = self.section(at: section) else { return 0 }
        switch section {
        case .dates:
            return aboutEntity?.dates.count ?? 0
        case .locations:
            return aboutEntity?.locations.count ?? 0
        case .sponsors:
            return aboutEntity?.sponsors.count ?? 0
        case .speakers:
            return aboutEntity?.speakers.count ?? 0
        case .staffs:
            return aboutEntity?.staffs.count ?? 0
        }
    }
    
    func date(at index: Int) -> AboutEntity.DateRange? {
        guard let dates = aboutEntity?.dates, index < dates.count else { return nil }
        return dates[index]
    }
    
    func location(at index: Int) -> AboutEntity.Location? {
        guard let locations = aboutEntity?.locations, index < locations.count else { return nil }
        return locations[index]
    }
    
    func sponsor(at index: Int) -> AboutEntity.Sponsor? {
        guard let sponsors = aboutEntity?.sponsors, index < sponsors.count else { return nil }
        return sponsors[index]
    }
    
    func speaker(at index: Int) -> Speaker? {
        guard let speakers = aboutEntity?.speakers, index < speakers.count else { return nil }
        return speakers[index]
    }
    
    func staff(at index: Int) -> Staff? {
        guard let staffs = aboutEntity?.staffs, index < staffs.count else { return nil }
        return staffs[index]
    }
}
