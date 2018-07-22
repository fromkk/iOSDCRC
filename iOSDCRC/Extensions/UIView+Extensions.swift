//
//  UIView+Extensions.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/22.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import UIKit

extension UIView {
    func addSubview(_ view: UIView, constraints: [NSLayoutConstraint]) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate(constraints)
    }
}

extension UIView {
    struct SafeArea {
        weak var view: UIView!
        
        var leadingAnchor: NSLayoutXAxisAnchor {
            if #available(iOS 11.0, *) {
                return view.safeAreaLayoutGuide.leadingAnchor
            } else {
                return view.leadingAnchor
            }
        }
        
        var trailingAnchor: NSLayoutXAxisAnchor {
            if #available(iOS 11.0, *) {
                return view.safeAreaLayoutGuide.trailingAnchor
            } else {
                return view.trailingAnchor
            }
        }
        
        var leftAnchor: NSLayoutXAxisAnchor {
            if #available(iOS 11.0, *) {
                return view.safeAreaLayoutGuide.leftAnchor
            } else {
                return view.leftAnchor
            }
        }
        
        var rightAnchor: NSLayoutXAxisAnchor {
            if #available(iOS 11.0, *) {
                return view.safeAreaLayoutGuide.rightAnchor
            } else {
                return view.rightAnchor
            }
        }
        
        var topAnchor: NSLayoutYAxisAnchor {
            if #available(iOS 11.0, *) {
                return view.safeAreaLayoutGuide.topAnchor
            } else {
                return view.topAnchor
            }
        }
        
        var bottomAnchor: NSLayoutYAxisAnchor {
            if #available(iOS 11.0, *) {
                return view.safeAreaLayoutGuide.bottomAnchor
            } else {
                return view.bottomAnchor
            }
        }
        
        var centerXAnchor: NSLayoutXAxisAnchor {
            if #available(iOS 11.0, *) {
                return view.safeAreaLayoutGuide.centerXAnchor
            } else {
                return view.centerXAnchor
            }
        }
        
        var centerYAnchor: NSLayoutYAxisAnchor {
            if #available(iOS 11.0, *) {
                return view.safeAreaLayoutGuide.centerYAnchor
            } else {
                return view.centerYAnchor
            }
        }
        
        var widthAnchor: NSLayoutDimension {
            if #available(iOS 11.0, *) {
                return view.safeAreaLayoutGuide.widthAnchor
            } else {
                return view.widthAnchor
            }
        }
        
        var heightAnchor: NSLayoutDimension {
            if #available(iOS 11.0, *) {
                return view.safeAreaLayoutGuide.heightAnchor
            } else {
                return view.heightAnchor
            }
        }
        
        var safeAreaInsets: UIEdgeInsets {
            if #available(iOS 11.0, *) {
                return view.safeAreaInsets
            } else {
                return .zero
            }
        }
    }
    
    var safeArea: SafeArea { return SafeArea(view: self) }
}
