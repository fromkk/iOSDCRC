//
//  RootFooterView.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/27.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import UIKit

final class RootFooterView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUp()
    }
    
    private lazy var setUp: () -> () = {
        addSubview(copyLabel, constraints: [
            copyLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            copyLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            ])
        
        return {}
    }()
    
    lazy var copyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.rc.mainText
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
}
