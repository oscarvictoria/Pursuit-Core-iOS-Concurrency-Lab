//
//  NetworkHelper.swift
//  Concurrency
//
//  Created by Oscar Victoria Gonzalez  on 12/7/19.
//  Copyright © 2019 Oscar Victoria Gonzalez . All rights reserved.
//

import Foundation

enum AppError: Error {
    case badURL(String) // associated value
    case noResponse
    case networkClientError(Error)
    case noData
    case decodingError(Error)
    case badStatusCode(Int) // 404 / 500
    case badMimeType(String) // image/jpg
}



class NetworkHelper {
    
    // We will create a shared instance of the NetworkHelper
    // This is the only place where the instance is created to be able to use everywhere
    static let shared = NetworkHelper()
    // We need to give it a value in the private init(), with a default value for configuration.
    private var session: URLSession
    // We will make the default inittializer private
    // required in order to be considered a singleton
    // also forbids anyone from creating an instance of NetworkHelper
    
    private init() {
        session = URLSession(configuration: .default)
    }
    
    func performDataTask(with urlString: String, completion: @escaping(Result<Data, AppError>) -> ()) {
        
        guard let url = URL(string: urlString) else {
            // handle bad url error case
            completion(.failure(.badURL(urlString)))
            return
        }
        
        // Two states on dataTask, resume() and suspended by default
        // suspended simply won't perform network request
        // this ultimately leads to debugging error and time lost if
        // you dont't explicitly resume() request
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            // 1. Here we check for client network error
            if let error = error {
                completion(.failure(.networkClientError(error)))
            }
            // 2. Downcast URLResponse (response) to HTTPURLResponse to
            // get access to the statusCode property on HTTPURLResponse
            guard let urlResponse = response as? HTTPURLResponse else {
                completion(.failure(.noResponse))
                return
            }
            // 3. Unwrap the data onject
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            // 4. Validate that the status code is in the 200 range otherwise it's a bad status code
            
            switch urlResponse.statusCode {
            case 200...299: break
            default:
                completion(.failure(.badStatusCode(urlResponse.statusCode)))
                return
            }
            
            // 5. Capture data as success case
            completion(.success(data))
            
            
        }
        dataTask.resume()
        
    }
}
