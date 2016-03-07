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

@interface HTTPTestViewController ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *mgr;

@end

@implementation HTTPTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
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
    [self testToDic];
    
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

// json 字符转字典
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
    
}

@end
