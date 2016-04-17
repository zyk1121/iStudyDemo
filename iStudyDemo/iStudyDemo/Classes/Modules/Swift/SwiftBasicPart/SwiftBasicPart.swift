//
//  SwiftBasicPart.swift
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/17.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

import Foundation

class SwiftBasicPart: NSObject {
    
    //  标识符 & 关键字 & 常量 & 变量
    func test0() {
        // 标识符
        let pai = 3.1415926
        let _hello = "hello world"
        let 中文 = "中文 var name"
        NSLog("\(pai),\(_hello),\(中文)")
        // 关键字
        NSLog("calss deinit enum extension func import init let protocol static struct subscript typealias var")
        NSLog("break case continue default do else fall through if in for return switch where while")
        NSLog("as dynamicType is new super self Self Type __COLUMN__ __FILE__ __FUNCTION__ __LINE__")
        NSLog("associativity didSet get infix inout left mutating none nonmutating operator override postfix precedence prefix rightset unowned unowned(safe) unowned(unsafe) weak willset")
        // 变量和常量
        // let 常量，
        var x = 10,y=20
        x = 30;
        y=30;
        NSLog("\(x),\(y)")
        let letX = 200
//        letX = 300;
        NSLog("\(letX)")
        
        if x < 100 {
        /*    NSLog("ok")
        } else {
             /*
            NSLog("error")
 */
 */
            NSLog("hello")
        }
        
    }
    
    
    //  基本运算符
    func test1() {
        var a = 12;
        a += 1;
        NSLog("\(a)")
        NSLog("=== 恒等于 a,b同引用同一个实例时返回true，否则返回false，专门用于引用的比较")
        NSLog("!== 不恒等于 a,b同引用不同一个实例时返回true，否则返回false，专门用于引用的比较，一般不用于引用之外的类型比较，Swift中只有类是引用类型")
        NSLog("值类型：就是在赋值和给函数传递参数的时候，创建一个副本，把副本传递过去，这样在函数调用过程中不影响原始数据")
        NSLog("引用类型：就是在赋值和给函数传递参数的时候，把本身数据传递过去，这样在函数调用的过程中会影响原始数据")
        NSLog("值类型：整形，浮点型，布尔型，字符型，元组，集合，枚举，结构体")
        NSLog("引用类型：类")
    }
    
    //  基本数据类型
    func test2() {
        // 整形
        NSLog("Int8:\(Int8.min)~\(Int8.max)")
        NSLog("UInt8:\(UInt8.min)~\(UInt8.max)")
        NSLog("Int16:\(Int16.min)~\(Int16.max)")
        NSLog("UInt16:\(UInt16.min)~\(UInt16.max)")
        NSLog("Int32:\(Int32.min)~\(Int32.max)")
        NSLog("Int64:\(Int64.min)~\(Int64.max)")
        NSLog("Int:\(Int.min)~\(Int.max)")
        NSLog("UInt:\(UInt.min)~\(UInt.max)")// 平台相关类型，在32位平台，与Int32 一致，在64位平台，与Int64一致
//        var intValue = 20
//        intValue = "name"// error,编译错误，类型不匹配，swift是强类型的语言，
        
        //  浮点型，默认为Double
        let myMoney: Float = 300.5
        let youMoney : Double = 350.0
        let pi = 3.14 // 默认Double
        
        NSLog("\(myMoney),\(youMoney),\(pi)")
//        0b11100
//        28
//        0x34
//        0x1C
//        
//        3.3e2
//        1.56e-2
//        000.1234
//        3_360_130
        
        
        // Bool,   只有两个值，true，false
        var b:Bool = true
        b = false
        if b {
            NSLog("true")
        } else
        {
            NSLog("false")
        }
        
        //  元组,很抽象，它是一种数据结构（"1001","zhang san",30,90）
        // (id:"1001","name":"zhang san","age":30,"score":90)
        let student1 = ("1001","zhang san",30,90)
        NSLog("学生：\(student1.1)，学号：\(student1.0)，年龄：\(student1.2)，成绩：\(student1.3)")
        let student2 = (id:"1001",name:"zhang san",age:30,score:90)
        NSLog("学生：\(student2.name)，学号：\(student2.id)，年龄：\(student2.age)，成绩：\(student2.score)")
        let (id1,name1,age1,score1) = student1
        NSLog("学生：\(name1)，学号：\(id1)，年龄：\(age1)，成绩：\(score1)")
        let (id2,name2,_,_) = student2
        print("\(id2),\(name2)")
        // 把不需要的字段使用下划线代替
        
    }
}