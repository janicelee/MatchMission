//
//  CardCollectionViewCell.swift
//  MatchMission
//
//  Created by Janice Lee on 2020-01-10.
//  Copyright © 2020 Janice Lee. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    
    let borderColor = UIColor.white.cgColor
    let borderWidth: CGFloat = 4
    let cornerRadius: CGFloat = 4
    let flipDuration = 0.2
    let delayDuration = 0.5
    
    func setFrontImageView(_ image: UIImage) {
        frontImageView.image = image
    }
    
    func setAppearance() {
        self.backgroundColor = UIColor.clear
        
        frontImageView.layer.borderColor = borderColor
        frontImageView.layer.borderWidth = borderWidth
        frontImageView.layer.cornerRadius = cornerRadius
        
        backImageView.layer.borderColor = borderColor
        backImageView.layer.borderWidth = borderWidth
        backImageView.layer.cornerRadius = cornerRadius
    }
    
    func flipUp() {
        UIView.transition(from: backImageView, to: frontImageView, duration: flipDuration, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
    }
    
    func flipDown() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayDuration) {
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: self.flipDuration, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
    }
    
    func hide() {
        backImageView.alpha = 0
        
        UIView.animate(withDuration: flipDuration, delay: delayDuration, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
            self.layer.borderWidth = 0
            self.backgroundColor = UIColor.clear
        }, completion: nil)
    }
    
}
