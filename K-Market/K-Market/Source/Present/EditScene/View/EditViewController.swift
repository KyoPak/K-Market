//
//  EditViewController.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/19.
//

import UIKit

final class EditViewController: UIViewController {
    private let viewModel: EditViewModel
    private let editView: EditView

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    init(viewModel: EditViewModel) {
        self.viewModel = viewModel
        self.editView = EditView(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
        setupNavigation()
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Action
extension EditViewController {
    @objc func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc func doneButtonTapped() {
        editView.packageData()
        viewModel.patchProduct { [weak self] error in
            if let error = error {
                print(error)
            } else {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension EditViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageDatas.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: UploadImageCell.identifier,
            for: indexPath) as? UploadImageCell
        else {
            let errorCell = UICollectionViewCell()
            return errorCell
        }

        cell.createImageView(data: viewModel.imageDatas[indexPath.item])

        return cell
    }
}

extension EditViewController {
    func setupNavigation() {
        title = "상품수정"

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
        view = editView
        view.backgroundColor = .systemBackground
        editView.collectionView.dataSource = self
        editView.collectionView.delegate = self
    }
}
