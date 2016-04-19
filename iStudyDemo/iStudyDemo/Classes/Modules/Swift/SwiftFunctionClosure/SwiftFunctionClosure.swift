//
//  SwiftFunctionClosure.swift
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/19.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

import Foundation

// Swift中函数很灵活，它可以独立存在，即全局函数，也可以存在于别的函数中，即函数嵌套，还可以存在于类，结构体，枚举中，称为方法
/*
 func 函数名(参数列表) -> 函数返回值类型 {
    语句组
    return 返回值
 }
 */

class SwiftFunctionClosure: NSObject {
    // 函数入口
    func test1() {
        
    }
    // 函数定义及使用
    func rectangleArea(width:Double, height:Double) -> Double {
        let area = width * height
        return area;
        /*
         var area = self.rectangleArea(10, height: 20)
         area = 30000
         print(area)
         */
    }
    
    // 传递参数,使用外部参数名
    func rectangleTest(W width:Double, H height:Double) -> Double {
        let area = width * height
        return area;
        /*
         let area = self.rectangleTest(W: 20, H: 20)
         print(area)
         */
    }
    // 外部参数和内部参数共用
//    func rectangleTest2(#width:Double,#height:Double) -> Double {
//        let area = width * height
//        return area;
//    }
    // 默认参数名
    func makeCoffee(type:String = "卡布奇诺") -> String {
        return "制作一杯\(type)咖啡"
        /*
         var coffee = self.makeCoffee()
         print(coffee)
         coffee = self.makeCoffee("hello")
         print(coffee)
         */
    }
    // 默认参数名2
//    func CircleArea(R radius:Double  = 30, pi:Double = 3.14) -> Double {
//        let area = 2 * radius * pi;
//        return area;
//    }
    // 可变参数
    func sum(numbers:Double...) -> Double {
        var total:Double = 0
        for item in numbers {
            total += item
        }
        return total;
        /*
         var value = self.sum(10,20,30)
         print(value)
         value = self.sum(10)
         print(value)
         */
    }
    // 参数的引用传递：只有类是引用类型，其他的数据类型如整形，浮点型，布尔型，字符串，元祖，集合，枚举，结构体都是值类型
    func increment(inout value:Double, amount:Double = 1.0) {
        value += amount
        /*
         var value = 1.0
         self.increment(&value)
         print(value)
         self.increment(&value)
         print(value)
         */
    }
    // 函数返回值，无返回值
    /*
    func voidFunc1() {
        print("空的返回类型定义1")
    }
    func voidFunc2() -> () {
        print("空的返回类型定义2")
    }
    func voidFunc3() -> Void {
        print("空的返回类型定义3")
    }
    */
    // 多返回值函数
    
    
    
    
    
    // *************************************************_______________________________________________________
    // 闭包入口
    func test2() {
        
    }
}
