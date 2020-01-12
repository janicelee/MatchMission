//
//  GameGridViewController.swift
//  MemoryMatch
//
//  Created by Janice Lee on 2020-01-10.
//  Copyright © 2020 Janice Lee. All rights reserved.
//

import UIKit

class GameScreenViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let cardManager = CardManager() // make the cardArray private?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardManager.setUp(reloadCollectionViewCells)

        collectionView.delegate = self
        collectionView.dataSource = self
        cardManager.delegate = self
    }
    
    func reloadCollectionViewCells() {
        print("Reloading the cells now!!!!")
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource Methods

extension GameScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print("Setting # Items in Section: \(cardManager.cardArray.count)")
        return cardManager.cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("Calling cellForItemAt")
        //print("setting up cell: \(indexPath.row)")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        let card = cardManager.cardArray[indexPath.row]
        cell.setFrontImage(card.image)
        return cell
    }
}

// MARK: - UICollectionViewDelegate Methods

extension GameScreenViewController: UICollectionViewDelegate {
    
}

// MARK: - CardManagerDelegate Methods

extension GameScreenViewController: CardManagerDelegate {
    func didFailWithError(_ error: Error) {
        //
    }
}
