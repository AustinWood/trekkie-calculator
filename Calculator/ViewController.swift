//
//  ViewController.swift
//  Calculator
//
//  Created by Austin Wood on 2016-08-26.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

///////////////////////////
///// NOTES FOR DAVID /////
///////////////////////////

// You can only input a number up to roughly 7.8e+19 (90% of Int.max), since the func numberPressed() works on a sequence of casting Int to String to Double. In a future version, I'd like to remove this limitation. The calculations, however, can go up to 1e+308 before displaying Infinity.
// I know there are lots of DRY violations with the animations. If you have any insight on how to write the animation code more efficiently that would be awesome. Trying to make the animation code more efficient is probably the thing that I've spent the most time on that doesn't actually make any difference to the end-user experience.

//////////////////////////////////
///// TO DO before v1 launch /////
//////////////////////////////////

// Can I make addTrailingZeros() more efficient by using NumberFormatter?
// Adjust layout for iPad: Change ratio of "1 View" from 1:1 to 4:3 and everything magically works, learn about Xcode 8 adaptive layouts
// Set . vs , for decimal based on phone settings (most countries, other than US and UK, use comma for decimal and period for thousands separater)
// Thousands separater?
// Press and hold on outputLabel copies to clipboard
// Adjust layout if enlarged status bar due to Personal Hotspot, GPS, Phone, etc
// Add sound effects?
// Create app icon
// Create launch screen

////////////////////////
///// TO DO for v2 /////
////////////////////////

// Register hardware keyboard presses
// Remove Int.max limit on input numbers
// Add second label that shows previous operations?
// Add slide in animation to outputLabel: http://www.andrewcbancroft.com/2014/09/24/slide-in-animation-in-swift/

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
// 31: Invert sign
//
// 40: MC
// 41: M+
// 42: M-
// 43: MR
//
// 50: Output label
// 51: Output background label

import UIKit

//////////////////
///// COLORS /////
//////////////////

let COLOR_TAN = UIColor(red:0.996, green:0.796, blue:0.612, alpha:1.00)
let COLOR_SALMON = UIColor(red:0.992, green:0.600, blue:0.420, alpha:1.00)
let COLOR_PINK = UIColor(red:0.796, green:0.604, blue:0.796, alpha:1.00)
let COLOR_PURPLE = UIColor(red:0.600, green:0.604, blue:0.792, alpha:1.00)
let COLOR_ORANGE = UIColor(red:0.992, green:0.596, blue:0.153, alpha:1.00)

////////////////
///// TEXT /////
////////////////

let TEXT_FONT = "FinalFrontierOldStyle"
let TEXT_SIZE = 28 as CGFloat
let TEXT_COLOR = UIColor.black

var isAnimatingOutputLabel = false

class ViewController: UIViewController {
    
    ////////////////////////////
    ///// OUTLETS and VARS /////
    ////////////////////////////
    
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var clearLabel: UILabel!
    @IBOutlet weak var invertSignLabel: UILabel!
    
    @IBOutlet weak var outputView: UIView!
    @IBOutlet weak var megaView: UIView!
    
