//
//  CardCollectionViewCell.swift
//  MemoryMatch
//
//  Created by Janice Lee on 2020-01-10.
//  Copyright © 2020 Janice Lee. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    
    func setFrontImage(_ imageURL: URL) {
        print("setting front image")
        URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            if error != nil {
                // do something
                return
            }
            
            if let data = data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.frontImageView.image = image
                }
            }
        }.resume()
    }
}
