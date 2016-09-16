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

// Connect touchDown() to all buttons
// Create a dragOut() function to animate fade in, but not register button press
// Reconnect all buttons to their original functions

// Long decimals and big numbers cut off with "..."
// Put colors in a separate file
// C vs AC
// Make Memory buttons a Switch statement
// Register hardware keyboard presses
// Add second label that shows previous operations
// Add slide in animation to new numbers: http://www.andrewcbancroft.com/2014/09/24/slide-in-animation-in-swift/

/////////////////////////////////////////////////
///// TAG REFERENCES FOR BUTTONS and LABELS /////
/////////////////////////////////////////////////

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
// 31: Reverse sign
//
// 40: MC
// 41: M+
// 42: M-
// 43: MR
//
// 50: Output label

class ViewController: UIViewController {
    
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var outputLbl: UILabel!
    
    var labelArray = [UILabel]()
    var buttonArray = [UIButton]()
    
    var runningNumber = Double()
    var leftString = Double()
    var rightString = Double()
    var currentOperation = 0
    var resetOutput = false
    var decimalPressed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stylizeReverseSignButton()
        
        labelArray = getLabelsInView(self.view)
        formatLabels()
        buttonArray = getButtonsInView(self.view)
    }
    
    
    @IBAction func buttonTouchDown(sender: AnyObject) {
        for label in labelArray {
            if label.tag == sender.tag {
                label.fadeOut()
            }
        }
    }
    
    @IBAction func buttonTouchUp(sender: AnyObject) {
        for label in labelArray {
            if label.tag == sender.tag {
                label.fadeIn()
            }
        }
    }
    
    
    func getLabelsInView(view: UIView) -> [UILabel] {
        var results = [UILabel]()
        for subview in view.subviews as [UIView] {
            if let labelView = subview as? UILabel {
                results += [labelView]
            } else {
                results += getLabelsInView(subview)
            }
        }
        return results
    }
    
    
    func formatLabels() {
        
        let COLOR_SALMON = UIColor(red:0.992, green:0.600, blue:0.420, alpha:1.00)
        let COLOR_PINK = UIColor(red:0.796, green:0.604, blue:0.796, alpha:1.00)
        let COLOR_PURPLE = UIColor(red:0.600, green:0.604, blue:0.792, alpha:1.00)
        let COLOR_ORANGE = UIColor(red:0.992, green:0.596, blue:0.153, alpha:1.00)
        
        let BUTTON_TEXT_FONT = "FinalFrontierOldStyle"
        //let BUTTON_TEXT_FONT = "Helvetica-Bold"
        let BUTTON_TEXT_SIZE = 28 as CGFloat
        let BUTTON_TEXT_COLOR = UIColor.blackColor()
        
        for label in labelArray {
            label.textColor = BUTTON_TEXT_COLOR
            if label.tag <= 10 {
                label.font = UIFont(name: BUTTON_TEXT_FONT, size: BUTTON_TEXT_SIZE * 1.5)
                label.backgroundColor = COLOR_SALMON
            } else {
                label.font = UIFont(name: BUTTON_TEXT_FONT, size: BUTTON_TEXT_SIZE * 1.0)
                if label.tag == 20 {
                    label.backgroundColor = COLOR_ORANGE
                } else if label.tag >= 21 && label.tag <= 31 {
                    label.backgroundColor = COLOR_PINK
                } else if label.tag >= 40 && label.tag <= 43 {
                    label.backgroundColor = COLOR_PURPLE
                } else {
                    label.font = UIFont(name: BUTTON_TEXT_FONT, size: BUTTON_TEXT_SIZE * 2.0)
                    label.backgroundColor = UIColor.clearColor()
                }
            }
        }
    }
    
    
    func getButtonsInView(view: UIView) -> [UIButton] {
        var results = [UIButton]()
        for subview in view.subviews as [UIView] {
            if let buttonView = subview as? UIButton {
                results += [buttonView]
            } else {
                results += getButtonsInView(subview)
            }
        }
        return results
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
//        let font: UIFont? = UIFont(name: BUTTON_TEXT_FONT, size: BUTTON_TEXT_SIZE)
//        let fontSuper: UIFont? = UIFont(name: BUTTON_TEXT_FONT, size: BUTTON_TEXT_SIZE / 1.5)
//        let attString: NSMutableAttributedString = NSMutableAttributedString(string: "+/–", attributes: [NSFontAttributeName: font!])
//        attString.setAttributes([NSFontAttributeName: fontSuper!, NSBaselineOffsetAttributeName: 10], range: NSRange(location:0,length:1))
//        attString.setAttributes([NSFontAttributeName: fontSuper!, NSBaselineOffsetAttributeName: 2], range: NSRange(location:2,length:1))
//        reverseSignButton.setAttributedTitle(attString, forState: .Normal)
    }
    
    func resetCalc() {
        
        print("func resetCalc()")
        
        runningNumber = 0.0
        leftString = 0.0
        rightString = 0.0
        currentOperation = 0
        resetOutput = false
        outputLbl.text = "0"
//        clearBtn.setTitle("AC", forState: .Normal)
    }
    
    @IBAction func clearPressed(sender: AnyObject) {
        
//        if clearBtn.titleLabel?.text == "AC" {
//            resetCalc()
//        } else {
//            runningNumber = 0.0
//            outputLbl.text = "0"
//            clearBtn.setTitle("AC", forState: .Normal)
//        }
    }
    
    @IBAction func numberPressed(sender: UIButton) {
        
        if resetOutput {
            resetCalc()
        }
        
//        clearBtn.setTitle("C", forState: .Normal)
        
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