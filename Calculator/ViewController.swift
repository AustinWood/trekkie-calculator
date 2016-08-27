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
    
    
    var runningNumber = String()
    var leftString = String()
    var rightString = String()
    
    
    enum Operation {
        case Divide
        case Multiply
        case Subtract
        case Add
        case Equals
    }
    
    var currentOperation = Operation.Equals
    
    
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
        
        outputLbl.text = "0"
    }
    
    
    @IBAction func clearPressed(sender: AnyObject) {
        resetCalc()
    }
    
    

    
    
    /////////////////////////////
    ///// OPERATION PRESSED /////
    /////////////////////////////
    
    
    func processOperation() {
        
        var calculation = Int()
        
        switch currentOperation {
        case .Divide:
            
            calculation = Int(leftString)! / Int(runningNumber)!
            break
            
        case .Multiply:
            
            calculation = Int(leftString)! * Int(runningNumber)!
            break
            
        case .Subtract:
            
            calculation = Int(leftString)! - Int(runningNumber)!
            break
            
        case .Add:
            
            calculation = Int(leftString)! + Int(runningNumber)!
            break
            
        case .Equals:
            
            ////// RESUME HERE
            ////// EQUALS SOMETIMES BREAKS THE CODE
            calculation = Int(runningNumber)!
            break
        }
        
        leftString = "\(calculation)"
        runningNumber = ""
        outputLbl.text = "\(calculation)"
        
    }
    
    
    
    @IBAction func dividePressed(sender: AnyObject) {
        processOperation()
        currentOperation = .Divide
    }
    
    @IBAction func multiplyPressed(sender: AnyObject) {
        processOperation()
        currentOperation = .Multiply
    }
    
    @IBAction func subtractPressed(sender: AnyObject) {
        processOperation()
        currentOperation = .Subtract
    }
    
    @IBAction func addPressed(sender: AnyObject) {
        processOperation()
        currentOperation = .Add
    }
    
    @IBAction func equalsPressed(sender: AnyObject) {
        processOperation()
        currentOperation = .Equals
    }
    
    //////////////////////////
    ///// NUMBER PRESSED /////
    //////////////////////////
    
    
    func numberPressed(number: String) {
        print(number)
        runningNumber = runningNumber + number
        outputLbl.text = runningNumber
    }
    
    
    @IBAction func zeroPressed(sender: AnyObject) {
        numberPressed("0")
    }
    
    @IBAction func onePressed(sender: AnyObject) {
        numberPressed("1")
    }
    
    @IBAction func twoPressed(sender: AnyObject) {
        numberPressed("2")
    }
    
    @IBAction func threePressed(sender: AnyObject) {
        numberPressed("3")
    }
    
    @IBAction func fourPressed(sender: AnyObject) {
        numberPressed("4")
    }
    
    @IBAction func fivePressed(sender: AnyObject) {
        numberPressed("5")
    }
    
    @IBAction func sixPressed(sender: AnyObject) {
        numberPressed("6")
    }
    
    @IBAction func sevenPressed(sender: AnyObject) {
        numberPressed("7")
    }
    
    @IBAction func eightPressed(sender: AnyObject) {
        numberPressed("8")
    }
    
    @IBAction func ninePressed(sender: AnyObject) {
        numberPressed("9")
    }
    
    
}