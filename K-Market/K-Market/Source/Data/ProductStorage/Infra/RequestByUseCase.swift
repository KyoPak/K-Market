//
//  RequestByUseCase.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/09.
//

import Foundation

struct ListFetchRequest: CustomRequest {
    var path: String? = "/api/products"
    var query: [URLQueryItem]?
    var httpMethod: HTTPMethod = .GET
    
    init(pageNo: Int, itemsPerPage: Int) {
        query = [
            URLQueryItem(name: "page_no", value: String(pageNo)),
            URLQueryItem(name: "items_per_page", value: String(itemsPerPage))
        ]
    }
}

struct DetailFetchRequest: CustomRequest {
    var path: String?
    var query: [URLQueryItem]?
    var httpMethod: HTTPMethod = .GET
    
    init(id: Int) {
        self.path = "/api/products/\(id)"
    }
}

struct ImageLoadRequest: CustomRequest {
    var path: String?
    var query: [URLQueryItem]?
    var httpMethod: HTTPMethod = .GET
    var baseURL: String?
    
    init(thumbnail: String) {
        baseURL = thumbnail
    }
}

struct PostDataRequest: CustomRequest {
    var path: String?
    var query: [URLQueryItem]?
    var httpMethod: HTTPMethod = .POST
    
    init() {
        self.path = "/api/products"
    }
    
    func createRequest(data: PostProduct, imageDatas: [Data]) -> URLRequest? {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(data) else { return nil }
        
        guard let url = url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request = setupIdentifier(request: &request)
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var httpBody = Data()
        httpBody.append(convertDataForm(named: "params", value: data, boundary: boundary))
        
        request.httpBody = createBody(&httpBody, boundary: boundary, imageDatas: imageDatas)
        
        return request
    }
    
    private func createBody(_ body: inout Data, boundary: String, imageDatas: [Data]) -> Data {
        for imageData in imageDatas {
            body.append(convertFileDataForm(
                fieldName: "images",
                fileName: "imagesName",
                mimeType: "multipart/form-data",
                fileData: imageData,
                boundary: boundary)
            )
        }
        
        body.appendStringData("--\(boundary)--")
        
        return body
    }
    
    
    private func setupIdentifier(request: inout URLRequest) -> URLRequest {
        request.setValue(
            "0574c520-6942-11ed-a917-43299f97bee6",
            forHTTPHeaderField: "identifier"
        )
        return request
    }
    
    private func convertDataForm(named name: String, value: Data, boundary: String) -> Data {
        var data = Data()
        data.appendStringData("--\(boundary)\r\n")
        data.appendStringData("Content-Disposition: form-data; name=\"\(name)\"\r\n")
        data.appendStringData("\r\n")
        data.append(value)
        data.appendStringData("\r\n")
        return data
    }
    
    private func convertFileDataForm(
        fieldName: String,
        fileName: String,
        mimeType: String,
        fileData: Data,
        boundary: String
    ) -> Data {
        var data = Data()
        data.appendStringData("--\(boundary)\r\n")
        data.appendStringData("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        data.appendStringData("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.appendStringData("\r\n")
        return data
    }
}

extension Data {
    mutating func appendStringData(_ string: String) {
        guard let data = string.data(using: .utf8) else { return }
        self.append(data)
    }
}
