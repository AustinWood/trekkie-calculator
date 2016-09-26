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
    
    func animateOutputBackground(duration: TimeInterval, backgroundColor: UIColor) {
        UILabel.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {() -> Void in
            self.backgroundColor = backgroundColor
            }, completion: {(finished: Bool) -> Void in
                if self.backgroundColor == UIColor.black {
                    self.animateOutputBackground(duration: 0.35, backgroundColor: CalcColor.tan)
                }
        })
    }
    
    func animate(duration: TimeInterval, textColor: UIColor, backgroundColor: UIColor, labelColor: UIColor) {
        UILabel.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {() -> Void in
            self.textColor = textColor
            self.backgroundColor = backgroundColor
            }, completion: {(finished: Bool) -> Void in
                if textColor == backgroundColor {
                    self.animate(duration: 0.5, textColor: UIColor.black, backgroundColor: labelColor, labelColor: labelColor)
                }
        })
    }
    
}
