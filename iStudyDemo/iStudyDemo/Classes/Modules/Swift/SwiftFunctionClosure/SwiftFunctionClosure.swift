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
        
        /*
        // 多返回值函数
        // 元组返回类型
        func position(dt:Double, speed:(x:Int,y:Int)) -> (x:Int,y:Int) {
            let posx:Int = speed.x*Int(dt);
            let posy:Int = speed.y*Int(dt);
            return (posx,posy)
        }
        let move = position(60.0,speed: (10,5));
        print(move)
 */
        
        
        /*
        
        // 函数类型，每一个函数都有一个类型，使用函数类型和使用其他类型一样，可以定义变量和常量
        func rectangleArea(width:Double,height:Double) -> Double {
            let area = width * height;
            return area;
        }
        // (Double,Double) -> Double 为函数类型
        func sayHello()->(){
            print("hello")
        }
        // ()->()
 */
        // 作为函数返回类型使用
        
        /*
        func rectangleArea(width:Double,height:Double) -> Double {
            return width * height;
        }
        func trangleArea(bottom:Double,height:Double) -> Double {
            return 0.5 * bottom * height;
        }
        func getArea(type:String) -> (Double,Double) -> Double {
            var retFunction:(Double,Double) -> Double
            switch type {
            case "rect":
                retFunction = rectangleArea;
            case "tria":
                retFunction = trangleArea;
            default:
                retFunction = rectangleArea;
            }
            return retFunction;
        }
        
        var area:(Double,Double)->Double = getArea("rect")
        print(area(10,20))
        
        area = getArea("tria")
        print(area(10,20))
 */
        // 作为函数参数类型使用
        
        /*
        func rectangleArea(width:Double,height:Double) -> Double {
            return width * height;
        }
        func trangleArea(bottom:Double,height:Double) -> Double {
            return 0.5 * bottom * height;
        }
        func getAreaByFunc(funcname:(Double,Double)->Double,a:Double,b:Double)->Double {
            return funcname(a,b)
            }
        print(getAreaByFunc(rectangleArea, a: 10, b: 20))
        print(getAreaByFunc(trangleArea, a: 10, b: 20))
 */
        // 函数重载，swift，函数重载：函数名相同，参数类型不同，或者返回值不同的可以构成重载
        /*
        func receive(i:Int) {
        print("1")
        }
        func receive(d:Double) {
        print("2")
        }
        func receive(x:Int,y:Int)
        {
            print("3")
        }
        func receive(i:Int) -> Int {
            print("4")
            return 1;
        }
        receive(1)
        receive(2)
        receive(1, y: 2)
        receive(4)
 */
        // 函数嵌套
        
        func calcute(opt:String) -> (Int,Int)->Int {
            func add(a:Int,b:Int)->Int {
                return a+b;
            }
            func sub(a:Int,b:Int)->Int {
                return a-b;
            }
            var result:(Int,Int)->Int
            switch opt {
            case "+":
                result = add;
            case "-":
                result = sub;
            default:
                result = add;
            }
            return result;
        }
        let f1:(Int,Int)->Int = calcute("+");
        print(f1(10,20))
        let f2:(Int,Int)->Int = calcute("-");
        print(f2(10,20))
        
        
        // 范型和范型函数
//        func isEquals<T>:(a:T,b:T)->Bool {
//            return (a==b)
//        }
        // 并不是所有类型都有可比性
