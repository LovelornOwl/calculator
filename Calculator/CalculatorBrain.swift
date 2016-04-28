//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by LovelornOwl on 4/28/16.
//  Copyright © 2016 LovelornOwl. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private var accumulator = 0.0
    private var internalProgram = [AnyObject]()
    
    struct PendingBinaryOperationInfo {
        var binaryFunction:(Double,Double)->Double
        var firstOperand:Double
    }
    private var pending:PendingBinaryOperationInfo?
    private func excutePendingOperation(){
        if pending != nil{
            accumulator = pending!.binaryFunction(pending!.firstOperand,accumulator)
            pending = nil
        }
    }
    
    enum Operation {
        case Constant(Double)
        case UnaryOperation((Double)->Double)
        case BinaryOperation((Double,Double) -> Double)
        case Equals
    }
    
    private var operations = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt),
        "%" : Operation.UnaryOperation{$0 * 0.01},
        "+/-" : Operation.UnaryOperation{-$0},
        "+" : Operation.BinaryOperation{$0 + $1},
        "-" : Operation.BinaryOperation{$0 - $1},
        "×" : Operation.BinaryOperation{$0 * $1},
        "÷" : Operation.BinaryOperation{$0 / $1},
        "=" : Operation.Equals
    ]
    func setOperand(opearand: Double) {
        accumulator = opearand
        internalProgram.append(opearand)
    }
    func performOperation(symbol: String) {
        internalProgram.append(symbol)
        if let operation = operations[symbol]{
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                excutePendingOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                excutePendingOperation()
            }
        }
    }
    func clearAll() {
        pending = nil
        accumulator = 0
        internalProgram.removeAll()
    }
    var result: Double{
        get {
            return accumulator
        }
    }
    
    typealias PropertyList = AnyObject
    var program: PropertyList{
        get{
            return internalProgram
        }
        set{
            clearAll()
            if let arrayOfOps = newValue as? [AnyObject]{
                for op in arrayOfOps{
                    if let operand = op as? Double{
                        setOperand(operand)
                    }
                    else if let operation = op as? String{
                        performOperation(operation)
                    }
                }
            }
        }
    }
    
}