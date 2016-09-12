//
//  CalcButton.swift
//  Calculator
//
//  Created by Austin Wood on 2016-08-27.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
    
    override func awakeFromNib() {
        
        //layer.cornerRadius = 20
        
        let COLOR_SALMON = UIColor(red:0.992, green:0.600, blue:0.420, alpha:1.00)
        backgroundColor = COLOR_SALMON
        
        setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        titleLabel!.font =  UIFont(name: "Helvetica-Bold", size: 18)
        
    }
    
}