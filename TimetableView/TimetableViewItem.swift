//
//  TimetableViewItem.swift
//  TimetableView
//
//  Created by Kazuya Ueoka on 2018/07/21.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import Foundation

public protocol TimetableViewItem {
    var startAt: Date { get }
    var endAt: Date { get }
}
