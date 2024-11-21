//
//  GameScene.swift
//  Molez
//
//  Created by Joy Xiang on 11/14/24.
//

import SpriteKit
import GameplayKit


class GameScene: SKScene {
    
    fileprivate var label: SKLabelNode?
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
    var Play: SKLabelNode?
    
    var gameModel: GameModel!
    var gameTimer: Timer?
    
    var music = SKAudioNode(url: Bundle.main.url(forResource: "bgmusic", withExtension: "mp3")!)
    var soundEffect = SKAction.playSoundFileNamed("tapeffect", waitForCompletion: false)
 
    func startGame() {
        
        gameModel.startGame()
        gameModel.score = 0

        Play?.isHidden = true
        updateGameCounters()
        spawnMoles()
        runTimer()
        
        music = SKAudioNode(url: Bundle.main.url(forResource: "bgmusic", withExtension: "mp3")!)
        addChild(music)
    }
    
    func spawnMoles() {
        let randomDelay = Double(arc4random_uniform(2))
        run(SKAction.wait(forDuration: randomDelay)) {
            self.MoleSpawner()
            self.spawnMolesRepeating()
        }
    }
    
    func runTimer() {
        gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimeAndGameCounters), userInfo: nil, repeats: true)
        RunLoop.main.add(gameTimer!, forMode: .common)
    }


    func spawnMolesRepeating() {
        let spawnInterval = 0.5
        let spawnAction = SKAction.sequence([SKAction.wait(forDuration: spawnInterval), SKAction.run {
            self.MoleSpawner()
        }])
        let repeatAction = SKAction.repeatForever(spawnAction)
        self.run(repeatAction, withKey: "MoleSpawning")
    }

    func endGame() {
        gameTimer?.invalidate()
        gameTimer = nil
        gameModel.gameOver = true
        Play?.isHidden = false // Show Play button

        let moleArray = [mole1, mole2, mole3, mole4, mole5, mole6, mole7, mole8, mole9]
        for mole in moleArray {
            mole?.isHidden = true // Hide all moles
        }
        
        music.removeFromParent()

        gameModel.remainingTime = gameModel.initialTime
        updateGameCounters()
    }

    
    func updateGameCounters() {
        scoreLabel?.fontName = "Impact"
        timeLabel?.fontName = "Impact"
        
        scoreLabel?.text = "Score: \(gameModel.score)"
        timeLabel?.text = "Time: \(gameModel.remainingTime)"
    }
    
    @objc func updateTimeAndGameCounters() {
        gameModel.updateTime()
        updateGameCounters()
        if gameModel.gameOver {
            endGame()
        }
    }

    func MoleSpawner() {
        if !gameModel.gameOver {
            let moleArray = [mole1, mole2, mole3, mole4, mole5, mole6, mole7, mole8, mole9]
            let randomMoleIndex = Int(arc4random_uniform(UInt32(moleArray.count)))
            let moleToSpawn = moleArray[randomMoleIndex]

            if let mole = moleToSpawn {
                mole.isHidden = false
                mole.alpha = 1.0

                // Hide the mole after 3 seconds
                run(SKAction.wait(forDuration: 3.0)) {
                    mole.isHidden = true
                }
            }
        }
    }

    class func newGameScene() -> GameScene {
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        scene.scaleMode = .aspectFill
        return scene
    }

    func setUpScene() {
        gameModel = GameModel()
        
        // Link score and time labels
        scoreLabel = self.childNode(withName: "//scoreLabel") as? SKLabelNode
        timeLabel = self.childNode(withName: "//timeLabel") as? SKLabelNode
        
        // Link Play button (corrected type)
        Play = self.childNode(withName: "//Play") as? SKLabelNode

        // Link moles
        mole1 = self.childNode(withName: "//mole1") as? SKSpriteNode
        mole2 = self.childNode(withName: "//mole2") as? SKSpriteNode
        mole3 = self.childNode(withName: "//mole3") as? SKSpriteNode
        mole4 = self.childNode(withName: "//mole4") as? SKSpriteNode
        mole5 = self.childNode(withName: "//mole5") as? SKSpriteNode
        mole6 = self.childNode(withName: "//mole6") as? SKSpriteNode
        mole7 = self.childNode(withName: "//mole7") as? SKSpriteNode
        mole8 = self.childNode(withName: "//mole8") as? SKSpriteNode
        mole9 = self.childNode(withName: "//mole9") as? SKSpriteNode

        // Hide all moles
        let moleArray = [mole1, mole2, mole3, mole4, mole5, mole6, mole7, mole8, mole9]
        for mole in moleArray {
            mole?.isHidden = true
        }

        updateGameCounters()
    }
    
    func handleMoleTap(_ mole: SKSpriteNode) {
        gameModel.score += 1
        mole.run(soundEffect)
        updateGameCounters()
        mole.isHidden = true
    }

    override func didMove(to view: SKView) {
        self.setUpScene()
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodesAtLocation = self.nodes(at: location)
        
        // Check if a mole was tapped
        let moleArray = [mole1, mole2, mole3, mole4, mole5, mole6, mole7, mole8, mole9]
        if let tappedMole = nodesAtLocation.first(where: { moleArray.contains($0 as? SKSpriteNode) }) as? SKSpriteNode {
            handleMoleTap(tappedMole)
            return
        }
            if nodesAtLocation.contains(where: { $0.name == "Play" }) {
            if Play?.isHidden == false && gameModel.gameOver {
                Play?.isHidden = true
                startGame()
            }
        }
    }
}
#endif
