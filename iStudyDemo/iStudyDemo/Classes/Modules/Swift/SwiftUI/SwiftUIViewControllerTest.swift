//
//  SwiftUIViewController.swift
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/23.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

import Foundation
import UIKit

// http://www.hangge.com/blog/cache/detail_528.html

class SwiftUIViewControllerTest: UIViewController,UITextFieldDelegate,UIActionSheetDelegate {
    
    // 属性
    var button1 : UIButton?
    
    // 方法
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.setupUI()
    }
    
    //
    func setupUI() {
        var startY : CGFloat = 64;
        
        
        button1 = UIButton.init()
        button1?.frame = CGRectMake(0, 64, 100, 40)
        button1?.setTitle("我是按钮", forState: UIControlState.Normal)
        button1?.setTitle("我是按钮", forState: UIControlState.Highlighted)
        button1?.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        button1?.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Highlighted)
//        button1?.addTarget(self, action:#selector(buttonClicked) , forControlEvents:.TouchUpInside)
        button1?.addTarget(self, action: #selector(buttonClicked(_:)), forControlEvents:.TouchUpInside)
        self.view.addSubview(button1!)
        /*
         //不传递触摸对象（即点击的按钮）
         button.addTarget(self,action:#selector(tapped),forControlEvents:.TouchUpInside)
         func tapped(){
         print("tapped")
         }
         
         //传递触摸对象（即点击的按钮），需要在定义action参数时，方法名称后面带上冒号
         button.addTarget(self,action:#selector(tapped(_:)),forControlEvents:.TouchUpInside)
         func tapped(button:UIButton){
         print(button.titleForState(.Normal))
         }
         */
        
        
        // 文本标签
        // http://www.hangge.com/blog/cache/detail_528.html
        let label=UILabel(frame:CGRectMake(100, 64, 200, 40))
        label.text="hangge.com"
        label.textColor=UIColor.whiteColor() //白色文字
        label.backgroundColor=UIColor.blackColor() //黑色背景
        label.textAlignment=NSTextAlignment.Right //文字右对齐
//        label.shadowColor=UIColor.grayColor()  //灰色阴影
//        label.shadowOffset=CGSizeMake(-5,5)  //阴影的偏移量
        label.font = UIFont(name:"Zapfino", size:20)
//        label.lineBreakMode=NSLineBreakMode.ByTruncatingTail  //隐藏尾部并显示省略号
//        label.lineBreakMode=NSLineBreakMode.ByTruncatingMiddle  //隐藏中间部分并显示省略号
//        label.lineBreakMode=NSLineBreakMode.ByTruncatingHead  //隐藏头部并显示省略号
//        label.lineBreakMode=NSLineBreakMode.ByClipping  //截去多余部分也不显示省略号
        self.view.addSubview(label)
        
        startY = 105;
        
        // UITextField
        let textField = UITextField(frame: CGRectMake(0,startY,100,40))
        textField.clearButtonMode=UITextFieldViewMode.WhileEditing  //编辑时出现清除按钮
//        textField.clearButtonMode=UITextFieldViewMode.UnlessEditing  //编辑时不出现，编辑后才出现清除按钮
//        textField.clearButtonMode=UITextFieldViewMode.Always  //一直显示清除按钮
        //设置边框样式为圆角矩形
        textField.borderStyle = UITextBorderStyle.RoundedRect
        textField.placeholder="请输入用户名"
        textField.adjustsFontSizeToFitWidth=true  //当文字超出文本框宽度时，自动调整文字大小
        textField.minimumFontSize=14  //最小可缩小的字号
        textField.delegate = self
        self.view.addSubview(textField)
        
        
        let textview=UITextView(frame:CGRectMake(100,startY,200,50))
        textview.layer.borderWidth=1  //边框粗细
        textview.layer.borderColor=UIColor.grayColor().CGColor //边框颜色
        self.view.addSubview(textview)
//        let mail = UIMenuItem(title: "邮件", action: "onMail")
//        let weixin = UIMenuItem(title: "微信", action: "onWeiXin")
//        let menu = UIMenuController()
//        menu.menuItems = [mail,weixin]
        
        
        startY = 150
        
        let uiswitch = UISwitch()
        //设置位置（开关大小无法设置）
        uiswitch.frame =  CGRectMake(0, startY, 40, 40)
        //设置默认
        uiswitch.on=true;
        uiswitch.addTarget(self, action: #selector(SwiftUIViewControllerTest.switchDidChange),
                           forControlEvents:UIControlEvents.ValueChanged)
        self.view.addSubview(uiswitch);
        
        
        //
        let items=["选项一","选项二"] as [AnyObject]
        let segmented=UISegmentedControl(items:items)
        segmented.frame=CGRectMake(60, startY, 160, 40)
        segmented.selectedSegmentIndex=1 //默认选中第二项
        segmented.addTarget(self, action: #selector(SwiftUIViewControllerTest.segmentDidchange(_:)),
                            forControlEvents: UIControlEvents.ValueChanged)  //添加值改变监听
        self.view.addSubview(segmented)
        
        
        
        let imageView=UIImageView(image:UIImage(named:"test"))
        imageView.frame=CGRectMake(220 ,startY,50,50)
        imageView.contentMode = .ScaleAspectFit
        self.view.addSubview(imageView)
        
        //定义NSURL对象
        let url = NSURL(string: "http://hangge.com/blog/images/logo.png")
        //从网络获取数据流
        let data = NSData(contentsOfURL: url!)
        //通过数据流初始化图片
        let newImage = UIImage(data: data!)
        let imageView2 = UIImageView(image:newImage);
        imageView2.frame = CGRectMake(270, startY, 50, 50)
        imageView2.contentMode = .ScaleAspectFit
        self.view.addSubview(imageView2)
        
        startY = 200
        
        let progressView=UIProgressView(progressViewStyle:UIProgressViewStyle.Default)
        progressView.frame = CGRectMake(10, startY, 300, 10);
        progressView.progress=0.5 //默认进度50%
        progressView.progressTintColor=UIColor.greenColor()//已有进度颜色
//        progressView.trackTintColor=UIColor.blueColor()//剩余进度颜色（即进度槽颜色）
        self.view.addSubview(progressView);
        
        startY = 210
        
        let slider=UISlider(frame:CGRectMake(0,startY,300,10))
        slider.minimumValue=0  //最小值
        slider.maximumValue=1  //最大值
        slider.value=0.5  //当前默认值
        slider.continuous=false  //滑块滑动停止后才触发ValueChanged事件
        slider.minimumTrackTintColor=UIColor.redColor()  //左边槽的颜色
        slider.maximumTrackTintColor=UIColor.greenColor() //右边槽的颜色
        slider.addTarget(self,action:#selector(SwiftUIViewControllerTest.sliderDidchange(_:)), forControlEvents:UIControlEvents.ValueChanged)
        self.view.addSubview(slider)
        
        
       //  http://www.hangge.com/blog/cache/detail_546.html 手势
        
        
    }
    
    /*
     func buttonClicked() {
     let alertView = UIAlertView.init(title: "title", message: "按钮点击", delegate: nil, cancelButtonTitle: "取消", otherButtonTitles: "确定")
     alertView.show()
     
     }
     */
    func buttonClicked(button:UIButton) {
        let alertView = UIAlertView.init(title: "title", message: "按钮点击", delegate: nil, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alertView.show()
        
        let actionSheet=UIActionSheet()
        //actionSheet.title = "请选择操作"
        actionSheet.addButtonWithTitle("取消")
        actionSheet.addButtonWithTitle("动作1")
        actionSheet.addButtonWithTitle("动作2")
        actionSheet.cancelButtonIndex=0
        actionSheet.delegate=self
        actionSheet.showInView(self.view);
        
    }
    
    func textFieldShouldReturn(textField:UITextField) -> Bool
    {
        //收起键盘
        textField.resignFirstResponder()
        //打印出文本框中的值
        print(textField.text)
        return true;
    }
    
    func switchDidChange() {
        let alertView = UIAlertView.init(title: "title", message: "switch点击", delegate: nil, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alertView.show()
    }
    
    func segmentDidchange(segmented:UISegmentedControl){
        //获得选项的索引
        print(segmented.selectedSegmentIndex)
        //获得选择的文字
        print(segmented.titleForSegmentAtIndex(segmented.selectedSegmentIndex))
    }
    
    func sliderDidchange(slider:UISlider){
        print(slider.value)
    }
    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        print("点击了："+actionSheet.buttonTitleAtIndex(buttonIndex)!)
    }
}

class SwiftTableViewTest: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ctrlnames:[String]?
    var tableView:UITableView?
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初始化数据，这一次数据，我们放在属性列表文件里
        self.ctrlnames =  NSArray(contentsOfFile:
            NSBundle.mainBundle().pathForResource("test_", ofType:"plist")!) as? Array
        
        print(self.ctrlnames)
        
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
        headerLabel.text = "常见 UIKit 控件"
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
        
        let itemString = self.ctrlnames![indexPath.row]
        
        let alertController = UIAlertController(title: "提示!",
                                                message: "你选中了【\(itemString)】", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "确定", style: .Default,handler: nil)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //滑动删除必须实现的方法
    func tableView(tableView: UITableView,
                   commitEditingStyle editingStyle: UITableViewCellEditingStyle,
                                      forRowAtIndexPath indexPath: NSIndexPath) {
        print("删除\(indexPath.row)")
        let index = indexPath.row
        self.ctrlnames?.removeAtIndex(index)
        self.tableView?.deleteRowsAtIndexPaths([indexPath],
                                               withRowAnimation: UITableViewRowAnimation.Top)
    }
    
    //滑动删除
    func tableView(tableView: UITableView,
                   editingStyleForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCellEditingStyle {
            return UITableViewCellEditingStyle.Delete
    }
    
    //修改删除按钮的文字
    func tableView(tableView: UITableView,
                   titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath)
        -> String? {
            return "删"
    }
    
}


class SwiftTableGroupedViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    var tableView:UITableView?
    
    var allnames:Dictionary<Int, [String]>?
    
    var adHeaders:[String]?
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初始化数据，这一次数据，我们放在属性列表文件里
        self.allnames =  [
            0:[String]([
                "UILabel 标签",
                "UITextField 文本框",
                "UIButton 按钮"]),
            1:[String]([
                "UIDatePiker 日期选择器",
                "UIToolbar 工具条",
                "UITableView 表格视图"])
        ];
        
        print(self.allnames)
        
        self.adHeaders = [
            "常见 UIKit 控件",
            "高级 UIKit 控件"
        ]
        
        //创建表视图
        self.tableView = UITableView(frame:self.view.frame, style:UITableViewStyle.Grouped)
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
        headerLabel.text = "高级 UIKit 控件"
        headerLabel.font = UIFont.italicSystemFontOfSize(20)
        self.tableView!.tableHeaderView = headerLabel
    }
    
    //在本例中，有2个分区
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2;
    }
    
    //返回表格行数（也就是返回控件数）
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = self.allnames?[section]
        return data!.count
    }
    
    
    // UITableViewDataSource协议中的方法，该方法的返回值决定指定分区的头部
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int)
        -> String? {
            var headers =  self.adHeaders!;
            return headers[section];
    }
    
    // UITableViewDataSource协议中的方法，该方法的返回值决定指定分区的尾部
    func tableView(tableView:UITableView, titleForFooterInSection
        section:Int)->String?
    {
        let data = self.allnames?[section]
        return "有\(data!.count)个控件"
    }
    
    //创建各单元显示内容(创建参数indexPath指定的单元）
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell
    {
        //为了提供表格显示性能，已创建完成的单元需重复使用
        let identify:String = "SwiftCell"
        //同一形式的单元格重复使用，在声明时已注册
        let cell = tableView.dequeueReusableCellWithIdentifier(
            identify, forIndexPath: indexPath) as UITableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        let secno = indexPath.section
        var data = self.allnames?[secno]
        cell.textLabel?.text = data![indexPath.row]
        
        return cell
    }
    
    // UITableViewDelegate 方法，处理列表项的选中事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.tableView!.deselectRowAtIndexPath(indexPath, animated: true)
        
        let itemString = self.allnames![indexPath.section]![indexPath.row]
        
        let alertController = UIAlertController(title: "提示!",
                                                message: "你选中了【\(itemString)】",
                                                preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

