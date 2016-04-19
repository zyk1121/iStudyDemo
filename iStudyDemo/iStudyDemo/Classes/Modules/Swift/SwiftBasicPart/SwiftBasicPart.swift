//
//  SwiftBasicPart.swift
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/17.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

import Foundation

// http://www.runoob.com/swift/swift-strings.html

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
    
    // 字符和字符串,Swift 采用unicode编码，它的字符几乎涵盖了我们所知道的一切字符
    // 字符,在C和OC中，字符是放在‘’中的，Swift中的字符是放在“”中的，
    func test3() {
        let andSign1:Character = "&"
        let andSign2 = "$"
        NSLog("\(andSign1)\(andSign2)")
        // 字符串
        
        let str1 = "123456"
        let str2:String = "abcdef"
        let str3 = String()
        NSLog("\(str1)\(str2)\(str3)")
        // var 声明的字符串是可变的，let声明的字符串是不可变的
        
//        str3 = "ddd";// error
//        var str4:String = String()
        var str4 = String() //  可变字符串
        str4 += "1"
        str4 += "a"
        str4 += "2"
         NSLog("\(str4)")
        
        // 字符串比较
        if str1 < str4 {
            NSLog("str1 < str4")
        }
        
        if str1 == str4 {
            NSLog("str1 == str4")
        } else {
            NSLog("str1 != str4")

        }
        NSLog("String 和 Character 类型支持== 和!=     “===   !==”是用于引用类型的判断的")
        // String 和 Character 类型支持== 和!=     “===   !==”是用于引用类型的判断的
        
        // 前缀和后缀
        let docFolder = [
            "java.docx",
            "JavaBean.docx",
            "Objective-C.xlsx",
            "Swift.docx"
        ]
        var wordCount = 0
        for doc in docFolder {
            if doc.hasSuffix(".docx") {
                wordCount += 1
            }
        }
        print("文件夹中word文档的个数：\(wordCount)")
        
        var javaDocCount = 0
        for doc in docFolder {
            let lowercaseDoc = doc.lowercaseString
            if lowercaseDoc.hasPrefix("java") {
                javaDocCount += 1
            }
        }
        print("文件夹中java文档的个数：\(javaDocCount)")
        print("string count字符串长度:\(str4.characters.count)")
    }
    
    // 控制语句
    func test4() {
        // 分支 if else 
        // switch,可以使用整数，浮点数，字符，字符串，元组类型，而且它的值可以是离散的也可以是连续的，语句执行完直接跳出，不需要braak
        /*
        let testScore = 86
        var grade:Character
        switch testScore / 10 {
        case 9:
            grade = "优"
        case 8:
            grade = "良"
        case 7,6:
            grade = "中"
        default:
            grade = "差"
        }
        print("\(testScore):\(grade)")
        
        let value = 1.00
        var desc:String
        switch value {
        case 0.0:
            desc = "最小值"
        case 0.5:
            desc = "中值"
        case 1.0:
            desc = "最大值"
        default:
            desc = "其他值"
        }
        
        print("\(desc)")
 */
        
        // swift 中使用范围 (...) (..<) (<..<)
//        let testScore = 90
//        var grade:Character
//        switch testScore {
//        case 90...100:
//            grade = "优"
//        case 80..<90:
//            grade = "良"
//        case 60..<80:
//            grade = "中"
//        default:
//            grade = "差"
//        }
//        print("\(testScore):\(grade)")
        
        // 元组 where
      
        let student = (id:"1002",name:"李四",age:32,chineseScore:90,EnglishScore:91)
        var desc:String
        
        switch student {
        case (_,_,let age,90...100,90...100) where age > 0:
            desc = "优"
        case (_,_,_,80..<90,80..<90):
            desc = "良"
        case (_,_,_,60..<80,60..<80):
            desc = "优"
        default:
            desc = "差"
        }
        
        print("\(desc)")
        
        
        // 循环语句
//        while true {
//            //
//        }
////
//        var i = 0
//        
//        repeat {
//            NSLog("\(i)");
//            i += 1;
//        } while i < 10
        let numbers = [1,2,3,4,5,6,7,8]
        for item in numbers {
            NSLog("\(item)")
        }
        
        // break 可以用于while ，do while，for，forin,强行退出（当前循环层）循环，可以带标签
        // continue,跳出本次循环
        // fallthrough 贯通语句，只能在switch中使用
        
        var j = 1
        let x = 4
        switch x {
        case 1:
            j += 1;
        case 2:
            j += 1;
        case 3:
            j += 1;
        case 4:
            j += 1;
            fallthrough
        case 5:
            j += 1;
            fallthrough
        default:
            j += 1
        }
        print("j=\(j)")
    }
    
    // 集合，Array ，Dictionry
    func test5() {
        // Array
//        var strArray = String()
//        var strArray2:Array<String> = []
//        var strArray:[String] = ["12","34"]
//        var strArray:[String] = String();
//        var strArray = [String]()
        /*
        
        
        var strArray:[String] = ["111"]
        strArray.append("123")
        strArray.append("234")
        strArray += ["avc","345dd"]
        strArray.insert("bbbb", atIndex: 0)
        print(strArray.count)
        print(strArray)
        
        let ff = strArray.removeAtIndex(0)
        strArray[0] = "hello"
        print(strArray.count)
        print(strArray)
        
        // 数组遍历
        for item in strArray {
            print(item)
        }
        
//        for (index,item) in enumerate(strArray) {
//            print("Item\(index + 1):\(item)")
//        }
        let itemArray = [String](count: 3, repeatedValue:"12345")
        print(itemArray)
//        var someInts:[Int] = [10, 20, 30]
 
        
        var someInts = [Int]()
        
        someInts.append(20)
        someInts.append(30)
        someInts += [40]
        
        var someVar = someInts[0]
        
        print( "第一个元素的值 \(someVar)" )
        print( "第二个元素的值 \(someInts[1])" )
        print( "第三个元素的值 \(someInts[2])" )
        */
        
        /*
        var intsA = [Int](count:2, repeatedValue: 2)
        var intsB = [Int](count:3, repeatedValue: 1)
        var intsC = [Int]()
        
        print("intsA.isEmpty = \(intsA.isEmpty)")
        print("intsB.isEmpty = \(intsB.isEmpty)")
        print("intsC.isEmpty = \(intsC.isEmpty)")
 
        
        var intsA = [Int](count:2, repeatedValue: 2)
        var intsB = [Int](count:3, repeatedValue: 1)
        
        var intsC = intsA + intsB
        
        print("intsA 元素个数为 \(intsA.count)")
        print("intsB 元素个数为 \(intsB.count)")
        print("intsC 元素个数为 \(intsC.count)")
          */
        
        // dictionry
        
        /*
        var studentDic1:Dictionary<Int, String> = [102:"zhangsan",105:"lisi",109:"wangwu"]
        var student2 = [102:"zhangsan",105:"lisi",109:"wangwu"]
        let student3 = [102:"zhangsan",105:"lisi",109:"wangwu"]
        var student4 = Dictionary<Int,String>()
        */
        var studentDic1:Dictionary<Int, String> = [102:"zhangsan",105:"lisi",109:"wangwu"]
        print(studentDic1)
        studentDic1[110] = "lll"
        print(studentDic1)
        studentDic1[102] = "hello"
        print(studentDic1)
        
        let dismisStud = studentDic1.removeValueForKey(102)
        print(dismisStud!)
        print(studentDic1)
        
        studentDic1.updateValue("abcdefg", forKey: 109)
        print(studentDic1)
        
        // 字典的遍历
        print("字典的遍历----")
        for item in studentDic1 {
            print(item)
        }
        for item in studentDic1.keys {
            print(item)
        }
        print("字典的遍历----")
        for (studentid,studentname) in studentDic1 {
            print("name:\(studentname) id:\(studentid)")
        }
    }
    
}