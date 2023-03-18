//
//  AddViewController.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/17.
//

import UIKit

final class AddViewController: UIViewController {
    private let addView: AddView
    private let viewModel: AddViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(viewModel: AddViewModel) {
        self.viewModel = viewModel
        addView = AddView(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
        setupNavigation()
        setupView()
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
        addView.packageData()
        viewModel.postProduct { check in
            // Alert
            print(check)
        }
    }
}

// MARK: - UI Constraints
extension AddViewController {
    func setupNavigation() {
        title = "상품등록"
        
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
        view = addView
        view.backgroundColor = .systemBackground
    }
}
