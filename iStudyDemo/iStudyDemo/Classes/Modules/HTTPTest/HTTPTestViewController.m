//
//  HTTPTestViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/7.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "HTTPTestViewController.h"
#import <AFNetworking.h>
#import "TestDomainObject.h"
#import "JSONKit.h"
#import "ObjectStorageManager.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JsonModelDomainObject.h"
#import "LEDNSURLSessionViewController.h"



@interface HTTPTestViewController ()<UITableViewDataSource, UITableViewDelegate, ASIHTTPRequestDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) AFHTTPRequestOperationManager *mgr;

@end

@implementation HTTPTestViewController

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
    
    [_listData addObject:@"NSURLRequest GET"];
    [_listData addObject:@"NSURLRequest POST"];
    
    [_listData addObject:@"ASI GET"];
    [_listData addObject:@"ASI POST"];
    
    [_listData addObject:@"AFNetworking GET"];
    [_listData addObject:@"AFNetworking POST"];
    
    [_listData addObject:@"Net Status"];
    
    [_listData addObject:@"Mantle 数据校验解析"];
    [_listData addObject:@"JSONModel 数据校验解析"];
    
    [_listData addObject:@"NSURLSession"];
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
    switch (indexPath.row) {
        case 0:
            [self urlrequestGET];
            break;
        case 1:
            [self urlrequestPOST];
            break;
            
        case 2:
            [self asiGET];
            break;
        case 3:
            [self asiPOST];
            break;
        case 4:
            [self afnetworkingGET];
            break;
        case 5:
            [self afnetworkingPOST];
            break;
        case 6:
            [self netstatus];
            break;
        case 7:
            [self mantleTest];
            break;
        case 8:
            [self jsonModelTest];
            break;
        case 9:
            [self urlsessionTest];
            break;
        default:
            break;
    }
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
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - private method

#pragma mark - NSURLRequest
// http://www.cnblogs.com/wendingding/p/3813706.html
- (void)urlrequestGET
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setHTTPMethod:@"GET"]; // 设置请求方式
    [request setURL:[NSURL URLWithString:@"http://www.weather.com.cn/data/sk/101010100.html"]]; // 设置网络请求的URL
    [request setTimeoutInterval:10]; // 设置超出时间 10s
    // 发送异步请求
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         // 返回结果
         if (connectionError) {
         }
         NSError *error = nil;
         id jsonData = nil;
         if (data) {
             jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
         } else {
             error = [NSError errorWithDomain:@"data is nil" code:-1 userInfo:nil];
         }
         
         if (connectionError || error) {
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:[NSString stringWithFormat:@"data length:%ld",[data length]] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"错误", nil];
             [alertView show];
             
         }  else {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 //
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:[NSString stringWithFormat:@"data length:%ld",[data length]] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                 [alertView show];
                 
             });
         }
     }];

}

/*
 建议：提交用户的隐私数据一定要使用POST请求
 
 相对POST请求而言，GET请求的所有参数都直接暴露在URL中，请求的URL一般会记录在服务器的访问日志中，而服务器的访问日志是黑客攻击的重点对象之一
 
 用户的隐私数据如登录密码，银行账号等。
 */

- (void)urlrequestPOST
{
    // 1.设置请求路径
    // http://api.ishowchina.com/
    // http://api.ishowchina.com/v3/search/busline/byid?city=010&busIds=1100006301,1100006701&ak=ec85d3648154874552835438ac6a02b2 post
    NSURL *URL=[NSURL URLWithString:@"http://api.ishowchina.com/v3/search/busline/byid?city=010&busIds=1100006301,1100006701&ak=ec85d3648154874552835438ac6a02b2"];//不需要传递参数
//    2.创建请求对象
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];//默认为get请求
    request.timeoutInterval=5.0;//设置请求超时为5秒
    request.HTTPMethod=@"POST";//设置请求方法
     //设置请求体
    NSString *param=[NSString stringWithFormat:@"username=%@&pwd=%@",@"name",@"pass"];
    //把拼接后的字符串转换为data，设置请求体
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    [request setTimeoutInterval:10]; // 设置超出时间 10s
    
