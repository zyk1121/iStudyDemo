//
//  SwiftClassClass.swift
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/23.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

import Foundation

class SwiftClassClass : NSObject {
    // 枚举
    func test1() {
        
        // 枚举
        /*
         enum WeekDays {
         case Monday
         case Thusday
         case Wednesday
         case Thursday
         case Friday
         }
         */
        /*
         enum WeekDays {
         case Monday,Thusday,Wednesday,Thursday,Friday
         }
         */
        enum WeekDays : Int {
            case Monday = 0
            case Thusday = 1
            case Wednesday = 2
            case Thursday
            case Friday
        }
        
        
        var day = WeekDays.Friday
        day = WeekDays.Wednesday
        day = .Monday
        
        func writeGreeting(day:WeekDays)
        {
            switch day {
            case .Monday:
                print("星期一好")
            case .Thusday:
                print("星期二好")
            case .Wednesday:
                print("星期三好")
            case .Thursday:
                print("星期四好")
            case .Friday:
                print("星期五好")
            }
        }
        writeGreeting(day)
        writeGreeting(WeekDays.Friday)
        
        // 原始值
        if day.rawValue == 0 {
            print("星期一好")
        }
        
        // 相关值
        enum Figure {
        
            case Rectangle(Int,Int)
            case Circle(Int)
        }
        
        func printFingure(figure:Figure)
        {
            switch figure {
            case .Rectangle(let width, let height):
                print("宽＝\(width);高＝\(height)")
            case .Circle(let radius):
                print("圆形半径:\(radius)")
            }
        }
        
        let figure = Figure.Rectangle(10, 20)
        printFingure(figure)
        let figure2 = Figure.Circle(30)
        printFingure(figure2)
        
    }
    // 结构体和类定义
    func test2() {
        
        class Employee {
            var no : Int = 0
            var name : String = ""
            var job : String?
            var salary : Double = 0
            
            var dept : Department?
            
        }
        
        struct Department
        {
            var no:Int = 0
            var name:String = ""
        }
        
        var dept = Department()
        dept.no = 10
        dept.name = "sals"
        
        let emp = Employee()
        emp.dept = dept
        emp.job = "developer"
        emp.name = "ddd"
        emp.no = 20
        emp.salary = 10000
        /*
        func updateValue(dept:Department)
        {
//            dept.no = 200 // 编译出错， 值类型
        }
 */
        func updateValue1(inout dept:Department)
        {
                        dept.no = 200 // ok
        }
        
        // 类是引用类型，可以直接通过函数修改值
        func updateValue2(emp:Employee)
        {
            emp.name = "ddd"
        }
        
        // 引用类型的比较
        // === !==
        let emp1 = emp
        let emp2 = Employee()
        
        if emp1 === emp2 {
            print("emp1 === emp2")
        }
        
        if emp1 === emp1 {
            print("emp1 === emp1")
        }
        
        if emp1 !== emp2 {
            print("emp1 !== emp2")
        }
        
        // 类型嵌套，已经提到
        
        
    }
    // 可选类型与可选链
    func test3() {
        // 可选类型，？ ！；有时候我们使用一个常量和变量，它保存的值可能有也可能没有（nil）
        func divide(n1:Int,n2:Int)->Double? {
            if n2 == 0{
                return nil
            } else {
                return Double(n1)/Double(n2)
            }
        }
        //
        // 可选绑定
        if let result:Double? = divide(100, n2: 0) {
            print("success")
        } else {
            print("failure")
        }
        // 强制拆封
        if let result:Double? = divide(100, n2: 200) {
            print(result)
            print(result!)
        }
        
        // 隐式拆封
        let result3:Double! = divide(100, n2: 300)
        print(result3)
//        let result4:Double! = divide(100, n2: 0)
//        print(result4)//result4 不能为nil,对nil进行强制拆封会出现运行时错误
        /*success
         Optional(0.5)
         0.5
         0.333333333333333
         fatal error: unexpectedly found nil while unwrapping an Optional value
         */
        
        
        // 可选链
       /*
        class Employee {
            var no : Int = 0
            var name :String = "tony"
            var job : String?
            var salary:Double = 0
            var dept:Department = Department()
        }
        class Department
        {
            var no:Int = 10
            var name:String = "ddd"
            var comp:Company = Company()
        }
        class Company
        {
            var no:Int=100
            var name:String = "EeE"
        }
        
        var emp = Employee()
        print(emp.dept.comp.name)
 */
        class Employee {
            var no : Int = 0
            var name :String = "tony"
            var job : String?
            var salary:Double = 0
            var dept:Department?
        }
        class Department
        {
            var no:Int = 10
            var name:String = "ddd"
            var comp:Company?
        }
        class Company
        {
            var no:Int=100
            var name:String = "EeE"
        }
        
        var emp = Employee()
      //  print(emp.dept!.comp!.name) // 强制拆封有一个弊端，如果可选链中某个环节为nil，将会导致运行时错误
        print(emp.dept?.comp?.name)// 用？表示的时候，如果某个环节为nil，不会抛出错误，而是会把nil返回给引用者
        emp.dept =  Department()
        print(emp.dept?.comp)
        
    }
    
