//
//  CalculatorLabel.swift
//  Calculator
//
//  Created by David Wolgemuth on 9/22/16.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import UIKit

class RoundedClickableLabel: UILabel
{
    var defaultBackgroundColor: UIColor?  // Save the color that you'd want to use
    
//  Bring all of these functions over here
    
    
//    func animateOutputLabel(duration: TimeInterval, textColor: UIColor) {
//        isAnimatingOutputLabel = true
//        UILabel.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {() -> Void in
//            self.textColor = textColor
//            }, completion: {(finished: Bool) -> Void in
//                if self.textColor == UIColor.white {
//                    self.animateOutputLabel(duration: 0.35, textColor: UIColor.black)
//                } else {
//                    isAnimatingOutputLabel = false
//                }
//        })
//    }
//    
//    func animateOutputBackground(duration: TimeInterval, backgroundColor: UIColor) {
//        UILabel.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {() -> Void in
//            self.backgroundColor = backgroundColor
//            }, completion: {(finished: Bool) -> Void in
//                if self.backgroundColor == UIColor.black {
//                    self.animateOutputBackground(duration: 0.35, backgroundColor: COLOR_TAN)
//                }
//        })
//    }
//    
//    func animate(duration: TimeInterval, textColor: UIColor, backgroundColor: UIColor, labelColor: UIColor) {
//        UILabel.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {() -> Void in
//            self.textColor = textColor
//            self.backgroundColor = backgroundColor
//            }, completion: {(finished: Bool) -> Void in
//                if textColor == backgroundColor {
//                    self.animate(duration: 0.5, textColor: UIColor.black, backgroundColor: labelColor, labelColor: labelColor)
//                }
//        })
//    }
    
    
    
    // I notice you did animated of them the same exact same.  Why not make some aliases with default params?
    func darken (duration: Double = 0.4) {
        self.animate(duration: duration, textColor: .white, backgroundColor: .black, labelColor: defaultBackgroundColor!)
    }
    func restoreColor (duration: Double = 0.4) {
        // You'd have to do more to actually make this work.. Just an example
        self.animate(duration: duration, textColor: .white, backgroundColor: .black, labelColor: defaultBackgroundColor!)
    }
}