//    3.发送请求
    
    // 发送异步请求
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         // 返回结果
         if (connectionError) {
         }
         NSError *error = nil;
         id jsonData = nil;
         if (data) {
             jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
         } else {
             error = [NSError errorWithDomain:@"data is nil" code:-1 userInfo:nil];
         }
         
         if (connectionError || error) {
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:@"错误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
             [alertView show];
             
         }  else {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 //
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:[NSString stringWithFormat:@"data length:%ld",[data length]] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                 [alertView show];
                 
             });
         }
     }];

}

#pragma mark - ASIHttpRequest

- (void)asiGET
{
    // 同步
    /*
    NSURL *url = [NSURL URLWithString:@"http://www.weather.com.cn/data/sk/101010100.html"];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request startSynchronous];
    
    NSError *error = [request error];
    
    if (!error) {
        
        NSString *response = [request responseString];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:response delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
     */
    // 异步
    
    /*
     {
     
     NSURL *url = [NSURL URLWithString:@"http://allseeing-i.com"];
     
     ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
     
     [request setDelegate:self];
     
     [request startAsynchronous];
     
     }
     
     - (void)requestFinished:(ASIHTTPRequest *)request
     
     {
     
     // 当以文本形式读取返回内容时用这个方法
     
     NSString *responseString = [request responseString];
     
     // 当以二进制形式读取返回内容时用这个方法
     
     NSData *responseData = [request responseData];
     
     }
     
     - (void)requestFailed:(ASIHTTPRequest *)request
     
     {
     
     NSError *error = [request error];
     
     }
     */
    
    NSURL *url = [NSURL URLWithString:@"http://www.weather.com.cn/data/sk/101010100.html"];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setDelegate:self];
    
    [request startAsynchronous];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request

{
    
    // 当以文本形式读取返回内容时用这个方法
    
    NSString *responseString = [request responseString];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:responseString delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
    
    // 当以二进制形式读取返回内容时用这个方法
    
//    NSData *responseData = [request responseData];
    
}

- (void)requestFailed:(ASIHTTPRequest *)request

{
    
    NSError *error = [request error];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
    
}

/*
 
 ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
 [request setPostValue:@"Ben" forKey:@"first_name"];
 [request setPostValue:@"Copsey" forKey:@"last_name"];
 [request setFile:@"/Users/ben/Desktop/ben.jpg" forKey:@"photo"];
 [request addData:imageData withFileName:@"george.jpg" andContentType:@"image/jpeg"forKey:@"photos"];
 
 
 ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
 [request appendPostData:[@"This is my data" dataUsingEncoding:NSUTF8StringEncoding]];
 // Default becomes POST when you use appendPostData: / appendPostDataFromFile: / setPostBody:
 [request setRequestMethod:@"PUT"];
 */

// http://www.cnblogs.com/pengyingh/articles/2343062.html

- (void)asiPOST
{
    NSString *urlString = [NSString stringWithFormat:@"http://api.ishowchina.com/v3/search/busline/byid?city=010&busIds=1100006301,1100006701&ak=ec85d3648154874552835438ac6a02b2"];
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    //设置需要POST的数据，这里提交两个数据，A=a&B=b
    [requestForm setPostValue:@"a" forKey:@"A"];
    [requestForm setPostValue:@"b" forKey:@"B"];
    [requestForm setDelegate:self];
    [requestForm startAsynchronous];
}

#pragma mark - AFNetworking

