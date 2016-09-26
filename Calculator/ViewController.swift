//
//  ViewController.swift
//  Calculator
//
//  Created by Austin Wood on 2016-08-26.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

//////////////////////////////////
///// TO DO before v1 launch /////
//////////////////////////////////

// Inverse sign puts - on 0
// Bug: MR can't be the right number in an operation
// Programmatically determine how many digits can fit on the screen
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
    
    
    @IBOutlet weak var outputLabel: CustomLabel!
    @IBOutlet weak var clearLabel: UILabel!
    @IBOutlet weak var invertSignLabel: UILabel!
    
    @IBOutlet weak var outputView: RoundedView!
    @IBOutlet weak var megaView: RoundedView!
    
    @IBOutlet weak var leftBar: UIView!
    @IBOutlet weak var bottomBar: UIView!
    
    var labelArray = [CustomLabel]()
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
        leftBar.backgroundColor = CalcColor.purple
        bottomBar.backgroundColor = CalcColor.purple
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
    
    func getLabelsInView(_ view: UIView) -> [CustomLabel] {
        var results = [CustomLabel]()
        for subview in view.subviews as [UIView] {
            if let labelView = subview as? CustomLabel {
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
        var labelBackgroundColor = CalcColor.salmon
        if labelTag == 50 {
            labelBackgroundColor = UIColor.clear
        } else if labelTag == 51 {
            labelBackgroundColor = CalcColor.tan
        } else if labelTag == 20 {
            labelBackgroundColor = CalcColor.orange
        } else if labelTag >= 21 && labelTag <= 31 {
            labelBackgroundColor = CalcColor.pink
        } else if labelTag >= 40 && labelTag <= 43 {
            labelBackgroundColor = CalcColor.purple
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
    
    func getLabel(senderTag: Int) -> CustomLabel {
        var theLabel = CustomLabel()
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
    
    var outputTextIsRightNum = true
    
    func resetCalc() {
        print("func resetCalc()")
        leftNumber = 0.0
        rightNumber = 0.0
        trailingZeros = 0
        currentOperation = .none
        resetOutput = false
        decimalShown = false
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
            decimalShown = false
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
    
    var trailingZeros = 0
    
    @IBAction func numberPressed(_ sender: UIButton) {
        print("func numberPressed(\(sender.tag))")
        var proceedWithInput = true
        if resetOutput {
            rightNumber = 0.0
            resetOutput = false
        } else if abs(rightNumber) > pow(10, 40) || (outputLabel.text?.characters.count)! >= 13 {
            proceedWithInput = false
        }
        if resetOperation {
            currentOperation = .none
        }
        clearLabel.text = "C"
        if proceedWithInput {
            let number = sender.tag
            let formatNumber = initializeFormatNumber(numberToFormat: rightNumber)
            var rightString = formatNumber.standardNotation()
            print("old rightDouble: \(rightNumber)")
            print("old rightString: \(rightString)")
            rightString += String(number)
            print("new rightString: \(rightString)")
            rightNumber = Double(rightString)!
            print("new rightDouble: \(rightNumber)")
            if decimalShown {
                if sender.tag == 0 {
                    trailingZeros += 1
                } else {
                    trailingZeros = 0
                }
            }
            updateOutputLabel(rightNumber)
        } else {
            animateOutputLabel()
        }
    }
    
    var decimalShown = false
    
    @IBAction func decimalPressed(_ sender: AnyObject) {
        print("func decimalPressed()")
        if !decimalShown {
            if resetOutput {
                rightNumber = 0.0
                trailingZeros = 0
                resetOutput = false
            }
            decimalShown = true
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
        decimalShown = false
        resetOutput = true
        resetOperation = true
        trailingZeros = 0
        performOperation()
    }
    
    //////////////////////
    ///// OPERATIONS /////
    //////////////////////
    
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
            performOperation()
        }
    }
    
    func performOperation() {
        let operationHandler = OperationHandler(currentOperation: currentOperation, leftNumber: leftNumber, rightNumber: rightNumber)
        leftNumber = operationHandler.processOperation()
        resetOutput = true
        decimalShown = false
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
    
    func initializeFormatNumber(numberToFormat: Double) -> FormatNumber {
        let formatNumber = FormatNumber(numberToFormat: numberToFormat, decimalShown: decimalShown, trailingZeros: trailingZeros)
        return formatNumber
    }
    
    func updateOutputLabel(_ inputDouble: Double) {
        print("func updateOutputLabel()")
        if inputDouble == rightNumber {
            outputTextIsRightNum = true
        } else {
            outputTextIsRightNum = false
        }
        let formatNumber = initializeFormatNumber(numberToFormat: inputDouble)
        let outputText = formatNumber.convertDoubleToString()
        outputLabel.text = outputText
        if outputText.contains("∞") {
            animateOutputLabel()
        }
    }
    
}
