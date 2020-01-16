//
//  ViewController.swift
//  MemoryMatch
//
//  Created by Janice Lee on 2020-01-10.
//  Copyright © 2020 Janice Lee. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController {

    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPlayButtonAppearance()
    }
    
    private func setPlayButtonAppearance() {
        playButton.layer.borderColor = UIColor.white.cgColor
        playButton.layer.borderWidth = 4
        playButton.layer.cornerRadius = 4
        
        if let superview = playButton.superview {
            let width = superview.frame.size.width * 0.6

            playButton.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }

    @IBAction func playButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToGameScreen", sender: self)
    }
    
}

