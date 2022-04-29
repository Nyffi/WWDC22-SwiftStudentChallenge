//
//  LevelTwo.swift
//  wwdc22
//
//  Created by Paulo César on 09/04/22.
//

import SpriteKit
import NotificationCenter

class Level2: MainControls {
    override func sceneDidLoad() {
        super.sceneDidLoad()
        self.name = "Level2"
        initializeEnemySpawns()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.spawnRandomEnemySet(notification:)), name: Notification.Name("SpawnEnemySet"), object: nil)
        
        nextScene = .EndScore
        backgroundMusic = SKAudioNode(fileNamed: "Running Errands - TrackTribe [Trimmed].mp3")
    }
    
    func initializeEnemySpawns() {
        for _ in 0..<16 {
            let enemy = Enemy(imageNamed: "Enemy")
            enemy.name = "Kukei"
//            addChild(enemy)
            self.enemies.append(enemy)
        }
        
        let enemy = Enemy(imageNamed: "Enemy Sun")
        enemy.name = "Kukei"
//        addChild(enemy)
        self.enemies.append(enemy)
        
        // Bench
        enemies[0].spawnSetup(valX: -50, valY: -150, valZ: -2, rot: 0, scale: 0.5)
        enemies[1].spawnSetup(valX: 50, valY: -150, valZ: -2, rot: 0, scale: 0.5)
        
        // Screen Edges
        enemies[2].spawnSetup(valX: -450, valY: -170, valZ: -2, rot: -0.5, scale: 0.75)
        enemies[3].spawnSetup(valX: 450, valY: -170, valZ: -2, rot: 0.5, scale: 0.75)
        
        // Behind a tree
        enemies[4].spawnSetup(valX: -365, valY: -60, valZ: -91, rot: 0.2, scale: 0.25)
        
        // On top of a tree
        enemies[5].spawnSetup(valX: -220, valY: 75, valZ: -96, rot: -0.1, scale: 0.35)
        enemies[6].spawnSetup(valX: 90, valY: 100, valZ: -96, rot: 0.15, scale: 0.35)
        
        // On the clouds
        enemies[7].spawnSetup(valX: -325, valY: 210, valZ: -1001, rot: 0.5, scale: 0.75)
        enemies[8].spawnSetup(valX: 225, valY: 175, valZ: -1001, rot: 0, scale: 0.75)
        
        // Behind hill
        enemies[9].spawnSetup(valX: -160, valY: -30, valZ: -101, rot: 0, scale: 0.35)
        enemies[10].spawnSetup(valX: -100, valY: -30, valZ: -101, rot: 0, scale: 0.35)
        enemies[11].spawnSetup(valX: -40, valY: -30, valZ: -101, rot: 0, scale: 0.35)
        enemies[12].spawnSetup(valX: 20, valY: -30, valZ: -101, rot: 0, scale: 0.35)
        
        // In your face
        enemies[13].spawnSetup(valX: -320, valY: -130, valZ: 0, rot: 0, scale: 2)
        enemies[14].spawnSetup(valX: 320, valY: -130, valZ: 0, rot: 0, scale: 2)
        
        // Tree shade
        enemies[15].spawnSetup(valX: 120, valY: -75, valZ: -85, rot: 0, scale: 0.35)
        
        // Sun
        guard ((enemies.last?.spawnSetup(valX: 32.563, valY: 229.685, valZ: 0, rot: 0, scale: 0.804)) != nil) else { return }
    }
    
    @objc func spawnRandomEnemySet(notification: Notification) {
        if self.isGameActive {
            var random = Int.random(in: 1...20)
            while random == lastUsedSpawnPattern {
                random = Int.random(in: 1...20)
            }
            let enemiesToSpawn: [Int]

            switch random {
            case 1:
                enemiesToSpawn = [0]
                break
            case 2:
                enemiesToSpawn = [1]
                break
            case 3:
                enemiesToSpawn = [0, 1]
                break
            case 4:
                enemiesToSpawn = [2]
                break
            case 5:
                enemiesToSpawn = [3]
                break
            case 6:
                enemiesToSpawn = [2, 3]
                break
            case 7:
                enemiesToSpawn = [0, 1, 2, 3]
                break
            case 8:
                enemiesToSpawn = [5]
                break
            case 9:
                enemiesToSpawn = [6]
                break
            case 10:
                enemiesToSpawn = [5, 6]
                break
            case 11:
                enemiesToSpawn = [2, 5, 6, 3]
                break
            case 12:
                enemiesToSpawn = [0, 1, 2, 5, 6, 3]
                break
            case 13:
                enemiesToSpawn = [9, 10, 11, 12]
                break
            case 14:
                enemiesToSpawn = [7]
                break
            case 15:
                enemiesToSpawn = [8]
                break
            case 16:
                enemiesToSpawn = [7, 8]
                break
            case 17:
                enemiesToSpawn = [13]
                break
            case 18:
                enemiesToSpawn = [14]
                break
            case 19:
                enemiesToSpawn = [13, 14]
                break
            case 20:
                enemiesToSpawn = [13, 14, 0, 1, 9, 10, 11, 12]
                break
            default:
                enemiesToSpawn = []
                break
            }

            checkParentAndSpawnEnemies(values: enemiesToSpawn)
        }
    }
}

