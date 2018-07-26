//
//  UIColor+rc.swift
//  iOSDCRC
//
//  Created by Kazuya Ueoka on 2018/07/26.
//  Copyright © 2018 Kazuya Ueoka. All rights reserved.
//

import UIKit

extension UIColor {
    struct RC {
        let mainText: UIColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        let subText: UIColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        let link: UIColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        let background: UIColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
    }
    
    static let rc: RC = RC()
}
