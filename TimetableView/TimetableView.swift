//
//  TimetableView.swift
//  TimetableView
//
//  Created by Kazuya Ueoka on 2018/07/21.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import UIKit

/// タイムテーブルを表現するクラス
open class TimetableView: UICollectionView, UICollectionViewDataSource {
    
    public var configuration: TimetableViewConfiguration {
        didSet {
            (collectionViewLayout as? TimetableViewLayout)?.configuration = configuration
            reloadData()
        }
    }
    
    public init(configuration: TimetableViewConfiguration) {
        self.configuration = configuration
        
        super.init(frame: .zero, collectionViewLayout: TimetableViewLayout(configuration: configuration))
        
        defer {
            self.dataSource = self
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return configuration.dataSource?.numberOfSections(in: self) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return configuration.dataSource?.timetableView(self, numberOfItemsIn: section) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = configuration.dataSource?.timetableView(self, cellForItemAt: indexPath) else {
            fatalError("cell reuse failed")
        }
        return cell
    }
    
}