//        func isEquals<T:Comparable>(a:T,b:T)->Bool {
//            return (a==b)
//        }
//        isEquals(1, b: 1)
//        func isEquals<T,U>(a:T,b:U) -> Bool {
//            //...
//            return true;
//        }
//        func isEquals<T,U>(a:T,b:U)->T {
//            return a;
//        }
        
        
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
    
    
    
    
    
    // *************************************************_______________________________________________________
    // 闭包入口
    // 闭包：是自包含的匿名函数代码块，可以作为表达式，函数参数，函数返回值等，闭包表达式的运算结果是一种函数类型

    /*
    {(参数列表)->返回类型 in
    语句组
    }
     */
    
    /*
     // 函数嵌套
     
     func calcute(opt:String) -> (Int,Int)->Int {
     func add(a:Int,b:Int)->Int {
     return a+b;
     }
     func sub(a:Int,b:Int)->Int {
     return a-b;
     }
     var result:(Int,Int)->Int
     switch opt {
     case "+":
     result = add;
     case "-":
     result = sub;
     default:
     result = add;
     }
     return result;
     }
     let f1:(Int,Int)->Int = calcute("+");
     print(f1(10,20))
     let f2:(Int,Int)->Int = calcute("-");
     print(f2(10,20))

     */
    func test2() {
        // 闭包
        /*
        func calcute(opt:String) -> (Int,Int)->Int {
//            func add(a:Int,b:Int)->Int {
//                return a+b;
//            }
//            func sub(a:Int,b:Int)->Int {
//                return a-b;
//            }
            var result:(Int,Int)->Int
            switch opt {
            case "+":
                result = {(a:Int,b:Int)->Int in
                    return a+b
                }
            case "-":
                result = {(a:Int,b:Int)->Int in
                    return a-b
                }
            default:
                result = {(a:Int,b:Int)->Int in
                    return a+b
                }
            }
            return result;
        }
        let f1:(Int,Int)->Int = calcute("+");
        print(f1(10,20))
        let f2:(Int,Int)->Int = calcute("-");
        print(f2(10,20))
 */
        
        // 类型推断简化
        /*
        func calcute(opt:String) -> (Int,Int)->Int {
            var result:(Int,Int)->Int
            switch opt {
            case "+":
                result = {(a,b) in
                    return a+b
                }
            case "-":
                result = {(a,b) in
                    return a-b
                }
            default:
                result = {(a,b) in
                    return a+b
                }
            }
            return result;
        }
        let f1:(Int,Int)->Int = calcute("+");
        print(f1(10,20))
        let f2:(Int,Int)->Int = calcute("-");
        print(f2(10,20))
 */
        
        // 隐藏return关键字：如果在闭包内部语句组中只有一条语句，可以省略return
        /*
        func calcute(opt:String) -> (Int,Int)->Int {
            var result:(Int,Int)->Int
            switch opt {
            case "+":
                result = {(a,b) in a+b}
            case "-":
                result = {(a,b) in a-b}
            default:
                result = {(a,b) in a+b}
            }
            return result;
        }
        let f1:(Int,Int)->Int = calcute("+");
        print(f1(10,20))
        let f2:(Int,Int)->Int = calcute("-");
        print(f2(10,20))
 */
        
        // 缩写参数名称
        /*
        func calcute(opt:String) -> (Int,Int)->Int {
            var result:(Int,Int)->Int
            switch opt {
            case "+":
                result = {$0+$1}
            case "-":
                result = {$0-$1}
            default:
                result = {$0+$1}
            }
            return result;
        }
        let f1:(Int,Int)->Int = calcute("+");
        print(f1(10,20))
        let f2:(Int,Int)->Int = calcute("-");
        print(f2(10,20))
 */
        // 使用闭包返回值
        /*
        let c1:Int = {(a:Int,b:Int)->Int in return a+b}(10,20)
        print(c1)
 */
        
        // 使用尾随闭包:尾随闭包是一个书写在函数括号之后的闭包表达式，函数支持将其作为最后一个参数调用
        /*
        func calcute(opt:String,funN:(Int,Int)->Int) {
            switch opt {
            case "+":
                print(funN(10,20))
            default:
                print(funN(10,20))
            }
        }
        calcute("+", funN: {(a:Int,b:Int)->Int in return a+b})
        calcute("-"){(a:Int,b:Int)->Int in return a-b}
 */
        
        // 捕获上下文中的常量和变量
        // captureing value(嵌套函数和闭包)
        
        /*
        func makeArray()->(String)->[String] {
             var ary = [String]()
            
            func addElement(element:String)->[String] {
                ary += element
                return ary
            }
            
            return addElement;
        }
        
        let f1 = makeArray()
        print(f1("张三"))
        print(f1("张三"))
        print(f1("张三"))
        
        let f2 = makeArray()
        print(f2("张三"))
        print(f2("张三"))
        print(f2("张三"))
 */
        
    }
    
    
    
    // 可选类型Optional
    /*
     Optional的定义
     Optional也是Objective-C没有的数据类型，是苹果引入到Swift语言中的全新类型，它的特点就和它的名字一样：可以有值，也可以没有值，当它没有值时，就是nil。此外，Swift的nil也和Objective-C有些不一样，在Objective-C中，只有对象才能为nil，而在Swift里，当基础类型（整形、浮点、布尔等）没有值时，也是nil，而不是一个初始值，没有初始值的值，是不能使用的，这就产生了Optional类型。定义一个Optional的值很容易，只需要在类型后面加上问号(?)就行了
     */
    func test3() {
        /*
        //未被初始化，但是是一个Optional类型，为nil
        var str: String?
        // str //输出nil
        print(str)
        //未被初始化，也不是Optional类型
        var str2: String
        // str2    //使用时出错
        print(str2)
 */
        
        // Optional的拆包
        // 显式拆包
        /*
        var str: String? = "Hello World!"
        // str! //Hello World!
        print(str)
        print(str!)
 */
        
        /*
         enum Optional<T> : Reflectable, NilLiteralConvertible {
         case None
         case Some(T)
         init()
         init(_ some: T)
         
         /// Haskell's fmap, which was mis-named
         func map<U>(f: (T) -> U) -> U?
         func getMirror() -> MirrorType
         static func convertFromNilLiteral() -> T?
         }
         当Optional没有值时，返回的nil其实就是Optional.None，即没有值。除了None以外，还有一个Some，当有值时就是被Some<T>包装的真正的值，所以我们拆包的动作其实就是将Some里面的值取出来。
         */
        
        // 隐式拆包
        // 隐式拆包
        /*除了显式拆包，Optional还提供了隐式拆包，通过在声明时的数据类型后面加一个感叹号(!)来实现：
 */
        /*
        var str: String! = "Hello World!"
        print(str)
        str = nil
        // print(str)// 会出现运行时错误
 */
        /*
        可以看到没有使用(?)进行显式的折包也得到了Some中的值，这个语法相当于告诉编译器：在我们使用Optional值前，这个Optional值就会被初始化，并且总是会有值，所以当我们使用时，编译器就帮我做了一次拆包。如果你确信你的变量能保证被正确初始化，那就可以这么做，否则还是不要尝试为好。
        另外：在上面可以看到，Optional其实就是一个枚举，然后给它指定一个类型就行了，所以下面这两种方法都能声明一个Optional值：
        var str: String! = "Hello World!"
        var str2: Optional<String>
 */
        /*
        var str: String! = "Hello World!"
        var str2: Optional<String> = nil
        print(str2)
 */
        
        
        
        // http://blog.csdn.net/zhangao0086/article/details/38640209
        // Optional Binding
        
        /*
        var count: Int?
        count = 100
        if count != nil {
            "count is " + String(count!)    //count is 100
        } else {
            "nil"
        }
 */
        
        // 我在把count强转成String的时候被要求拆包了，这是因为count本身是一个Optional的类型，为了避免在条件判断语句后执行一次或更多次的拆包，Swift引进了Optional Binding，我们就可以这样做：
//        var count: Int?
//        count = 100
//        if let validCount = count {
//            "count is " + String(validCount)    //count is 100
//        } else {
//            "nil"
//        }
        
        //Optional Chaining
        
        class Person {
            var pet: Pet?
        }
        
        class Pet {
            var name: String
            
            var favoriteToy: Toy?
            
            init (name: String) {
                self.name = name
            }
        }
        
        class Toy {
            var name: String
            
            init (name: String) {
                self.name = name
            }
        }
        /*
        
        let jackon = Person()
        jackon.pet = Pet(name: "Max")
        jackon.pet?.favoriteToy = Toy(name: "Ball")
        if let pet = jackon.pet {
            if let toy = pet.favoriteToy {
                toy.name
            }
        }
        
        
        let jackon = Person()
        jackon.pet = Pet(name: "Max")
        jackon.pet?.favoriteToy = Toy(name: "Ball")
        if let toy = jackon.pet?.favoriteToy {
            toy.name
        }

 */
        
    }
}
