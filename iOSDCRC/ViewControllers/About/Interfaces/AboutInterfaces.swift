//
//  AboutInterfaces.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/27.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import UIKit

protocol AboutInteractorProtocol {
    func fetch(_ completion: @escaping (AboutEntity?) -> ())
}

protocol AboutPresenterProtocol {
    typealias Dependencies = (
        view: AboutViewProtocol,
        interactor: AboutInteractorProtocol
    )
    init(dependencies: Dependencies)
    
    func loadAbout()
    func numberOfSections() -> Int
    func section(at index: Int) -> AboutSections?
    func numberOfRows(in section: Int) -> Int
    func date(at index: Int) -> AboutEntity.DateRange?
    func location(at index: Int) -> AboutEntity.Location?
    func staff(at index: Int) -> AboutEntity.TwitterAccount?
    func speaker(at index: Int) -> AboutEntity.TwitterAccount?
    func sponsor(at index: Int) -> AboutEntity.Sponsor?
}

protocol AboutViewProtocol: class {
    func showAbout()
}
