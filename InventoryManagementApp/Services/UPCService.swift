//
//  UPCService.swift
//  InventoryManagementApp
//
//  Created by Johnny on 20/10/2023.
//

import Foundation

struct UPCResponse: Codable {
    let code: String
    let total: Int
    let offset: Int
    let items: [Item]
    
    struct Item: Codable {
        let brand: String
        let title: String
        let description: String
        let upc: String
        let color: String
        let images: [String]
        
    }
}

class UPCService {
    let networkManager: Networking
    
    init(networkManager: Networking = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func fetchItemByUPC(_ upcCode: String, completion: @escaping (UPCResponse.Item?, Error?) -> Void) {
        let urlString = "https://api.upcitemdb.com/prod/trial/lookup?upc=\(upcCode)"
        
        guard let url = URL(string: urlString) else {
            completion(nil, NetworkError.failedToFetchData)
            return
        }
        
        networkManager.request(url: url) { (data, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NetworkError.failedToFetchData)
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(UPCResponse.self, from: data)
                print("UPC DATA")
                print(decoded)
                completion(decoded.items[0], nil)
            } catch let jsonError {
                completion(nil, jsonError)
            }
        }
    }
}
