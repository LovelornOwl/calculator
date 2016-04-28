//
//  ViewController.swift
//  Calculator
//
//  Created by LovelornOwl on 4/24/16.
//  Copyright © 2016 LovelornOwl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var displayLabel: UILabel!
    
    private var inTheMiddleOfTyping = false
    
    private var displayValue:Double {
        get{
            return Double(displayLabel.text!)!
        }
        set{
            if !newValue.isNaN{
                if (newValue - floor(newValue) > 0){
                    displayLabel.text = String(newValue)
                }
                else{
                    displayLabel.text = String(Int(newValue))
                }
            }
            else{
                displayLabel.text = "Error"
            }
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction func touchDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!
        if inTheMiddleOfTyping{
            if (displayValue != 0 || displayLabel.text!.containsString(".")){
                displayLabel.text = displayLabel.text! + digit
            }
            else{
                displayLabel.text = digit
            }
        }
        else{
            displayLabel.text = digit
        }
        inTheMiddleOfTyping = true
    }
    
    @IBAction func touchDot() {
        if let text = displayLabel.text{
            if !text.containsString("."){
                displayLabel.text = displayLabel.text! + "."
            }
        }
        inTheMiddleOfTyping = true
    }
    @IBAction func performOperation(sender: UIButton) {
        if inTheMiddleOfTyping{
            brain.setOperand(displayValue)
            inTheMiddleOfTyping = false
        }
        
        if let mathSymbol = sender.currentTitle{
            brain.performOperation(mathSymbol)
        }
        displayValue = brain.result
    }
    
    @IBAction func clearAll() {
        brain.clearAll()
        displayValue = 0
    }
    var savedProgram:CalculatorBrain.PropertyList?
    @IBAction func saveProgram() {
        savedProgram = brain.program
    }
    
    @IBAction func restoreProgram() {
        if savedProgram != nil{
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
}

