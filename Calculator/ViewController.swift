//
//  ViewController.swift
//  Calculator
//
//  Created by Austin Wood on 2016-08-26.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func numberPressed(number: String) {
        print(number)
    }
    
}