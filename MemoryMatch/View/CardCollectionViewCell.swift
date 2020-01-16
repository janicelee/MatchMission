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
    
    var card: Card?
    
    func setCard(_ card: Card) {
        self.card = card
        frontImageView.image = card.getImage()
    }
    
    func setAppearence() {
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        self.backgroundColor = UIColor.clear
    }
    
    func flipUp() {
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.2, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
    }
    
    func flipDown() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.2, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
    }
    
    func Hide() {
        backImageView.alpha = 0
        
        UIView.animate(withDuration: 0.2, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
            self.layer.borderWidth = 0
            self.backgroundColor = UIColor.clear
        }, completion: nil)
    }
    
}
