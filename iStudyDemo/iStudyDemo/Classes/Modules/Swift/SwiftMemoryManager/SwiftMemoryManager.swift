//
//  SwiftMemoryManager.swift
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/23.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

import Foundation


class Employee {
    
    var name : String = ""
    init() {
        self.name = "123"
        
        print("Employee init")
    }
    // 闭包
//    lazy var fullName :()->String = {
//        // 强循环引用
//        return self.name
//    }
    
//    lazy var fullName :()->String = {
//        // 强循环引用解除，weak 会把self变成可选类型
//        [weak self] ()->String in
//        return self!.name
//    }
    
    lazy var fullName :()->String = {
        // 强循环引用解除，unowned
        [unowned self] ()->String in
        return self.name
    }
    
    // 使用方式：当捕获的对象可能为nil时，则将闭包的引用声明为弱引用，；如果捕获的对象不会为nil，那么应该采用无主引用
    
    deinit {
        print("Employee deinit")
    }
}


class SwiftMemoryManager: NSObject {
    func test1() {
        class Test1{
            var name : String = ""
            var t2 : Test2?;
            
            init()
            {
                self.name = ""
                print("Test1 init")
            }
            deinit {
                print("Test1 deinit")
            }
        }
        
        class Test2{
            var num : Int = 0;
            
            var t1 : Test1?
            
            init()
            {
                self.num = 0
                print("Test2 init")
            }
            deinit {
                print("Test2 deinit")
            }
        }
        
        
//        let t1:Test1 = Test1()
//        let t2:Test2 = Test2()
//        t1.t2 = t2
//        t2.t1 = t1
        
        var t1:Test1? = Test1()
        var t2:Test2? = Test2()
        t1!.t2 = t2
        t2!.t1 = t1
        t1 = nil
        t2 = nil
        
        // 强循环引用，引起内存泄漏，弱引用和无主引用的方式解决
    }
    
    // 弱引用weak
    // 弱引用适用于对象可以没有值的情况，因为弱引用对象可以没有值，我们必须将弱引用声明为可选类型
    func test2() {
        class Test1{
            var name : String = ""
            var t2 : Test2?;
            
            init()
            {
                self.name = ""
                print("Test1 init")
            }
            deinit {
                print("Test1 deinit")
            }
        }
        
        class Test2{
            var num : Int = 0;
            
            weak var t1 : Test1?// 弱引用必须是可选类型
            
            init()
            {
                self.num = 0
                print("Test2 init")
            }
            deinit {
                print("Test2 deinit")
            }
        }
        
        var t1:Test1? = Test1()
        var t2:Test2? = Test2()
        t1!.t2 = t2
        t2!.t1 = t1
        t1 = nil
        t2 = nil

    }
    
    // 无主引用unowned
    // 无主引用：适用于引用对象永远有值的情况，它总是被定义为非可选类型
    func test3() {
        class Test1{
            var name : String = ""
            var t2 : Test2?;
            
            init()
            {
                self.name = ""
                print("Test1 init")
            }
            deinit {
                print("Test1 deinit")
            }
        }
        
        class Test2{
            var num : Int = 0;
            
           unowned var t1 : Test1
            
            init(t1:Test1)
            {
                self.num = 0
                self.t1 = t1
                print("Test2 init")
            }
            deinit {
                print("Test2 deinit")
            }
        }
        
        var t1:Test1? = Test1()
        var t2:Test2 = Test2(t1:t1!)
        t1?.t2 = t2
      
    }
    
    // 闭包循环引用：并不是所有的闭包补货变量和常量都会发生强循环引用，只有将闭包赋值给一个对象的属性，并且这个闭包使用了该对象，才会产生强循环引用
    func test4() {
        var emp = Employee()
        print(emp.fullName())
        
        
        print("-------------------block强循环引用")
        print("如果闭包和捕获的对象总是相互引用并且总是同时销毁，那么应该采用无主引用")
        print("当捕获的对象可能为nil时，则将闭包的引用声明为弱引用，；如果捕获的对象不会为nil，那么应该采用无主引用")
    }
    
}