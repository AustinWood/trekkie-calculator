//
//  SciNum.swift
//  Calculator
//
//  Created by David Wolgemuth on 9/22/16.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import Foundation

struct SciNum
{
    // Store the main value here, then tack on all your functions for changing it below
    var value: Double
    
    
    // If you wanted to make this number into a larger number (Int max * 8, for example) you could even do that with an array
//    var value: [Double] = [Double(Int.max), Double(Int.max) ...]
    
    var significantDigits: Int
    
    func scientificNotation () -> String {
        // Obviously not what this would actually do ...
        return "\(value).00"
    }
    func standardNotation () -> String {
        return "\(Int(value))"
    }
    func isInt () -> Bool {
        return true
    }
}
