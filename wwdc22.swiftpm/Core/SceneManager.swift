//
//  SceneManager.swift
//  
//
//  Created by Paulo César on 09/04/22.
//

import Foundation
import SpriteKit

class SceneManager {
    enum AvailableScenes {
        case Onboarding
        case Level1
        case Level2
        case EndScore
    }
    
    public static func switchScenes(from source: SKScene?, to target: AvailableScenes) {
        guard let targetScene = getScene(target) else { return }
        
        targetScene.scaleMode = .fill
        
        source?.view?.presentScene(targetScene)
    }
    
    private static func getScene(_ scene: AvailableScenes) -> SKScene? {
        switch scene {
        case .Level1:
            return Level1(fileNamed: "Level01")
        case .Level2:
            return Level2(fileNamed: "Level02")
        case .Onboarding:
            return Onboarding(fileNamed: "Onboarding")
        case .EndScore:
            return EndScore(fileNamed: "EndScore")
        }
    }
}
