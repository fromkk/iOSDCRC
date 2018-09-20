//
//  AboutWireframe.swift
//  iOSDCRC
//
//  Created by Kenji Tanaka on 2018/09/18.
//  Copyright © 2018年 Kazuya Ueoka. All rights reserved.
//

import UIKit

struct AboutWireframe: AboutWireframeProtocol {
    func transitionToTwitterUser(url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
