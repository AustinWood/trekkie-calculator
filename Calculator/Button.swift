//
//  ButtonName.swift
//  Calculator
//
//  Created by David Wolgemuth on 9/22/16.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import Foundation

////////////////////////
/// Instead of making comments you have to reference
////////////////////////

// 0-9: Numbers
// 10: Decimal
//
// 20: Equals
// 21: Addition
// 22: Subtraction
// 23: Multiplication
// 24: Division
//
// 30: Clear
// 31: Invert sign
//
// 40: MC
// 41: M+
// 42: M-
// 43: MR
//
// 50: Output label
// 51: Output background label

////////////////////////
/// You can make an enum
////////////////////////

enum Button: Int
{
    case zero = 0, one, two, three, four, five, six, seven, eight, nine, decimal
    case equals = 20, addition, subtraction, multiplication, division
    // etc.
    
    
}


//  Sample Usage:
//let num = Button(rawValue: 24)
//if num == .division {
//    print("DIVISION")
//}
//
//func printB(button: Button) {
//    print(button.rawValue)
//}
//printB(button: .eight)
//printB(button: .multiplication)
