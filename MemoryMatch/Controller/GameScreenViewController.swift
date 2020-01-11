//
//  GameGridViewController.swift
//  MemoryMatch
//
//  Created by Janice Lee on 2020-01-10.
//  Copyright © 2020 Janice Lee. All rights reserved.
//

import UIKit

class GameScreenViewController: UIViewController {
    
    let cardManager = CardManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardManager.performRequest()
    }
}
