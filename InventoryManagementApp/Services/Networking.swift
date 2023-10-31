//
//  Networking.swift
//  InventoryManagementApp
//
//  Created by Johnny on 20/10/2023.
//

import Foundation

enum HTTPError: Error {
  case invalidResponse // sends an invalidResponse
  case invalidStatusCode // If the status code cannot be recognised it will run the InvalidStatusCode
  case requestFailed(statusCode: Int, message: String)// Creates a requestFailed which contains both the statuscode and a message to user/developer
}

enum HTTPStatusCode: Int {
  case success = 200 // success status code requested
  case notFound = 404 // status code could not be found
  
  var isSuccessful: Bool { // assess to see if the status code request was sucessful
    return (200..<300).contains(rawValue)
    }
  
  var message: String {
    return HTTPURLResponse.localizedString(forStatusCode: rawValue)
    }
}
// This validates that URLResponse object
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


enum NetworkError: Error { // This enum is there for other network errors that are outside other cases
    case failedToFetchData
}

protocol Networking {
    @discardableResult func request(url: URL, completion: @escaping (Data?, Error?) -> Void) -> URLSessionTask // This get request is to a URL that should return the URLSessionTask
}

final class NetworkManager: Networking { // Networking Protocol
    private let session: URLSession // This instance is used to make the network requests
    
    init(session: URLSession = URLSession.shared) { // Initialiser that manages the URLSession object
        self.session = session
    }
    
    // GET REQUEST to a URL
    @discardableResult func request(url: URL, completion: @escaping (Data?, Error?) -> Void) -> URLSessionTask {
        let task = session.dataTask(with: url) { (data, response, error) in
            do {
                print("Network Data \(String(describing: data))")
//                print(String(data: data!, encoding: .utf8) ?? "Data could not be printed")
                
                try validate(response) // Validates HTTP reponse

                guard error == nil else {
                    print("Network Error: \(String(describing: error))")
                    completion(nil, error)
                    return
                }
                
                DispatchQueue.main.async { // Execution of completion handler
                    completion(data, nil)
                }
                
            }
            catch let error {
                // TODO: Catch reponse error
                completion(nil, error)
                print("Network Validation Error: \(error)")
            }
        }
        task.resume() // start network request
        
        return task
        
    }
}


