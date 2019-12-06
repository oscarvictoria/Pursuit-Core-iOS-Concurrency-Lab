//
//  CountryAPIClient.swift
//  Concurrency
//
//  Created by Oscar Victoria Gonzalez  on 12/6/19.
//  Copyright © 2019 Oscar Victoria Gonzalez . All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case badURL(String)
    case networkClientError(Error)
    case noResponse
    case noData
    case badStatusCode(Int)
    case decodingError(Error)
}

struct CountryAPIClient {
    static func getCountries(completion: @escaping (Result<[Country], NetworkError>)-> ()) {
        
        let endpointURL = "https://restcountries.eu/rest/v2/name/united"
        guard let url = URL(string: endpointURL) else {
            completion(.failure(.badURL(endpointURL)))
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) {(data, response, error) in
            if let error = error {
                completion(.failure(.networkClientError(error)))
                
            }
            
            guard let urlResponse = response as? HTTPURLResponse else {
                completion(.failure(.noResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            switch urlResponse.statusCode {
            case 200...299: break
            default: completion(.failure(.badStatusCode(urlResponse.statusCode)))
            }
            
            do {
                let country = try JSONDecoder().decode([Country].self, from: data)
                completion(.success(country))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        dataTask.resume()
    }
}
