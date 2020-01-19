//
//  ViewController.swift
//  MatchMission
//
//  Created by Janice Lee on 2020-01-10.
//  Copyright © 2020 Janice Lee. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController {

    @IBOutlet weak var playButton: UIButton!
    
    let borderWidth: CGFloat = 4
    let cornerRadius: CGFloat = 4
    let playButtonSizePercentage: CGFloat = 0.66
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPlayButtonAppearance()
    }
    
    private func setPlayButtonAppearance() {
        playButton.layer.borderColor = UIColor.white.cgColor
        playButton.layer.borderWidth = borderWidth
        playButton.layer.cornerRadius = cornerRadius
        
        if let superview = playButton.superview {
            let width = superview.frame.size.width * 0.66
            playButton.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }

    @IBAction func playButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToGameScreen", sender: self)
    }
    
}

