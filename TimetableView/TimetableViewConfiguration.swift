//
//  TimetableViewConfiguration.swift
//  TimetableView
//
//  Created by Kazuya Ueoka on 2018/07/21.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import UIKit

public class TimetableViewConfiguration {
    public let itemWidth: CGFloat
    public let heightOfHour: CGFloat
    public let itemEdgeInsets: UIEdgeInsets
    public let startDate: Date?
    public let endDate: Date?
    public weak var dataSource: TimetableViewDataSource?
    
    public init(itemWidth: CGFloat, heightOfHour: CGFloat, itemEdgeInsets: UIEdgeInsets = .zero, startDate: Date?, endDate: Date?, dataSource: TimetableViewDataSource?) {
        self.itemWidth = itemWidth
        self.heightOfHour = heightOfHour
        self.itemEdgeInsets = itemEdgeInsets
        self.startDate = startDate
        self.endDate = endDate
        self.dataSource = dataSource
    }
}
