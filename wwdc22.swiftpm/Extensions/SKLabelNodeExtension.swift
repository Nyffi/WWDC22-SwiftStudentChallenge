//
//  SKLabelNodeExtension.swift
//  wwdc22
//
//  Created by Paulo César on 07/04/22.
//

import Foundation
import SpriteKit

extension SKLabelNode {
    
    /// Shortcut to add a stroke to an attributed text.
    /// - Parameters:
    ///   - color: The stroke's color
    ///   - width: The stroke's thickness
   func addStroke(color:UIColor, width: CGFloat) {

        guard let labelText = self.text else { return }

        let font = UIFont(name: self.fontName!, size: self.fontSize)

        let attributedString:NSMutableAttributedString
        if let labelAttributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelAttributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        let attributes:[NSAttributedString.Key:Any] = [.strokeColor: color, .strokeWidth: -width, .font: font!, .foregroundColor: self.fontColor!]
        attributedString.addAttributes(attributes, range: NSMakeRange(0, attributedString.length))

        self.attributedText = attributedString
   }
}