    @IBOutlet weak var leftBar: UIView!
    @IBOutlet weak var bottomBar: UIView!
    
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
        leftBar.backgroundColor = COLOR_PURPLE
        bottomBar.backgroundColor = COLOR_PURPLE
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
            } else {
                label.font = UIFont(name: TEXT_FONT, size: TEXT_SIZE * 1.0)
            }
        }
        stylizeInvertSignLabel()
    }
    
    func getLabelBackgroundColor(labelTag: Int) -> UIColor {
        var labelBackgroundColor = COLOR_SALMON
        if labelTag == 50 {
            labelBackgroundColor = UIColor.clear
        } else if labelTag == 51 {
            labelBackgroundColor = COLOR_TAN
        } else if labelTag == 20 {
            labelBackgroundColor = COLOR_ORANGE
        } else if labelTag >= 21 && labelTag <= 31 {
            labelBackgroundColor = COLOR_PINK
        } else if labelTag >= 40 && labelTag <= 43 {
            labelBackgroundColor = COLOR_PURPLE
        }
        return labelBackgroundColor
    }

    func stylizeInvertSignLabel() {
        let font: UIFont? = UIFont(name: TEXT_FONT, size: TEXT_SIZE)
        let fontSuper: UIFont? = UIFont(name: TEXT_FONT, size: TEXT_SIZE / 1.5)
        let attString: NSMutableAttributedString = NSMutableAttributedString(string: "+/–", attributes: [NSFontAttributeName: font!])
        attString.setAttributes([NSFontAttributeName: fontSuper!, NSBaselineOffsetAttributeName: 10], range: NSRange(location:0,length:1))
        attString.setAttributes([NSFontAttributeName: fontSuper!, NSBaselineOffsetAttributeName: 2], range: NSRange(location:2,length:1))
        invertSignLabel.attributedText = attString
    }
    
    //////////////////////
    ///// ANIMATIONS /////
    //////////////////////
    
    var touchDownArray = [Int]()
    
    @IBAction func buttonTouchDown(_ sender: AnyObject) {
        print("----------")
        touchDownArray.append(sender.tag)
        let label = getLabel(senderTag: sender.tag)
        let labelColor = getLabelBackgroundColor(labelTag: sender.tag)
        label.animate(duration: 0.25, textColor: UIColor.white, backgroundColor: UIColor.black, labelColor: labelColor)
    }
    
    @IBAction func buttonTouchDragOutside(_ sender: AnyObject) {
        if touchDownArray.contains(sender.tag) {
            touchDownArray = touchDownArray.filter { $0 != sender.tag }
            let label = getLabel(senderTag: sender.tag)
            let labelColor = getLabelBackgroundColor(labelTag: sender.tag)
            label.animate(duration: 0.25, textColor: UIColor.black, backgroundColor: UIColor.black, labelColor: labelColor)
        }
    }
    
    @IBAction func buttonTouchUp(_ sender: AnyObject) {
        touchDownArray = touchDownArray.filter { $0 != sender.tag }
        let label = getLabel(senderTag: sender.tag)
        let labelColor = getLabelBackgroundColor(labelTag: sender.tag)
        if sender.tag == 20 || (sender.tag == 30 && getLabel(senderTag: 30).text == "AC") {
            resetOperationColors()
        }
        if sender.tag >= 21 && sender.tag <= 24 {
            resetOperationColors()
            label.animate(duration: 0.4, textColor: UIColor.black, backgroundColor: UIColor.white, labelColor: labelColor)
        } else {
            label.animate(duration: 0.4, textColor: UIColor.black, backgroundColor: labelColor, labelColor: labelColor)
        }
    }
    
    func animateOutputLabel() {
        if !isAnimatingOutputLabel {
            outputLabel.animateOutputLabel(duration: 0.4, textColor: UIColor.white)
            getLabel(senderTag: 51).animateOutputBackground(duration: 0.4, backgroundColor: UIColor.black)
        }
    }
    
    func resetOperationColors() {
        for operationLabel in 21...24 {
            let label = getLabel(senderTag: operationLabel)
            let labelColor = getLabelBackgroundColor(labelTag: operationLabel)
            label.animate(duration: 0.4, textColor: UIColor.black, backgroundColor: labelColor, labelColor: labelColor)
        }
    }
    
    func getLabel(senderTag: Int) -> UILabel {
        var theLabel = UILabel()
        for label in labelArray {
            if label.tag == senderTag {
                theLabel = label
            }
        }
        return theLabel
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
        var proceedWithInput = true
        if resetOutput {
            rightNumber = 0.0
            resetOutput = false
        } else {
            if rightNumber >= Double(Int.max) * 0.9 || (outputLabel.text?.characters.count)! >= 13 {
                proceedWithInput = false
            }
        }
        if resetOperation {
            currentOperation = .none
        }
        clearLabel.text = "C"
        if proceedWithInput {
            let number = sender.tag
            var rightString = standardNotationString(rightNumber)
            rightString += String(number)
            rightNumber = Double(rightString)!
            if decimalPressed {
                if sender.tag == 0 {
                    trailingZeros += 1
                } else {
                    trailingZeros = 0
                }
            }
        } else {
            animateOutputLabel()
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
            updateOutputLabel(rightNumber)
        }
    }
    
    @IBAction func invertSignPressed(_ sender: AnyObject) {
        print("func invertSignPressed()")
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
        resetOutput = true
        decimalPressed = false
        if currentOperation != .none {
            updateOutputLabel(leftNumber)
        }
    }
    
    //////////////////
    ///// MEMORY /////
    //////////////////
    
    @IBAction func memoryPressed(_ sender: AnyObject) {
        let defaults = UserDefaults.standard
        if sender.tag == 40 {
            print("func memoryPressed(MC)")
            defaults.set(0.0, forKey: "memoryDouble")
        } else {
            var savedDouble = defaults.double(forKey: "memoryDouble")
            if sender.tag == 43 {
                print("func memoryPressed(MR)")
                resetOutput = true
                currentOperation = .none
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
                defaults.set(savedDouble, forKey: "memoryDouble")
            }
        }
    }
    
    /////////////////////////////
    ///// NUMBER FORMATTING /////
    /////////////////////////////
    
    func scientificNotationString(_ inputDouble: Double) -> String {
        print("func scientificNotationString()")
        let val = inputDouble as NSNumber
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumIntegerDigits = 1
        numberFormatter.decimalSeparator = "."
        numberFormatter.numberStyle = NumberFormatter.Style.scientific
        numberFormatter.positiveFormat = "0.###E+0"
        numberFormatter.negativeFormat = "0.###E-0"
        numberFormatter.exponentSymbol = "e"
        if let stringFromNumber = numberFormatter.string(from: val) {
            return(stringFromNumber)
        } else {
            return "Error"
        }
    }
    
    func standardNotationString(_ inputDouble: Double) -> String {
        print("func standardNotationString()")
        let val = inputDouble as NSNumber
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumIntegerDigits = 1
        numberFormatter.decimalSeparator = "."
        if decimalPressed {
            numberFormatter.alwaysShowsDecimalSeparator = true
        }
        var integerDigits = 1
        if abs(inputDouble) >= 1 {
            integerDigits = Int(log10(abs(inputDouble))) + 1
        }
        if inputDouble < 0 {
            integerDigits += 1
        }
        numberFormatter.maximumFractionDigits = 12 - integerDigits
        if let stringFromNumber = numberFormatter.string(from: val) {
            let outputString = addTrailingZeros(inputString: stringFromNumber)
            return outputString
        } else {
            return "Error"
        }
    }
    
    func updateOutputLabel(_ inputDouble: Double) {
        print("func updateOutputLabel()")
        if inputDouble == rightNumber {
            outputTextIsRightNum = true
        } else {
            outputTextIsRightNum = false
        }
        if abs(inputDouble) >= 1000000000 || (abs(inputDouble) <= 0.00000000001 && inputDouble != 0.0) {
            let outputText = scientificNotationString(inputDouble)
            outputLabel.text = outputText
            if outputText.contains("∞") {
                animateOutputLabel()
            }
        } else {
            outputLabel.text = standardNotationString(inputDouble)
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
    
    func isInt(_ double: Double) -> Bool {
        let isInteger = double.truncatingRemainder(dividingBy: 1) == 0
        return isInteger
    }
}

///////////////////////////////////////////////////////
///// EXTENSIONS (ANIMATIONS and CORNER ROUNDING) /////
///////////////////////////////////////////////////////

extension UILabel {
    
    func animateOutputLabel(duration: TimeInterval, textColor: UIColor) {
        isAnimatingOutputLabel = true
        UILabel.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {() -> Void in
            self.textColor = textColor
            }, completion: {(finished: Bool) -> Void in
                if self.textColor == UIColor.white {
                    self.animateOutputLabel(duration: 0.35, textColor: UIColor.black)
                } else {
                    isAnimatingOutputLabel = false
                }
        })
    }
    
    func animateOutputBackground(duration: TimeInterval, backgroundColor: UIColor) {
        UILabel.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {() -> Void in
            self.backgroundColor = backgroundColor
            }, completion: {(finished: Bool) -> Void in
                if self.backgroundColor == UIColor.black {
                    self.animateOutputBackground(duration: 0.35, backgroundColor: COLOR_TAN)
                }
        })
    }
    
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