    // 属性和下标
    func test4() {
        // 存储属性：存储属性可以存储数据，分为常量属性和变量属性，适用于类和结构体
        class Test{
            var no:Int = 0
            let name:String = ""
        }
        let test:Test = Test()
//        test.name = ""// 编译错误
        test.no = 123
        
        
        // 延时存储属性
        class Employee {
            var no:Int = 0
            var name:String = ""
            var job:String?
            var salary:Double = 0
            lazy var dept:Department = Department()// 延迟加载技术
        }
        struct Department{
            let no : Int = 0
            var name : String = "ddd"
            
        }
        // 延迟加载技术，lazy声明属性：第一次使用的时候才加载，如果永远不访问，它就不会创建，这样可以减少内存占用
        // 属性观察者，willSet:在设置新的值之前调用 didSet：在新的值被设置之后马上调用
        struct Test2
        {
            var name : String = "123" {
                willSet (newValue){
                    print(newValue)
                }
                didSet (oldValue) {
                    print(oldValue)
                }
            }
        }
        
        var test2:Test2 = Test2()
        test2.name = "abc"
        
        
        // 计算属性:计算属性本身不存储数据，而是从其他存储属性中计算得到数据，类 结构体 枚举都可以定义计算属性
        //
        class Employee2 {
            var no:Int = 0
            var name:String = ""
            var fullName : String {
                get {
                    return "abc"
                }
                
                set (newValue) {
                    name = newValue
                    no = 2
                }
            }
        }
        
        var emp2 = Employee2()
        emp2.fullName = "aaaaa"
        print(emp2.fullName)
        print(emp2.no)

        // 只读计算属性：只有getter访问器，没有setter访问器
        class Employee3 {
            var no:Int = 0
            var name:String = ""
            var fullName : String {
                get {
                    return "abc"
                }
            }
        }

        var emp3 = Employee3()
//        emp3.fullName = ""// 编译错误
        // 可以省略 set {}
        class Employee4 {
            var no:Int = 0
            var name:String = ""
            var fullName : String {
                //get {
                    return "abc"
//                }
            }
        }
        
        // 结构体和枚举中的计算属性
        struct Department3
        {
            var  no:Int = 0
            var name:String = "ABCED"
            
            var fullName:String {
            return "swift" + name+"."
            }
        }
        
        var dep3 = Department3()
        print(dep3.fullName)
        
        enum WeekDays : String{
            case Monday = "Mon."
            case Thusday = "Tus."
            case Wednesday = "Wed"
            case Thursday = "thu"
            case Friday = "fri"
            
            var message : String {
            
                return "today is" + self.rawValue;
            }
        }
        
        var day = WeekDays.Friday
        print(day.message)
        
        
        
        // 静态属性
        // 结构体静态属性
        struct Account
        {
            var amount : Double = 0.0
            var owner : String = ""
            //  存储属性
            static var interestRate  : Double = 0.668 // 利率
            // 计算属性
            static var staticProp : Double {
                return interestRate * 10_000_000
            }
            
            var instanceProp : Double {
                return Account.interestRate * amount
            }
        }
        
        // 访问静态属性＋访问实例属性
        print(Account.staticProp)
        
        var myAccount = Account()
        myAccount.amount = 1000
        print(myAccount.instanceProp)
        
        // 枚举静态属性
        enum Account2{
            case 中国银行
            case 中国工商银行
            case 中国建设银行
            case 中国农业银行
            
            static var interestRate : Double = 0.668
            
            static var staticProp : Double {
                return interestRate * 1000_000
            }
            var intersetPorp:Double {
                switch self {
                case 中国银行:
                    Account2.interestRate = 0.667
                case 中国工商银行:
                    Account2.interestRate = 0.668
                case 中国建设银行:
                    Account2.interestRate = 0.669
                case 中国农业银行:
                    Account2.interestRate = 0.670
                }
                return Account2.interestRate * 1_000_000
            }
        }
        // 访问静态属性＋实例属性
        
        print(Account2.staticProp)
        
        var mymy = Account2.中国银行
        
        print(mymy.intersetPorp)
        
        
        // 类的静态属性，使用关键字 class
        
        class Account3
        {
            var amount : Double = 0.0
            var owner : String = ""
            // 静态存储属性
            static var interestRate  : Double = 0.668 // 利率
            // 静态计算属性
            class var staticProp : Double {
                return interestRate * 10_000_000
            }
            
            var instanceProp : Double {
                return Account.interestRate * amount
            }
        }

        print(Account3.staticProp)
        
        
        print("----------------------下标：subscript")
        /*下标的语法：
         面向对象类型 类型名 {
            其他属性
            subscript(参数：参数数据类型) －> 返回数据类型 {
                get {
         
                }
                set (新属性值){
         
                }
            }
         }
         
         */
        // 二维数组
        struct DoubleDimensionalArray {
            let rows : Int,columns : Int
            var grid : [Int]
            
            init(rows:Int,colum:Int) {
                self.rows = rows
                self.columns = colum
                grid = Array(count: rows * colum, repeatedValue: 0)
            }
            
            subscript(row:Int,col:Int) -> Int {
                get {
                    return grid[(row * columns) + col]
                }
                set (newValue){
                    grid[(row * columns) + col] = newValue
                }
            }
        }
        
        var ary = DoubleDimensionalArray(rows: 10,colum: 10)
        
        // 初始化数组
        for i in 0 ..< 10 {
            for j in 0 ..< 10 {
                ary[i,j] = i*j
            }
        }
        // 打印
        for i in 0 ..< 10 {
            for j in 0 ..< 10 {
               print(ary[i,j])
            }
        }
    }
    
    
    // 方法
    func test5() {
        // 类的方法可以直接修改类的属性
        // 结构体和枚举方法变异 （mutating）
        // 结构体和枚举中的方法默认是不能修改变量属性的，添加mutating修饰之后，可以修改变量属性，但是不能修改常量属性
        struct Test
        {
            var name:String = ""
            let id : Int = 0
//            func changevalue() {
//                name = ""
//            }// 编译出错
            mutating func changevalue() {
                name = "abc"
            }
            static func test()
            {
                print("struct static method")
            }
        }
        
        var tt = Test()
        tt.changevalue()
        Test.test()
        
        
        // 静态方法：
        // 静态方法中定义的方法也是与静态属性中类似的，枚举和结构体中的静态方法：static;类中的静态方法：class
        class Test2
        {
            static func test()
            {
                print("class static method")
            }
            class func test2()
            {
                print("class static method for class")
            }
        }
        Test2.test()
        Test2.test2()
        
    }
    
    
    
