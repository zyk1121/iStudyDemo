//
//  SwiftProjectViewController.swift
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/24.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

import Foundation
import UIKit

// dyld: Library not loaded: @rpath/libswiftCore.dylib(已解决)   :
// dyld: Library not loaded: @rpath/libswiftContacts.dylib 添加
/*
 use_frameworks!
 
 pod 'SnapKit', '~> 0.15.0'
 pod 'Alamofire', '~> 3.2.1'
 pod 'SwiftHTTP', '~> 1.0.4'
 
 
 */
/*
 http://www.cocoachina.com/bbs/read.php?tid=287975
 
 1. 退出 Xcode
 2. 重启电脑(不需要)
 3. 找到 这个 DerivedData 文件夹 删除 (路径: ~/Library/Developer/Xcode/DerivedData)
 4. 删除这个 com.apple.dt.Xcode 文件 (路径: ~/Library/Caches/com.apple.dt.Xcode)，（可以不用执行）
 
 */

class SwiftProjectTableView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var listData:[String]?
    var tableView:UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.setupData()
        self.setupUI()
        self.view.updateConstraintsIfNeeded()
    }
    
    
    func setupData() {
        // listData = [String]()
        listData = ["航歌教程:http://www.hangge.com/","2","3"]
        
    }
    
    func setupUI() {
        //创建表视图
        self.tableView = UITableView()
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView?.tableFooterView = UIView.init(frame: CGRectZero)
        //创建一个重用的单元格
        self.tableView!.registerClass(UITableViewCell.self,
                                      forCellReuseIdentifier: "SwiftCell")
        self.view.addSubview(self.tableView!)
    }
    
    // 自动布局
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.tableView?.snp_updateConstraints(closure: { (make) in
            make.edges.equalTo(self.view)
        })
    }
    
    
    //在本例中，只有一个分区
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    //返回表格行数（也就是返回控件数）
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listData!.count
    }
    
    //创建各单元显示内容(创建参数indexPath指定的单元）
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell
    {
        //为了提供表格显示性能，已创建完成的单元需重复使用
        let identify:String = "SwiftCell"
        //同一形式的单元格重复使用，在声明时已注册
        let cell = tableView.dequeueReusableCellWithIdentifier(identify,
                                                               forIndexPath: indexPath) as UITableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.text = self.listData![indexPath.row]
        return cell
    }
    
    // UITableViewDelegate 方法，处理列表项的选中事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.tableView!.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.testFunc(indexPath.row)
    }
    
    // 点击执行
    func testFunc(row:Int) {
        switch row {
        case 0:
            self.hangge()
        default:
            self.hangge()
        }
    }
    // method
    func hangge() {
        let alertView = UIAlertView.init(title: "hangge", message: "http://www.hangge.com/", delegate: nil, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alertView.show()
    }
}