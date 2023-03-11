//
//  DecodeManager.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/11.
//

import Foundation

struct DecodeManager<T: Decodable> {
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(Formatter.customDateFormat)
        
        return decoder
    }()
    
    func decode(_ data: Data) -> Result<T, NetworkError> {
        guard let datas = try? decoder.decode(T.self, from: data) else {
            if data.count == 0 {
                return Result.failure(NetworkError.last)
            }
            return Result.failure(NetworkError.decoding)
        }
        
        return Result.success(datas)
    }
}
