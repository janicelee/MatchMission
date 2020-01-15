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
    @IBOutlet weak var scoreLabel: UILabel!
    
    let cardManager = CardManager() // make the cardArray private?
    var faceUpCardIndexA: IndexPath?
    var pairsFound = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardManager.setUp(reloadCollectionViewCells)

        collectionView.delegate = self
        collectionView.dataSource = self
        cardManager.delegate = self
        
        updateScoreLabel()
    }
    
    func reloadCollectionViewCells() {
        collectionView.reloadData()
    }
    
    // MARK: - Game Logic
    
    func checkForMatch(_ faceUpCardIndexB: IndexPath) {
        let cellA = collectionView.cellForItem(at: faceUpCardIndexA!) as! CardCollectionViewCell
        let cellB = collectionView.cellForItem(at: faceUpCardIndexB) as! CardCollectionViewCell
        
        let cards = cardManager.getCards()
        
        let cardA = cards[faceUpCardIndexA!.row]
        let cardB = cards[faceUpCardIndexB.row]
        
        if cardA.getImageURL() == cardB.getImageURL() {
            cardA.setIsMatched(to: true)
            cardB.setIsMatched(to: true)
            
            pairsFound += 1
            updateScoreLabel()
            
            cellA.Hide()
            cellB.Hide()
            gameShouldEnd()
        } else {
            cardA.setIsFaceUp(to: false)
            cardB.setIsFaceUp(to: false)
            
            cellA.flipDown()
            cellB.flipDown()
        }
        faceUpCardIndexA = nil
    }
    
    func gameShouldEnd() {
        if cardManager.allCardsMatched() {
            showAlert(title: "Mission Complete", message: "You found all matching pairs!", actionTitle: "Main Menu")
        } else {
            return
        }
    }
    
    // MARK: - UI Updates
    func updateScoreLabel() {
        scoreLabel.text = "\(pairsFound) out of 10"
    }
    
    func showAlert(title: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: actionTitle, style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        showAlert(title: "Return to Main Menu?", message: "You will lose your progress", actionTitle: "Main Menu")
    }
    
}

// MARK: - UICollectionViewDataSource

extension GameScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardManager.getCards().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        let card = cardManager.getCards()[indexPath.row]
        cell.setCard(card)
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 1
        cell.backgroundColor = UIColor.white
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension GameScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numCardsPerRow = CGFloat(cardManager.getCards().count / 5)
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
            if !card.getIsFaceUp() && !card.getIsMatched() {
                card.setIsFaceUp(to: true)
                cell.flipUp()
                
                if faceUpCardIndexA == nil {
                    faceUpCardIndexA = indexPath
                } else {
                    checkForMatch(indexPath)
                }
            }
        }
    }
}

// MARK: - CardManagerDelegate

extension GameScreenViewController: CardManagerDelegate {
    func didFailWithError(_ error: Error) {
        //
    }
}



