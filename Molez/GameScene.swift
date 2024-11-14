//
//  GameScene.swift
//  Molez
//
//  Created by Joy Xiang on 11/14/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var scoreLabel: SKLabelNode?
    var timeLabel: SKLabelNode?
    var mole1: SKSpriteNode?
    var mole2: SKSpriteNode?
    var mole3: SKSpriteNode?
    var mole4: SKSpriteNode?
    var mole5: SKSpriteNode?
    var mole6: SKSpriteNode?
    var mole7: SKSpriteNode?
    var mole8: SKSpriteNode?
    var mole9: SKSpriteNode?
    var startButton: SKSpriteNode?
    
    var gameModel: GameModel!
    
    override func didMove(to view: SKView) {
        gameModel = GameModel()
        
        self.scoreLabel = self.childNode(withName: "//scoreLabel") as? SKLabelNode
        self.timeLabel = self.childNode(withName: "//timeLabel") as? SKLabelNode
        self.mole1 = self.childNode(withName: "//mole1") as? SKSpriteNode
        self.mole2 = self.childNode(withName: "//mole2") as? SKSpriteNode
        self.mole3 = self.childNode(withName: "//mole3") as? SKSpriteNode
        self.mole4 = self.childNode(withName: "//mole4") as? SKSpriteNode
        self.mole5 = self.childNode(withName: "//mole5") as? SKSpriteNode
        self.mole6 = self.childNode(withName: "//mole6") as? SKSpriteNode
        self.mole7 = self.childNode(withName: "//mole7") as? SKSpriteNode
        self.mole8 = self.childNode(withName: "//mole8") as? SKSpriteNode
        self.mole9 = self.childNode(withName: "//mole9") as? SKSpriteNode
        self.startButton = self.childNode(withName: "//startButton") as? SKSpriteNode

        updateGameCounters()
        playMusic()
        
        startButton?.isHidden = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if let node = self.nodes(at: location).first as? SKSpriteNode, node == startButton {
                startGame()
            }
        }
    }
    
    func startGame() {
        gameModel.startGame()
        startButton?.isHidden = true
        
        updateGameCounters()
    }
    
    func endGame() {
        gameModel.gameOver = true
        startButton?.isHidden = false
    }
    
    func updateGameCounters() {
        scoreLabel?.fontName = "Impact"
        timeLabel?.fontName = "Impact"
        
        scoreLabel?.text = "Score: \(gameModel.score)"
        timeLabel?.text = "Time: \(gameModel.remainingTime)"
    }
    
    func playMusic() {
        let music = SKAudioNode(fileNamed: "")
        music.autoplayLooped = true
        addChild(music)
    }

    func playHammerEffect() {
        run(SKAction.playSoundFileNamed("", waitForCompletion: false))
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
