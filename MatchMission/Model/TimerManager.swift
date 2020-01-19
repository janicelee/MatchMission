//
//  TimerManager.swift
//  MatchMission
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
    private var secondsElapsed: Float = 0.0
    
    var delegate: TimerManagerDelegate? 

    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimeElapsed), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    func getTimeElapsed() -> String{
        return String(format: "%.1f", secondsElapsed)
    }

    @objc func updateTimeElapsed() {
        secondsElapsed += 0.1
        delegate?.updateTimeElapsed(getTimeElapsed())
    }
}
