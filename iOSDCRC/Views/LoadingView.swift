//
//  LoadingView.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/24.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUp()
    }
    
    private lazy var setUp: () -> () = {
        isHidden = true
        backgroundColor = .white
        
        addSubview(indicatorView, constraints: [
            indicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        
        return {}
    }()
    
    lazy var indicatorView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    func startAnimating() {
        isHidden = false
        indicatorView.startAnimating()
    }
    
    func stopAnimating() {
        isHidden = true
        indicatorView.stopAnimating()
    }
}
