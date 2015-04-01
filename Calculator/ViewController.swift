//
//  ViewController.swift
//  Calculator
//
//  Created by 朱俊汀 on 15/3/24.
//  Copyright (c) 2015年 JUNTING ZHU. All rights reserved.
//

import UIKit
import Foundation

extension String {
    var length: Int {
        return countElements(self)
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTypingANumber: Bool = false
    var isFloatPoint = false
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if(digit == "0" && display.text! == "0"){
            
        }else if(userIsInTheMiddleOfTypingANumber && display.text! != "0"){
            display.text = display.text! + digit
        }else{
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func appendFloatPoint(sender: UIButton) {
        if(!userIsInTheMiddleOfTypingANumber){
            display.text = "0."
            isFloatPoint = true
            userIsInTheMiddleOfTypingANumber = true
        }else if(!isFloatPoint){
            display.text = display.text! + "."
            isFloatPoint = true
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func appendPi(sender: UIButton) {
        if(userIsInTheMiddleOfTypingANumber){
            enter()
        }
        display.text = "π"
        operandStack.append(M_PI)
        println("operandStack = \(operandStack)")
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if(userIsInTheMiddleOfTypingANumber){
            enter()
        }
        switch(operation){
        case "×": performOperation { $1 * $0 }
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $1 + $0 }
        case "−": performOperation { $1 - $0 }
        case "√": performOperation { sqrt($0) }
        case "sin": performOperation { sin($0) }
        case "cos": performOperation { cos($0) }
        default: break
        }
    }
    
    func performOperation(operation: (Double, Double) -> Double){
        if(operandStack.count >= 2){
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    func performOperation(operation: Double -> Double){
        if(operandStack.count >= 1){
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        isFloatPoint = false
        operandStack.append(displayValue)
        println("operandStack = \(operandStack)")
    }
    
    @IBAction func addHistory(sender: UIButton) {
        if(history.text == "History:"){
            history.text = sender.currentTitle!
        }else{
            history.text = history.text! + sender.currentTitle!
        }
    }
    
    @IBAction func clear(sender: UIButton) {
        userIsInTheMiddleOfTypingANumber = false
        isFloatPoint = false
        display.text = "0"
        history.text = "History:"
        operandStack.removeAll()
        println("operandStack = \(operandStack)")
    }
    
    @IBAction func backspace(sender: UIButton) {
        if(userIsInTheMiddleOfTypingANumber && display.text!.length > 0){
            display.text = display.text!.substringToIndex(advance(display.text!.endIndex, -1))
            //history.text = history.text!.substringToIndex(advance(history.text!.endIndex, -1))
            history.text = dropLast(history.text!)
        }
    }
    
    @IBAction func changeSign(sender: UIButton) {
        if(userIsInTheMiddleOfTypingANumber){
            if(isFloatPoint){
                display.text = "\(displayValue * -1)"
            }else{
                display.text = "\(Int(displayValue) * -1)"
            }
        }else{
            if(operandStack.count >= 1){
                displayValue = operandStack.removeLast() * -1
                enter()
            }
        }
    }
    
    var displayValue: Double{
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }set{
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}

