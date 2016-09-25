//
//  RoundedView.swift
//  Calculator
//
//  Created by Austin Wood on 2016-09-25.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import UIKit

class RoundedView: UIView {
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}
