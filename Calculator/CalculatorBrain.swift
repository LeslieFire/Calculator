//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Leslie Yang on 2/2/15.
//  Copyright (c) 2015 SeeFeel App House. All rights reserved.
//

import Foundation

class CalculatorBrain {
    // enum case switch isvery important in swift
    // printable, description 
    // protocall
    private enum Op: Printable{
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)   // all funcs are type in swift
        case BinaryOperation(String, (Double, Double) -> Double)
        case NonOperation(String, () -> Double)
        
        // it has to be called discription
        var description: String{
            get{
                // switch on myself
                switch self{
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .NonOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    private var opStack = [Op]()  // array init
    // dictionary init
    private var knownOps = [String:Op]()  // private  get set? property
    
    init(){
        func learnOps(op: Op){
            knownOps[op.description] = op
        }
        learnOps(Op.BinaryOperation("×", *))
        learnOps(Op.BinaryOperation("÷"){ $1 / $0 })
        learnOps(Op.BinaryOperation("+", +))
        learnOps(Op.BinaryOperation("−"){ $1 - $0 })
        learnOps(Op.UnaryOperation("√", sqrt))
        learnOps(Op.UnaryOperation("sin", sin))
        learnOps(Op.UnaryOperation("cos", cos))
        learnOps(Op.NonOperation("pi"){ M_PI })
        
        //knownOps["×"] = Op.BinaryOperation("×", *)  // * / sqrt, they all funcs , so, they can be parameters here
//        knownOps["÷"] = Op.BinaryOperation("÷"){ $1 / $0 }
//        knownOps["+"] = Op.BinaryOperation("+", +)
//        knownOps["−"] = Op.BinaryOperation("−"){ $1 - $0 }
//        knownOps["√"] = Op.UnaryOperation("√", sqrt)
//        knownOps["sin"] = Op.UnaryOperation("sin", sin)
//        knownOps["cos"] = Op.UnaryOperation("cos", cos)
//        knownOps["pi"] = Op.NonOperation("pi"){ M_PI }
        
    }
    // ops: [Op]  means let ops: [Op] immutable
    
    // array , Dictionary are struct, all identical to class . but with 2 different side
    // 1, class can have hiareneces, struct cannot 
    // 2, structs are passed by value, classes are passed by reference
    // struct: Double, int 
    
    // there is a unseeing ''let'' behind all you passed , unless you use 'var'
    private func evaluate(ops :[Op]) -> (result: Double? , remainingOps: [Op]) // return tuples, types with name bebind :
    {
        if !ops.isEmpty {
            // because struct pass by value, it will make a copy of ops
            // but will it slow down ?
            // no, swift is so smart that not actually copy it
            // only copy when necessary and copy changed
            var remainingOps = ops   // it's var it's mutable
            let op = remainingOps.removeLast()
            
            switch op{
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                // call a function return a tuple
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result{
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let op1 = op1Evaluation.result{
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let op2 = op2Evaluation.result{
                        return (operation(op1, op2), op2Evaluation.remainingOps)
                    }
                }
            case .NonOperation(_, let operation):
                return (operation(), remainingOps)
            }
        }
        
        return (nil, ops)
    }
    
    func evaluate() -> Double?{  // when optional? when type
        let (result, remainder) = evaluate(opStack) // another way to call func with tuple return
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double?{
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double?{
        if let operation = knownOps[symbol] {  // let is const , operation is optional, for maybe symbol not exist and return nil
            opStack.append(operation)
        }
        return evaluate()
    }
}