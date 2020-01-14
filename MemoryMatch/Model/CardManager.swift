//
//  CardManager.swift
//  MemoryMatch
//
//  Created by Janice Lee on 2020-01-10.
//  Copyright © 2020 Janice Lee. All rights reserved.
//

import UIKit

protocol CardManagerDelegate {
    func didFailWithError(_ error: Error)
}

class CardManager {

    private let urlString = "https://shopicruit.myshopify.com/admin/products.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
    public var cardArray = [Card]()
    public var delegate: CardManagerDelegate?
    
    // MARK: - Networking Methods
    
    func setUp(_ onComplete: @escaping () -> ()) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                
                if let data = data {
                    let imageURLs = self.getImageURLs(data)
                    self.generateCards(with: imageURLs, onComplete)
                }
            }
            task.resume()
        }
    }
    
    private func getImageURLs(_ data: Data) -> [URL] {
        let decoder = JSONDecoder()
        var imageURLs = [URL]()

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
        return imageURLs
    }
    
    // TODO: throw error?
    private func generateCards(with imageURLs: [URL], _ onComplete: @escaping () -> ()) {
        guard imageURLs.count >= 10 else { return }
        let shuffledImageURLs = imageURLs.shuffled()
        let group = DispatchGroup()
        
        for i in 0..<10 {
            group.enter()
            URLSession.shared.dataTask(with: shuffledImageURLs[i]) { (data, response, error) in
                if error != nil {
                    // TODO
                }
                
                if let data = data {
                    if let resultImage = UIImage(data: data) {
                        // On success, create a Card with this image, append to cardArray
                        self.cardArray.append(Card(resultImage, shuffledImageURLs[i]))
                        self.cardArray.append(Card(resultImage, shuffledImageURLs[i]))
                        group.leave()
                    }
                }
            }.resume()
        }
        
        group.notify(queue: .main) {
            self.cardArray = self.cardArray.shuffled()
            onComplete()
        }
    }
}
