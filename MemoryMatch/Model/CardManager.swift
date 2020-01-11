//
//  CardManager.swift
//  MemoryMatch
//
//  Created by Janice Lee on 2020-01-10.
//  Copyright © 2020 Janice Lee. All rights reserved.
//

import Foundation

protocol CardManagerDelegate {
    func didFailWithError(_ error: Error)
}

class CardManager {

    let urlString = "https://shopicruit.myshopify.com/admin/products.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
    var cardArray = [Card]()
    var delegate: CardManagerDelegate?
    var imageURLs = [String]()
    
    func performRequest() {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    self.delegate?.didFailWithError(error)
                    return
                }
                
                if let data = data {
                    self.parseJSON(data)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(ProductData.self, from: data)
            let products = decodedData.products
            
            for product in products {
                print(product.image.src)
                imageURLs.append(product.image.src)
            }
        } catch {
            self.delegate?.didFailWithError(error)
        }
    }
}
