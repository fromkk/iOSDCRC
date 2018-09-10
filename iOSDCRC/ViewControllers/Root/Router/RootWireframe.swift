//
//  RootWireframe.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/22.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import UIKit

class RootWireframe: RootWireframeProtocol {
    unowned var viewController: UIViewController
    required init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func about() {
        let aboutViewController = AboutViewController()
        let presenter = AboutPresenter(dependencies: (view: aboutViewController, interactor: AboutInteractor()))
        aboutViewController.inject(dependency: presenter)
        viewController.navigationController?.pushViewController(aboutViewController, animated: true)
    }
    
    func timeline() {
        let timelineViewController = TimelineViewController()
        let presenter = TimelinePresenter(dependencies: (view: timelineViewController, interactor: TimelineInteractor()))
        timelineViewController.inject(dependency: presenter)
        viewController.navigationController?.pushViewController(timelineViewController, animated: true)
    }
    
    func timetable() {
        let timetableViewController = TimetableViewController()
        let presenter = TimetablePresenter(dependencies: (view: timetableViewController, interactor: TimetableInteractor()))
        timetableViewController.inject(dependency: presenter)
        viewController.navigationController?.pushViewController(timetableViewController, animated: true)
    }
}
