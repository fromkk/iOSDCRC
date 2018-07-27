//
//  AboutCell.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/27.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import UIKit

final class AboutCell: UITableViewCell, ReusableTableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUp()
    }
    
    private lazy var setUp: () -> () = {
        selectionStyle = .none
        
        contentView.addSubview(descriptionLabel, constraints: [
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            contentView.trailingAnchor.constraint(greaterThanOrEqualTo: descriptionLabel.trailingAnchor, constant: 16),
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: descriptionLabel.bottomAnchor, constant: 16)
            ])
        
        return {}
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.rc.mainText
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
}
