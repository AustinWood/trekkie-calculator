//
//  Calculator.swift
//  Calculator
//
//  Created by David Wolgemuth on 9/22/16.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import Foundation

class Calculator
{
    var leftNumber = SciNum(value: 0, significantDigits: 0)
    var currentOperation = Op.none
    
    enum Op {
        case none, addition, subtraction
    }
    
    func process(operation: Op) {
        
    }
//    func process(memory: Memory)
//    func process(input: Double)
//    func reset()
}