- (void)afnetworkingGET
{
    // 1.获得请求管理者
    _mgr = [AFHTTPRequestOperationManager manager];
    _mgr.requestSerializer = [AFHTTPRequestSerializer serializer];// 请求
    _mgr.responseSerializer = [AFHTTPResponseSerializer serializer];// 响应
    
    // 2.封装请求参数
    //    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //    params[@"userId"] = [appDefault objectForKey:@"userId"];
    //    params[@"IMSI"] = _IMSI.text;
    //    params[@"nickName"] = _nickName.text;
    //    params[@"phoneNumber"] = _phoneNumber.text;
    
    NSString *url = [NSString stringWithFormat:@"http://www.weather.com.cn/data/sk/101010100.html"];// http://www.baidu.com/
    
    // NSString *url = [NSString stringWithFormat:@"http://www.baidu.com/"];// http://www.baidu.com/
    
    // 3.发送GET请求
    [_mgr GET:url parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"%@",responseObject);
          UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:[responseObject description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
          [alertView show];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"%@",error);
          UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
          [alertView show];
      }];

}

- (void)afnetworkingPOST
{
//    [self testLDAuth];
    
    //1.管理器
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //2.设置登录参数
    NSDictionary *dict = @{ @"username":@"xn", @"password":@"123" };
    
    //3.请求
    [manager POST:@"http://api.ishowchina.com/v3/search/busline/byid?city=010&busIds=1100006301,1100006701&ak=ec85d3648154874552835438ac6a02b2" parameters:dict success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:[responseObject description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
//        NSLog(@"POST --> %@, %@", responseObject, [NSThread currentThread]); //自动返回主线程
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
//        NSLog(@"%@", error);
    }];
}

#pragma mark - netstatus

- (void)netstatus
{
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // WiFi
     */
    __block NSString *str = nil;
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                str = @"未知";
                break;
            case AFNetworkReachabilityStatusNotReachable:
                str = @"无连接";
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                str = @"WWAN 2G/3G/4G";
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                str = @"Wifi";
                break;
                
            default:
                break;
        }
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:str delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
}


#pragma mark - mantle
- (void)mantleTest
{
    [self testjson];
}

#pragma mark - JSONModel
// http://m.blog.csdn.net/article/details?id=40432287

