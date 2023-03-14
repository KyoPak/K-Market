//
//  CollectionCell.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/11.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    var viewModel: ProductListCellViewModel?
    
    let indicatorView: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .label
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let salePriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stockLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        nameLabel.text = nil
        priceLabel.text = nil
        locationLabel.text = nil
        salePriceLabel.text = nil
        stockLabel.text = nil
    }
    
    func setupViewModel(_ viewModel: ProductListCellViewModel) {
        self.viewModel = viewModel
    }
    
    func setupBind() {
        viewModel?.bindData(completion: { [weak self] data in
            self?.nameLabel.text = data.name
            self?.priceLabel.text = self?.viewModel?.customPriceText(data.price)
            self?.stockLabel.text = self?.viewModel?.customStockText(data.stock)
            self?.salePriceLabel.text = self?.viewModel?.customPriceText(data.bargainPrice)
            
            data.discountedPrice == .zero ? self?.salePriceLabel.isHidden = true : self?.changePriceLabel()
        })
        
        viewModel?.loadImage(completion: { [weak self] data in
            DispatchQueue.main.async {
                if let data = data {
                    self?.imageView.image = UIImage(data: data)
                } else {
                    self?.imageView.image = UIImage(named: "photo")
                }
            }
        })
        
        viewModel?.bindLocationData(completion: { [weak self] subLocale in
            self?.locationLabel.text = subLocale
        })
    }
    
    func changePriceLabel() {
        priceLabel.textColor = .red
        priceLabel.applyStrikeThroughStyle()
    }
    
    func clearPriceLabel() {
        salePriceLabel.isHidden = false
        priceLabel.textColor = .gray
        priceLabel.attributedText = .none
    }
}
