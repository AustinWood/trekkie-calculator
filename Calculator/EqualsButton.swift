//
//  EqualsButton.swift
//  Calculator
//
//  Created by Austin Wood on 2016-09-12.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import UIKit

class EqualsButton: UIButton {

    override func awakeFromNib() {
        
        let COLOR_ORANGE = UIColor(red:0.992, green:0.596, blue:0.153, alpha:1.00)
        backgroundColor = COLOR_ORANGE
        
        setTitleColor(BUTTON_TEXT_COLOR, forState: UIControlState.Normal)
        titleLabel!.font =  UIFont(name: BUTTON_TEXT_FONT, size: BUTTON_TEXT_SIZE)
        
    }

}