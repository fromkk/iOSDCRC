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
}
