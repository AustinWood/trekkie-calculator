// DEEP WORK start: 15:46


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
// Make Memory buttons a Switch statement
// Register hardware keyboard presses
// Second label that shows input trace

// Add slide in animation to new numbers
// http://www.andrewcbancroft.com/2014/09/24/slide-in-animation-in-swift/

class ViewController: UIViewController {
    
    @IBOutlet weak var twoView: UIView!
    @IBOutlet weak var twoLabel: UILabel!
    
    @IBOutlet weak var reverseSignButton: PinkButton!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var outputLbl: UILabel!
    @IBOutlet weak var clearBtn: PinkButton!
    
    var runningNumber = Double()
    var leftString = Double()
    var rightString = Double()
    var currentOperation = 0
    var resetOutput = false
    var decimalPressed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stylizeReverseSignButton()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setDouble(0.0, forKey: "memoryDouble")
        resetCalc()
    }
    
    func stylizeReverseSignButton() {
        let font: UIFont? = UIFont(name: BUTTON_TEXT_FONT, size: BUTTON_TEXT_SIZE)
        let fontSuper: UIFont? = UIFont(name: BUTTON_TEXT_FONT, size: BUTTON_TEXT_SIZE / 1.5)
        let attString: NSMutableAttributedString = NSMutableAttributedString(string: "+/–", attributes: [NSFontAttributeName: font!])
        attString.setAttributes([NSFontAttributeName: fontSuper!, NSBaselineOffsetAttributeName: 10], range: NSRange(location:0,length:1))
        attString.setAttributes([NSFontAttributeName: fontSuper!, NSBaselineOffsetAttributeName: 2], range: NSRange(location:2,length:1))
        reverseSignButton.setAttributedTitle(attString, forState: .Normal)
    }
    
    func resetCalc() {
        
        print("func resetCalc()")
        
        runningNumber = 0.0
        leftString = 0.0
        rightString = 0.0
        currentOperation = 0
        resetOutput = false
        outputLbl.text = "0"
        clearBtn.setTitle("AC", forState: .Normal)
    }
    
    @IBAction func clearPressed(sender: AnyObject) {
        
        if clearBtn.titleLabel?.text == "AC" {
            resetCalc()
        } else {
            runningNumber = 0.0
            outputLbl.text = "0"
            clearBtn.setTitle("AC", forState: .Normal)
        }
    }
    
    @IBAction func numberPressed(sender: UIButton) {
        
        twoLabel.fadeOut()
        twoLabel.fadeIn()
        
        if resetOutput {
            resetCalc()
        }
        
        clearBtn.setTitle("C", forState: .Normal)
        
        let number = sender.tag
        
        if !decimalPressed {
            runningNumber = Double(String(Int(runningNumber)) + String(number))!
        } else {
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
            
            if resetOutput {
                resetCalc()
            }
            
        } else {
            
            // button press feedback to ackngoledge the operation regitsered but invalid
        }
        
        outputLbl.text = formatOutputText(runningNumber)
    }
    
    
    @IBAction func operationPressed(sender: AnyObject) {
        
        print("operationPressed()")
        print("runningNumber = \(runningNumber)")
        print("currentOperation = \(currentOperation)")
        
        decimalPressed = false
        
        if resetOutput {
            resetOutput = false
        }
        
        if currentOperation == 0 {
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
        
        if !resetOutput && currentOperation != 0 {
            resetOutput = true
            rightString = runningNumber
            runningNumber = 0.0
        }
        
        processOperation()
    }
    
    
    @IBAction func reverseSignPressed(sender: AnyObject) {
        
        if outputLbl.text != "0" {
            if Double(outputLbl.text!)! == runningNumber {
                runningNumber = runningNumber * -1
                outputLbl.text = formatOutputText(runningNumber)
            } else {
                leftString = leftString * -1
                outputLbl.text = formatOutputText(leftString)
            }
        }
    }
    
    
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
        
        leftString = calculation
        
        outputLbl.text = formatOutputText(leftString)
    }
    
    
    @IBAction func memoryPressed(sender: AnyObject) {
        
        resetOutput = true
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
            
            runningNumber = Double(outputLbl.text!)!
            
            print("memoryPressed()")
            print("runningNumber = \(runningNumber)")
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
    
}