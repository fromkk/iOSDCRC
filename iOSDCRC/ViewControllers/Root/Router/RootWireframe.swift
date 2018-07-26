//
//  RootWireframe.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/22.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import UIKit

protocol RootWireframeProtocol {
    init(viewController: UIViewController)
    
    func about()
    
    func timeline()
    
    func timetable()
    
    func speaker()
    
    func sponsor()
}

class RootWireframe: RootWireframeProtocol {
    unowned var viewController: UIViewController
    required init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func about() {
        let aboutViewController = AboutViewController()
        viewController.navigationController?.pushViewController(aboutViewController, animated: true)
    }
    
    func timeline() {
        let timelineViewController = TimelineViewController()
        viewController.navigationController?.pushViewController(timelineViewController, animated: true)
    }
    
    func timetable() {
        let timetableViewController = TimetableViewController()
        viewController.navigationController?.pushViewController(timetableViewController, animated: true)
    }
    
    func speaker() {
        let speakerViewController = AboutViewController()
        viewController.navigationController?.pushViewController(speakerViewController, animated: true)
    }
    
    func sponsor() {
        let sponsorViewController = AboutViewController()
        viewController.navigationController?.pushViewController(sponsorViewController, animated: true)
    }
}
