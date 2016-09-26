//
//  CustomLabel.swift
//  Calculator
//
//  Created by Austin Wood on 2016-09-26.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import Foundation
import UIKit

class CustomLabel: UILabel {
    
    /////////////////////////
    ///// BUTTON LABELS /////
    /////////////////////////
    
    var originalColor: UIColor?
    
    func darken() {
        self.animate(duration: 0.25, textColor: .white, backgroundColor: .black)
    }
    
    func whiten() {
        self.animate(duration: 0.4, textColor: .black, backgroundColor: .white)
    }
    
    func restoreColor(labelColor: UIColor) {
        self.animate(duration: 0.4, textColor: .black, backgroundColor: labelColor)
    }
    
    func disappear(labelColor: UIColor) {
        originalColor = labelColor
        self.animate(duration: 0.25, textColor: UIColor.black, backgroundColor: UIColor.black)
    }
    
    func animate(duration: TimeInterval, textColor: UIColor, backgroundColor: UIColor) {
        UILabel.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {() -> Void in
            self.textColor = textColor
            self.backgroundColor = backgroundColor
            }, completion: {(finished: Bool) -> Void in
                if textColor == backgroundColor {
                    self.restoreColor(labelColor: self.originalColor!)
                }
        })
    }
    
    /////////////////////////
    ///// OUTPUT LABELS /////
    /////////////////////////
    
    func flashOutputLabel() {
        self.animateOutputLabel(duration: 0.4, textColor: UIColor.white)
    }
    
    func animateOutputLabel(duration: TimeInterval, textColor: UIColor) {
        isAnimatingOutputLabel = true
        UILabel.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {() -> Void in
            self.textColor = textColor
            }, completion: {(finished: Bool) -> Void in
                if self.textColor == UIColor.white {
                    self.animateOutputLabel(duration: 0.35, textColor: UIColor.black)
                } else {
                    isAnimatingOutputLabel = false
                }
        })
    }
    
    func flashOutputBackground() {
        self.animateOutputBackground(duration: 0.4, backgroundColor: UIColor.black)
    }
    
    func animateOutputBackground(duration: TimeInterval, backgroundColor: UIColor) {
        UILabel.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {() -> Void in
            self.backgroundColor = backgroundColor
            }, completion: {(finished: Bool) -> Void in
                if self.backgroundColor == UIColor.black {
                    self.animateOutputBackground(duration: 0.35, backgroundColor: CalcColor.tan)
                }
        })
    }
    
}
