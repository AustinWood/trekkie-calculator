//
//  ViewController.swift
//  Calculator
//
//  Created by Austin Wood on 2016-08-26.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import UIKit

/////////////////
///// TO DO /////
/////////////////

// Long decimals and big numbers cut off with "..."
// On second clear, also depress MC button
// Equals pressed after first number input resets to 0

class ViewController: UIViewController {
    
    @IBOutlet weak var outputLbl: UILabel!
    
    var runningNumber = Double()
    var leftString = Double()
    var rightString = Double()
    var currentOperation = 0
    var equalsPressed = false
    var decimalPressed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setDouble(0.0, forKey: "memoryDouble")
            
        resetCalc()
    }
    
    func resetCalc() {
        runningNumber = 0.0
        leftString = 0.0
        rightString = 0.0
        currentOperation = 0
        equalsPressed = false
        outputLbl.text = "0"
    }
    
    
    @IBAction func clearPressed(sender: AnyObject) {
        resetCalc()
    }
    
    
    @IBAction func numberPressed(sender: AnyObject) {
        
        if equalsPressed {
            resetCalc()
        }
        
        let number = sender.tag
        
        if !decimalPressed {
            runningNumber = Double(String(Int(runningNumber)) + String(number))!
        }
        else {
            if isInt(runningNumber) {
                runningNumber = Double(String(Int(runningNumber)) + "." + String(number))!
            } else {
                runningNumber = Double(String(runningNumber) + String(number))!
            }
        }
        
        outputLbl.text = formatOutputText(runningNumber)
    }
    
    
    @IBAction func decimalPressed(sender: AnyObject) {
        
        if !decimalPressed {
            
            decimalPressed = true
            
            // TO-DO: is this still necessary?
            if equalsPressed {
                resetCalc()
            }
            
        } else {
            
            // button press feedback to ackngoledge the operation regitsered but invalid
        }
        
        outputLbl.text = formatOutputText(runningNumber)
    }
    
    
    @IBAction func operationPressed(sender: AnyObject) {
        
        decimalPressed = false
        
        if equalsPressed {
            equalsPressed = false
        } else if currentOperation == 0 {
            leftString = runningNumber
        } else {
            rightString = runningNumber
            processOperation()
        }
        
        runningNumber = 0.0
        currentOperation = sender.tag
    }
    
    
    @IBAction func equalsPressed(sender: AnyObject) {
        
        decimalPressed = false
        
        if !equalsPressed {
            equalsPressed = true
            rightString = runningNumber
            runningNumber = 0.0
        }
        
        processOperation()
    }
    
    
    @IBAction func reverseSignPressed(sender: AnyObject) {
        
        if outputLbl.text != "0" {
            if Double(outputLbl.text!)! == runningNumber {
                runningNumber = runningNumber * -1
                outputLbl.text = String(runningNumber)
            } else {
                leftString = leftString * -1
                outputLbl.text = String(leftString)
            }
        }
    }
    
    
//    func reverseSign(inputString: String) -> String {
//        
//        var outputString = ""
//        
//        if inputString.rangeOfString("-") != nil {
//            outputString = inputString.stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
//        } else {
//            outputString = "-" + inputString
//        }
//        
//        return outputString
//    }
    
    
    func processOperation() {
        
        var calculation = Double()
        
        switch currentOperation {
        
        case 1:
            calculation = leftString / rightString
            break
        case 2:
            calculation = leftString * rightString
            break
        case 3:
            calculation = leftString - rightString
            break
        case 4:
            calculation = leftString + rightString
            break
        default:
            calculation = runningNumber
            break
        }
        
//        if calculation % 1 == 0 {
//            let intCalc = Int(calculation)
//            leftString = "\(intCalc)"
//        } else {
//            leftString = "\(calculation)"
//        }
        
        leftString = calculation
        
        outputLbl.text = formatOutputText(leftString)
    }
    
    
    @IBAction func memoryPressed(sender: AnyObject) {
        
        equalsPressed = true
        currentOperation = 0
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if sender.tag == 1 {
            
            defaults.setDouble(0.0, forKey: "memoryDouble")
            
        } else {
            
            var savedDouble = defaults.doubleForKey("memoryDouble")
            
            if sender.tag == 2 {
                savedDouble += Double(outputLbl.text!)!
                defaults.setDouble(savedDouble, forKey: "memoryDouble")
            }
            else if sender.tag == 3 {
                savedDouble -= Double(outputLbl.text!)!
                defaults.setDouble(savedDouble, forKey: "memoryDouble")
            }
            else {
                runningNumber = savedDouble
                outputLbl.text = formatOutputText(runningNumber)
            }
            
        }
        
    }
    
    
    func formatOutputText(inputDouble: Double) -> String {
        
        var outputString = String()
        
        if inputDouble % 1 == 0 {
            
            outputString = String(Int(inputDouble))
            
            if decimalPressed {
                outputString = outputString + "."
            }
                
        } else {
            outputString = String(inputDouble)
        }
        
        return outputString
    }
    
    
    
    func isInt(double: Double) -> Bool {
        
        let isInteger = double % 1 == 0
        return isInteger
    }
    
    // TO-DO: Can I create a "formatInt" function that returns an Int if an Int and a Double if a Double?
    
}