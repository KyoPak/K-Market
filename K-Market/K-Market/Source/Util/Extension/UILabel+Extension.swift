//
//  UILabel+Extension.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/14.
//

import UIKit

extension UILabel {
    convenience init(textColor: UIColor = .label, font: UIFont, line: Int = 1) {
        self.init(frame: .zero)
        self.textColor = textColor
        self.font = font
        self.numberOfLines = line
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
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
