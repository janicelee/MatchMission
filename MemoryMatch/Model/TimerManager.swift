//
//  TimerManager.swift
//  MemoryMatch
//
//  Created by Janice Lee on 2020-01-16.
//  Copyright © 2020 Janice Lee. All rights reserved.
//

import Foundation

protocol TimerManagerDelegate {
    func updateTimeElapsed(_ timeElapsed: String)
}

class TimerManager {
    private var timer = Timer()
    private var secondsElapsed: Float = 0.00
    
    var delegate: TimerManagerDelegate? 
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimeElapsed), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimeElapsed() {
        secondsElapsed += 0.01
        delegate?.updateTimeElapsed(getTimeElapsed())
    }
    
    func invalidateTimer() {
        timer.invalidate()
    }
    
    func getTimeElapsed() -> String{
        return String(format: "%.2f", secondsElapsed)
    }
}
