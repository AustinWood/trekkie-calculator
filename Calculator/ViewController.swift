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

// View is layed out improperly when orientation (etc?) changes
// Bug: MR can't be the right number in an operation
// Press and hold on outputLabel copies to clipboard
// Create app icon
// Create launch screen

////////////////////////
///// TO DO for v2 /////
////////////////////////

// Move CALCULATOR LOGIC to Model
// Move MEMORY to Model
// Add sound effects?
// Adjust layout if enlarged status bar due to Personal Hotspot, GPS, Phone, etc
// Programmatically determine how many digits can fit on the screen
// Can I make addTrailingZeros() more efficient by using NumberFormatter?
// Set . vs , for decimal based on phone settings (most countries, other than US and UK, use comma for decimal and period for thousands separater)
// Thousands separater?
// Bug: reset label colors after multitasking swipe on iPad
// Register hardware keyboard presses
// Add second label that shows previous operations?
// Add slide-in animation to outputLabel: http://www.andrewcbancroft.com/2014/09/24/slide-in-animation-in-swift/

import UIKit

var isAnimatingOutputLabel = false

class ViewController: UIViewController {
    
    ////////////////////////////
    ///// OUTLETS and VARS /////
    ////////////////////////////
    
    @IBOutlet weak var outputLabel: CustomLabel!
    @IBOutlet weak var clearLabel: CustomLabel!
    @IBOutlet weak var invertSignLabel: CustomLabel!
    
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
        let notificationName = Notification.Name("applicationWillResignActive")
        NotificationCenter.default.addObserver(self, selector: #selector(self.resetButtons), name: notificationName, object: nil)
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
            label.textColor = CalcText.color
            let backgroundColor = getLabelBackgroundColor(labelTag: label.tag)
            label.backgroundColor = backgroundColor
            if label.tag <= 10 {
                label.font = UIFont(name: CalcText.font, size: CalcText.size * 1.5)
            } else if label.tag == 50 {
                label.font = UIFont(name: CalcText.font, size: CalcText.size * 2.0)
            } else {
                label.font = UIFont(name: CalcText.font, size: CalcText.size * 1.0)
            }
        }
        stylizeInvertSignLabel()
    }
    
    func getLabelBackgroundColor(labelTag: Int) -> UIColor {
        let button = Button(rawValue: labelTag)
        var labelBackgroundColor = CalcColor.salmon // Numbers 0-9 and decimal
        if button == .outputLabel {
            labelBackgroundColor = UIColor.clear
        } else if button == .outputBackground {
            labelBackgroundColor = CalcColor.tan
        } else if button == .equals {
            labelBackgroundColor = CalcColor.orange
        } else if labelTag >= 21 && labelTag <= 31 { // Addition, subtraction, multiplication, division, invert sign, and clear
            labelBackgroundColor = CalcColor.pink
        } else if labelTag >= 40 && labelTag <= 43 { // Memory buttons
            labelBackgroundColor = CalcColor.purple
        }
        return labelBackgroundColor
    }

    func stylizeInvertSignLabel() {
        let font: UIFont? = UIFont(name: CalcText.font, size: CalcText.size)
        let fontSuper: UIFont? = UIFont(name: CalcText.font, size: CalcText.size / 1.5)
        let attString: NSMutableAttributedString = NSMutableAttributedString(string: "+/–", attributes: [NSFontAttributeName: font!])
        attString.setAttributes([NSFontAttributeName: fontSuper!, NSBaselineOffsetAttributeName: 10], range: NSRange(location:0,length:1))
        attString.setAttributes([NSFontAttributeName: fontSuper!, NSBaselineOffsetAttributeName: 2], range: NSRange(location:2,length:1))
        invertSignLabel.attributedText = attString
    }
    
    // Called on applicationWillResignActive()
    // Prevents depressed buttons from remaining darkened after a four-finger app-switching swipe on iPad
    func resetButtons() {
        touchDownArray = []
        formatLabels()
    }
    
    //////////////////////
    ///// ANIMATIONS /////
    //////////////////////
    
    var touchDownArray = [Int]()
    
    @IBAction func buttonTouchDown(_ sender: AnyObject) {
        print("----------")
        touchDownArray.append(sender.tag)
        let label = getLabel(senderTag: sender.tag)
        label.darken()
    }
    
    @IBAction func buttonTouchDragOutside(_ sender: AnyObject) {
        if touchDownArray.contains(sender.tag) {
            touchDownArray = touchDownArray.filter { $0 != sender.tag }
            let label = getLabel(senderTag: sender.tag)
            let labelColor = getLabelBackgroundColor(labelTag: sender.tag)
            label.disappear(labelColor: labelColor)
        }
    }
    
    @IBAction func buttonTouchUp(_ sender: AnyObject) {
        touchDownArray = touchDownArray.filter { $0 != sender.tag }
        let label = getLabel(senderTag: sender.tag)
        if sender.tag == 20 || (sender.tag == 30 && getLabel(senderTag: 30).text == "AC") {
            resetOperationColors()
        }
        if sender.tag >= 21 && sender.tag <= 24 {
            resetOperationColors()
            label.whiten()
        } else {
            let labelColor = getLabelBackgroundColor(labelTag: sender.tag)
            label.restoreColor(labelColor: labelColor)
        }
    }
    
    func resetOperationColors() {
        for operationLabel in 21...24 {
            let label = getLabel(senderTag: operationLabel)
            let labelColor = getLabelBackgroundColor(labelTag: operationLabel)
            label.restoreColor(labelColor: labelColor)
        }
    }
    
    func animateOutputLabel() {
        if !isAnimatingOutputLabel {
            outputLabel.flashOutputLabel()
            let outputBackground = getLabel(senderTag: 51)
            outputBackground.flashOutputBackground()
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
        let button = Button(rawValue: sender.tag)
        let defaults = UserDefaults.standard
        if button == .memoryClear {
            print("func memoryPressed(MC)")
            defaults.set(0.0, forKey: "memoryDouble")
        } else {
            var savedDouble = defaults.double(forKey: "memoryDouble")
            if button == .memoryRecall {
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
                if button == .memoryPlus {
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
