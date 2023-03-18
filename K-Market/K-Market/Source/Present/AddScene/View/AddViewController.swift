//
//  AddViewController.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/17.
//

import UIKit

final class AddViewController: UIViewController {
    private let addView = AddView()
    private let viewModel: AddViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(viewModel: AddViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Action
extension AddViewController {
    @objc func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func doneButtonTapped() {
        //TODO: -
    }
}

// MARK: - UI Constraints
extension AddViewController {
    func setupNavigation(title: String) {
        self.title = title
        let cancelButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(cancelButtonTapped)
        )
        
        let doneButtonItem = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(doneButtonTapped)
        )
        
        cancelButtonItem.tintColor = .label
        doneButtonItem.tintColor = .label
        
        navigationItem.leftBarButtonItem = cancelButtonItem
        navigationItem.rightBarButtonItem = doneButtonItem
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(addView)
    }
    
    private func setupConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            addView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            addView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            addView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            addView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}
