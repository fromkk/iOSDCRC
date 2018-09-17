//
//  TimetableCell.swift
//  TimetableViewSampler
//
//  Created by Kazuya Ueoka on 2018/07/21.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import UIKit

class TimetableCell: UICollectionViewCell, ReusableCollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUp()
    }
    
    private lazy var setUp: () -> () = {
        contentView.backgroundColor = UIColor.rc.background
        
        contentView.addSubview(titleLabel, constraints: [
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            contentView.trailingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 8),
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: 8)
            ])
        
        return {}
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    var item: Event.Track.Session? {
        didSet {
            guard let item = item else {
                titleLabel.text = nil
                return
            }
            
            let attributedString = NSMutableAttributedString(string: item.title, attributes: [
                .font: UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor.rc.mainText
                ])
            if let author = item.author {
                attributedString.append(NSAttributedString(string: String(format: " %@", author), attributes: [
                    .font: UIFont.systemFont(ofSize: 16),
                    .foregroundColor: UIColor.rc.link
                    ]))
            }
            attributedString.append(NSAttributedString(string: String(format: " %@ - %@", item.startAt.toString(with: "HH:mm"), item.endAt.toString(with: "HH:mm")), attributes: [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.rc.subText
                ]))
            titleLabel.attributedText = attributedString
        }
    }
    
}
