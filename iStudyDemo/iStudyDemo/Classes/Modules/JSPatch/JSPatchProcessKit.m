//
//  JSPatchProcessKit.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/16.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "JSPatchProcessKit.h"
#import "JPEngine.h"
#import <AFNetworking.h>

// https://github.com/bang590/JSPatch/wiki/%E5%9F%BA%E7%A1%80%E7%94%A8%E6%B3%95

@interface JSPatchProcessKit ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *mgr;

@end

@implementation JSPatchProcessKit

+ (instancetype)defaultJSPatchKit
{
    static JSPatchProcessKit *_sharedKit = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedKit = [[self alloc] init];
    });
    
    return _sharedKit;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        // 1.获得请求管理者
        _mgr = [AFHTTPRequestOperationManager manager];
//        _mgr.requestSerializer = [AFHTTPRequestSerializer serializer];// 请求
        _mgr.responseSerializer = [AFHTTPResponseSerializer serializer];// 响应
    }
    return self;
}

- (void)execJSProcess
{
    // 步骤一:从本地指定文件夹中读取是否有当前版本的js patch文件，如果有的话，则执行
    // 步骤二:从服务器下载当前版本的js patch 文件,替换或则新建一个文件，保存到指定路径下
    // 不直接加载下载后的js目的，防止网络不好等问题造成的不确定性问题
    // js文件数据最好进行加密后上传到服务器
    
    [JPEngine startEngine];
    // https://github.com/bang590/JSPatch
//    [JPEngine evaluateScript:@"\
//     var alertView = require('UIAlertView').alloc().init();\
//     alertView.setTitle('Alert');\
//     alertView.setMessage('AlertView from js'); \
//     alertView.addButtonWithTitle('OK');\
//     alertView.show(); \
//     "];
    //路径
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES);
    NSString *documentDirectory =[documentPaths objectAtIndex:0];
    NSString *docPath = [documentDirectory stringByAppendingPathComponent:@"JSPatch"];//fileName就是保存文件的文件名
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:nil];
    // 版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];// 1.0.1
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"]; //1
    
    NSString *fileName = [NSString stringWithFormat:@"main_%@_%@.js",appCurVersion,appCurVersionNum];
    NSString *filePath = [docPath stringByAppendingPathComponent:fileName];
//    [fileManager removeItemAtPath:filePath error:nil];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        [JPEngine evaluateScriptWithPath:filePath];
    }
    
    [self httpDownload];
    
//    NSString *contentStr =@"\
//         var alertView = require('UIAlertView').alloc().init();\
//         alertView.setTitle('Alert');\
//         alertView.setMessage('AlertView from js'); \
//         alertView.addButtonWithTitle('OK');\
//         alertView.show(); \
//         ";
//    [contentStr writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
//    NSString *str = @"\
//    require('UIAlertAction')\
//    defineClass('UIAlertAction',{\
//    },{\
//    actionWithTitle_style_handler:function(cancelTitle,style,handler) {\
//        if (cancelTitle) {\
//            var tempBlock = block('UIAlertAction*',function(alertAction){\
//                handler(alertAction);\
//    };\
//    return UIAlertAction.ORIGactionWithTitle_style_handler(cancelTitle,style,tempBlock);\
//        } else {\
//            return null;\
//        }\
//    }\
//    })";
//    [JPEngine evaluateScript:str];
}

- (void)httpDownload
{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES);
    NSString *documentDirectory =[documentPaths objectAtIndex:0];
    NSString *docPath = [documentDirectory stringByAppendingPathComponent:@"JSPatch"];//fileName就是保存文件的文件名
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:nil];
    // 版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];// 1.0.1
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"]; //1
    
    NSString *fileName = [NSString stringWithFormat:@"main_%@_%@.js",appCurVersion,appCurVersionNum];
    NSString *filePath = [docPath stringByAppendingPathComponent:fileName];
    
    // 3.发送GET请求
    NSString *url = @"http://localhost:8888/JSPatch/main_1.0.0_1.js";
    [_mgr GET:url parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSString *jsSTR =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
          // 写入文件
          [jsSTR writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"%@",error);
      }];
}


@end
