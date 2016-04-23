//
//  SwiftExtensionProtocol.swift
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/23.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

import Foundation

extension Int {
    var errorMessage : String {
        var errorMsg = ""
        switch self {
        case -3:
            errorMsg = "没有数据3"
        case -2:
            errorMsg = "没有数据2"
        case -1:
            errorMsg = "没有数据1"
        default:
            errorMsg = ""
        }
        return errorMsg;
    }
}


struct Account {
    var name : String = "avc"
}

extension Account {
    static var InterestRate : Double {
        return 0.45
    }
}

extension Account {
    func test() {
        print(name)
    }
}

extension String {

    subscript(index:Int) -> String{
        if index > self.characters.count {
            return ""
        }
        var c : String = ""
        var i = 0
        for ch in self.characters {
            if i == index {
                c = String(ch)
                break;
            }
            i += 1
        }
        return c
    }
}


//一般方法，静态协议,变异方法
protocol Figure
{
    func onDraw();
    
    static func test();
    
    mutating func test2();
    
    
    var fullName : String {get}
    
    // 静态协议属性
    static var testValue : Int {get set}
    
}

class Rectangle: Figure {
    func onDraw()
    {
        print("Rectangle draw")
    }
    
    static func test() {
        print("Rectangle test")
    }
    
    func test2() {
        print("Rectangle不用加关键字，结构体和枚举中需要加mutating")
        
    }
    
    var fullName: String {
        get {
            return "Rectangle name"
        }
    }
    
    static var testValue: Int{
        set (newValue){
            
            print(newValue)
        }
        get {
            print("testValue:Rectangle")
            return 1;
            
        }
    }
    
}

class Circle: Figure {
    func onDraw()
    {
        print("Circle draw")
    }
    static func test() {
        print("Circle test")
    }
    
    func test2() {
        print("Circle不用加关键字，结构体和枚举中需要加mutating")
    }
    var fullName: String {
        get {
            return "Circle name"
        }
        set (newValue) {
            print(newValue)
        }
    }
    
    static var testValue: Int{
        set (newValue){
            
            print(newValue)
        }
        get {
            print("testValue:Circle")
            return 1;
            
        }
    }
}


class SwiftExtensionProtocol : NSObject {
    // 扩展和协议
    func test1() {
        print("扩展-----------")
        // 在swift中可以使用扩展机制，在原油类型的基础上添加新的功能，扩展是一种轻量级的继承机制，即使是缘由类型被限制继承，我门仍然可以通过扩展机制“继承”原有类型的功能
        //  扩展还有另外一个优势，它扩展的类型可以是类，结构体，枚举，而继承只能是类，不能是结构体和枚举
        // 扩展计算属性
        
        print((-3).errorMessage)
        
        // 扩展静态属性
        print(Account.InterestRate)
        
        // 扩展方法
        var v = Account()
        v.test()
        
        // 扩展构造器
        
        //  扩展下标
        let s = "abcd12345"
        print(s[3])
        
    }
    
    
    
    // 协议
    func test2() {
        print("协议-----------")
        // 实现协议的方法
        var rect : Figure = Rectangle()
        var c : Figure  = Circle()
        
        rect.onDraw()
        c.onDraw()
        
        
        // 静态协议
        Rectangle.test();
        Circle.test();
        // 变异方法
        rect.test2()
        c.test2()
        
        // 协议属性
        print(rect.fullName)
//        c.fullName = "123"
        print(c.fullName)
        
        
        // 静态协议属性
        print(Rectangle.testValue)
        print(Circle.testValue)
        
        
        // 协议的继承和多协议的合成（多继承）
        
    }
}
