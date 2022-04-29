//
//  MainControls.swift
//  wwdc22
//
//  Created by Paulo César on 05/04/22.
//

import SpriteKit
import SwiftUI

class MainControls: SKScene, Timer {
    
    var feedback: UIImpactFeedbackGenerator? = nil
    
    var enemies: [Enemy] = []
    var backgroundMusic = SKAudioNode()
    var hardMode = UserDefaults.standard.bool(forKey: "HardMode")
    var nextScene: SceneManager.AvailableScenes? = nil
    var isGameActive = false
    var totalScore = 0  // x > 5k = Excellent // 2.5k < x < 5k = Good // 2.5k > x = Bad
    
    private let enemyTimeLimit: TimeInterval = 3   // 3     Seconds
    private let levelTimeLimit: TimeInterval = 40  // 40    Seconds
    var countdownBeforeStart: TimeInterval = 3     // 3     Seconds
    let cdLabel = SKLabelNode()
    
    var timer: SKShapeNode = SKShapeNode(circleOfRadius: 50)
    var timerLabel: SKLabelNode = SKLabelNode()
    let scoreLabel = SKLabelNode()
    let scoreSprite = SKSpriteNode()
    
    var lastUsedSpawnPattern = -1
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor(red: 0.463, green: 0.831, blue: 0.945, alpha: 1)
        self.view?.ignoresSiblingOrder = true
        feedback? = UIImpactFeedbackGenerator(style: .light)
        
        //enableDebug()
        setupScoreLabel()
        setupTimer()
        countdownBeforeGameStart()
    }
    
    @objc static public override var supportsSecureCoding: Bool {
        // SKNode conforms to NSSecureCoding, so any subclass going
        // through the decoding process must support secure coding
        get {
            return true
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        let nodes = self.nodes(at: pos)
        for node in nodes {
            if node.name == "Kukei" {
                guard let enemy = enemies.first(where: {$0 == node}) else {return}
                enemyHasBeenTouched(enemy)
            }
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        let nodes = self.nodes(at: pos)
        for node in nodes {
            if node.name == "Kukei" {
                guard let enemy = enemies.first(where: {$0 == node}) else {return}
                enemyHasBeenTouched(enemy)
            }
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isGameActive { return }
        for t in touches { touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isGameActive { return }
        for t in touches { touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    // Custom Methods
    
    /// This method is run when the enemy sprite has been touched
    /// - Parameter enemy: The enemy's sprite node
    func enemyHasBeenTouched(_ enemy: Enemy) {
        enemy.enemyTouched()
        feedback?.impactOccurred()
        
        if hardMode {
            self.totalScore += Int(round(Double(enemy.score) * 1.5))
        } else {
            self.totalScore += enemy.score
        }
        
        self.scoreLabel.text = String(format: "%06d", self.totalScore)
    }
    
    /// Creates the timer in the bottom-mid section of the screen.
    func setupTimer() {
        let cfURL = Bundle.main.url(forResource: "Chango-Regular", withExtension: "ttf")! as CFURL
        CTFontManagerRegisterFontsForURL(cfURL, CTFontManagerScope.process, nil)
        
        timer.position = CGPoint(x: 0, y: -275)
        timer.fillColor = .green
        timer.strokeColor = .clear
        timer.zRotation = CGFloat.pi / 2
        timer.zPosition = 1000
        addChild(timer)
        
        let timerBg = SKShapeNode(circleOfRadius: 50)
        timerBg.fillColor = .red
        timerBg.strokeColor = .clear
        timerBg.zPosition = -1
        timer.addChild(timerBg)
        
        timerLabel.zPosition = 1001
        timerLabel.position = timer.position
        timerLabel.position.y -= 17.5
        timerLabel.fontName = "Chango-Regular"
        timerLabel.fontColor = .black
        timerLabel.addStroke(color: .white, width: 10)
        addChild(timerLabel)
    }
    
    /// Enables debug information on the bottom-right corner of the screen.
    func enableDebug() {
        self.view?.showsFPS = true
        self.view?.showsNodeCount = true
        self.view?.showsDrawCount = true
    }
    
    /// Checks through the enemy pattern list if each enemy in the list is not on screen. If they are, they remain unaltered. If they aren't, they spawn.
    /// - Parameter values: Enemy pattern array
    func checkParentAndSpawnEnemies(values: [Int]) {
        for i in values {
            if enemies[i].parent == nil {
                enemies[i].position.y += 5
                addChild(enemies[i])
                enemies[i].run(.moveTo(y: enemies[i].position.y - 5, duration: 0.1))
                enemies[i].enemySpawned(hardMode)
            }
        }
    }
    
    /// Created the countdown before the game starts.
    func countdownBeforeGameStart() {
        cdLabel.position = CGPoint(x: 0, y: -50)
        addChild(cdLabel)
                
        let animate = SKAction.run {
            if self.countdownBeforeStart > 0 {
                self.cdLabel.attributedText = self.getAttributedString(string: "\(Int(self.countdownBeforeStart))", size: 150)
                self.countdownBeforeStart -= 1
            } else {
                self.cdLabel.attributedText = self.getAttributedString(string: "Start", size: 150)
            }
            self.run(.playSoundFileNamed("clock-windup", waitForCompletion: false))
        }
        let wait = SKAction.wait(forDuration: 1)
        let action = SKAction.sequence([wait, animate])

        run(SKAction.repeat(action,count:4)) {
            self.run(SKAction.wait(forDuration:1)) {
                self.countdown(circle: self.timer, steps: Int(self.levelTimeLimit), duration: self.levelTimeLimit, countdown: self.timerLabel, hardMode: self.hardMode, completion: {
                    self.saveLevelScore()
                    self.isGameActive = false
                    self.feedback = nil
                    self.backgroundMusic.run(.changeVolume(to: 0, duration: 3), completion: { SceneManager.switchScenes(from: self, to: self.nextScene ?? .Level1)})
                    })
                self.isGameActive = true
                self.addChild(self.backgroundMusic)
                self.cdLabel.removeFromParent()
                self.feedback?.prepare()
            }
        }
    }
    
    /// Creates the score label on the top-left corner of the screen.
    func setupScoreLabel() {
        scoreSprite.run(.setTexture(SKTexture(imageNamed: "scoreBar"), resize: true))
        scoreSprite.setScale(0.75)
        scoreSprite.position = CGPoint(x: -600, y: 300) // -275
        scoreSprite.zPosition = 1001
        addChild(scoreSprite)
        
        scoreLabel.position = CGPoint(x: -20, y: -20)
        scoreLabel.fontName = "HelveticaNeue-Bold"
        scoreLabel.fontColor = .black
        scoreLabel.fontSize = 52
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.zPosition = 1002
        scoreLabel.text = String(format: "%06d", totalScore)
        scoreSprite.addChild(scoreLabel)
        
        scoreSprite.run(.moveTo(x: -275, duration: 0.5))
    }
    
    /// Saves the player's score for later use in the EndScore scene.
    func saveLevelScore() {
        let uD = UserDefaults.standard
        
        if let sceneName = self.name {
            switch sceneName {
            case "Level1":
                uD.set(self.totalScore, forKey: "Level1Score")
                break
            case "Level2":
                uD.set(self.totalScore, forKey: "Level2Score")
                break
            default:
                return
            }
        }
    }
}
