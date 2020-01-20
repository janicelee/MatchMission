//
//  GameScreenViewController.swift
//  MatchMission
//
//  Created by Janice Lee on 2020-01-10.
//  Copyright © 2020 Janice Lee. All rights reserved.
//

import UIKit

class GameScreenViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    let cardManager = CardManager()
    let timerManager = TimerManager()
    
    var lastFaceUpIndexPath: IndexPath?
    var numCardsPerRow = 4
    var pairsFound = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        timerManager.delegate = self
        cardManager.delegate = self
        
        setupGame()
    }
    
    // MARK: - Game Logic
    
    func setupGame() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        updateScoreLabel()
        cardManager.setup(startGame)
    }
    
    func startGame() {
        collectionView.reloadData()
        activityIndicator.stopAnimating()
        timerManager.startTimer()
    }
    
    func checkForMatch(_ currentIndexPath: IndexPath) {
        let cellA = collectionView.cellForItem(at: lastFaceUpIndexPath!) as! CardCollectionViewCell
        let cellB = collectionView.cellForItem(at: currentIndexPath) as! CardCollectionViewCell
       
        let cardA = cardManager.getCard(lastFaceUpIndexPath!.row)
        let cardB = cardManager.getCard(currentIndexPath.row)
        
        let isMatch = cardManager.checkCardsMatch(cardA, cardB)
        
        if isMatch {
            pairsFound += 1
            updateScoreLabel()
            cellA.hide()
            cellB.hide()
            
            if cardManager.allCardsMatched() {
                endGame()
            }
        } else {
            cellA.flipDown()
            cellB.flipDown()
        }
        lastFaceUpIndexPath = nil
    }
    
    func endGame() {
        timerManager.stopTimer()
        
        let timeElasped = timerManager.getTimeElapsed()
        let action = UIAlertAction(title: "Main Menu", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        showAlert(title: "Mission Complete", message: "Found all matching pairs in \(timeElasped)s!", actions: [action])
    }

    // MARK: - UI Updates
    func updateScoreLabel() {
        scoreLabel.text = "\(pairsFound)/10"
    }
    
    func showAlert(title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for action in actions {
            alert.addAction(action)
        }
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Event Handlers
    @IBAction func backButtonPressed(_ sender: UIButton) {
        timerManager.stopTimer()
        let yesAction = UIAlertAction(title: "Main Menu", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        let noAction = UIAlertAction(title: "Continue Mission", style: .default) { (action) in
            self.timerManager.startTimer()
        }
        showAlert(title: "Return to Main Menu?", message: "Your mission progress will be erased", actions: [yesAction, noAction])
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
        cell.setFrontImageView(card.getImage())
        cell.setAppearance()
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension GameScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        let card = cardManager.getCard(indexPath.row)
        
        if !card.getIsFaceUp() && !card.getIsMatched() {
            card.setIsFaceUp(to: true)
            cell.flipUp()
            
            if lastFaceUpIndexPath == nil {
                lastFaceUpIndexPath = indexPath
            } else {
                checkForMatch(indexPath)
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension GameScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let emptySpacePerRow = CGFloat((numCardsPerRow - 1) * 10)
        let x = ((collectionView.frame.size.width - emptySpacePerRow) / CGFloat(numCardsPerRow)).rounded(.down)
        return CGSize(width: x, height: x)
    }
}

// MARK: - CardManagerDelegate

extension GameScreenViewController: CardManagerDelegate {
    func didFailWithError(_ error: Error, _ msg: String) {
        DispatchQueue.main.async {
            let action = UIAlertAction(title: "Main Menu", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            self.showAlert(title: "BEEP BOOP", message: "Robots cannot make it to mission control, please try again later", actions: [action])
        }
        print(msg)
    }
}

// MARK: - TimerManagerDelegate

extension GameScreenViewController: TimerManagerDelegate {
    func updateTimeElapsed(_ timeElapsed: String) {
        timerLabel.text = "\(timeElapsed)"
    }
}

