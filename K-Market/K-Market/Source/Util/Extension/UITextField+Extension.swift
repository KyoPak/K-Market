//
//  UITextView+Extension.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/18.
//

import UIKit

extension UITextField {
    convenience init(
        placeholder: String,
        borderStyle: BorderStyle,
        returnKeyType: UIReturnKeyType = .done,
        keyboardType: UIKeyboardType = .default
    ) {
        self.init(frame: .zero)
        self.placeholder = placeholder
        self.borderStyle = borderStyle
        self.keyboardType = keyboardType
        translatesAutoresizingMaskIntoConstraints = false
    }
}
