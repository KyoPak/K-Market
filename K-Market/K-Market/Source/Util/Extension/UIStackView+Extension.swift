//
//  UIStackView+Extension.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/17.
//

import UIKit

extension UIStackView {
    convenience init(axis: NSLayoutConstraint.Axis, spacing: CGFloat, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution) {
        self.init(frame: .zero)
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
