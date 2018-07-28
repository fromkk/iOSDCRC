//
//  TimetableViewItem.swift
//  TimetableView
//
//  Created by Kazuya Ueoka on 2018/07/21.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import Foundation

/// 項目を表現するのに必要な情報
public protocol TimetableViewItem {
    
    /// 項目の開始時間
    var startAt: Date { get }
    
    /// 項目の終了時間
    var endAt: Date { get }
}
