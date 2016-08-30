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
// If memory is INT, don't display ".0"

class ViewController: UIViewController {
    
    @IBOutlet weak var outputLbl: UILabel!
    
    var runningNumber = ""
    var leftString = ""
    var rightString = ""
    var currentOperation = 0
    var equalsPressed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        resetCalc()
    }
    
    func resetCalc() {
        runningNumber = ""
        leftString = ""
        rightString = ""
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
        
        let number = "\(sender.tag)"
        runningNumber = runningNumber + number
        outputLbl.text = runningNumber
    }
    
    
    @IBAction func decimalPressed(sender: AnyObject) {
        
        if equalsPressed {
            resetCalc()
        }
        
        if runningNumber == "" {
            runningNumber = "0"
        }
        
        runningNumber = runningNumber + "."
        outputLbl.text = runningNumber
    }
    
    
    @IBAction func operationPressed(sender: AnyObject) {
        
        if equalsPressed {
            equalsPressed = false
        } else if currentOperation == 0 {
            leftString = runningNumber
        } else {
            rightString = runningNumber
            processOperation()
        }
        
        runningNumber = ""
        currentOperation = sender.tag
    }
    
    
    @IBAction func equalsPressed(sender: AnyObject) {
        
        if !equalsPressed {
            equalsPressed = true
            rightString = runningNumber
            runningNumber = ""
        }
        
        processOperation()
    }
    
    
    @IBAction func reverseSignPressed(sender: AnyObject) {
        
        if outputLbl.text != "0" {
            if outputLbl.text == runningNumber {
                runningNumber = reverseSign(runningNumber)
                outputLbl.text = runningNumber
            } else {
                leftString = reverseSign(leftString)
                outputLbl.text = leftString
            }
        }
    }
    
    
    func reverseSign(inputString: String) -> String {
        
        var outputString = ""
        
        if inputString.rangeOfString("-") != nil {
            outputString = inputString.stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        } else {
            outputString = "-" + inputString
        }
        
        return outputString
    }
    
    
    func processOperation() {
        
        var calculation = Double()
        
        if leftString == "" {
            leftString = "0"
        }
        
        switch currentOperation {
        
        case 1:
            calculation = Double(leftString)! / Double(rightString)!
            break
        case 2:
            calculation = Double(leftString)! * Double(rightString)!
            break
        case 3:
            calculation = Double(leftString)! - Double(rightString)!
            break
        case 4:
            calculation = Double(leftString)! + Double(rightString)!
            break
        default:
            break
        }
        
        if calculation % 1 == 0 {
            let intCalc = Int(calculation)
            leftString = "\(intCalc)"
        } else {
            leftString = "\(calculation)"
        }
        
        outputLbl.text = leftString
    }
    
    
    @IBAction func memoryPressed(sender: AnyObject) {
        
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
                runningNumber = "\(savedDouble)"
                outputLbl.text = runningNumber
            }
            
        }
        
    }
    
    
    
    func isInt(double: Double) -> Bool {
        
        let isInteger = double % 1 == 0
        return isInteger
    }
    
}