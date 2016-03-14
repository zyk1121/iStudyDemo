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
//    [self testToDic];
    [self testLDAuth];
    
}

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
    // 3.发送GET请求
    [_mgr POST:url parameters:params
       success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
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
