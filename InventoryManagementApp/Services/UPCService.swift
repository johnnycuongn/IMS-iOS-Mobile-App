//
//  UPCService.swift
//  InventoryManagementApp
//
//  Created by Johnny on 20/10/2023.
//

import Foundation

struct UPCResponse: Codable { // This structure is what constants will be returned from the API
    let code: String
    let total: Int
    let offset: Int
    let items: [Item]
    // This is all the UPC attributes
    struct Item: Codable {
        let brand: String
        let title: String
        let description: String
        let upc: String
        let color: String
        let images: [String]
        
    }
}

class UPCService { // This class is in charge of the API
    let networkManager: Networking
    
    init(networkManager: Networking = NetworkManager()) { // Uses network Manager to initialise the UPCservice
        self.networkManager = networkManager
    }
    
    func fetchItemByUPC(_ upcCode: String, completion: @escaping (UPCResponse.Item?, Error?) -> Void) { // fetching the information from the UPC database
        let urlString = "https://api.upcitemdb.com/prod/trial/lookup?upc=\(upcCode)" // URL with the UPC code
        
        guard let url = URL(string: urlString) else {
            completion(nil, NetworkError.failedToFetchData) // good error handling to ensure that the URL is valid
            return
        }
        
        networkManager.request(url: url) { (data, error) in // runs the network request using the URL
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NetworkError.failedToFetchData) //error handling
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(UPCResponse.self, from: data) // decoded the data retrieved into a UPCResponse
                print("UPC DATA")
                print(decoded)
                completion(decoded.items[0], nil)
            } catch let jsonError {
                completion(nil, jsonError) // error handling for JSON coding errors 
            }
        }
    }
}
