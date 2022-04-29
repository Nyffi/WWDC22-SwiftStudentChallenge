//
//  Level1.swift
//  wwdc22
//
//  Created by Paulo César on 05/04/22.
//

import SpriteKit
import NotificationCenter

class Level1: MainControls {
    override func sceneDidLoad() {
        super.sceneDidLoad()
        self.name = "Level1"
        initializeEnemySpawns()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.spawnRandomEnemySet(notification:)), name: Notification.Name("SpawnEnemySet"), object: nil)
        
        nextScene = .Level2
        backgroundMusic = SKAudioNode(fileNamed: "Smokey's Lounge - TrackTribe [Trimmed].mp3")
        
    }
    
    /// Creates and defines each enemy's X, Y and Z coordinates, alongside rotation and scale, and adds them to the enemies array, ready to be spawned.
    func initializeEnemySpawns() {
        for _ in 0..<26 {
            let enemy = Enemy(imageNamed: "Enemy")
            enemy.name = "Kukei"
            //addChild(enemy)
            self.enemies.append(enemy)
        }
        
        let enemy = Enemy(imageNamed: "Enemy Sun")
        enemy.name = "Kukei"
        //addChild(enemy)
        self.enemies.append(enemy)
        
        // Close Hill
        enemies[0].spawnSetup(valX: -350, valY: -240, valZ: -2, rot: 0, scale: 0.5)
        enemies[1].spawnSetup(valX: -200, valY: -190, valZ: -4, rot: 0, scale: 0.5)
        enemies[2].spawnSetup(valX: -100, valY: -190, valZ: -4, rot: 0, scale: 0.5)
        
        // Mid Hill
        enemies[3].spawnSetup(valX: 150, valY: -50, valZ: -15, rot: 0, scale: 0.4)
        enemies[4].spawnSetup(valX: 200, valY: -100, valZ: -15, rot: 0, scale: 0.4)
        enemies[5].spawnSetup(valX: 250, valY: -150, valZ: -14, rot: 0, scale: 0.4)
        enemies[6].spawnSetup(valX: 300, valY: -200, valZ: -14, rot: 0, scale: 0.4)
        enemies[7].spawnSetup(valX: 350, valY: -250, valZ: -14, rot: 0, scale: 0.4)
        
        enemies[8].spawnSetup(valX: 350, valY: -50, valZ: -15, rot: 0, scale: 0.4)
        enemies[9].spawnSetup(valX: 300, valY: -100, valZ: -15, rot: 0, scale: 0.4)
        enemies[10].spawnSetup(valX: 200, valY: -200, valZ: -14, rot: 0, scale: 0.4)
        enemies[11].spawnSetup(valX: 150, valY: -250, valZ: -14, rot: 0, scale: 0.4)
        
        // Far Hill
        enemies[12].spawnSetup(valX: 60, valY: -10, valZ: -25, rot: 0, scale: 0.3)
        
        // Behind Far Hill
        enemies[13].spawnSetup(valX: 430, valY: 75, valZ: -35, rot: -0.05, scale: 0.4)
        enemies[14].spawnSetup(valX: 350, valY: 80, valZ: -35, rot: -0.04, scale: 0.4)
        enemies[15].spawnSetup(valX: 270, valY: 85, valZ: -35, rot: -0.03, scale: 0.4)
        enemies[16].spawnSetup(valX: 190, valY: 90, valZ: -35, rot: -0.02, scale: 0.4)
        enemies[17].spawnSetup(valX: 110, valY: 90, valZ: -35, rot: -0.01, scale: 0.4)
        enemies[18].spawnSetup(valX: 30, valY: 90, valZ: -35, rot: 0, scale: 0.4)
        
        // Tree Fruits
        enemies[19].spawnSetup(valX: -440, valY: -20, valZ: 0, rot: 0, scale: 0.3)
        enemies[20].spawnSetup(valX: -330, valY: -22, valZ: 0, rot: 0, scale: 0.3)
        enemies[21].spawnSetup(valX: -410, valY: -115, valZ: 0, rot: 0, scale: 0.3)
        enemies[22].spawnSetup(valX: -210, valY: 55, valZ: 0, rot: 0, scale: 0.3)
        enemies[23].spawnSetup(valX: -40, valY: 10, valZ: 0, rot: 0, scale: 0.3)
        enemies[24].spawnSetup(valX: -135, valY: 0, valZ: 0, rot: 0, scale: 0.3)
        
        // Giant
        enemies[25].spawnSetup(valX: -350, valY: 170, valZ: -30, rot: 0.05, scale: 2)
        
        // Sun
        guard ((enemies.last?.spawnSetup(valX: 321.61, valY: 238.39, valZ: 0, rot: 0, scale: 1)) != nil) else { return }
    }
    
    /// Enemy spawn patterns
    /// - Parameter notification: Call to execution
    @objc func spawnRandomEnemySet(notification: Notification) {
        if self.isGameActive {
            var random = Int.random(in: 1...13)
            while random == lastUsedSpawnPattern {
                random = Int.random(in: 1...13)
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
                enemiesToSpawn = [2]
                break
            case 4:
                enemiesToSpawn = [0, 1, 2]
                break
            case 5:
                enemiesToSpawn = [3, 4, 5, 6, 7]
                break
            case 6:
                enemiesToSpawn = [8, 9, 5, 10, 11]
                break
            case 7:
                enemiesToSpawn = [12]
                break
            case 8:
                enemiesToSpawn = [13, 14, 15, 16, 17, 18]
                break
            case 9:
                enemiesToSpawn = [19, 20, 21]
                break
            case 10:
                enemiesToSpawn = [22, 23, 24]
                break
            case 11:
                enemiesToSpawn = [19, 20, 21, 22, 23, 24]
                break
            case 12:
                enemiesToSpawn = [25]
                break
            case 13:
                enemiesToSpawn = [26]
                break
            default:
                enemiesToSpawn = []
                break
            }
            
            checkParentAndSpawnEnemies(values: enemiesToSpawn)
            self.lastUsedSpawnPattern = random
        }
    }
}
