//
//  TimetableViewDataSource.swift
//  TimetableView
//
//  Created by Kazuya Ueoka on 2018/07/21.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import UIKit

public protocol TimetableViewDataSource: class {
    func numberOfSections(in timetableView: TimetableView) -> Int
    func timetableView(_ timetableView: TimetableView, numberOfItemsIn section: Int) -> Int
    func timetableView(_ timetableView: TimetableView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    func timetableView(_ timetableView: TimetableView, itemAt indexPath: IndexPath) -> TimetableViewItem?
}
