//
//  ViewController.swift
//  Calculator
//
//  Created by Austin Wood on 2016-08-26.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

/////////////////////////////////////
/////////////// TO DO ///////////////
/////////////////////////////////////

// Add text animations
// Clean up CALCULATOR LOGIC code
// Reconnect all buttons to their original functions

// Long decimals and big numbers cut off with "..."
// Put colors in a separate file
// C vs AC
// Make Memory buttons a Switch statement
// Register hardware keyboard presses
// Add second label that shows previous operations
// Add slide in animation to new numbers: http://www.andrewcbancroft.com/2014/09/24/slide-in-animation-in-swift/
// Adjust layout if Personal Hotspot, etc is turned on
// Add sound effects
// Create app icon
// Create launch screen
// Create info/about screen?

/////////////////////////////////////////////////
///// TAG REFERENCES for BUTTONS and LABELS /////
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

import UIKit

class ViewController: UIViewController {
    
    //////////////////
    ///// COLORS /////
    //////////////////
    
    let COLOR_SALMON = UIColor(red:0.992, green:0.600, blue:0.420, alpha:1.00)
    let COLOR_PINK = UIColor(red:0.796, green:0.604, blue:0.796, alpha:1.00)
    let COLOR_PURPLE = UIColor(red:0.600, green:0.604, blue:0.792, alpha:1.00)
    let COLOR_ORANGE = UIColor(red:0.992, green:0.596, blue:0.153, alpha:1.00)
    
    ////////////////
    ///// TEXT /////
    ////////////////
    
    let TEXT_FONT = "FinalFrontierOldStyle" // or "Helvetica-Bold" ?
    let TEXT_SIZE = 28 as CGFloat
    let TEXT_COLOR = UIColor.black
    
    ////////////////////////////
    ///// OUTLETS and VARS /////
    ////////////////////////////
    
    //@IBOutlet weak var borderView: UIView!
    
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var clearLabel: UILabel!
    @IBOutlet weak var reverseSignLabel: UILabel!
    @IBOutlet weak var outputView: UIView!
    @IBOutlet weak var leftBar: UIView!
    @IBOutlet weak var bottomBar: UIView!
    @IBOutlet weak var mrView: UIView!
    @IBOutlet weak var barAndButtonsStack: UIStackView!
    
    var labelArray = [UILabel]()
    var buttonArray = [UIButton]()
    
    var runningNumber = Double()
    var leftString = Double()
    var rightString = Double()
    var currentOperation = 0
    var resetOutput = false
    var decimalPressed = false
    
