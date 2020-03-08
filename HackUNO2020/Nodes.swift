//
//  Nodes.swift
//  HackUNO2020
//
//  Created by Christopher Phillips on 3/7/20.
//  Copyright © 2020 Lion275. All rights reserved.
//

import Foundation

protocol BoolNode {
    var days : [Day]? { get set };
    func value() -> Bool;
    func dayValue(d : Day) -> Bool;
}

protocol DoubleNode {
    var days : [Day]? { get set };
    func value() -> Double;
    func dayValue(d : Day) -> Double;
}

class DayFunctionBoolNode : BoolNode{
    var days : [Day]?
    var f : (Day) -> Bool;
    init(dayFunction: @escaping (Day) -> Bool){
        f = dayFunction;
    }
    func value() -> Bool {
        return false;
    }
    
    func dayValue(d: Day) -> Bool {
        return f(d);
    }
}

class DayFunctionDoubleNode : DoubleNode{
    var days : [Day]?
    var f : (Day) -> Double?
    init(dayFunction: @escaping (Day) -> Double){
        f = dayFunction;
    }
    func value() -> Double {
        return 0.0;
    }
    
    func dayValue(d: Day) -> Double {
        return f(d)!;
    }
}

class GreaterThanNode : BoolNode {
    var days : [Day]?
    var term1 : DoubleNode;
    var term2 : DoubleNode;
    init(t1: DoubleNode, t2: DoubleNode){
        term1 = t1;
        term2 = t2;
    }
    func value() -> Bool {
        term1.days = days;
        term2.days = days;
        return term1.value() > term2.value();
    }
    func dayValue(d: Day) -> Bool {
        return term1.dayValue(d: d) > term2.dayValue(d: d);
    }
    
}

class LessThanNode : BoolNode{
    var days : [Day]?
    var term1 : DoubleNode;
    var term2 : DoubleNode;
    init(t1: DoubleNode, t2: DoubleNode){
        term1 = t1;
        term2 = t2;
    }
    func value() -> Bool {
        term1.days = days;
        term2.days = days;
        return term1.value() < term2.value();
    }
    func dayValue(d : Day) -> Bool {
        return term1.dayValue(d: d) < term2.dayValue(d: d);
    }
}

class orNode : BoolNode {
    var days : [Day]?
    var term1 : BoolNode;
    var term2 : BoolNode;
    init(t1: BoolNode, t2: BoolNode){
        term1 = t1;
        term2 = t2;
    }
    func value() -> Bool {
        term1.days = days;
        term2.days = days;
        return term1.value() || term2.value();
    }
    
    func dayValue(d : Day) -> Bool {
        return term1.dayValue(d: d) || term2.dayValue(d: d);
    }
}

class andNode : BoolNode {
    var days : [Day]?
    var term1 : BoolNode;
    var term2 : BoolNode;
    init(t1: BoolNode, t2: BoolNode){
        term1 = t1;
        term2 = t2;
    }
    func value() -> Bool {
        term1.days = days;
        term2.days = days;
        return term1.value() && term2.value();
    }
    func dayValue(d : Day) -> Bool {
        return term1.dayValue(d: d) && term2.dayValue(d: d);
    }
}

class notNode : BoolNode {
    var days : [Day]?
    var term1 : BoolNode;
    init(t1: BoolNode){
        term1 = t1;
    }
    func value() -> Bool {
        term1.days = days;
        return !term1.value();
    }
    func dayValue(d : Day) -> Bool {
        return !term1.dayValue(d: d);
    }
}

class NumberNode : DoubleNode{
    var days : [Day]?
    var term1 : Double;
    init(t1 : Double){
        term1 = t1;
    }
    
    func value() -> Double {
        return term1;
    }
    func dayValue(d: Day) -> Double {
        return term1;
    }
}

