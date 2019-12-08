//
//  ImageClient.swift
//  Concurrency
//
//  Created by Oscar Victoria Gonzalez  on 12/7/19.
//  Copyright © 2019 Oscar Victoria Gonzalez . All rights reserved.
//

import UIKit

struct ImageClient {
    
    static func fetchImage(for urlString: String,
                           completion: @escaping (Result<UIImage?, Error>) -> ()) {
        // validate it is a valid url
        guard let url = URL(string: urlString) else {
            print("bad url \(urlString)")
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // check if an error exist
            if let error = error {
                print("error: \(error)")
                // TODO: add enum error
            }
            
            // TODO: check for valid status code of 200...299
            
            // TODO: check for valid mime type of image\jpeg
            
            if let data = data {
                // use data to create an image
                let image = UIImage(data: data)
                // capture result of image
                
                completion(.success(image))
            }
        }
        dataTask.resume() // invokes network request
    }
    
}
