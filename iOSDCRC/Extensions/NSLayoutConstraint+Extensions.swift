//
//  NSLayoutConstraint+Extensions.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/23.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    func priority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
