//
//  File.swift
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/24.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SwiftTableViewTest2: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ctrlnames:[String]?
    var tableView:UITableView?
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初始化数据，这一次数据，我们放在属性列表文件里
        //        self.ctrlnames =  NSArray(contentsOfFile:
        //            NSBundle.mainBundle().pathForResource("test_", ofType:"plist")!) as? Array
        //
        //        print(self.ctrlnames)
        
        //        self.ctrlname
        self.ctrlnames = [String]()
        self.ctrlnames?.append("Json解析－NSJSONSerialization")
        self.ctrlnames?.append("SwiftyJSON")
        self.ctrlnames?.append("NSURL")
        
        //创建表视图
        self.tableView = UITableView(frame: self.view.frame, style:UITableViewStyle.Plain)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        //创建一个重用的单元格
        self.tableView!.registerClass(UITableViewCell.self,
                                      forCellReuseIdentifier: "SwiftCell")
        self.view.addSubview(self.tableView!)
        
        //创建表头标签
        let headerLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, 30))
        headerLabel.backgroundColor = UIColor.blackColor()
        headerLabel.textColor = UIColor.whiteColor()
        headerLabel.numberOfLines = 0
        headerLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        headerLabel.text = "简单的第三方框架"
        headerLabel.font = UIFont.italicSystemFontOfSize(20)
        self.tableView!.tableHeaderView = headerLabel
    }
    
    //在本例中，只有一个分区
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    //返回表格行数（也就是返回控件数）
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ctrlnames!.count
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
        cell.textLabel?.text = self.ctrlnames![indexPath.row]
        return cell
    }
    
    // UITableViewDelegate 方法，处理列表项的选中事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.tableView!.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.testFunc(indexPath.row)
        
        //        let itemString = self.ctrlnames![indexPath.row]
        //
        //        let alertController = UIAlertController(title: "提示!",
        //                                                message: "你选中了【\(itemString)】", preferredStyle: .Alert)
        //        let okAction = UIAlertAction(title: "确定", style: .Default,handler: nil)
        //        alertController.addAction(okAction)
        //        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //滑动删除必须实现的方法
    //    func tableView(tableView: UITableView,
    //                   commitEditingStyle editingStyle: UITableViewCellEditingStyle,
    //                                      forRowAtIndexPath indexPath: NSIndexPath) {
    //        print("删除\(indexPath.row)")
    //        let index = indexPath.row
    //        self.ctrlnames?.removeAtIndex(index)
    //        self.tableView?.deleteRowsAtIndexPaths([indexPath],
    //                                               withRowAnimation: UITableViewRowAnimation.Top)
    //    }
    
    //滑动删除
    //    func tableView(tableView: UITableView,
    //                   editingStyleForRowAtIndexPath indexPath: NSIndexPath)
    //        -> UITableViewCellEditingStyle {
    //            return UITableViewCellEditingStyle.Delete
    //    }
    
    //修改删除按钮的文字
    //    func tableView(tableView: UITableView,
    //                   titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath)
    //        -> String? {
    //            return "删"
    //    }
    
    
    
    func testFunc(row : Int) {
        // 0 NSJSONSerialization
        switch row {
        case 0:
            self.testJson()
            self.testjson2()
        case 1:
            // http://www.hangge.com/blog/cache/detail_968.html
            //  SwiftyJSON
            self.SwiftyJSON()
        case 2:
            self.NSURLPostGet()
            
            
        default:
            print("nothing")
        }
    }
    
    // json － NSJSONSerialization
    //测试json
    func testJson() {
        //Swift对象
        let user = [
            "uname": "张三",
            "tel": ["mobile": "138", "home": "010"]
        ]
        //首先判断能不能转换
        if (!NSJSONSerialization.isValidJSONObject(user)) {
            print("is not a valid json object")
            return
        }
        //利用OC的json库转换成OC的NSData，
        //如果设置options为NSJSONWritingOptions.PrettyPrinted，则打印格式更好阅读
        let data : NSData! = try? NSJSONSerialization.dataWithJSONObject(user, options: [])
        //NSData转换成NSString打印输出
        let str = NSString(data:data, encoding: NSUTF8StringEncoding)
        //输出json字符串
        print("Json Str:"); print(str)
        
        //把NSData对象转换回JSON对象
        let json : AnyObject! = try? NSJSONSerialization
            .JSONObjectWithData(data, options:NSJSONReadingOptions.AllowFragments)
        print("Json Object:"); print(json)
        //验证JSON对象可用性
        let uname : AnyObject = json.objectForKey("uname")!
        let mobile : AnyObject = json.objectForKey("tel")!.objectForKey("mobile")!
        print("get Json Object:"); print("uname: \(uname), mobile: \(mobile)")
    }
    func testjson2() {
        let string: NSString = "[{\"ID\":1,\"Name\":\"元台禅寺\",\"LineID\":1},{\"ID\":2,\"Name\":\"田坞里山塘\",\"LineID\":1},{\"ID\":3,\"Name\":\"滴水石\",\"LineID\":1}]"
        let data = string.dataUsingEncoding(NSUTF8StringEncoding)
        
        let jsonArr = try! NSJSONSerialization.JSONObjectWithData(data!,
                                                                  options: NSJSONReadingOptions.MutableContainers) as! NSArray
        
        print("记录数：\(jsonArr.count)")
        for json in jsonArr {
            print("ID：", json.objectForKey("ID")!, "    Name：", json.objectForKey("Name")!)
        }
    }
    
    // 
    func  SwiftyJSON() {
        // http://www.hangge.com/blog/cache/detail_968.html
        
    }
    
    // NSURL post get
    func NSURLPostGet() {
        // post同步
        /*
        let urlString:String = "http://www.hangge.com/"
        var url:NSURL!
        url = NSURL(string:urlString)
        let request = NSMutableURLRequest(URL:url)
        let body = "score=\(50)&user=\("1234")"
        //编码POST数据
        let postData = body.dataUsingEncoding(NSUTF8StringEncoding)
        //保用 POST 提交
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        
        //响应对象
        var response:NSURLResponse?
        
        do{
            //发出请求
            let received:NSData? = try NSURLConnection.sendSynchronousRequest(request,
                                                                              returningResponse: &response)
            let datastring = NSString(data:received!, encoding: NSUTF8StringEncoding)
            print(datastring)
            
        }catch let error as NSError{
            //打印错误消息
            print(error.code)
            print(error.description)
        }
         
 */
        
        //   
        func saveScore(score:Int, userid:String)
        {
            let urlString:String = "http://www.hangge.com/savescore.php"
            var url:NSURL!
            url = NSURL(string:urlString)
            let request = NSMutableURLRequest(URL:url)
            let body = "score=\(score)&user=\(userid)"
            //编码POST数据
            let postData = body.dataUsingEncoding(NSASCIIStringEncoding)
            //保用 POST 提交
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            var conn:NSURLConnection!
            conn = NSURLConnection(request: request,delegate: self)
            conn.start()
            print(conn)
        }
        
        func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse)
        {
            print("请求成功！");
            print(response)
        }
        
//        func connection(connection: NSURLConnection, didReceiveData data: NSData)
//        {
//            print("请求成功1！");
//            let datastring = NSString(data:data, encoding: NSUTF8StringEncoding)
//            print(datastring)
//        }
//        
//        func connectionDidFinishLoading(connection: NSURLConnection)
//        {
//            print("请求成功2！");
//        }
        
        saveScore(20,userid: "123")
        
        // http://www.hangge.com/blog/cache/detail_670.html
    }
}




class SwiftTableViewTest3: UIViewController {
    
     lazy var box = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        box.backgroundColor = UIColor.redColor()
        self.view.addSubview(box)
        
        box.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(50)
            make.center.equalTo(self.view)
        }
    }
}
