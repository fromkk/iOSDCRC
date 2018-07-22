//
//  TimetableViewLayout.swift
//  TimetableView
//
//  Created by Kazuya Ueoka on 2018/07/21.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import UIKit

class TimetableViewLayout: UICollectionViewLayout {
    var configuration: TimetableViewConfiguration
    init(configuration: TimetableViewConfiguration) {
        self.configuration = configuration
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var attributesDictionary: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    
    override func prepare() {
        attributesDictionary = [:]
        
        guard
            let dataSource = configuration.dataSource,
            let timetableView = collectionView as? TimetableView else {
                return
        }
        
        for section in 0..<dataSource.numberOfSections(in: timetableView) {
            for row in 0..<dataSource.timetableView(timetableView, numberOfItemsIn: section) {
                let indexPath = IndexPath(item: row, section: section)
                guard let item = dataSource.timetableView(timetableView, itemAt: indexPath) else { continue }
                let bounds = self.bounds(at: indexPath, with: item)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = UIEdgeInsetsInsetRect(bounds, configuration.itemEdgeInsets)
                attributesDictionary[indexPath] = attributes
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesDictionary.compactMap({ (item) -> UICollectionViewLayoutAttributes? in
            guard item.value.frame.intersects(rect) else {
                return nil
            }
            return item.value
        })
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }
    
    override var collectionViewContentSize: CGSize {
        guard
            let dataSource = configuration.dataSource,
            let timetableView = collectionView as? TimetableView,
            let startDate = configuration.startDate,
            let endDate = configuration.endDate else {
                return .zero
        }
        
        let section = dataSource.numberOfSections(in: timetableView)
        return CGSize(width: configuration.itemWidth * CGFloat(section), height: height(for: endDate.timeIntervalSince1970 - startDate.timeIntervalSince1970))
    }
    
    private func bounds(at indexPath: IndexPath, with item: TimetableViewItem) -> CGRect {
        guard let startDate = configuration.startDate else {
            return .zero
        }
        
        let x: CGFloat = CGFloat(indexPath.section) * configuration.itemWidth
        let width = configuration.itemWidth
        
        let start = item.startAt.timeIntervalSince1970 - startDate.timeIntervalSince1970
        let hour = item.endAt.timeIntervalSince1970 - item.startAt.timeIntervalSince1970
        
        let y: CGFloat = self.height(for: start)
        let height: CGFloat = self.height(for: hour)
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    private func height(for timeInterval: TimeInterval) -> CGFloat {
        let heightOfHour = configuration.heightOfHour
        let hour = timeInterval / 3600
        return heightOfHour * CGFloat(hour)
    }
}
