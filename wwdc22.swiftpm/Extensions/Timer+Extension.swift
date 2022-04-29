//
//  Timer.swift
//  wwdc22
//
//  Created by Paulo César on 06/04/22.
//

import Foundation
import SpriteKit

protocol Timer {
    func countdown(circle:SKShapeNode, steps:Int, duration:TimeInterval, countdown:SKLabelNode, hardMode:Bool, completion:@escaping ()->Void)
    func circle(radius:CGFloat, percent:CGFloat) -> CGPath
    func getAttributedString(string: String, size: CGFloat) -> NSMutableAttributedString
}

extension Timer where Self: SKScene {
    
    /// Counts down from the time given to zero, setting off ticks along it's progress. Each tick also spawns an enemy pattern.
    /// - Parameters:
    ///   - circle: Shape node of the timer
    ///   - steps: How many ticks will happen before the countdown ends
    ///   - duration: How long will the countdown lasts
    ///   - countdown: Visible number label for the timer
    ///   - hardMode: Game's difficulty setting. If true, each tick has an extra chance of spawning a complimentary enemy pattern.
    ///   - completion: When done, some extra code is executed.
    func countdown(circle:SKShapeNode, steps:Int, duration:TimeInterval, countdown:SKLabelNode, hardMode:Bool, completion:@escaping ()->Void) {
        guard let path = circle.path else {
            return
        }
        let radius = path.boundingBox.width/2
        let timeInterval = duration/TimeInterval(steps)
        let incr = 1 / CGFloat(steps)
        var percent = CGFloat(1.0)
        var timer = Int(duration)
        countdown.attributedText = self.getAttributedString(string: "\(timer)", size: 36)
        

        let animate = SKAction.run {
            percent -= incr
            circle.path = self.circle(radius: radius, percent:percent)
            timer -= 1
            countdown.attributedText = self.getAttributedString(string: "\(timer)", size: 36)
            NotificationCenter.default.post(name: Notification.Name("SpawnEnemySet"), object: nil)
            if hardMode {
                if Int.random(in: 1...10) >= 3 {
                    NotificationCenter.default.post(name: Notification.Name("SpawnEnemySet"), object: nil)
                }
            }
        }
        let wait = SKAction.wait(forDuration:timeInterval)
        let action = SKAction.sequence([wait, animate])

        run(SKAction.repeat(action,count:steps-1)) {
            self.run(SKAction.wait(forDuration:timeInterval)) {
                circle.path = nil
                timer -= 1
                countdown.attributedText = self.getAttributedString(string: "\(timer)", size: 36)
                completion()
            }
        }
    }
    
    /// Created a path that hides part of the circle to indicate time's running out.
    /// - Parameters:
    ///   - radius: The circle's radius.
    ///   - percent: How much is left.
    /// - Returns: A path that will show how much of the circle remains according to the time left.
    func circle(radius:CGFloat, percent:CGFloat) -> CGPath {
        let start:CGFloat = 0
        let end = CGFloat.pi * 2 * percent
        let center = CGPoint.zero
        let bezierPath = UIBezierPath()
        bezierPath.move(to:center)
        bezierPath.addArc(withCenter:center, radius: radius, startAngle: start, endAngle: end, clockwise: true)
        bezierPath.addLine(to:center)
        return bezierPath.cgPath
    }
    
    func getAttributedString(string: String, size: CGFloat) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        let attributions: [NSAttributedString.Key : Any] = [.font: UIFont(name: "Chango-Regular", size: size)!,
                                                            .strokeColor: UIColor.white,
                                                            .strokeWidth: -7.5,
                                                            .foregroundColor: UIColor.black] // Having a positive stroke width somehow changes the foreground color of the text to .clear permanently. Making it negative somehow fixes the problem.
        let stringRange = NSMakeRange(0, attributedString.length)
        
        attributedString.beginEditing()
        attributedString.addAttributes(attributions, range: stringRange)
        attributedString.endEditing()
        
        return attributedString
    }
}
