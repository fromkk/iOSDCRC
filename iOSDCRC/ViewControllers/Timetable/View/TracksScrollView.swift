//
//  TracksScrollView.swift
//  TimetableViewSampler
//
//  Created by Kazuya Ueoka on 2018/07/21.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import UIKit

class TracksScrollView: UIScrollView {
    var itemWidth: CGFloat {
        didSet {
            setNeedsLayout()
        }
    }
    
    var trackNames: [String] {
        didSet {
            labels.forEach { $0.removeFromSuperview() }
            showTrackNames()
        }
    }
    init(trackNames: [String], itemWidth: CGFloat) {
        self.trackNames = trackNames
        self.itemWidth = itemWidth
        
        super.init(frame: .zero)
        
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var setUp: () -> () = {
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        showTrackNames()
        
        return {}
    }()
    
    private func showTrackNames() {
        trackNames.enumerated().forEach({ item in
            let label = makeLabel(with: item.element)
            label.frame = CGRect(x: CGFloat(item.offset) * itemWidth, y: 0, width: itemWidth, height: self.frame.size.height)
            addSubview(label)
            labels.append(label)
        })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        labels.forEach { (label) in
            var frame = label.frame
            frame.size.height = self.frame.size.height
            label.frame = frame
        }
        
        self.contentSize = CGSize(width: itemWidth * CGFloat(trackNames.count), height: self.frame.size.height)
    }
    
    var labels: [UILabel] = []
    
    private func makeLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.rc.mainText
        label.text = text
        return label
    }
}
