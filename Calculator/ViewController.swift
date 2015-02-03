//
//  ViewController.swift
//  Calculator
//
//  Created by Leslie Yang on 31/1/15.
//  Copyright (c) 2015 SeeFeel App House. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
 
    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    
    var brain = CalculatorBrain()
    
    @IBAction func clear() {
        display.text = "0"
        history.text = ""
        userIsInTheMiddleOfTypingANumber = false
    }
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber{
            display.text = display.text! + digit
        }else{
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }

    @IBAction func operate(sender: UIButton) {
        
        
        if userIsInTheMiddleOfTypingANumber {
            history.text = history.text! + display.text!
            enter()
        }
        if let operation = sender.currentTitle{
            history.text = history.text! + operation
            if let result = brain.performOperation(operation){
                displayValue = result
            }else{
                displayValue = 0
            }
        }
    }
    
    
    @IBAction func userEnter() {
        history.text = history.text! + display.text! + "⏎"
        enter()
    }
    
    func enter() {
        userIsInTheMiddleOfTypingANumber = false
        
        if (display.text!.rangeOfString("[.].*[.]", options: .RegularExpressionSearch ) != nil){
            
            println("illegal floating input" + display.text!)
            display.text = "0"
        }
        else{
            if let result = brain.pushOperand(displayValue){
                displayValue = result
            }else{
                displayValue = 0
            }
        }
    }
    
    var displayValue : Double {
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }

}

