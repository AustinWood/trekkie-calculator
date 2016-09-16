//
//  Extensions.swift
//  Calculator
//
//  Created by Austin Wood on 2016-09-14.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func fadeOutIn() {
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.alpha = 0.0
            }, completion: nil)
        
        UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 1.0
            }, completion: nil)
    }
}





//let COLOR_SALMON = UIColor(red:0.992, green:0.600, blue:0.420, alpha:1.00)
//UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
//    
//    sender.backgroundColor = COLOR_SALMON.colorWithAlphaComponent(0.0)
//    }, completion: {
//        (finished: Bool) -> Void in
//        
//        //Once the label is completely invisible, set the text and fade it back in
//        //self.borderView.text = "Bird Type: Swift"
//        
//        // Fade in
//        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
//            sender.backgroundColor = COLOR_SALMON.colorWithAlphaComponent(1.0)
//            }, completion: nil)
//})