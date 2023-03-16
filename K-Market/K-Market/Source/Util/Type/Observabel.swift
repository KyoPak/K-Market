//
//  Observabel.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/16.
//

import Foundation

final class Observable<Value> {
    private var listener: ((Value) -> Void)?

    var value: Value {
        didSet {
            listener?(value)
        }
    }

    init(_ value: Value) {
        self.value = value
    }

    func bind(_ closure: @escaping (Value) -> Void) {
        closure(value)
        listener = closure
    }
}
