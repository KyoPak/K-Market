//
//  ListViewController.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/09.
//

import UIKit

final class ListViewController: UIViewController {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
        setupConstraint()
    }
}

extension ListViewController {
    @objc private func addButtonTapped() {
        
    }
}

extension ListViewController {
    private func setupNavigation() {
        title = "K-Market"
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBackground
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let addBarButtonItem = UIBarButtonItem(
            title: "+",
            style: .plain,
            target: self,
            action: #selector(addButtonTapped)
        )
        
        addBarButtonItem.tintColor = .label
        navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(segmentedControl)
    }
    
    private func setupConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: safeArea.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}
