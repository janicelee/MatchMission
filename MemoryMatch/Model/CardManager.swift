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
    var imageURLs = [URL]()
    
    
    // TODO: throw error?
    func generateCards() {
        guard imageURLs.count >= 10 else { return }
        imageURLs = imageURLs.shuffled()
        
        for i in 0..<10 {
            cardArray.append(Card(imageURLs[i]))
            cardArray.append(Card(imageURLs[i]))
        }
        cardArray = cardArray.shuffled()
    }
    
    // MARK: - Networking Methods
    
    func setUp() {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                
                if let data = data {
                    self.parseJSON(data)
                    self.generateCards()
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
                if let url = URL(string: product.image.src) {
                    imageURLs.append(url)
                }
            }
        } catch {
            self.delegate?.didFailWithError(error)
        }
    }
}
