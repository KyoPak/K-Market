//
//  NetworkError.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/09.
//

import Foundation

enum NetworkError: Error {
    case empty
    case decoding
    case unknown
    case data
    case networking
    case last
    
    public var description: String {
        switch self {
        case .empty:
            return "None Data Error"
        case .decoding:
            return "Decoding Error"
        case .unknown:
            return "Unknown Error"
        case .data:
            return "Data Error"
        case .networking:
            return "Networking Error"
        case .last:
            return "Last Data"
        }
    }
}
