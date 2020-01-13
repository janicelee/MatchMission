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
    
    func setFrontImage(_ image: UIImage) {
        frontImageView.image = image
        backImageView.alpha = 0
    }
}
