//
//  ViewController.swift
//  CalculatorNewStart
//
//  Created by jingdai yang on 4/18/16.
//  Copyright © 2016 JY. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var trackInput: UILabel!
    
    var userIsInTheMiddileOfTypingNumber = false

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddileOfTypingNumber {
            //if digit inputed as ∏
            if digit == "∏" {
                enter()
                display.text = digit
                enter()
            }else {
            //if not ∏, check if it is . and also see if it is duplicated
                if digit != "."{
                    if display.text! != "0"{
                        display.text = display.text! + digit
                    }
                }else {
                    if (display.text!.rangeOfString(".") == nil) {
                        display.text = display.text! + digit
                    }
                }
            }
        }else{
            //if digit inputed as ∏
            if digit == "∏" {
                display.text = digit
                enter()
            }else {
            //if not ∏, check if it is . and also see if it is duplicated
                if digit == "." {
                    display.text = "0."
                }else {
                    display.text = digit
                }
                userIsInTheMiddileOfTypingNumber = true
            }
        }
        
    }
    
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        userIsInTheMiddileOfTypingNumber = false
        if displayValue != nil {
            operandStack.append(displayValue!)
            if (trackInput.text!.rangeOfString("=") != nil) {
                trackInput.text!.removeRange(trackInput.text!.rangeOfString("=")!)
            }
            if (trackInput.text! != "") {
                trackInput.text = trackInput.text! + ","
            }
            trackInput.text = trackInput.text! + "\(displayValue!)"
            print("operandStack = \(operandStack)")
        }else{
            display.text = ""
        }
    }
    
    @IBAction func clear() {
        userIsInTheMiddileOfTypingNumber = false
        operandStack.removeAll()
        trackInput.text = ""
        display.text = "0"
    }
    
    @IBAction func backspace() {
        if userIsInTheMiddileOfTypingNumber {
         //both works
            display.text!.removeAtIndex(display.text!.endIndex.predecessor())
        //  String(display.text!.characters.dropLast())
        }
    }
    
    var displayValue: Double? {
        get {
            if display.text == "∏" {
                return M_PI
            }else {
                return NSNumberFormatter().numberFromString(display.text!)?.doubleValue

            }
        }
        set {
            if newValue == nil {
                display.text = ""
            }else {
                display.text = "\(newValue!)"
            }
            userIsInTheMiddileOfTypingNumber = false
        }
    }
    
    @IBAction func signChange() {
        if userIsInTheMiddileOfTypingNumber {
            if (display.text!.rangeOfString("-") != nil) {
                display.text!.removeAtIndex(display.text!.startIndex)
            }else {
                display.text = "-"+display.text!
            }
        }else{
            performOperation("±",operation:{$0 * -1})
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddileOfTypingNumber {
            enter()
        }
        switch operation {
        case "×":   performOperation ("×",operation:{$0 * $1})
        case "÷":   performOperation ("÷",operation:{$1 / $0})
        case "+":   performOperation ("+",operation:{$0 + $1})
        case "−":   performOperation ("−",operation:{$1 - $0})
        case "√":   performOperation ("√",operation:{sqrt($0)})
        case "sin": performOperation ("sin",operation:{sin($0)})
        case "cos": performOperation ("cos",operation:{cos($0)})
        default: break
        }
    }
    
    func performOperation(inputOperator: String, operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            trackInput.text = trackInput.text! + ", " + inputOperator
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
            trackInput.text = trackInput.text! + "="
        }
    }
    
    @nonobjc
    func performOperation(inputOperator: String, operation: Double -> Double) {
        if operandStack.count >= 1 {
            trackInput.text = trackInput.text! + inputOperator + "="
            displayValue = operation(operandStack.removeLast())
            enter()
            trackInput.text = trackInput.text! + "="
        }
    }
    
}