- (void)jsonModelTest
{
    NSDictionary *dic = @{@"bankname":@"中国银行",
                          @"icon":@"http://www.baidu.com",
                          @"amount":@234.56,
                          @"arr":@[
                                  @{@"name":@"zyk",
                                    @"age":@27},
                                  @{@"name":@"cyy",
                                    @"age":@25},
                                  @{@"name":@"zx",
                                    @"age":@24}
                                  ]};
    
    
    NSError *error = nil;
    JsonModelDomainObject *model = [[JsonModelDomainObject alloc] initWithDictionary:dic error:&error];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:[model description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

















//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
    /*
    // 1.获得请求管理者
    _mgr = [AFHTTPRequestOperationManager manager];
    _mgr.requestSerializer = [AFHTTPRequestSerializer serializer];// 请求
    _mgr.responseSerializer = [AFHTTPResponseSerializer serializer];// 响应
    
    // 2.封装请求参数
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"userId"] = [appDefault objectForKey:@"userId"];
//    params[@"IMSI"] = _IMSI.text;
//    params[@"nickName"] = _nickName.text;
//    params[@"phoneNumber"] = _phoneNumber.text;
    
    NSString *url = [NSString stringWithFormat:@"http://mps.amap.com/amapsrv/MPS?t=VMMV4&type=13&cp=1&mesh=132100103321;132100103303;132100103330;132100103323;132100103320;132100103302;132100103312;132100103332;132100103322;132100121101;132100121110;132100121100"];// http://www.baidu.com/
    
    // NSString *url = [NSString stringWithFormat:@"http://www.baidu.com/"];// http://www.baidu.com/
    
    // 3.发送GET请求
    [_mgr GET:url parameters:nil
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSLog(@"%@",responseObject);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@",error);
     }];
     */
    
    
    //[self netWorkStatus];
//    [self testjson];
//    [self testToDic];
//    [self testLDAuth];
    
//}

// 鉴权
- (void)testLDAuth
{
    
    NSString *bundleID = @"com.kdtm.iStudyDemo";
//    NSString *buid2 = [NSBundle mainBundle].bundleIdentifier;
//    NSUInteger ts = [[[NSDate alloc] init] timeIntervalSince1970];
    NSUInteger ts = 1457930192410;
    NSString *keyTemp = @"f6d92d3a67f7eecd0462f0df04526bf9";
    NSString *tsStr = [NSString stringWithFormat:@"%ld", ts];
    tsStr = [NSString stringWithFormat:@"%@1%@",[tsStr substringToIndex:[tsStr length] - 2], [tsStr substringFromIndex:[tsStr length] - 1]];
    
    NSString *temp = [NSString stringWithFormat:@"%@:%@",[bundleID sha1],tsStr];
    NSString *md5STr = [temp stringByComputingMD5];
    
//    md5([bundleID sha1]:ts)
    
    
    
    // 1.获得请求管理者
    _mgr = [AFHTTPRequestOperationManager manager];
//    _mgr.requestSerializer = [AFHTTPRequestSerializer serializer];// 请求
//    _mgr.responseSerializer = [AFHTTPResponseSerializer serializer];// 响应
    
   
_mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSString *url = [NSString stringWithFormat:@"http://apiinit.amap.com/v3/log/init"];// http://www.baidu.com/
    
    // NSString *url = [NSString stringWithFormat:@"http://www.baidu.com/"];// http://www.baidu.com/
    
    
    _mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    _mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    [_mgr.requestSerializer setValue:@"*/*" forHTTPHeaderField:@"Accept"];
    [_mgr.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [_mgr.requestSerializer setValue:@"zh-cn" forHTTPHeaderField:@"Accept-Language"];
    [_mgr.requestSerializer setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
    [_mgr.requestSerializer setValue:@"AMAP_SDK_iOS_3DMap_3.3.1" forHTTPHeaderField:@"User-Agent"];
    [_mgr.requestSerializer setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
    [_mgr.requestSerializer setValue:@"platform=iOS&sdkversion=3.3.1&product=3dmap" forHTTPHeaderField:@"platinfo"];
    [_mgr.requestSerializer setValue:@"H4sIAAAAAAAAAwGwAU/+eUn2DWD62pxIjmBa3P2N7DVUEetsXVxbSuQlqfPZUUKpENzdDqlAT6pW1x/Az2Fh/VXM723iDU+zJWt7IMC5Jy1S9sCpfg+xqdYHMun/ODdoLdqCGqUDlI648WphgzjfJ5HVuNmvCb4UbQ/2j023oCvAhtgAqollGXdOew6ARMlbbOjKEtcfs+VDsQXLiuqDUDo692FDuqSnKafoegfOQSRq8RWV+XyEttjtmYvnStd0L3TA/p0rTj+yem0S0dtleaHgWGLdP/5KD4yluCbJgM6RflxK3ZnhRMBD4bgQm8LCADqPWMdQfSVr2jcDUiuy7XPmPx099Zr8Y9D2TnI7Xu7LDrVZ+NeRQGHXOjOrQafERYtE8wcAU2mdt+sB6QoYafpIwYpFDLNuBMurDsyxwgkXrE4BcQcYI+ArVIP5nmEOxdAAmvDJS1gJ4erkTQ6DSt5CE4lKmtEwTbDdzeAbMfBHSMGasJXvhScgqsrNhi49Tli7vTuE9RZlVd+EvOGV4AjGfrq56IwCfLS3/hmjz/reMegdD/vSuFbrT7ZOr6HkMYXIlD1M3R1ToWyIN3M66RqujLABAAA" forHTTPHeaderField:@"x-info"];
    [_mgr.requestSerializer setValue:@"f6d92d3a67f7eecd0462f0df04526bf9" forHTTPHeaderField:@"key"];
    [_mgr.requestSerializer setValue:@"9d0915e9a162f3b4428ed6e497c96d89" forHTTPHeaderField:@"scode"];
    [_mgr.requestSerializer setValue:tsStr forHTTPHeaderField:@"ts"];
    
    
    
    // 2.封装请求参数
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setValue:@"platform=iOS&sdkversion=3.3.1&product=3dmap" forKey:@"platinfo"];
//    [params setValue:@"H4sIAAAAAAAAAwGwAU/+eUn2DWD62pxIjmBa3P2N7DVUEetsXVxbSuQlqfPZUUKpENzdDqlAT6pW1x/Az2Fh/VXM723iDU+zJWt7IMC5Jy1S9sCpfg+xqdYHMun/ODdoLdqCGqUDlI648WphgzjfJ5HVuNmvCb4UbQ/2j023oCvAhtgAqollGXdOew6ARMlbbOjKEtcfs+VDsQXLiuqDUDo692FDuqSnKafoegfOQSRq8RWV+XyEttjtmYvnStd0L3TA/p0rTj+yem0S0dtleaHgWGLdP/5KD4yluCbJgM6RflxK3ZnhRMBD4bgQm8LCADqPWMdQfSVr2jcDUiuy7XPmPx099Zr8Y9D2TnI7Xu7LDrVZ+NeRQGHXOjOrQafERYtE8wcAU2mdt+sB6QoYafpIwYpFDLNuBMurDsyxwgkXrE4BcQcYI+ArVIP5nmEOxdAAmvDJS1gJ4erkTQ6DSt5CE4lKmtEwTbDdzeAbMfBHSMGasJXvhScgqsrNhi49Tli7vTuE9RZlVd+EvOGV4AjGfrq56IwCfLS3/hmjz/reMegdD/vSuFbrT7ZOr6HkMYXIlD1M3R1ToWyIN3M66RqujLABAAA=" forKey:@"x-info"];
//    [params setValue:@"f6d92d3a67f7eecd0462f0df04526bf9" forKey:@"key"];
////    [params setObject:@1 forKey:@"ia"];
////    [params setObject:@2.0 forKey:@"logversion"];
////    [params setObject:@1 forKey:@"ec"];
////    [params setValue:@"9d0915e9a162f3b4428ed6e497c96d89" forKey:@"scode"];
//    [params setValue:@"AMAP_SDK_iOS_3DMap_3.3.1" forKey:@"User-Agent"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"utf-8" forKey:@"encode"];
    [params setValue:@"json" forKey:@"resType"];

    /*
ia: 1
logversion: 2.0
ec: 1
key: f6d92d3a67f7eecd0462f0df04526bf9
scode: 9d0915e9a162f3b4428ed6e497c96d89
    Accept-Language: zh-cn
    Accept-Encoding: gzip, deflate
    Content-Length: 25
    User-Agent: AMAP_SDK_iOS_3DMap_3.3.1
Connection: keep-alive
    Content-Type: application/x-www-form-urlencoded
ts: 1457930192410
     */
    // 3.发送POST请求
    [_mgr POST:url parameters:params
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:[responseObject description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
           [alertView show];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }];

    
}

// 检测网络状态
- (void)netWorkStatus
{
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // WiFi
     */
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"%ld", status);
    }];
}

// JSON方式获取数据
+ (void)JSONDataWithUrl:(NSString *)url success:(void (^)(id json))success fail:(void (^)())fail;
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"format": @"json"};
    // 网络访问是异步的,回调是主线程的,因此程序员不用管在主线程更新UI的事情
    [manager GET:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        if (fail) {
            fail();
        }
    }];
}