    ///////////////////
    ///// ON LOAD /////
    ///////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelArray = getLabelsInView(self.view)
        buttonArray = getButtonsInView(self.view)
        formatLabels()
//        leftBar.layoutIfNeeded()
//        leftBar.roundCorners(corners: [.topLeft], radius: 13)
//        bottomBar.layoutIfNeeded()
//        bottomBar.roundCorners(corners: [.bottomRight], radius: 13)
        outputView.layoutIfNeeded()
        outputView.roundCorners(corners: [.allCorners], radius: 13)
//        mrView.layoutIfNeeded()
//        mrView.roundCorners(corners: [.topRight], radius: 13)
        barAndButtonsStack.layoutIfNeeded()
        barAndButtonsStack.roundCorners(corners: [.topLeft, .topRight, .bottomRight], radius: 13)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        let defaults = UserDefaults.standard
        defaults.set(0.0, forKey: "memoryDouble")
        resetCalc()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    func getLabelsInView(_ view: UIView) -> [UILabel] {
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
    
    func getButtonsInView(_ view: UIView) -> [UIButton] {
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
    
    func formatLabels() {
        for label in labelArray {
            label.textColor = TEXT_COLOR
            if label.tag <= 10 {
                label.font = UIFont(name: TEXT_FONT, size: TEXT_SIZE * 1.5)
                label.backgroundColor = COLOR_SALMON
            } else if label.tag == 50 {
                label.font = UIFont(name: TEXT_FONT, size: TEXT_SIZE * 2.0)
                label.backgroundColor = UIColor.clear
            } else {
                label.font = UIFont(name: TEXT_FONT, size: TEXT_SIZE * 1.0)
                if label.tag == 20 {
                    label.backgroundColor = COLOR_ORANGE
                } else if label.tag >= 21 && label.tag <= 31 {
                    label.backgroundColor = COLOR_PINK
                } else if label.tag >= 40 && label.tag <= 43 {
                    label.backgroundColor = COLOR_PURPLE
                }
            }
        }
        stylizeReverseSignLabel()
    }
    
    func stylizeReverseSignLabel() {
        let font: UIFont? = UIFont(name: TEXT_FONT, size: TEXT_SIZE)
        let fontSuper: UIFont? = UIFont(name: TEXT_FONT, size: TEXT_SIZE / 1.5)
        let attString: NSMutableAttributedString = NSMutableAttributedString(string: "+/–", attributes: [NSFontAttributeName: font!])
        attString.setAttributes([NSFontAttributeName: fontSuper!, NSBaselineOffsetAttributeName: 10], range: NSRange(location:0,length:1))
        attString.setAttributes([NSFontAttributeName: fontSuper!, NSBaselineOffsetAttributeName: 2], range: NSRange(location:2,length:1))
        reverseSignLabel.attributedText = attString
    }
    
    //////////////////////////
    ///// BUTTON PRESSES /////
    //////////////////////////
    
    @IBAction func buttonTouchDown(_ sender: AnyObject) {
        labelFadeOut(senderTag: sender.tag)
    }
    
    @IBAction func buttonTouchDragOutside(_ sender: AnyObject) {
        labelFadeIn(senderTag: sender.tag)
    }
    
    @IBAction func buttonTouchUp(_ sender: AnyObject) {
        labelFadeIn(senderTag: sender.tag)
    }
    
    //////////////////////
    ///// ANIMATIONS /////
    //////////////////////
    
    func labelFadeOut(senderTag: Int) {
        for label in labelArray {
            if label.tag == senderTag {
                label.fadeOut()
            }
        }
    }
    
    func labelFadeIn(senderTag: Int) {
        for label in labelArray {
            if label.tag == senderTag {
                label.fadeIn()
            }
        }
    }
    
    ////////////////////////////
    ///// CALCULATOR LOGIC /////
    ////////////////////////////
    
    func resetCalc() {
        print("func resetCalc()")
        runningNumber = 0.0
        leftString = 0.0
        rightString = 0.0
        currentOperation = 0
        resetOutput = false
        outputLabel.text = "0"
        clearLabel.text = "AC"
    }
    
    @IBAction func clearPressed(_ sender: AnyObject) {
        if clearLabel.text == "AC" {
            resetCalc()
        } else {
            runningNumber = 0.0
            outputLabel.text = "0"
            clearLabel.text = "AC"
        }
    }
    
    @IBAction func numberPressed(_ sender: UIButton) {
        
        if resetOutput {
            resetCalc()
        }
        
        clearLabel.text = "C"
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
        
        outputLabel.text = formatOutputText(runningNumber)
    }
    
    @IBAction func decimalPressed(_ sender: AnyObject) {
        
        if !decimalPressed {
            decimalPressed = true
            if resetOutput {
                resetCalc()
            }
        } else {
            // Button press feedback to acknowledge the operation regitsered but invalid
            // Put this in the BUTTON PRESS section?
        }
        
        outputLabel.text = formatOutputText(runningNumber)
    }
    
    @IBAction func operationPressed(_ sender: AnyObject) {
        
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
    
    
    @IBAction func equalsPressed(_ sender: AnyObject) {
        
        decimalPressed = false
        
        if !resetOutput && currentOperation != 0 {
            resetOutput = true
            rightString = runningNumber
            runningNumber = 0.0
        }
        
        processOperation()
    }
    
    @IBAction func reverseSignPressed(_ sender: AnyObject) {
        
        if outputLabel.text != "0" {
            if Double(outputLabel.text!)! == runningNumber {
                runningNumber = runningNumber * -1
                outputLabel.text = formatOutputText(runningNumber)
            } else {
                leftString = leftString * -1
                outputLabel.text = formatOutputText(leftString)
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
        
        outputLabel.text = formatOutputText(leftString)
    }
    
    @IBAction func memoryPressed(_ sender: AnyObject) {
        
        resetOutput = true
        currentOperation = 0
        
        let defaults = UserDefaults.standard
        
        
        if sender.tag == 1 {
            
            defaults.set(0.0, forKey: "memoryDouble")
            
        } else {
            
            var savedDouble = defaults.double(forKey: "memoryDouble")
            
            if sender.tag == 2 {
                savedDouble += Double(outputLabel.text!)!
                defaults.set(savedDouble, forKey: "memoryDouble")
            }
            else if sender.tag == 3 {
                savedDouble -= Double(outputLabel.text!)!
                defaults.set(savedDouble, forKey: "memoryDouble")
            }
            else {
                runningNumber = savedDouble
                outputLabel.text = formatOutputText(runningNumber)
            }
            
            runningNumber = Double(outputLabel.text!)!
            
            print("memoryPressed()")
            print("runningNumber = \(runningNumber)")
        }
    }
    
    func formatOutputText(_ inputDouble: Double) -> String {
        
        var outputString = String()
        
        if inputDouble.truncatingRemainder(dividingBy: 1) == 0 {
            
            outputString = String(Int(inputDouble))
            
            if decimalPressed {
                outputString = outputString + "."
            }
                
        } else {
            outputString = String(inputDouble)
        }
        
        return outputString
    }
    
    func isInt(_ double: Double) -> Bool {
        
        let isInteger = double.truncatingRemainder(dividingBy: 1) == 0
        return isInteger
    }
    
}

//////////////////////
///// EXTENSIONS /////
//////////////////////

extension UIView {
    
    func fadeOut() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
            }, completion: nil)
    }
    
    func fadeIn() {
        UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
            }, completion: nil)
    }
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}
