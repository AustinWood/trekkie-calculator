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
// C vs AC

class ViewController: UIViewController {
    
    
    
    
    @IBOutlet weak var borderView: UIView!
    
//    @IBOutlet weak var outputLbl: UILabel!
//    @IBOutlet weak var clearBtn: CalcButton!
    
    
//    var runningNumber = Double()
//    var leftString = Double()
//    var rightString = Double()
//    var currentOperation = 0
//    var resetOutput = false
//    var decimalPressed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let screenSize: CGRect = UIScreen.mainScreen().bounds
//        let screenWidth = screenSize.width
//        let outerMargin = screenWidth / 1242 * 30
//        
//        rightMargin.constant = outerMargin
//        leftMargin.constant = outerMargin
//        bottomMargin.constant = outerMargin
//        
//        let borderWidth = self.borderView.frame.size.width / 1182 * 40
//        let innerBorder = outerMargin + borderWidth + 4
//        
//        buttonsRightMargin.constant = outerMargin
//        buttonsLeftMargin.constant = innerBorder
//        buttonsBottomMargin.constant = innerBorder
//        
//        print(outerMargin)
//        print(innerBorder)
        
    }
    
//    override func viewWillAppear(animated: Bool) {
//        
//        super.viewWillAppear(animated)
//        self.navigationController?.navigationBarHidden = true
//        
//        let defaults = NSUserDefaults.standardUserDefaults()
//        defaults.setDouble(0.0, forKey: "memoryDouble")
//            
//        resetCalc()
//    }
//    
//    func resetCalc() {
//        print("func resetCalc()")
//        runningNumber = 0.0
//        leftString = 0.0
//        rightString = 0.0
//        currentOperation = 0
//        resetOutput = false
//        outputLbl.text = "0"
//        clearBtn.setTitle("AC", forState: .Normal)
//    }
//    
//    
//    @IBAction func clearPressed(sender: AnyObject) {
//        
//        if clearBtn.titleLabel?.text == "AC" {
//            resetCalc()
//        } else {
//            runningNumber = 0.0
//            outputLbl.text = "0"
//            clearBtn.setTitle("AC", forState: .Normal)
//        }
//    }
//    
//    
//    @IBAction func numberPressed(sender: AnyObject) {
//        
//        if resetOutput {
//            resetCalc()
//        }
//        
//        clearBtn.setTitle("C", forState: .Normal)
//        
//        let number = sender.tag
//        
//        if !decimalPressed {
//            runningNumber = Double(String(Int(runningNumber)) + String(number))!
//        }
//        else {
//            if isInt(runningNumber) {
//                runningNumber = Double(String(Int(runningNumber)) + "." + String(number))!
//            } else {
//                runningNumber = Double(String(runningNumber) + String(number))!
//            }
//        }
//        
//        outputLbl.text = formatOutputText(runningNumber)
//    }
//    
//    
//    @IBAction func decimalPressed(sender: AnyObject) {
//        
//        if !decimalPressed {
//            
//            decimalPressed = true
//            
//            // TO-DO: is this still necessary?
//            if resetOutput {
//                resetCalc()
//            }
//            
//        } else {
//            
//            // button press feedback to ackngoledge the operation regitsered but invalid
//        }
//        
//        outputLbl.text = formatOutputText(runningNumber)
//    }
//    
//    
//    @IBAction func operationPressed(sender: AnyObject) {
//        
//        print("operationPressed()")
//        print("runningNumber = \(runningNumber)")
//        print("currentOperation = \(currentOperation)")
//        
//        decimalPressed = false
//        
//        if resetOutput {
//            resetOutput = false
//        }
//        
//        if currentOperation == 0 {
//            leftString = runningNumber
//        } else {
//            rightString = runningNumber
//            processOperation()
//        }
//        
//        runningNumber = 0.0
//        currentOperation = sender.tag
//    }
//    
//    
//    @IBAction func equalsPressed(sender: AnyObject) {
//        
//        decimalPressed = false
//        
//        if !resetOutput && currentOperation != 0 {
//            resetOutput = true
//            rightString = runningNumber
//            runningNumber = 0.0
//        }
//        
//        processOperation()
//    }
//    
//    
//    @IBAction func reverseSignPressed(sender: AnyObject) {
//        
//        if outputLbl.text != "0" {
//            if Double(outputLbl.text!)! == runningNumber {
//                runningNumber = runningNumber * -1
//                outputLbl.text = formatOutputText(runningNumber)
//            } else {
//                leftString = leftString * -1
//                outputLbl.text = formatOutputText(leftString)
//            }
//        }
//    }
//    
//    
//    func processOperation() {
//        
//        var calculation = Double()
//        
//        switch currentOperation {
//        
//        case 1:
//            calculation = leftString / rightString
//            break
//        case 2:
//            calculation = leftString * rightString
//            break
//        case 3:
//            calculation = leftString - rightString
//            break
//        case 4:
//            calculation = leftString + rightString
//            break
//        default:
//            calculation = runningNumber
//            break
//        }
//        
//        leftString = calculation
//        
//        outputLbl.text = formatOutputText(leftString)
//    }
//    
//    
//    @IBAction func memoryPressed(sender: AnyObject) {
//        
//        resetOutput = true
//        currentOperation = 0
//        
//        let defaults = NSUserDefaults.standardUserDefaults()
//        
//        if sender.tag == 1 {
//            
//            defaults.setDouble(0.0, forKey: "memoryDouble")
//            
//        } else {
//            
//            var savedDouble = defaults.doubleForKey("memoryDouble")
//            
//            if sender.tag == 2 {
//                savedDouble += Double(outputLbl.text!)!
//                defaults.setDouble(savedDouble, forKey: "memoryDouble")
//            }
//            else if sender.tag == 3 {
//                savedDouble -= Double(outputLbl.text!)!
//                defaults.setDouble(savedDouble, forKey: "memoryDouble")
//            }
//            else {
//                runningNumber = savedDouble
//                outputLbl.text = formatOutputText(runningNumber)
//            }
//            
//            runningNumber = Double(outputLbl.text!)!
//            
//            print("memoryPressed()")
//            print("runningNumber = \(runningNumber)")
//        }
//        
//    }
//    
//    
//    func formatOutputText(inputDouble: Double) -> String {
//        
//        var outputString = String()
//        
//        if inputDouble % 1 == 0 {
//            
//            outputString = String(Int(inputDouble))
//            
//            if decimalPressed {
//                outputString = outputString + "."
//            }
//                
//        } else {
//            outputString = String(inputDouble)
//        }
//        
//        return outputString
//    }
//    
//    
//    
//    func isInt(double: Double) -> Bool {
//        
//        let isInteger = double % 1 == 0
//        return isInteger
//    }
    
}