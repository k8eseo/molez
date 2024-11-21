//
//  GameScene.swift
//  Molez
//
//  Created by Joy Xiang on 11/14/24.
//

import SpriteKit
import GameplayKit


class GameScene: SKScene {
    
    fileprivate var label : SKLabelNode?
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
    var Play: SKSpriteNode?
    
    var gameModel: GameModel!
    var gameTimer: Timer?
 
    func startGame() {
        print("StartGame called") // Log when method is called
        gameModel.startGame()
        print("Game model initialized: \(gameModel.gameOver)") // Check game state
        Play?.isHidden = true
        print("Play button hidden: \(Play?.isHidden ?? false)")
        updateGameCounters()
        print("Counters updated")
        
        let randomDelay = Double(arc4random_uniform(2)) // Random delay 0-2 seconds
        run(SKAction.wait(forDuration: randomDelay)) {
            print("Spawning moles")
            self.MoleSpawner()
            self.spawnMolesRepeating()
        }
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimeAndGameCounters), userInfo: nil, repeats: true)
        print("Game timer started")
    }


      func spawnMolesRepeating() {
          let spawnInterval = 0.5
          let spawnAction = SKAction.sequence([SKAction.wait(forDuration: spawnInterval), SKAction.run {
              self.MoleSpawner()
          }])
          let repeatAction = SKAction.repeatForever(spawnAction)
          self.run(repeatAction)
      }
    
    func endGame() {
        // End the game and show the Play button
        gameTimer?.invalidate()
        gameTimer = nil
        gameModel.gameOver = true
        Play?.isHidden = false // Unhide Play button
        let moleArray = [mole1, mole2, mole4, mole3, mole5, mole6, mole7, mole8, mole9]
        
        for mole in moleArray {
            mole?.isHidden = true // Hide all moles
        }
        
        // Reset game counters
        gameModel.score = 0
        gameModel.remainingTime = gameModel.initialTime
        updateGameCounters()
        print("Game ended")
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
        if !gameModel.gameOver {  // Only spawn moles if the game is active
            let moleArray = [mole1, mole2, mole4, mole3, mole5, mole6, mole7, mole8, mole9]
            let randomMoleIndex = Int(arc4random_uniform(UInt32(moleArray.count)))
            let moleToSpawn = moleArray[randomMoleIndex]

            if let mole = moleToSpawn {
                mole.isHidden = false  // Make the mole visible
                mole.alpha = 1.0 // Ensure the mole is fully visible

                // Hide the mole after 3 seconds
                run(SKAction.wait(forDuration: 3.0)) {
                    mole.isHidden = true
                }
            }
        }
    }
    
func playMusic() {
       let music = SKAudioNode(fileNamed: "")
       music.autoplayLooped = true
      addChild(music)
   }

func playHammerEffect() {
    run(SKAction.playSoundFileNamed("", waitForCompletion: false))
   }

        class func newGameScene() -> GameScene {
            // Load 'GameScene.sks' as an SKScene.
            guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
                print("Failed to load GameScene.sks")
                abort()
            }
            
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            return scene
        }
        
    func setUpScene() {
        // Initialize the game model
        gameModel = GameModel()
        
        // Link score and time labels
        scoreLabel = self.childNode(withName: "//scoreLabel") as? SKLabelNode
        timeLabel = self.childNode(withName: "//timeLabel") as? SKLabelNode
        
        // Link mole nodes
        mole1 = self.childNode(withName: "//mole1") as? SKSpriteNode
        mole2 = self.childNode(withName: "//mole2") as? SKSpriteNode
        mole3 = self.childNode(withName: "//mole3") as? SKSpriteNode
        mole4 = self.childNode(withName: "//mole4") as? SKSpriteNode
        mole5 = self.childNode(withName: "//mole5") as? SKSpriteNode
        mole6 = self.childNode(withName: "//mole6") as? SKSpriteNode
        mole7 = self.childNode(withName: "//mole7") as? SKSpriteNode
        mole8 = self.childNode(withName: "//mole8") as? SKSpriteNode
        mole9 = self.childNode(withName: "//mole9") as? SKSpriteNode

        // Link Play button
        Play = self.childNode(withName: "//Play") as? SKSpriteNode

        // Debugging: Check if Play button is found
        if Play == nil {
            print("Play node not found in the scene!")
        } else {
            print("Play node found: \(Play?.name ?? "Unnamed")")
        }

        // Ensure Play button is visible initially
        Play?.isHidden = false
        print("Play button set up and visible: \(Play?.isHidden == false)")

        // Hide all moles at the start of the game
        let moleArray = [mole1, mole2, mole3, mole4, mole5, mole6, mole7, mole8, mole9]
        for mole in moleArray {
            mole?.isHidden = true
        }

        // Update initial game counters (score and time)
        updateGameCounters()

        // Optionally start background music
        playMusic()
    }

        
        override func didMove(to view: SKView) {
            
            self.setUpScene()
        }
        
        
        
        override func update(_ currentTime: TimeInterval) {
            // Called before each frame is rendered
        }
    }
    #if os(iOS) || os(tvOS)
    // Touch-based event handling
    extension GameScene {

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            let nodesAtLocation = self.nodes(at: location)
            
            // Check if the Play button was tapped
            if nodesAtLocation.contains(where: { $0.name == "Play" }) {
                print("Play button tapped")
                print("Play button is hidden: \(Play?.isHidden ?? true)")
                print("Game model gameOver state: \(gameModel.gameOver)")
                
                // Force visibility check
                if Play?.isHidden == false || true { // Allow game to start regardless of visibility
                    print("Forcing game start")
                    Play?.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
                    Play?.isHidden = true
                    startGame()
                } else {
                    print("Play button tap ignored due to state")
                }
            }
        }


        
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
           
        }
        
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            
        }
        
        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
            
        }
        
       
    }
    #endif
