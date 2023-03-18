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
    private let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(viewModel: AddViewModel) {
        self.viewModel = viewModel
        addView = AddView(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
        setupNavigation()
        setupView()
        bindData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Bind
extension AddViewController {
    func bindData() {
        viewModel.imageDatas.bind { [weak self] _ in
            self?.addView.collectionView.reloadData()
        }
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

// MARK: - UploadImageCellDelegate
extension AddViewController: UploadImageCellDelegate {
    func uploadImageCell(_ isShowPicker: Bool) {
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        
        let alert = UIAlertController(title: "사진선택",
                                      message: "업로드할 사진을 선택해주세요.",
                                      preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let rawAction = UIAlertAction(title: "원본사진", style: .default) { _ in
            self.picker.allowsEditing = false
            self.present(self.picker, animated: true, completion: nil)
        }
        
        let editAction = UIAlertAction(title: "편집사진", style: .default) { _ in
            self.picker.allowsEditing = true
            self.present(self.picker, animated: true, completion: nil)
        }
        
        [rawAction, editAction, cancelAction].forEach(alert.addAction(_:))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerController
extension AddViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if let image = info[.editedImage] as? UIImage {
            viewModel.addImageData(image.pngData())
        } else {
            if let image = info[.originalImage] as? UIImage {
                viewModel.addImageData(image.pngData())
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
}


// MARK: - Extension UICollectionView
extension AddViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return viewModel.imageDatas.value.count < 5 ? viewModel.imageDatas.value.count + 1 : 5
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
        
        cell.buttonDelegate = self
        
        if indexPath.item == viewModel.imageDatas.value.count {
            cell.createButton()
        } else {
            let data = viewModel.fetchImageData(index: indexPath.item)
            cell.createImageView(data: data)
        }
        
        return cell
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
        picker.delegate = self
        addView.collectionView.dataSource = self
        addView.collectionView.delegate = self
    }
}
