//
//  SwiftFoundation.swift
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/23.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

import Foundation

class SwiftFoundation: NSObject {
    func test1() {
        var swiftInt = 80
        var intNumber1 = NSNumber(integer: swiftInt)
        var intNumber2 = NSNumber(int: CInt(swiftInt))
        let myInt = intNumber1.intValue
        var floatValue = NSNumber(float: CFloat(30.0))
        var myFloat = floatValue.floatValue
    }
    func test2() {
        var str1 : NSString = "abcdefg"
        NSLog("%d", str1.length)
        print(str1)
        print(str1.length)
        
        str1 = str1.stringByAppendingString("1234")
        print(str1)
        
        str1 = str1.uppercaseString
        print(str1)
        var range:NSRange
        range = str1.rangeOfString("FG")
        print(range.length)
        
        // 
        var str2 : NSString = "oc"
        var search,replace  : NSString
        var mstr : NSMutableString
        var range2 : NSRange
        
        mstr = NSMutableString.init()
        mstr.appendString(str2 as String)
        mstr.insertString("23", atIndex: 2)
        
        
        mstr.deleteCharactersInRange(NSMakeRange(0, 2))
        mstr.deleteCharactersInRange(NSMakeRange(0, 0))
        mstr.replaceCharactersInRange(NSMakeRange(0, 1), withString: "1234")
        print("-----")
        print(mstr)
    }
    
    func test3() {
        var weeks : NSMutableArray = NSMutableArray(capacity: 3)
        weeks.addObject("1")
        weeks.addObject("2")
        weeks.addObject("3")
        weeks.addObject("4")
        
        for item in weeks {
            print(item)
        }
        
        weeks.removeAllObjects()
        
    }
    
    func test4() {
        var mutable : NSMutableDictionary = NSMutableDictionary()
        mutable.setObject("123", forKey: "1")
        mutable.setObject("abc", forKey: "2")
        
        var keys = mutable.allKeys
        var values = mutable.allValues
        
        print(keys)
        print(values)
        
        print(mutable.objectForKey("1"))
        
    }
}