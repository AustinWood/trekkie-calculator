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

// Clean up CALCULATOR LOGIC code
// Reconnect all buttons to their original functions
// Reconsider color scheme

// Programmatically set outputLabel.fontSize so 9 digits fit snugly
// Rename leftString and rightString -- they're no longer strings!
// Add animation/styling for operation depressed (for example, Apple iPhone calc app has black border)
// Add animation to outputLabel when numberPressed() and String is too long
// Long decimals and big numbers cut off with "..."
// Put colors in a separate file
// C vs AC
// Make Memory buttons a SWITCH statement
// Make currentOperation a SWITCH statement
// Register hardware keyboard presses
// Add second label that shows previous operations
// Add slide in animation to new numbers: http://www.andrewcbancroft.com/2014/09/24/slide-in-animation-in-swift/
// Adjust layout if Personal Hotspot, etc is turned on
// Add sound effects
// Create app icon
// Create launch screen
// Create info/about screen?
// Make iPhone only (no iPad)

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

class ViewController: UIViewController {
    
    ////////////////////////////
    ///// OUTLETS and VARS /////
    ////////////////////////////
    
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var clearLabel: UILabel!
    @IBOutlet weak var reverseSignLabel: UILabel!
    
    @IBOutlet weak var outputView: UIView!
    @IBOutlet weak var megaView: UIView!
    
    var labelArray = [UILabel]()
    var buttonArray = [UIButton]()
    
