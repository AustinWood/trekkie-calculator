//
//  ViewController.swift
//  Calculator
//
//  Created by Austin Wood on 2016-08-26.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

/////////////////////////////////////
/////////////// TO DO ///////////////
/////////////////////////////////////    Before submission to David for code review:

// Add animation/styling for operation depressed (for example, Apple iPhone calc app has black border)
// Trailing zeros acting funky
// Bug: Pressing Clear after Equals, then Operation, then a Number, does not consider 0 to be the Left number
// outputLabel.text = Inf for infity
// Verify that C vs AC works as it should
// Programmatically set outputLabel.fontSize so 9 digits fit snugly
// Center outputLabel vertically in outputView
// Add animation to outputLabel when numberPressed() and String is too long
// Verify layout on all device sizes

/////////////////////////
///// BEFORE LAUNCH /////
/////////////////////////

// Set . vs , for decimal based on phone settings
// Thousands separaters
// Add sound effects
// Create app icon
// Create launch screen

//////////////
///// v2 /////
//////////////

// Make isTooBig() dependent on Bool.max, not Int.max
// Register hardware keyboard presses
// Add second label that shows previous operations
// Add slide in animation to outputLabel: http://www.andrewcbancroft.com/2014/09/24/slide-in-animation-in-swift/
// Adjust layout if Personal Hotspot, etc is turned on

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
    
    @IBAction func buttonTouchDown(_ sender: AnyObject) {
        print("----------")
        touchDownArray.append(sender.tag)
        animateLabel(senderTag: sender.tag, duration: 0.25, textColor: UIColor.white, backgroundFinal: false)
    }
    
    @IBAction func buttonTouchDragOutside(_ sender: AnyObject) {
        if touchDownArray.contains(sender.tag) {
            touchDownArray = touchDownArray.filter { $0 != sender.tag }
            animateLabel(senderTag: sender.tag, duration: 0.25, textColor: UIColor.black, backgroundFinal: false)
        }
    }
    
    @IBAction func buttonTouchUp(_ sender: AnyObject) {
        touchDownArray = touchDownArray.filter { $0 != sender.tag }
        animateLabel(senderTag: sender.tag, duration: 0.4, textColor: UIColor.black, backgroundFinal: true)
    }
    
    func animateLabel(senderTag: Int, duration: TimeInterval, textColor: UIColor, backgroundFinal: Bool) {
        for label in labelArray {
            if label.tag == senderTag {
                let labelColor = getLabelBackgroundColor(labelTag: senderTag)
                var backgroundColor = UIColor.black
                if backgroundFinal {
                    backgroundColor = labelColor
                }
                label.animate(duration: duration, textColor: textColor, backgroundColor: backgroundColor, labelColor: labelColor)
            }
        }
    }
    
    ////////////////////////////
    ///// CALCULATOR LOGIC /////
    ////////////////////////////
    
    var leftNumber = Double()
    var rightNumber = Double()
    
    var resetOutput = false
    var resetOperation = false
    var decimalPressed = false
    var outputTextIsRightNum = true
    
    func resetCalc() {
        print("func resetCalc()")
        leftNumber = 0.0
        rightNumber = 0.0
        trailingZeros = 0
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
            trailingZeros = 0
            rightNumber = 0.0
            decimalPressed = false
            outputLabel.text = "0"
            clearLabel.text = "AC"
            if resetOutput {
                currentOperation = .none
                if resetOperation {
                    leftNumber = 0.0
                }
            }
        }
    }
    
    @IBAction func numberPressed(_ sender: UIButton) {
        print("func numberPressed(\(sender.tag))")
        if resetOutput {
            rightNumber = 0.0
            resetOutput = false
        }
        if resetOperation {
            currentOperation = .none
        }
        clearLabel.text = "C"
        let number = sender.tag
        if !decimalPressed {
            rightNumber = Double(String(Int(rightNumber)) + String(number))!
        } else {
            if isInt(rightNumber) && trailingZeros == 0 {
                rightNumber = Double(String(Int(rightNumber)) + "." + String(number))!
            } else {
                var rightString = String(rightNumber)
                print(rightString)
                rightString = addTrailingZeros(inputString: rightString)
                print(rightString)
                rightString = rightString + String(number)
                rightNumber = Double(rightString)!
            }
            if sender.tag == 0 {
                trailingZeros += 1
            } else {
                trailingZeros = 0
            }
        }
        updateOutputLabel(rightNumber)
    }
    
    var trailingZeros = 0
    
    @IBAction func decimalPressed(_ sender: AnyObject) {
        print("func decimalPressed()")
        if !decimalPressed {
            if resetOutput {
                rightNumber = 0.0
                trailingZeros = 0
                resetOutput = false
            }
            decimalPressed = true
        }
        updateOutputLabel(rightNumber)
    }
    
    @IBAction func reverseSignPressed(_ sender: AnyObject) {
        print("func reverseSignPressed()")
        if outputTextIsRightNum {
            rightNumber = rightNumber * -1
            updateOutputLabel(rightNumber)
        } else {
            leftNumber = leftNumber * -1
            updateOutputLabel(leftNumber)
        }
    }
    
    @IBAction func equalsPressed(_ sender: AnyObject) {
        print("func equalsPressed()")
        decimalPressed = false
        resetOutput = true
        resetOperation = true
        trailingZeros = 0
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
        resetOperation = false
        trailingZeros = 0
        if !resetOutput {
            processOperation()
        }
    }
    
    func processOperation() {
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
        leftNumber = calculation
        updateOutputLabel(leftNumber)
        resetOutput = true
        decimalPressed = false
    }
    
    //////////////////
    ///// MEMORY /////
    //////////////////
    
    @IBAction func memoryPressed(_ sender: AnyObject) {
        resetOutput = true
        currentOperation = .none
        let defaults = UserDefaults.standard
        if sender.tag == 40 {
            print("func memoryPressed(MC)")
            defaults.set(0.0, forKey: "memoryDouble")
        } else {
            var savedDouble = defaults.double(forKey: "memoryDouble")
            if sender.tag == 43 {
                print("func memoryPressed(MR)")
                leftNumber = savedDouble
                updateOutputLabel(leftNumber)
            } else {
                var displayedNumber = leftNumber
                if outputTextIsRightNum {
                    displayedNumber = rightNumber
                }
                if sender.tag == 41 {
                    print("func memoryPressed(M+)")
                    savedDouble += displayedNumber
                } else {
                    print("func memoryPressed(M-)")
                    savedDouble -= displayedNumber
                }
                if isTooBig(savedDouble) {
                    resetCalc()
                    defaults.set(0.0, forKey: "memoryDouble")
                    outputLabel.text = "That's big!"
                } else {
                    defaults.set(savedDouble, forKey: "memoryDouble")
                }
            }
        }
    }
    
    ///////////////////////////////////
    ///// MISCELLANEOUS FUNCTIONS /////
    ///////////////////////////////////
    
    func doubleToString(_ inputDouble: Double) -> String {
        if isTooBig(inputDouble) {
            return "That's big!"
        } else if abs(inputDouble) >= 1000000000 {
            let val = inputDouble as NSNumber
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.scientific
            numberFormatter.positiveFormat = "0.###E+0"
            numberFormatter.exponentSymbol = "e"
            if let stringFromNumber = numberFormatter.string(from: val) {
                return(stringFromNumber)
            } else {
                return "Error"
            }
        } else {
            var outputString = String()
            if isInt(inputDouble) {
                outputString = String(Int(inputDouble))
                if decimalPressed {
                    outputString = outputString + "."
                }
            } else {
                outputString = String(inputDouble)
            }
            outputString = addTrailingZeros(inputString: outputString)
            return outputString
        }
    }
    
    func updateOutputLabel(_ inputDouble: Double) {
        if inputDouble == rightNumber {
            outputTextIsRightNum = true
        } else {
            outputTextIsRightNum = false
        }
        outputLabel.text = doubleToString(inputDouble)
    }
    
    func addTrailingZeros(inputString: String) -> String {
        var mutableString = inputString
        if trailingZeros > 0 {
            for _ in 1...trailingZeros {
                mutableString += "0"
            }
        }
        return mutableString
    }
    
    func isInt(_ double: Double) -> Bool {
        let isInteger = double.truncatingRemainder(dividingBy: 1) == 0
        return isInteger
    }
    
    func isTooBig(_ inputDouble: Double) -> Bool {
        if abs(inputDouble) > Double(Int.max) {
            return true
        } else {
            return false
        }
    }
}

///////////////////////////////////////////////////////
///// EXTENSIONS (ANIMATIONS and CORNER ROUNDING) /////
///////////////////////////////////////////////////////

extension UILabel {
    
    func animate(duration: TimeInterval, textColor: UIColor, backgroundColor: UIColor, labelColor: UIColor) {
        UILabel.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {() -> Void in
            self.textColor = textColor
            self.backgroundColor = backgroundColor
            }, completion: {(finished: Bool) -> Void in
                if textColor == backgroundColor {
                    self.animate(duration: 0.5, textColor: UIColor.black, backgroundColor: labelColor, labelColor: labelColor)
                }
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
