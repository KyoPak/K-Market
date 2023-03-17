//
//  HeaderView.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/15.
//

import UIKit

// MARK: - SegmentedControl, LocationLabel

final class HeaderView: UIView {
    private let viewModel: ListViewModel
    
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["LIST", "GRID"])
        control.selectedSegmentIndex = .zero
        control.layer.borderWidth = 1
        control.layer.borderColor = UIColor.systemBackground.cgColor
        control.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.label],
            for: UIControl.State.normal
        )
        control.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.systemBackground],
            for: UIControl.State.selected
        )
        control.selectedSegmentTintColor = .secondaryLabel
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let locationLabel = UILabel(font: .preferredFont(forTextStyle: .title3))

    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupView()
        bindData()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Bind
extension HeaderView {
    func bindData() {
        viewModel.userSubLocale.bind { [weak self] subLocale in
            self?.locationLabel.text = subLocale
        }
    }
}

// MARK: - Action
extension HeaderView {
    @objc private func segmentedControlTapped(sender: UISegmentedControl) {
        viewModel.setLayoutType(layoutIndex: sender.selectedSegmentIndex)
    }
}


// MARK: - UIConstraint
extension HeaderView {
    private func setupView() {
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        
        [segmentedControl, locationLabel].forEach(addSubview(_:))
        segmentedControl.addTarget(self, action: #selector(segmentedControlTapped), for: .valueChanged)
    }
    
    private func setupConstraint() {
        let safeArea = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: safeArea.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            
            locationLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            locationLabel.leadingAnchor.constraint(equalTo: segmentedControl.leadingAnchor, constant: 20)
        ])
    }
}
