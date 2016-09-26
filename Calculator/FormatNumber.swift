//
//  ScientificNotation.swift
//  Calculator
//
//  Created by Austin Wood on 2016-09-26.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import Foundation

struct FormatNumber {
    
    var numberToFormat: Double
    
    func convertDoubleToString() -> String {
        print("func convertDoubleToString()")
        if abs(numberToFormat) >= 1000000000 || (abs(numberToFormat) <= 0.00000000001 && numberToFormat != 0.0) {
            return scientificNotation()
        } else {
            return standardNotation()
        }
    }
    
    func scientificNotation() -> String {
        print("func scientificNotation()")
        let value = numberToFormat as NSNumber
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumIntegerDigits = 1
        numberFormatter.decimalSeparator = "."
        numberFormatter.numberStyle = NumberFormatter.Style.scientific
        numberFormatter.positiveFormat = "0.###E+0"
        numberFormatter.negativeFormat = "0.###E-0"
        numberFormatter.exponentSymbol = "e"
        if let stringFromNumber = numberFormatter.string(from: value) {
            return(stringFromNumber)
        } else {
            return "Error"
        }
    }
    
    func standardNotation() -> String {
        print("func standardNotation()")
        let value = numberToFormat as NSNumber
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumIntegerDigits = 1
        numberFormatter.decimalSeparator = "."
        if decimalShown {
            numberFormatter.alwaysShowsDecimalSeparator = true
        }
        var integerDigits = 1
        if abs(numberToFormat) >= 1 {
            integerDigits = Int(log10(abs(numberToFormat))) + 1
        }
        if numberToFormat < 0 { // Account for the negative sign
            integerDigits += 1
        }
        numberFormatter.maximumFractionDigits = 12 - integerDigits
        if let stringFromNumber = numberFormatter.string(from: value) {
            let outputString = addTrailingZeros(inputString: stringFromNumber)
            return outputString
        } else {
            return "Error"
        }
    }
    
    func addTrailingZeros(inputString: String) -> String {
        print("func addTrailingZeros()")
        var mutableString = inputString
        if trailingZeros > 0 {
            for _ in 1...trailingZeros {
                mutableString += "0"
            }
        }
        return mutableString
    }
    
}
