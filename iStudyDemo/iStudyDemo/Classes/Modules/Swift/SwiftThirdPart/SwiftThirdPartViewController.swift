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
import Alamofire
import SwiftHTTP

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
        self.ctrlnames?.append("Alamofire")
        self.ctrlnames?.append("SwiftHTTP")
        
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
        case 3:
            self.testAlamofire()
        case 4:
            self.testSwiftHTTP()
            
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
    
    
    
    // Alamofire
    /*1，什么是Alamofire
     （1）Alamofire 的前身是 AFNetworking。AFNetworking 是 iOS 和 OS X 上很受欢迎的第三方HTTP网络基础库。
     （2）其实 AFNetwork 的前缀 AF 便是 Alamofire 的缩写。
     （3）Swift发布后，AFNetworking的作者又用Swift语言写了个相同功能的库，这便是 Alamofire。
     （4）Alamofire 本质是基于`NSURLSession`，并做了封装。使用 Alamofire 可以让我们网络请求相关代码（如获取数据，提交数据，上传文件，下载文件等）更加简洁易用。
     
     原文出自：www.hangge.com  转载请保留原文链接：http://www.hangge.com/blog/cache/detail_970.html
     */
    func testAlamofire() {
//        Alamofire.request(.GET, "https://httpbin.org/get", parameters: ["foo": "bar"]).responseJSON { response in
//            print(response.request)// original URL request
//            print(response.response) // URL response
//            print(response.data)// server data
//            print(response.result)// result of response serialization
//            
//            if let JSON = response.result.value {
//                print("JSON: \(JSON)") //具体如何解析json内容可看下方“响应处理”部分
//            }
//        }
        
        /*
        Alamofire.request(.GET, "https://httpbin.org/get", parameters: ["foo": "bar"])
            .response { request, response, data, error in
                            print(request)// original URL request
                            print(response) // URL response
                            print(data)// server data
                           //  print(result)// result of response serialization
        }
 */
        
        /*
        Alamofire.request(.GET, "http://www.hangge.com/jsonData.php")
            .responseJSON { response in
                switch response.result {
                case .Success:
                    //把得到的JSON数据转为数组
                    if let items = response.result.value as? NSArray{
                        //遍历数组得到每一个字典模型
                        for dict in items{
                            print(dict)
                        }
                    }
                case .Failure(let error):
                    print(error)
                }
        }
 */
        
        /*
        Alamofire.request(.GET, "https://httpbin.org/get")
            .responseString { response in
                print("Response String: \(response.result.value)")
            }
            .responseJSON { response in
                print("Response JSON: \(response.result.value)")
        }
 */
        Alamofire.request(.GET, "https://httpbin.org/get", parameters: ["foo": "bar"])
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success:
                    print("数据获取成功!")
                case .Failure(let error):
                    print(error)
                }
        }
        
        /*
         
         3，请求类型（HTTP Methods）
         除了上面使用的 .Get 类型。Alamofire还定义了许多其他的HTTP 方法（HTTP Medthods）可以使用。
         1
         2
         3
         public enum Method: String {
         case OPTIONS, GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT
         }
         比如要使用 POST 请求，把 Alamofire.request 第一个参数做修改即可：
         1
         Alamofire.request(.POST, "http://httpbin.org/post")
         
         */
    }
    
    
    // SwiftHTTP
    func testSwiftHTTP() {
//        do {
//            let opt = try HTTP.GET("http://hangge.com")
//            opt.start { response in
//                //进行具体的响应操作...
//                print("请求成功")
//                print(response)
//                
//            }
//        } catch let error {
//            print("请求失败: \(error)")
//        }
        
        /*
        
        do {
            //实际的url是: http://www.hangge.com/test.php?hello=world&param2=1&ids[]=1&ids[]=2
            let opt = try HTTP.GET("http://www.hangge.com/test.php",
                                   parameters: ["hello": "world", "param2": 1, "ids": [1,2]])
            opt.start { response in
                //进行具体的响应操作...
                                print("请求成功")
                                print(response)
            }
        } catch let error {
            print("请求失败: \(error)")
        }
 */
        
        // POST
        /*
        let params = ["param": "param1",
                      "array": ["first array element","second","third"],
                      "num": 23,
                      "dict": ["someKey": "someVal"]]
        
        do {
            let opt = try HTTP.POST("http://www.hangge.com/test.php", parameters: params)
            opt.start { response in
                //进行具体的响应操作...
                print("ok")
            }
        } catch let error {
            print("请求失败: \(error)")
        }
 */
        /*
        
        do {
            let opt = try HTTP.GET("http://hangge.com")
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    return
                }
                print("获取到数据: \(response.text)")
            }
        } catch let error {
            print("请求失败: \(error)")
        }
 */
        /*
        do {
            let opt = try HTTP.GET("http://hangge.com")
            opt.start { response in
                print("statusCode: \(response.statusCode)\n")
                print("headers: \(response.headers)")
            }
        } catch let error {
            print("请求失败: \(error)")
        }
 */
        
        
        let operationQueue = NSOperationQueue()
        operationQueue.maxConcurrentOperationCount = 2 //最大任务数
        
        do {
            let opt1 = try HTTP.New("http://www.hangge.com", method: .GET)
            opt1.onFinish = { response in
                //进行具体的响应操作...
                print("ok 1")
            }
            operationQueue.addOperation(opt1)
            
            let opt2 = try HTTP.New("http://www.baidu.com", method: .GET)
            opt2.onFinish = { response in
                //进行具体的响应操作...
                 print("ok 2")
            }
            operationQueue.addOperation(opt2)
            
            let opt3 = try HTTP.New("http://www.iteye.com", method: .GET)
            opt3.onFinish = { response in
                //进行具体的响应操作...
                 print("ok 3")
            }
            operationQueue.addOperation(opt3)
            // 下面的操作没有效果
//            opt2.cancel()
//            operationQueue.cancelAllOperations()
            
        } catch let error {
            print("请求失败: \(error)")
        }
        
        /*
         
         可以使用 cancel() 方法停止单个任务：
         1
         opt2.cancel() //取消这个请求任务
         也可以通过 NSOperationQueue 的 cancelAllOperations() 方法取消所有的任务：
         1
         operationQueue.cancelAllOperations() //取消所有线程操作
         */

        // http://www.hangge.com/blog/cache/detail_1032.html
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


// snapkit自动布局

class SwiftTableViewTest4: UIViewController {
    
    var box:UIView?
    var labelUserName : UILabel?
    var labelPassword : UILabel?
    
    var textFieldUserName : UITextField?
    var textFieldPassword : UITextField?
    
    var loginButton : UIButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.setupUI()
    }
    
    func setupUI() {
        self.box = UIView()
//        self.box!.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(self.box!)
        
        self.labelUserName = UILabel.init()
        self.labelUserName?.text = "用户名"
        self.labelUserName?.backgroundColor = UIColor.grayColor()
        self.labelUserName?.textColor = UIColor.blueColor()
        self.box?.addSubview(self.labelUserName!)
        
        self.textFieldUserName = UITextField()
        self.textFieldUserName?.borderStyle = .RoundedRect
//        self.textFieldUserName?.backgroundColor = UIColor.grayColor()
        self.box?.addSubview(self.textFieldUserName!)
        
        self.labelPassword = UILabel.init()
        self.labelPassword?.text = "密码"
        self.labelPassword?.backgroundColor = UIColor.grayColor()
        self.labelPassword?.textColor = UIColor.blueColor()
        self.box?.addSubview(self.labelPassword!)
        
        self.textFieldPassword = UITextField()
        self.textFieldPassword?.borderStyle = .RoundedRect
        //        self.textFieldUserName?.backgroundColor = UIColor.grayColor()
        self.box?.addSubview(self.textFieldPassword!)
        
        
        loginButton = UIButton.init()
//        loginButton?.frame = CGRectMake(0, 64, 100, 40)
        loginButton?.backgroundColor = UIColor.lightGrayColor()
        loginButton?.setTitle("登录", forState: UIControlState.Normal)
        loginButton?.setTitle("登录", forState: UIControlState.Highlighted)
        loginButton?.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        loginButton?.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Highlighted)
        //        button1?.addTarget(self, action:#selector(buttonClicked) , forControlEvents:.TouchUpInside)
//        loginButton?.addTarget(self, action: #selector(buttonClicked(_:)), forControlEvents:.TouchUpInside)
        loginButton?.addTarget(self, action: #selector(SwiftTableViewTest4.buttonClicked(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(loginButton!)

    }
    
    // 自动布局
    override func updateViewConstraints() {
        super.updateViewConstraints()
//        print("updateViewConstraints")
        
        self.box?.snp_updateConstraints(closure: { (make) in
            make.center.equalTo(self.view)
        })
        
        self.labelUserName?.snp_updateConstraints(closure: { (make) in
            make.top.equalTo(self.box!)
            make.left.equalTo(self.box!)
            make.height.equalTo(40)
            make.width.equalTo(60)
        })
        
        self.labelPassword?.snp_updateConstraints(closure: { (make) in
            make.top.equalTo((self.labelUserName?.snp_bottom)!).offset(15)
            make.left.equalTo(self.box!)
            make.height.equalTo(40)
            make.width.equalTo(60)
            make.bottom.equalTo(self.box!)
        })
        
        self.textFieldUserName?.snp_updateConstraints(closure: { (make) in
            make.top.equalTo(self.box!)
            make.left.equalTo((self.labelUserName?.snp_right)!).offset(15)
            make.right.equalTo(self.box!)
            make.width.equalTo(160)
            make.bottom.equalTo(self.labelUserName!)
        })
        
        self.textFieldPassword?.snp_updateConstraints(closure: { (make) in
            make.top.equalTo((self.labelPassword?.snp_top)!)
            make.left.equalTo((self.labelUserName?.snp_right)!).offset(15)
            make.right.equalTo(self.box!)
            make.width.equalTo(160)
            make.bottom.equalTo(self.box!)
        })
        
        self.loginButton?.snp_updateConstraints(closure: { (make) in
            make.top.equalTo((self.box?.snp_bottom)!).offset(15)
            make.left.equalTo(self.box!)
            make.right.equalTo(self.box!)
            make.height.equalTo(50)
        })
    }
    
    
    // 事件
    func buttonClicked(button : UIButton) {
        
    }
    
}
