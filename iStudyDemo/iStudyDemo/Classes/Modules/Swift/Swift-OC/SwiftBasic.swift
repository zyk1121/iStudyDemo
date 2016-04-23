//
//  SwiftBasic.swift
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/17.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

import Foundation
import UIKit

// http://www.jianshu.com/p/7d6cd5c6b709
// http://blog.csdn.net/fengsh998/article/details/34440159
// http://blog.csdn.net/showhilllee/article/details/50606284

func testGlobal() {
    NSLog("global test func")
}

class SwiftClass: NSObject {
    // 声明变量
    var tempStr = "hello world"

    // 函数入口
    func runOCCallSwift() {
        // log
        NSLog("NSLog:\(tempStr)")
        print("print:\(tempStr)")
        testGlobal();
    }
    
    // 函数入口
    func runSwiftCallOC() {
        let obj:SwiftCallOCObject = SwiftCallOCObject();
        obj.swiftCallOC();
        obj.test2();// 新加入的函数不需要重新clean
        testOCGlobal();// OC 中的全局方法
        testGlobal(); // 调用全局的函数
        

        
        // 定义了一个公共的数据属性存放类
        GlobalOCSwiftData.testFunc();
    }
    
    func test3() {
        NSLog("OCCallSwift:新加入的函数需要重新clean")
    }
}

class GlobalOCSwiftData: NSObject {
    static var name = "name";
    static func testFunc()
    {
        NSLog("global func:\(name)");
    }
}

class TestSwiftViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad();
        self.title = "swift vc"
        self.view.backgroundColor = UIColor.lightGrayColor()
        //
        // 添加一个switch
        let switchBtn = UISwitch();
        switchBtn.frame = CGRectMake(0, 100, 100, 40)
        self.view.addSubview(switchBtn);
    }
}