class DivisionNode : DoubleNode{
    var days : [Day]?
    var term1 : DoubleNode;
    var term2 : DoubleNode;
    init(t1 : DoubleNode, t2 : DoubleNode){
        term1 = t1;
        term2 = t2;
    }
    func value() -> Double {
        term1.days = days;
        term2.days = days;
        if(term2.value() == 0){
            return term1.value() / 0.0001;
        }
        return term1.value() / term2.value();
    }
    func dayValue(d: Day) -> Double {
        if(term2.dayValue(d: d) == 0){
            return term1.dayValue(d: d) / 0.0001;
        }
        return term1.dayValue(d: d) / term2.dayValue(d: d);
    }
}

class MultiplicationNode : DoubleNode{
    var days : [Day]?
    var term1 : DoubleNode;
    var term2 : DoubleNode;
    init(t1 : DoubleNode, t2 : DoubleNode){
        term1 = t1;
        term2 = t2;
    }
    func value() -> Double {
        term1.days = days;
        term2.days = days;
        return term1.value() * term2.value();
    }
    func dayValue(d: Day) -> Double {
        return term1.dayValue(d : d) * term2.dayValue(d : d);
    }
    
}

class AdditionNode : DoubleNode{
    var days : [Day]?
    var term1 : DoubleNode;
    var term2 : DoubleNode;
    init(t1 : DoubleNode, t2 : DoubleNode){
        term1 = t1;
        term2 = t2;
    }
    func value() -> Double {
        term1.days = days;
        term2.days = days;
        return term1.value() + term2.value();
    }
    func dayValue(d: Day) -> Double {
        return term1.dayValue(d: d) + term2.dayValue(d: d);
    }
}

class SubtractionNode : DoubleNode{
    var days : [Day]?
    var term1 : DoubleNode;
    var term2 : DoubleNode;
    init(t1 : DoubleNode, t2 : DoubleNode){
        term1 = t1;
        term2 = t2;
    }
    func value() -> Double {
        term1.days = days;
        term2.days = days;
        return term1.value() - term2.value();
    }
    func dayValue(d: Day) -> Double {
        return term1.dayValue(d: d) - term2.dayValue(d: d);
    }
}

class CountNode : DoubleNode{
    
    var days : [Day]?
    var boolFunction : BoolNode;
    init(f : BoolNode){
        boolFunction = f;
    }
    func value() -> Double {
        var count = 0;
        for d in days!{
            if boolFunction.dayValue(d: d){
                count += 1;
            }
        }
        return Double(count);
    }
    
    func dayValue(d: Day) -> Double {
        return 0.0;
    }
    
    
}

class AverageNode : DoubleNode{
    var days : [Day]?
    var doubleFunction : DoubleNode;
    init(f : DoubleNode){
        doubleFunction = f;
    }
    func value() -> Double {
        if(days!.count == 0){
            return 0.0;
        }
        var count = 0;
        var total = 0.0;
        for d in days!{
            total += doubleFunction.dayValue(d: d);
            count += 1;
        }
        return total / Double(count);
    }
    
    func dayValue(d: Day) -> Double {
        return 0.0;
    }
}

class MaxNode : DoubleNode{
    var days : [Day]?
    var doubleFunction : DoubleNode;
    init(f : DoubleNode){
        doubleFunction = f;
    }
    func value() -> Double {
        var max = doubleFunction.dayValue(d: days![0]);
        for d in days!{
            if (doubleFunction.dayValue(d: d) > max){
                max = doubleFunction.dayValue(d: d);
            }
        }
        return max;
    }
    
    func dayValue(d: Day) -> Double {
        return 0.0;
    }
}

class MinNode : DoubleNode{
    var days : [Day]?
    var doubleFunction : DoubleNode;
    init(f : DoubleNode){
        doubleFunction = f;
    }
    func value() -> Double {
        var min = doubleFunction.dayValue(d: days![0]);
        for d in days!{
            if (doubleFunction.dayValue(d: d) < min){
                min = doubleFunction.dayValue(d: d);
            }
        }
        return min;
    }
    
    func dayValue(d: Day) -> Double {
        return 0.0;
    }
}