    // 构造与析构方法
    func test6() {
        print("构造与析构方法------------")
        // 默认的构造器
        class Rectangle {
            var width : Double = 0.0
            var height : Double = 0.0
        }
        // 默认init构造器
        var rect : Rectangle = Rectangle()
        rect.width = 100
        rect.height = 200
        print(rect.width)
        
        
        class Rectangle2 {
            var width : Double = 0.0
            var height : Double = 0.0
            init(){
            // 默认构造器
            }
            // 重载构造器
            init(width:Double,height:Double)
            {
                self.width = width
                self.height = height
            }
            // 指定外部访问参数名
            init(W width:Double, H height:Double)
            {
                self.width = width
                self.height = height
            }
        }
        
        let rect2 = Rectangle2(width:10,height:20)
        let rect3  = Rectangle2(W: 20 ,H: 30)
        
        // 构造器重载：
        /*
         1.函数有相同的名字
         2.参数列表不同或返回值类型不同，或外部参数名不同
         */
        
        // 构造器代理：值类型的构造器代理，引用类型的构造器代理（横向代理：便利构造器；向上代理：指定构造器）
        // 值类型的构造器
        
        struct Rectangle3 {
            var width : Double = 0.0
            var height : Double = 0.0
            init(width:Double,height:Double)
            {
                self.width = width
                self.height = height
            }
        
            init(W width:Double, H height:Double)
            {
                self.width = width
                self.height = height
            }
            
            init(length:Double)
            {
                self.init(W:length,H: length)
            }
            
            init(){
                self.init(width:320,height: 480)
            }
        }

        // 引用类型构造器横向代理
        /*
        横向代理：横向代理类似于值类型的构造器代理，发生在同一个类的内部，这种构造器称为便利构造器（convenience initializers）
                便利构造器调用本类的指定构造器，指定构造器调用父类的指定构造器
        向上代理：指定构造器（designated initializers）
         */
        
        
        //  引用的构造器代理
        // 便利构造器调用本类的指定构造器，指定构造器调用父类的指定构造器
        print("引用的构造器代理：便利构造器调用本类的指定构造器，指定构造器调用父类的指定构造器")
        
        class Shape{
        
            var area :Double = 0.0
            // 指定构造器
            init()
            {
                area = 0.0
            }
            // 指定构造器
            init(area:Double)
            {
                self.area = area;
            }
            // 便利构造器
            convenience init(width:Double,height:Double)
            {
                self.init(area:width*height)
            }
        }
        
        class Rectangle4 : Shape{
            var width : Double = 0.0
            var height : Double = 0.0
            // 指定构造器
            init(width:Double,height:Double)
            {
                self.width = width
                self.height = height
                // 调用 父类的指定构造器
                super.init()
            }
            // 指定构造器
            init(W width:Double, H height:Double)
            {
                self.width = width
                self.height = height
                // 调用 父类的指定构造器
                super.init(area: 20)
//                super.init(width: 10, height: 20)// 编译错误，不能调用父类的便利构造器
            }
        
            // 便利构造器
            convenience init(length:Double)
            {
                // 调用本类的制定构造器
                self.init(W:length,H: length)
            }
            // 便利构造器
            convenience override init(){
                // 调用本类的制定构造器
                self.init(width:320,height: 480)
            }
        }
        
        // 析构器
        print("析构器-----------")
        class TestTest
        {
            init()
            {
                print("init")
            }
            deinit
            {
                print("deinit")
            }
        }
        
        var t:TestTest = TestTest()
    
    }
    
    
    // 继承
    func test7() {
        print("---------------继承")
        /*
         一般情况下，swift中一个类只能继承一个父类，称为单继承，多重继承可以使用协议实现，swift中一个类只能继承一个父类，但是可以遵守多个协议
         */
        print("构造器的调用规则:")
        print("1.指定构造器必须调用其直接父类的指定构造器")
        print("2.便利构造器必须调用同一类的其它构造器")
        print("3.便利构造器必须以最终调用一个指定构造器结束")
        
        print("---- 构造过程安全检查----:")
        print("1.指定构造器必须保证其所在类的所有存储属性都初始化完毕之后才能向上嗲用父类的构造器代理")
        print("2.指定构造器必须先向上调用父类的构造器代理，然后再为继承的属性设置新的值，否则指定构造器设置的新值将被父类的构造器所覆盖")
        print("3.便利构造器必须先调用同一个类的其它构造器代理，然后再为任意属性设置新值，否则便利构造器赋予的新值将会被同一个类中的其它指定构造器所覆盖")
        print("4.构造器在第一阶段（子类和父类初始化完成）完成之前，不能嗲用实例方法，也不能读取实例属性")
        
        
        // 重写，属性，方法和下标都能重写，关键字为override
        // final:final 关键字声明的类不能被继承，final声明的属性方法下标不能被重写
//        
//        final class Test1
//        {
//            var no:Int = 0
//        }
//        class Test2:Test1
//        {
//            // 编译出错
//        }
        
        class Test1
        {
//            final var name : String = ""// 不能被重写
            var name : String = ""
            final var age : Int  = 0
        }
        
        class Test2: Test1
        {
            override var name: String
                {
                get {
                    return "abv"
                }
                set(name){
                    self.name = name
                }
            }
        }
        
        var dd = Test2()
        print(dd.name)
        
        // 类型安全与检查
        class Person
        {
        }
        class Student:Person
        {
        }
        class Worker:Student
        {
        }
        
        // is as
        // is: 可以判断一个实例是否是某个类的类型
//        var p:Person = Person()
//        if p is Person {
//            print("p is Person true")
//        } else {
//            print("p is Person false")
//        }
        
        var p:Person = Student()
        if p is Student {
            print("p is Student true")
        } else {
            print("p is Student false")
        }
                if p is Person {
                    print("p is Person true")
                } else {
                    print("p is Person false")
                }
        
        // is 相当于 isKindOfClass
        
        // 使用as操作符
        
        print("-----使用as--------")
        // as 转型，父类可以像子类转型，as?更为安全，将其转为目标类型的可选类型，能够成功则转换，不成功则返回nil
        // AnyObject可以表示任何类的实例，Any可以表示任何类型，包含AnyObject
        let p1 = Person()
        let s1 = Student()
        let s2 = Student()
        let w1 = Worker()
        let w2 = Worker()
        
        let people1:[Person] = [p1,s1,s2,w1,w2]
        let people2:[AnyObject] = [p1,s1,s2,w1,w2]
        let people3:[Any] = [p1,s1,s2,w1,w2]
        
        for item in people3 {
            if let s = item as? Person {
                print("item is person")
            } else {
                if let s = item as? Student {
                    print("item is Student")
                } else {
                    print("item is Worker")
                }
            }
        }
        
    }
    
}