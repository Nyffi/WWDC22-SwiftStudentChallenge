//
//  Enemy.swift
//  wwdc22
//
//  Created by Paulo César on 05/04/22.
//

import Foundation
import SpriteKit

class Enemy: SKSpriteNode {
    private var startTime: UInt64 = 0
    private var endTime: UInt64 = 0
    var score = 0
    
    /// Defines where the Kukei enemy will be spawned.
    /// - Parameters:
    ///   - valX: X position
    ///   - valY: Y position
    ///   - valZ: Z position
    ///   - rot: Rotation
    ///   - scale: Scale
    func spawnSetup(valX: CGFloat, valY: CGFloat, valZ: CGFloat, rot: CGFloat, scale: CGFloat) {
        self.position = CGPoint(x: valX, y: valY)
        self.zPosition = valZ
        self.zRotation = rot
        self.setScale(scale)
    }
    
    /// As soon as a Kukei enemy gets added to the scene, this function must be called.
    /// - Parameter hardMode: The game's difficulty setting. Shortens the enemy's screen lifespan by half if true.
    func enemySpawned(_ hardMode: Bool) {
        var waitTime: TimeInterval
        
        resetData()
        startTime = DispatchTime.now().uptimeNanoseconds
        
        if hardMode { waitTime = 1.5 } else { waitTime = 3 }
        self.run(.wait(forDuration: waitTime), completion: {
            self.removeFromParent()
        })
    }
    
    /// As soon as a Kukei enemy is touched, this function must be called. It sets the time it was touched, calculate the score to be awarded, plays a feedback sound and removes itself from the scene.
    func enemyTouched() {
        endTime = DispatchTime.now().uptimeNanoseconds
        calculateScore()
        self.removeAllActions()
        self.run(.playSoundFileNamed("touched", waitForCompletion: false), completion: { self.removeFromParent() })
    }
    
    /// Calculates the score to be awarded to the player. First, it finds out how many seconds did the player take to catch that enemy. If the value is above 3 seconds, it awards no points. Then, it divides the value by 3000 (3 seconds) to get a value between 0 and 1, and then reverse it and multiply it by the base max score of 100 points. After that, the value is rounded and set as the score to be added to the level's total score.
    func calculateScore() {
        var calc = Double((endTime - startTime) / 1000000)
        if calc >= 3000 { score = 0; return }
        calc /= 3000
        calc = 1 - calc
        calc *= 100
        score = Int(round(calc))
    }
    
    /// Resets all of this enemy's score calculation and assignment data.
    func resetData() {
        self.startTime = 0
        self.endTime = 0
        self.score = 0
    }
}
