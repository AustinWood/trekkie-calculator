//
//  ViewController.swift
//  Calculator
//
//  Created by Austin Wood on 2016-08-26.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import UIKit

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
    
    
    func processOperation() {
        
        var calculation = Int()
        
        if leftString == "" {
            leftString = "0"
        }
        
        switch currentOperation {
        
        case 1:
            calculation = Int(leftString)! / Int(rightString)!
            break
        case 2:
            calculation = Int(leftString)! * Int(rightString)!
            break
        case 3:
            calculation = Int(leftString)! - Int(rightString)!
            break
        case 4:
            calculation = Int(leftString)! + Int(rightString)!
            break
        default:
            break
        }
        
        leftString = "\(calculation)"
        outputLbl.text = leftString
    }
    
}