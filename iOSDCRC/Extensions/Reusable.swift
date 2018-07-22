//
//  Reusable.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/22.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import UIKit

public protocol Reusable: class {}

public extension Reusable {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}

// MARK: - ReusableTableViewCell
public protocol ReusableTableViewCell: Reusable {}

public extension ReusableTableViewCell {
    
    public static func register(to tableView: UITableView) {
        tableView.register(self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    public static func dequeue(for tableView: UITableView, at indexPath: IndexPath) -> Self {
        return tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! Self
    }
    
}

// MARK: ReusableTableHeaderFooterView
public protocol ReusableTableViewHeaderFooterView: Reusable {}

public extension ReusableTableViewHeaderFooterView {
    
    public static func register(to tableView: UITableView) {
        tableView.register(self, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
    }
    
    public static func dequeue(for tableView: UITableView) -> Self {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier) as! Self
    }
    
}

// MARK: - ReusableCollectionViewCell
public protocol ReusableCollectionViewCell: Reusable {}

public extension ReusableCollectionViewCell {
    
    public static func register(to collectionView: UICollectionView) {
        collectionView.register(self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    public static func dequeue(for collectionView: UICollectionView, at indexPath: IndexPath) -> Self {
        return collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! Self
    }
    
}

