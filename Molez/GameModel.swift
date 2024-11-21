//
//  GameModel.swift
//  Molez
//
//  Created by Joy Xiang on 11/14/24.
//

import Foundation

class GameModel {
    var score: Int
    var remainingTime: Int
    var gameOver: Bool
    
    let initialTime = 15
    
    init() {
        self.score = 0
        self.remainingTime = initialTime
        self.gameOver = true
    }
    
    func startGame() {
        score = 0
        remainingTime = initialTime
        gameOver = false
    }
    
    func updateTime() {
        if remainingTime > 0 {
            remainingTime -= 1
        }
        
        if remainingTime == 0 {
            gameOver = true
        }
    }
}
