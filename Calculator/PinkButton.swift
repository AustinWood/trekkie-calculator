//
//  PinkButton.swift
//  Calculator
//
//  Created by Austin Wood on 2016-09-12.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import UIKit

class PinkButton: UIButton {

    override func awakeFromNib() {
        
        let COLOR_PINK = UIColor(red:0.796, green:0.604, blue:0.796, alpha:1.00)
        backgroundColor = COLOR_PINK
        
        setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        titleLabel!.font =  UIFont(name: "Helvetica-Bold", size: 18)
        
    }

}
