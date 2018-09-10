//
//  Injectable.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/09/10.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import UIKit

protocol Injectable where Self: UIViewController {
    associatedtype Dependency
    func inject(dependency: Dependency)
}