    ///////////////////
    ///// ON LOAD /////
    ///////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelArray = getLabelsInView(self.view)
        buttonArray = getButtonsInView(self.view)
        formatLabels()
        outputView.layoutIfNeeded()
        outputView.roundCorners(corners: [.allCorners], radius: 10)
        megaView.layoutIfNeeded()
        megaView.roundCorners(corners: [.topLeft, .topRight, .bottomRight], radius: 10)
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
            let backgroundColor = getLabelBackgroundColor(labelTag: label.tag)
            label.backgroundColor = backgroundColor
            if label.tag <= 10 {
                label.font = UIFont(name: TEXT_FONT, size: TEXT_SIZE * 1.5)
            } else if label.tag == 50 {
                label.font = UIFont(name: TEXT_FONT, size: TEXT_SIZE * 2.0)
                // let labelWidth = outputLabel.frame.width
                // let textSize = outputLabel.text!.size(attributes: [NSFontAttributeName: outputLabel.font])
                // let textWidth: CGFloat = textSize.width
            } else {
                label.font = UIFont(name: TEXT_FONT, size: TEXT_SIZE * 1.0)
            }
        }
        stylizeReverseSignLabel()
    }
    
    func getLabelBackgroundColor(labelTag: Int) -> UIColor {
        var labelBackgroundColor = COLOR_SALMON
        if labelTag == 50 {
            labelBackgroundColor = UIColor.clear
        } else if labelTag == 20 {
            labelBackgroundColor = COLOR_ORANGE
        } else if labelTag >= 21 && labelTag <= 31 {
            labelBackgroundColor = COLOR_PINK
        } else if labelTag >= 40 && labelTag <= 43 {
            labelBackgroundColor = COLOR_PURPLE
        }
        return labelBackgroundColor
    }

    func stylizeReverseSignLabel() {
        let font: UIFont? = UIFont(name: TEXT_FONT, size: TEXT_SIZE)
        let fontSuper: UIFont? = UIFont(name: TEXT_FONT, size: TEXT_SIZE / 1.5)
        let attString: NSMutableAttributedString = NSMutableAttributedString(string: "+/–", attributes: [NSFontAttributeName: font!])
        attString.setAttributes([NSFontAttributeName: fontSuper!, NSBaselineOffsetAttributeName: 10], range: NSRange(location:0,length:1))
        attString.setAttributes([NSFontAttributeName: fontSuper!, NSBaselineOffsetAttributeName: 2], range: NSRange(location:2,length:1))
        reverseSignLabel.attributedText = attString
    }
    
    //////////////////////
    ///// ANIMATIONS /////
    //////////////////////
    
    var touchDownArray = [Int]()
    
    enum animationType {
        case fadeOut
        case fadeCancel
        case fadeIn
    }
    
    @IBAction func buttonTouchDown(_ sender: AnyObject) {
        print("----------")
        touchDownArray.append(sender.tag)
        animateLabel(senderTag: sender.tag, animationType: .fadeOut)
    }
    
    @IBAction func buttonTouchDragOutside(_ sender: AnyObject) {
        if touchDownArray.contains(sender.tag) {
            touchDownArray = touchDownArray.filter { $0 != sender.tag }
            animateLabel(senderTag: sender.tag, animationType: .fadeCancel)
        }
    }
    
    @IBAction func buttonTouchUp(_ sender: AnyObject) {
        touchDownArray = touchDownArray.filter { $0 != sender.tag }
        animateLabel(senderTag: sender.tag, animationType: .fadeIn)
    }
    
    func animateLabel(senderTag: Int, animationType: animationType) {
        let labelBackgroundColor = getLabelBackgroundColor(labelTag: senderTag)
        for label in labelArray {
            if label.tag == senderTag {
                switch animationType {
                case .fadeOut:
                    label.fadeOut()
                case .fadeCancel:
                    label.fadeCancel(labelBackgroundColor: labelBackgroundColor)
                case .fadeIn:
                    label.fadeIn(labelBackgroundColor: labelBackgroundColor)
                }
                break
            }
        }
    }
    
    ////////////////////////////
    ///// CALCULATOR LOGIC /////
    ////////////////////////////
    
    var runningNumber = Double()
    var leftString = Double()
    var rightString = Double()
    
    var resetOutput = false
    var decimalPressed = false
    
    func resetCalc() {
        print("func resetCalc()")
        runningNumber = 0.0
        leftString = 0.0
        rightString = 0.0
        currentOperation = .none
        resetOutput = false
        decimalPressed = false
        outputLabel.text = "0"
        clearLabel.text = "AC"
    }
    
    @IBAction func clearPressed(_ sender: AnyObject) {
        print("func clearPressed()")
        if clearLabel.text == "AC" {
            resetCalc()
        } else {
            runningNumber = 0.0
            outputLabel.text = "0"
            clearLabel.text = "AC"
        }
    }
    
    @IBAction func numberPressed(_ sender: UIButton) {
        print("func numberPressed(\(sender.tag))")
        if resetOutput {
            resetCalc()
        }
        clearLabel.text = "C"
        let number = sender.tag
        var tempRunningNumber = runningNumber
        if !decimalPressed {
            tempRunningNumber = Double(String(Int(runningNumber)) + String(number))!
        } else {
            if isInt(runningNumber) {
                tempRunningNumber = Double(String(Int(runningNumber)) + "." + String(number))!
            } else {
                tempRunningNumber = Double(String(runningNumber) + String(number))!
            }
        }
        if doubleToString(tempRunningNumber).characters.count > 9 {
            // Animate outputLabel
            print("String too long")
        } else {
            runningNumber = tempRunningNumber
            updateOutputLabel(runningNumber)
        }
    }
    
    @IBAction func decimalPressed(_ sender: AnyObject) {
        print("func decimalPressed()")
        if !decimalPressed {
            if resetOutput {
                resetCalc()
            }
            decimalPressed = true
        }
        updateOutputLabel(runningNumber)
    }
    
    @IBAction func reverseSignPressed(_ sender: AnyObject) {
        print("func reverseSignPressed()")
        if outputLabel.text != "0" {
            if Double(outputLabel.text!)! == runningNumber {
                runningNumber = runningNumber * -1
                updateOutputLabel(runningNumber)
            } else {
                leftString = leftString * -1
                updateOutputLabel(leftString)
            }
        }
    }
    
    @IBAction func equalsPressed(_ sender: AnyObject) {
        print("func equalsPressed()")
        decimalPressed = false
        if !resetOutput && currentOperation != .none {
            resetOutput = true
            rightString = runningNumber
            runningNumber = 0.0
        }
        processOperation()
    }
    
    //////////////////////
    ///// OPERATIONS /////
    //////////////////////
    
    enum operation {
        case none
        case add
        case subtract
        case multiply
        case divide
    }
    
    var currentOperation: operation = .none
    
    @IBAction func addPressed(_ sender: AnyObject) {
        print("func addPressed()")
        operationPressed()
        currentOperation = .add
    }
    
    @IBAction func subtractPressed(_ sender: AnyObject) {
        print("func subtractPressed()")
        operationPressed()
        currentOperation = .subtract
    }
    
    @IBAction func multiplyPressed(_ sender: AnyObject) {
        print("func multiplyPressed()")
        operationPressed()
        currentOperation = .multiply
    }
    
    @IBAction func dividePressed(_ sender: AnyObject) {
        print("func dividePressed()")
        operationPressed()
        currentOperation = .divide
    }
    
    func operationPressed() {
        print("func operationPressed()")
        print("resetOutput = \(resetOutput)")
        decimalPressed = false
        if currentOperation == .none {
            leftString = runningNumber
        } else if !resetOutput {
            rightString = runningNumber
            processOperation()
        }
        runningNumber = 0.0
        resetOutput = false
    }
    
    func processOperation() {
        print("func processOperation(\(currentOperation))")
        var calculation = Double()
        switch currentOperation {
        case .none:
            calculation = runningNumber
        case .add:
            calculation = leftString + rightString
            print("\(leftString) + \(rightString) = \(calculation)")
        case .subtract:
            calculation = leftString - rightString
            print("\(leftString) - \(rightString) = \(calculation)")
        case .multiply:
            calculation = leftString * rightString
            print("\(leftString) * \(rightString) = \(calculation)")
        case .divide:
            calculation = leftString / rightString
            print("\(leftString) / \(rightString) = \(calculation)")
        }
        if isTooBig(calculation) {
            resetCalc()
            outputLabel.text = "Error"
        } else {
            leftString = calculation
            updateOutputLabel(leftString)
        }
    }
    
    //////////////////
    ///// MEMORY /////
    //////////////////
    
    @IBAction func memoryPressed(_ sender: AnyObject) {
        resetOutput = true
        currentOperation = .none
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
                updateOutputLabel(runningNumber)
            }
            runningNumber = Double(outputLabel.text!)!
        }
    }
    
    ///////////////////////////////////
    ///// MISCELLANEOUS FUNCTIONS /////
    ///////////////////////////////////
    
    func doubleToString(_ inputDouble: Double) -> String {
        var outputString = String()
        if isInt(inputDouble) {
            outputString = String(Int(inputDouble))
            if decimalPressed {
                outputString = outputString + "."
            }
        } else {
            outputString = String(inputDouble)
        }
        return outputString
    }
    
    func updateOutputLabel(_ inputDouble: Double) {
        outputLabel.text = doubleToString(inputDouble)
    }
    
    func isInt(_ double: Double) -> Bool {
        let isInteger = double.truncatingRemainder(dividingBy: 1) == 0
        return isInteger
    }
    
    func isTooBig(_ double: Double) -> Bool {
        if double < 1000000000 {
            return false
        } else {
            return true
        }
    }
}

