//
//  SystemFunctionViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "SystemFunctionViewController.h"

#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "AddressBookViewController.h"
#import <MessageUI/MessageUI.h>
#import "CoreBluetooth/CoreBluetooth.h"


// http://www.lvtao.net/ios/506.html
// http://www.2cto.com/kf/201504/395296.html

@interface SystemFunctionViewController () <UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate,CBCentralManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) NSMutableArray *listViewControllers;
@property (nonatomic, strong) CBCentralManager  *cbCentralMgr;
@property (nonatomic, strong) NSMutableArray *peripheralArray;

@end

@implementation SystemFunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupData];
    [self setupUI];
    [self.view setNeedsUpdateConstraints];
}

#pragma mark - masonry

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - private method

- (void)setupUI
{
    _tableView = ({
        UITableView *tableview = [[UITableView alloc] init];
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        tableview;
    });
    [self.view addSubview:_tableView];
}

- (void)setupData
{
    _listData = [[NSMutableArray alloc] init];
    _listViewControllers = [[NSMutableArray alloc] init];
    
    // 0.通讯录
    [_listData addObject:@"通讯录"];
    AddressBookViewController *addressController = [[AddressBookViewController alloc] init];
    [_listViewControllers addObject:addressController];
    // 1.打电话
    [_listData addObject:@"打电话"];
    // 2.发短信
    [_listData addObject:@"发短信"];
    // 3.发邮件
    [_listData addObject:@"发邮件"];
    // 4.蓝牙
    [_listData addObject:@"蓝牙"];
    // 5.打开另一个APP
    [_listData addObject:@"打开另一个APP"];
    
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.listData.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self runWithNumber:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdetify = @"tableViewCellIdetify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.showsReorderControl = YES;
    }
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [self.listData objectAtIndex:indexPath.row];
    //    cell.detailTextLabel.text = [self.listData objectForKey:[self.listData allKeys][indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


#pragma mark - private method

- (void)runWithNumber:(NSInteger)num
{
    if (num == 0) {
        UIViewController *vc = [self.listViewControllers objectAtIndex:num];
        vc.title = [self.listData objectAtIndex:num];
        [self.navigationController pushViewController:vc animated:YES];
    } else  {
        switch (num) {
            case 1:
                [self callphone];
                break;
            case 2:
                [self sendMessage];
                break;
            case 3:
                [self sendEmail];
                break;
            case 4:
                [self blueTooth];
                break;
            case 5:
                [self openAnotherApp];
                break;
                
            default:
                break;
        }
    }
}

// 打电话
- (void)callphone
{
    /*
    // 1，这种方法，拨打完*****回不到原来的应用，会停留在通讯录里，而且是直接拨打，不弹出提示,,,,自己测试还能回到原来的程序
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"1008611"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
     */
    
    // 2，这种方法，打完*****后还会回到原来的程序，也会弹出提示，推荐这种
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"1008611"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
    /*
    // 3,这种方法也会回去到原来的程序里（注意这里的telprompt），也会弹出提示
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"1008611"];
    //            NSLog(@"str======%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
     */
}

// 发短信
- (void)sendMessage
{
 /*
  1.1.发短信(1)——URL
  // 直接拨号，拨号完成后会停留在通话记录中
  1、方法：
  NSURL *url = [NSURL URLWithString:@"sms://10010"];
  [[UIApplication sharedApplication] openURL:url];
  2、优点：
  –简单
  3、缺点：
  –不能指定短信内容，而且不能自动回到原应用
  1.2发短信(2)——MessageUI框架
  如果自定义短信，需要使用一个框架MessageUI。
  优点
  1. 从应用出去能回来
  2. 可以多人
  3. 可以自定义消息，消息支持HTML格式的
  而且如果在苹果系统中，如果彼此的手机都是iOS设备，并且开通了iMessage功能，彼此之间的短信是走网络通道，而不走运营商的通道！
  - (void)msg2
  {
  // 判断用户设备能否发送短信
  if (![MFMessageComposeViewController canSendText]) {
  return;
  }
  
  // 1. 实例化一个控制器
  MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
  
  // 2. 设置短信内容
  // 1) 收件人
  controller.recipients = @[@"10010", @"10086"];
  
  // 2) 短信内容
  controller.body = @"给您拜个晚年，祝您晚年快乐！";
  
  // 3) 设置代理
  controller.messageComposeDelegate = self;
  
  // 3. 显示短信控制器
  [self presentViewController:controller animated:YES completion:nil];
  }
  记得发完短信记得调用代理方法关闭窗口
  #pragma mark 短信控制器代理方法
  
  短信发送结果
  
  MessageComposeResultCancelled,     取消
  MessageComposeResultSent,          发送
  MessageComposeResultFailed         失败
  
    - (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
    {
        NSLog(@"%d", result);
        
        // 在面向对象程序开发中，有一个原则，谁申请，谁释放！
        // *** 此方法也可以正常工作，因为系统会将关闭消息发送给self
        //    [controller dismissViewControllerAnimated:YES completion:nil];
        
        // 应该用这个！！！
        [self dismissViewControllerAnimated:YES completion:nil];
    }
  */
    
    
//    NSURL *url = [NSURL URLWithString:@"sms://10086"];
//    [[UIApplication sharedApplication] openURL:url];
    
    
    
    
    // 判断用户设备能否发送短信
    if (![MFMessageComposeViewController canSendText]) {
        return;
    }
    
    // 1. 实例化一个控制器
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    
    // 2. 设置短信内容
    // 1) 收件人
//    controller.recipients = @[@"10010", @"10086"];
        controller.recipients = @[@"15101086350"];
    
    // 2) 短信内容
    controller.body = @"hello";
    
    // 3) 设置代理
    controller.messageComposeDelegate = self;
    
    // 3. 显示短信控制器
    [self presentViewController:controller animated:YES completion:nil];
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    NSLog(@"%d", result);
    
    // 在面向对象程序开发中，有一个原则，谁申请，谁释放！
    // *** 此方法也可以正常工作，因为系统会将关闭消息发送给self
        [controller dismissViewControllerAnimated:YES completion:nil];
    
    // 应该用这个！！！
  //  [self dismissViewControllerAnimated:YES completion:nil];
}

