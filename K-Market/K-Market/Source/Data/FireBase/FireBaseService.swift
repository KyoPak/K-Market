//
//  FireBaseService.swift
//  K-Market
//
//  Created by parkhyo on 2023/03/10.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

protocol FireBaseService {
    func load(_ data: LocationData, completion: @escaping ([LocationData]) -> Void)
    func add(data: LocationData)
    func update(data: LocationData)
    func delete(data: LocationData)
}

final class DefaultFireBaseService: FireBaseService {
    private enum Attribute {
        static let collection = "LocationData"
        static let id = "id"
        static let local = "local"
        static let subLocal = "subLocal"
    }
    
    private let fireStoreDB = Firestore.firestore().collection(Attribute.collection)
    
    func load(_ data: LocationData, completion: @escaping ([LocationData]) -> Void) {
        fireStoreDB.whereField(
            Attribute.id,
            isEqualTo: data.id
        ).getDocuments { querySnapshot, error in
            var locationData: [LocationData] = []
            
            guard error == nil else { return }
            guard let querySnapshot = querySnapshot else { return }
            
            for document in querySnapshot.documents {
                let result = self.convert(from: document)
                
                switch result {
                case .success(let data):
                    locationData.append(data)
                case .failure(_):
                    return
                }
            }
            
            completion(locationData)
        }
    }

    func add(data: LocationData) {
        fireStoreDB
            .document(data.id.description)
            .setData([
                Attribute.id: data.id,
                Attribute.local: data.locality,
                Attribute.subLocal: data.subLocality
            ])
    }
    
    func update(data: LocationData) {
        fireStoreDB
            .document(data.id.description)
            .updateData([
                Attribute.id: data.id,
                Attribute.local: data.locality,
                Attribute.subLocal: data.subLocality
            ])
    }
    
    func delete(data: LocationData) {
        fireStoreDB
            .document(data.id.description)
            .delete()
    }
    
    private func convert(from document: QueryDocumentSnapshot) -> Result<LocationData, NetworkError> {
        
        let id = document.data()[Attribute.id] as? Int ?? .zero
        let local = document.data()[Attribute.local] as? String ?? ""
        let subLocal = document.data()[Attribute.subLocal] as? String ?? ""
        
        let data = LocationData(id: id, locality: local, subLocality: subLocal)
        
        return .success(data)
    }
}
