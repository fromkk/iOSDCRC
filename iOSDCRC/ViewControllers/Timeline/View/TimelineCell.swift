//
//  TimelineCell.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/23.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import UIKit

final class TimelineCell: UITableViewCell, ReusableTableViewCell {
    
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
        
        contentView.addSubview(iconImageView, constraints: [
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            iconImageView.widthAnchor.constraint(equalToConstant: 48).priority(.required),
            iconImageView.heightAnchor.constraint(equalToConstant: 48).priority(.required),
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: iconImageView.bottomAnchor, constant: 8)
            ])
        
        contentView.addSubview(dateLabel, constraints: [
            contentView.trailingAnchor.constraint(greaterThanOrEqualTo: dateLabel.trailingAnchor, constant: 16),
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            ])
        
        contentView.addSubview(nameLabel, constraints: [
            nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8)
            ])
        
        contentView.addSubview(tweetLabel, constraints: [
            tweetLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            tweetLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            contentView.trailingAnchor.constraint(greaterThanOrEqualTo: tweetLabel.trailingAnchor, constant: 16),
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: tweetLabel.bottomAnchor, constant: 8)
            ])
        
        return {}
    }()
    
    // MARK: - Elements
    
    var task: ImageLoader.Task?
    
    // MARK: - UI
    
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 24
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        imageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = UIColor.rc.subText
        return label
    }()
    
    lazy var tweetLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.rc.mainText
        return label
    }()
}
