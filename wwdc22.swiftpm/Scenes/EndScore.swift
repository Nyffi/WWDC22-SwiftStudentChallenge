//
//  EndScore.swift
//  wwdc22
//
//  Created by Paulo César on 11/04/22.
//

import Foundation
import SpriteKit

class EndScore: SKScene {
    let nextScene: SceneManager.AvailableScenes = .Onboarding
    
    override func didMove(to view: SKView) {
        let lv1ScoreLabel = children.first(where: { $0.name == "LV1Score"}) as! SKLabelNode
        let lv2ScoreLabel = children.first(where: { $0.name == "LV2Score"}) as! SKLabelNode
        let totalScoreLabel = children.first(where: { $0.name == "TotalScore"}) as! SKLabelNode
        let lv1Score = UserDefaults.standard.integer(forKey: "Level1Score")
        let lv2Score = UserDefaults.standard.integer(forKey: "Level2Score")
        let totalScore = lv1Score + lv2Score
        
        let music = SKAudioNode(fileNamed: "Walk Through the Park - TrackTribe")
        music.run(.changeVolume(to: 0.75, duration: 0))
        addChild(music)
        
        lv1ScoreLabel.text = String(format: "%06d", lv1Score)
        lv2ScoreLabel.text = String(format: "%06d", lv2Score)
        totalScoreLabel.text = String(format: "%06d", totalScore)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if nodes(at: pos).first(where: {$0.name == "backButton"}) != nil {
            SceneManager.switchScenes(from: self, to: nextScene)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchDown(atPoint: t.location(in: self)) }
    }
}
