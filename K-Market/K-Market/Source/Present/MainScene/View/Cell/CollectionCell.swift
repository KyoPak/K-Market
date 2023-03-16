//
//  CollectionCell.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/11.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    var viewModel: ProductCellViewModel?
    
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
        clearPriceLabel()
        
        imageView.image = nil
        nameLabel.text = nil
        priceLabel.text = nil
        locationLabel.text = nil
        salePriceLabel.text = nil
        stockLabel.text = nil
    }
    
    func setupViewModel(_ viewModel: ProductCellViewModel) {
        self.viewModel = viewModel
    }
    
    func setupBind() {
        nameLabel.text = viewModel?.product.name
        stockLabel.text = viewModel?.customStockText()
        priceLabel.text = viewModel?.customPriceText(viewModel?.product.price ?? .zero)
        salePriceLabel.text = viewModel?.customPriceText(viewModel?.product.bargainPrice ?? .zero)
        viewModel?.product.discountedPrice == .zero ? salePriceLabel.isHidden = true : changePriceLabel()
        
        viewModel?.imageData.bind({ [weak self] data in
            DispatchQueue.main.async {
                guard let data = data else {
                    self?.imageView.image = UIImage(named: "photo")
                    return
                }
                
                self?.imageView.image = UIImage(data: data)
            }
        })
        
        viewModel?.productLocale.bind({ [weak self] locale in
            self?.locationLabel.text = locale
        })
    }
    
    func changePriceLabel() {
        priceLabel.textColor = .systemRed
        priceLabel.applyStrikeThroughStyle()
    }
    
    func clearPriceLabel() {
        salePriceLabel.isHidden = false
        priceLabel.textColor = .label
        priceLabel.attributedText = .none
    }
}
