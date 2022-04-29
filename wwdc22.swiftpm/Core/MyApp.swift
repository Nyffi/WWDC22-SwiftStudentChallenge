import SwiftUI
import SpriteKit

@main
struct MyApp: App {
    var scene: SKScene {
        //guard let scene = Level1(fileNamed: "Level01") else { return Level1() }
        guard let scene = Onboarding(fileNamed: "Onboarding") else { return Onboarding()}
        scene.size = CGSize(width: 960, height: 720)
        scene.scaleMode = .fill
        return scene
    }
    
    var body: some Scene {
        WindowGroup {
            SpriteView(scene: scene)
//                .frame(width: 960, height: 720)
                .ignoresSafeArea()
        }
    }
}