///////////////////////////////////////////////////////
///// EXTENSIONS (ANIMATIONS and CORNER ROUNDING) /////
///////////////////////////////////////////////////////

extension UILabel {
    
    func fadeOut() {
        UILabel.transition(with: self, duration: 0.25, options: .transitionCrossDissolve, animations: {() -> Void in
            self.textColor = UIColor.white
            self.backgroundColor = UIColor.black
            }, completion: {(finished: Bool) -> Void in
        })
    }
    
    func fadeCancel(labelBackgroundColor: UIColor) {
        UILabel.transition(with: self, duration: 0.25, options: .transitionCrossDissolve, animations: {() -> Void in
            self.textColor = UIColor.black
            self.backgroundColor = UIColor.black
            }, completion: {(finished: Bool) -> Void in
                UILabel.transition(with: self, duration: 0.5, options: .transitionCrossDissolve, animations: {() -> Void in
                    self.textColor = UIColor.black
                    self.backgroundColor = labelBackgroundColor
                    }, completion: {(finished: Bool) -> Void in
                })
        })
    }
    
    func fadeIn(labelBackgroundColor: UIColor) {
        UILabel.transition(with: self, duration: 0.4, options: .transitionCrossDissolve, animations: {() -> Void in
            self.textColor = UIColor.black
            self.backgroundColor = labelBackgroundColor
            }, completion: {(finished: Bool) -> Void in
        })
    }
}

extension UIView {
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