// xml方式获取数据
+ (void)XMLDataWithUrl:(NSString *)urlStr success:(void (^)(id xml))success fail:(void (^)())fail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // 返回的数据格式是XML
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    NSDictionary *dict = @{@"format": @"xml"};
    
    // 网络访问是异步的,回调是主线程的,因此程序员不用管在主线程更新UI的事情
    [manager GET:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        if (fail) {
            fail();
        }
    }];
}

// post提交json数据 http://blog.csdn.net/daiyelang/article/details/38434023
+ (void)postJSONWithUrl:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id responseObject))success fail:(void (^)())fail
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 设置请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置返回格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        if (fail) {
            fail();
        }
    }];
    
}

// json 转字典
- (void)testToDic
{
    NSString *json2 = @"{\"a\":123, \"b\":\"abc\", \"c\":[456, \"hello\"], \"d\":{\"name\":\"张三\", \"age\":\"32\"}}";
    
    
    // 第一种方式
    NSData *response = [json2 dataUsingEncoding:NSUTF8StringEncoding];
    // IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSError *error;
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"%@", weatherDic);
    
    
    // 第二种方式，转换成data后使用jsonkit
    
    NSData *data = [json2 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *ddd = [data mutableObjectFromJSONData];
    NSLog(@"%@", ddd);

    
    // 第三种方式，使用jsonkit直接转账NSString
    NSDictionary *data2 = [json2 objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
    NSLog(@"%@",data2);
    
}

// 字典转模型
- (void)testjson
{
    NSDictionary *dic = @{@"bankname":@"中国银行",
                          @"icon":@"http://www.baidu.com",
                          @"amount":@234.56};
    TestDomainObject *obj = [TestDomainObject domainWithJSONDictionary:dic];
    NSLog(@"%@",obj);
    
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:[obj description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}


#pragma mark - NSURLSession
// http://www.cocoachina.com/industry/20131106/7304.html
/*
 NSURLSession提供的功能：
 1.通过URL将数据下载到内存
 2.通过URL将数据下载到文件系统
 3.将数据上传到指定URL
 4.在后台完成上述功能
 
 工作流程
 如果我们需要利用NSURLSession进行数据传输我们需要：
 1.创建一个NSURLSessionConfiguration，用于第二步创建NSSession时设置工作模式和网络设置：
 工作模式分为：
 一般模式（default）：工作模式类似于原来的NSURLConnection，可以使用缓存的Cache，Cookie，鉴权。
 及时模式（ephemeral）：不使用缓存的Cache，Cookie，鉴权。
 后台模式（background）：在后台完成上传下载，创建Configuration对象的时候需要给一个NSString的ID用于追踪完成工作的Session是哪一个（后面会讲到）。
 
 网络设置：参考NSURLConnection中的设置项。
 1. 创建一个NSURLSession，系统提供了两个创建方法：
 sessionWithConfiguration:
 sessionWithConfiguration:delegate:delegateQueue:
 　　　　
 第一个粒度较低就是根据刚才创建的Configuration创建一个Session，系统默认创建一个新的OperationQueue处理Session的消息。
 
 第二个粒度比较高，可以设定回调的delegate（注意这个回调delegate会被强引用），并且可以设定delegate在哪个OperationQueue回调，如果我们将其设置为[NSOperationQueue mainQueue]就能在主线程进行回调非常的方便。
 
 2.创建一个NSURLRequest调用刚才的NSURLSession对象提供的Task函数，创建一个NSURLSessionTask。
 
 根据职能不同Task有三种子类：
 NSURLSessionUploadTask：上传用的Task，传完以后不会再下载返回结果；
 NSURLSessionDownloadTask：下载用的Task；
 NSURLSessionDataTask：可以上传内容，上传完成后再进行下载。
 
 得到的Task，调用resume开始工作。
 */

- (void)urlsessionTest
{
    
    LEDNSURLSessionViewController *vc = [[LEDNSURLSessionViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
//    [self fileDownload];
}

// 文件断点下载
- (void)fileDownload
{
    NSLog(@"文件断点下载:http://my.oschina.net/iOSliuhui/blog/469276");
}

@end
