//
//  Operations.swift
//  Calculator
//
//  Created by Austin Wood on 2016-09-26.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import Foundation

enum operation {
    case none
    case add
    case subtract
    case multiply
    case divide
}

struct OperationHandler {
    
    var currentOperation: operation
    var leftNumber: Double
    var rightNumber: Double
    
    func processOperation() -> Double {
        print("func processOperation(\(currentOperation))")
        var calculation = Double()
        switch currentOperation {
        case .none:
            calculation = rightNumber
        case .add:
            calculation = leftNumber + rightNumber
            print("\(leftNumber) + \(rightNumber) = \(calculation)")
        case .subtract:
            calculation = leftNumber - rightNumber
            print("\(leftNumber) - \(rightNumber) = \(calculation)")
        case .multiply:
            calculation = leftNumber * rightNumber
            print("\(leftNumber) * \(rightNumber) = \(calculation)")
        case .divide:
            calculation = leftNumber / rightNumber
            print("\(leftNumber) / \(rightNumber) = \(calculation)")
        }
        return(calculation)
    }
    
}
