//
//  Networking.swift
//  InventoryManagementApp
//
//  Created by Johnny on 20/10/2023.
//

import Foundation

enum HTTPError: Error {
  case invalidResponse
  case invalidStatusCode
  case requestFailed(statusCode: Int, message: String)
}

enum HTTPStatusCode: Int {
  case success = 200
  case notFound = 404
  
  var isSuccessful: Bool {
    return (200..<300).contains(rawValue)
    }
  
  var message: String {
    return HTTPURLResponse.localizedString(forStatusCode: rawValue)
    }
}

func validate(_ response: URLResponse?) throws {
    
  guard let response = response as? HTTPURLResponse else {
    throw HTTPError.invalidResponse
  }
    
  guard let status = HTTPStatusCode(rawValue: response.statusCode) else {
    throw HTTPError.invalidStatusCode
  }
    
  if !status.isSuccessful {
    throw HTTPError.requestFailed(statusCode: status.rawValue, message: status.message)
  }
}


enum NetworkError: Error {
    case failedToFetchData
}

protocol Networking {
    @discardableResult func request(url: URL, completion: @escaping (Data?, Error?) -> Void) -> URLSessionTask
}

final class NetworkManager: Networking {
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    // GET REQUEST to a URL
    @discardableResult func request(url: URL, completion: @escaping (Data?, Error?) -> Void) -> URLSessionTask {
        let task = session.dataTask(with: url) { (data, response, error) in
            do {
                print("Network Data \(data)")
//                print(String(data: data!, encoding: .utf8) ?? "Data could not be printed")
                
                try validate(response)

                guard error == nil else {
                    print("Network Error: \(String(describing: error))")
                    completion(nil, error)
                    return
                }
                
                DispatchQueue.main.async {
                    completion(data, nil)
                }
                
            }
            catch let error {
                // TODO: Catch reponse error
                completion(nil, error)
                print("Network Validation Error: \(error)")
            }
        }
        task.resume()
        
        return task
        
    }
}


