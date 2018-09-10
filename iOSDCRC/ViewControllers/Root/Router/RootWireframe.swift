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
        
        let view = aboutViewController
        let interactor = AboutInteractor()
        
        let presenter = AboutPresenter(dependencies: (view: view, interactor: interactor))
        aboutViewController.inject(dependency: presenter)
        viewController.navigationController?.pushViewController(aboutViewController, animated: true)
    }
    
    func timeline() {
        let timelineViewController = TimelineViewController()
        
        let view = timelineViewController
        let interacotor = TimelineInteractor()
        
        let presenter = TimelinePresenter(dependencies: (view: view, interactor: interacotor))
        timelineViewController.inject(dependency: presenter)
        viewController.navigationController?.pushViewController(timelineViewController, animated: true)
    }
    
    func timetable() {
        let timetableViewController = TimetableViewController()
        
        let view = timetableViewController
        let interactor = TimetableInteractor()
        
        let presenter = TimetablePresenter(dependencies: (view: view, interactor: interactor))
        timetableViewController.inject(dependency: presenter)
        viewController.navigationController?.pushViewController(timetableViewController, animated: true)
    }
}
