//
//  Onboarding.swift
//  wwdc
//
//  Created by Paulo César on 11/04/22.
//

import Foundation
import SpriteKit

class Onboarding: SKScene {
    let nextScene: SceneManager.AvailableScenes = .Level1
    
    override func didMove(to view: SKView) {
        let music = SKAudioNode(fileNamed: "Easy Stroll - TrackTribe")
        music.run(.changeVolume(to: 0.25, duration: 0))
        addChild(music)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if nodes(at: pos).first(where: {$0.name == "startButton"}) != nil {
            UserDefaults.standard.set(false, forKey: "HardMode")
            SceneManager.switchScenes(from: self, to: nextScene)
        }
        
        if nodes(at: pos).first(where: {$0.name == "startHardButton"}) != nil {
            UserDefaults.standard.set(true, forKey: "HardMode")
            SceneManager.switchScenes(from: self, to: nextScene)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchDown(atPoint: t.location(in: self)) }
    }
}
