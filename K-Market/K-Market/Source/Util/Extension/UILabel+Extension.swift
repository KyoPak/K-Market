//
//  UILabel+Extension.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/14.
//

import UIKit

extension UILabel {
    func applyStrikeThroughStyle() {
        let attributeString = NSMutableAttributedString(string: self.text ?? "")
        
        attributeString.addAttribute(
            .strikethroughStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSMakeRange(0, attributeString.length)
        )
        self.attributedText = attributeString
    }
}
