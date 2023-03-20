//
//  AlertPresentable.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/20.
//

import UIKit

protocol AlertPresentable where Self: UIViewController { }

extension AlertPresentable {
    func presentAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default)
        
        alert.addAction(confirm)
        
        present(alert, animated: true)
    }
}
