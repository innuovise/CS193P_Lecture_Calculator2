//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by SK on 3/12/17.
//  Copyright © 2017 SK. All rights reserved.
//

import Foundation

// structs don't have inheritance
// classes live in the heap - reference types
// structs not in heap, copy them
// struct will automatically initialize the variables
struct CalculatorBrain
{
    // not set because no initial accumulated value
    // not set so value is nil
    private var accumulator: Double?
    
    private enum Operation
    {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    private var operations: Dictionary<String,Operation> =
    [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "±" : Operation.unaryOperation({ -$0 }),
        "✖️" : Operation.binaryOperation({ $0 * $1 }),
        "➗" : Operation.binaryOperation({ $0 / $1 }),
        "➖" : Operation.binaryOperation({ $0 - $1 }),
        "➕" : Operation.binaryOperation({ $0 + $1 }),
        "=" : Operation.equals
    ]
    
    
    mutating func performOperation(_ symbol: String)
    {
        if let operation = operations[symbol]
        {
            switch operation
            {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil
                {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil
                {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            
            }
        }
    }
    
    private mutating func performPendingBinaryOperation()
    {
        if pendingBinaryOperation != nil && accumulator != nil
        {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation
    {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        
        func perform(with secondOperand: Double) -> Double
        {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double)
    {
        accumulator = operand
    }
    
    // not set so value is nil
    var result: Double?
    {
        get
        {
            return accumulator
        }
    }
    
}
