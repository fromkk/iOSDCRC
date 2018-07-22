//
//  TimelineViewController.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/22.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import UIKit

protocol TimelineViewProtocol: class {
    func showAlertTokenGetFailed()
    func showAlertTimelineGetFailed()
}

class TimelineViewController: UIViewController, TimelineViewProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()
     
        presenter.viewDidLoad()
    }
    
    // MARK: - Elements
    
    lazy var presenter: TimelinePresenterProtocol = TimelinePresenter(dependencies: (
        view: self,
        interactor: TimelineInteractor()
    ))

    // MARK: - TimelineViewProtocol
    
    func showAlertTokenGetFailed() {
        debugPrint(#function)
    }
    
    func showAlertTimelineGetFailed() {
        debugPrint(#function)
    }

}