// 发邮件
- (void)sendEmail
{
    [self sendmail];
}

- (void)sendmail
{
    // 1. 先判断能否发送邮件
    if (![MFMailComposeViewController canSendMail]) {
        // 提示用户设置邮箱
        return;
    }
    
    // 2. 实例化邮件控制器，准备发送邮件
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    
    // 1) 主题 xxx的工作报告
    [controller setSubject:@"我的工作报告"];
    // 2) 收件人
    [controller setToRecipients:@[@"542944896@qq.com"]];
    
    // 3) cc 抄送
    // 4) bcc 密送(偷偷地告诉，打个小报告)
    // 5) 正文
    [controller setMessageBody:@"这是我的<font color=\"blue\">工作报告</font>，请审阅！<BR />P.S. 我的头像牛X吗？" isHTML:YES];
    
    // 6) 附件
    UIImage *image = [UIImage imageNamed:@"头像1.png"];
    NSData *imageData = UIImagePNGRepresentation(image);
    // 1> 附件的二进制数据
    // 2> MIMEType 使用什么应用程序打开附件
    // 3> 收件人接收时看到的文件名称
    // 可以添加多个附件
    [controller addAttachmentData:imageData mimeType:@"image/png" fileName:@"头像.png"];
    
    // 7) 设置代理
    [controller setMailComposeDelegate:self];
    
    // 显示控制器
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - 邮件代理方法
/**
 MFMailComposeResultCancelled,      取消
 MFMailComposeResultSaved,          保存邮件
 MFMailComposeResultSent,           已经发送
 MFMailComposeResultFailed          发送失败
 */
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    // 根据不同状态提示用户
    NSLog(@"%d", result);

       [controller dismissViewControllerAnimated:YES completion:nil];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - blueTooth

// http://blog.sina.com.cn/s/blog_8d1bc23f0102vos2.html
// http://www.2cto.com/kf/201403/283412.html

- (void)blueTooth
{
    self.cbCentralMgr = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
//    创建数组管理外设
    
    self.peripheralArray = [NSMutableArray array];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:false],CBCentralManagerScanOptionAllowDuplicatesKey, nil];
    
    [self.cbCentralMgr scanForPeripheralsWithServices:nil options:dic];
}

#pragma mark - delegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI

{
    [self.cbCentralMgr connectPeripheral:peripheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
}



//一个中心设备可以同时连接多个周围的蓝牙设备
//
//当连接上某个蓝牙之后，CBCentralManager会通知代理处理


- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral

{
    
}

#pragma mark - openAnotherApp

//http://blog.sina.com.cn/s/blog_877e9c3c0102v0m5.html

- (void)openAnotherApp
{
    // 配置URL sechemes：是为了让别人能够打开我
    // URL secheme:注册，ceshiidentifier，、、 url secheme：ceshischeme
    // 其他app中调用：[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"ceshischeme://123"]];
    // 本app 中 ：- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options 会回调
    
    /*
     三：Scheme白名单
     
     从iOS9.0后，涉及到平台客户端的跳转，系统会自动到info.plist下检查是否设置Scheme。如果没有做相应的配置，就无法跳转到相应的客户端。因此如果客户端集成有分享与授权，需要配置Scheme白名单。
     
     解决方案：
     
     （1）、在info.plist增加key：LSApplicationQueriesSchemes，类型为NSArray。
     
     （2）、添加需要支持的白名单，类型为String。
     
     
     
     新浪微博白名单：sinaweibo、sinaweibohd、sinaweibosso、sinaweibohdsso、weibosdk、weibosdk2.5。
     
     微信白名单：wechat、weixin。
     
     支付宝白名单：alipay、alipayshare。
     
     QQ与QQ空间白名单：mqzoneopensdk、mqzoneopensdkapi、mqzoneopensdkapi19、mqzoneopensdkapiV2、mqqOpensdkSSoLogin、mqqopensdkapiV2、mqqopensdkapiV3、wtloginmqq2、mqqapi、mqqwpa、mqzone、mqq。
     
     另外，如果应用使用了检测是否安装了某款app，我们会调用canOpenURL， 如果url不在白名单中，即使手机上有这款app，也会返回NO。
     
     补充：在使用sharesdk进行分享的时候，如果你设置有微信、QQ、QQ空间分享，并且你也把相应的白名单给添加进去了，但是如果你手机上没有装QQ的时候，也是不会出现分享到QQ的选
     */
    // http://my.oschina.net/daguoshi/blog/508547
    // iOS9  常见问题：http://www.bubuko.com/infodetail-1110714.html
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"weixin://123"]];
    
//    配置URL sechemes：是为了让别人能够打开我
}


@end
