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
    
 
    
   func startGame() {
    gameModel.startGame()
    Play?.isHidden = true
        print("Game started")
      updateGameCounters()
       let randomDelay = Double(arc4random_uniform(2) + 0) // Random delay 0- 2 seconds
          run(SKAction.wait(forDuration: randomDelay)) {
              self.MoleSpawner()
              self.spawnMolesRepeating()
          }
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
      gameModel.gameOver = true
     Play?.isHidden = false
    let moleArray = [mole1, mole3, mole5, mole6, mole7, mole8, mole9]
        for mole in moleArray {
            mole?.isHidden = true
        }}
    
func updateGameCounters() {
       scoreLabel?.fontName = "Impact"
       timeLabel?.fontName = "Impact"
        
       scoreLabel?.text = "Score: \(gameModel.score)"
       timeLabel?.text = "Time: \(gameModel.remainingTime)"
}
    
    func MoleSpawner(){
        let moleArray = [mole1, mole2,mole4, mole3, mole5, mole6, mole7, mole8, mole9]
            let randomMoleIndex = Int(arc4random_uniform(UInt32(moleArray.count)))
            let moleToSpawn = moleArray[randomMoleIndex]

            if let mole = moleToSpawn {
                mole.isHidden = false  // Make the mole visible
                mole.alpha = 1.0 // Ensure the mole is fully visible

                // Hide the mole after 3 seconds
                run(SKAction.wait(forDuration: 3.0)) {
                    mole.isHidden = true
                }
            }    }
    
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
            // Get label node from scene and store it for use later
            self.label = self.childNode(withName: "//Play") as? SKLabelNode
            gameModel = GameModel()
                 
              self.scoreLabel = self.childNode(withName: "//scoreLabel") as? SKLabelNode
              self.timeLabel = self.childNode(withName: "//timeLabel") as? SKLabelNode
            self.mole1 = self.childNode(withName: "//mole1") as? SKSpriteNode
            self.mole2 = self.childNode(withName: "//mole2") as? SKSpriteNode
            self.mole4 = self.childNode(withName: "//mole4") as? SKSpriteNode
            self.mole3 = self.childNode(withName: "//mole3") as? SKSpriteNode
              self.mole5 = self.childNode(withName: "//mole5") as? SKSpriteNode
        self.mole6 = self.childNode(withName: "//mole6") as? SKSpriteNode
            self.mole7 = self.childNode(withName: "//mole7") as? SKSpriteNode
               self.mole8 = self.childNode(withName: "//mole8") as? SKSpriteNode
               self.mole9 = self.childNode(withName: "//mole9") as? SKSpriteNode
              self.Play = self.childNode(withName: "//Play") as? SKSpriteNode
            let moleArray = [mole1, mole2, mole4, mole3, mole5, mole6, mole7, mole8, mole9]
                for mole in moleArray {
                    mole?.isHidden = true
                }
            Play?.isHidden = false
            updateGameCounters()
                playMusic()
                 
               Play?.isHidden = false
            
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
            if let label = self.label {
               
                
                if Play?.isHidden != false{
                    label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
                    Play?.isHidden = true
                    startGame()
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

    
    
    
    
    
//}
