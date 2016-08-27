//
//  CalcButton.swift
//  Calculator
//
//  Created by Austin Wood on 2016-08-27.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import UIKit

class CalcButton: UIButton {
    
    override func awakeFromNib() {
        
        layer.cornerRadius = 10
        
        //        layer.shadowColor = UIColor.blackColor().CGColor //COLOR_GRAY_DARKER.CGColor // .colorWithAlphaComponent(0.8)
        //        layer.shadowOpacity = 1.0
        //        layer.shadowRadius = 5.0
        //        layer.shadowOffset = CGSizeMake(0.0, 2.0)
        
        let COLOR_YELLOW = UIColor(red:0.992, green:0.596, blue:0.153, alpha:1.00)
        let COLOR_PURPLE = UIColor(red:0.600, green:0.612, blue:0.988, alpha:1.00)
        backgroundColor = COLOR_YELLOW
        
        
        setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        titleLabel!.font =  UIFont(name: "Helvetica-Bold", size: 18)
        
    }
    
}