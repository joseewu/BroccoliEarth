//
//  UILabel+letterSpacing.swift
//  DramaTV
//
//  Created by joseewu on 2018/3/14.
//  Copyright © 2018年 com.chocolabs.dramacrazy. All rights reserved.
//

import UIKit
extension UILabel {
    func spacing(with degree:CGFloat) {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: degree, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}
