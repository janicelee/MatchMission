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
    var faceUpCardIndexA: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardManager.setUp(reloadCollectionViewCells)

        collectionView.delegate = self
        collectionView.dataSource = self
        cardManager.delegate = self
    }
    
    func reloadCollectionViewCells() {
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension GameScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardManager.cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        let card = cardManager.cards[indexPath.row]
        cell.setCard(card)
        cell.layer.borderColor = UIColor.red.cgColor
        cell.layer.borderWidth = 1
        cell.backgroundColor = UIColor.white
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension GameScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numCardsPerRow = CGFloat(cardManager.cards.count / 5)
        let emptySpacePerRow = CGFloat((numCardsPerRow - 1) * 10)
        let width = (collectionView.frame.size.width - emptySpacePerRow) / 4
        let height = width
        return CGSize(width: width, height: height)
    }
}

// MARK: - UICollectionViewDelegate

extension GameScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        // Retrieve card from either the cell or cardManager.cardArray[indexpath.row]
        if let card = cell.card {
            if !card.isFaceUp && !card.isMatched {
                card.isFaceUp = true
                cell.flipUp()
                
                if faceUpCardIndexA == nil {
                    faceUpCardIndexA = indexPath
                } else {
                    checkForMatch(indexPath)
                }
            }
        }
    }
    
    func checkForMatch(_ faceUpCardIndexB: IndexPath) {
        let cellA = collectionView.cellForItem(at: faceUpCardIndexA!) as! CardCollectionViewCell
        let cellB = collectionView.cellForItem(at: faceUpCardIndexB) as! CardCollectionViewCell
        
        let cardA = cardManager.cards[faceUpCardIndexA!.row]
        let cardB = cardManager.cards[faceUpCardIndexB.row]
        
        if cardA.imageURL == cardB.imageURL {
            cardA.isMatched = true
            cardB.isMatched = true
            
            cellA.Hide()
            cellB.Hide()
            gameShouldEnd()
        } else {
            cardA.isFaceUp = false
            cardB.isFaceUp = false
            
            cellA.flipDown()
            cellB.flipDown()
        }
        faceUpCardIndexA = nil
    }
    
    func gameShouldEnd() {
        if cardManager.allCardsMatched() {
            showAlert("Mission Complete", "You found all matching pairs!")
        } else {
            return
        }
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Return to main menu", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
        
    }
}

// MARK: - CardManagerDelegate

extension GameScreenViewController: CardManagerDelegate {
    func didFailWithError(_ error: Error) {
        //
    }
}


