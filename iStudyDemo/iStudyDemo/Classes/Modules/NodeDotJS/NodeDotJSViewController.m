//
//  NodeDotJSViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/29.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "NodeDotJSViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "LEDWebViewController.h"

/*
 
 Node.js® is a JavaScript runtime built on Chrome's V8 JavaScript engine. Node.js uses an event-driven, non-blocking I/O model that makes it lightweight and efficient. Node.js' package ecosystem, npm, is the largest ecosystem of open source libraries in the world.
 
 Node.js was installed at
 
 /usr/local/bin/node
 
 npm was installed at
 
 /usr/local/bin/npm
 
 Make sure that /usr/local/bin is in your $PATH.
 
 
 简单的说 Node.js 就是运行在服务端的 JavaScript。
 Node.js 是一个基于Chrome JavaScript 运行时建立的一个平台。
 Node.js是一个事件驱动I/O服务端JavaScript环境，基于Google的V8引擎，V8引擎执行Javascript的速度非常快，性能非常好。
 
 Node.js 创建第一个应用
 如果我们使用PHP来编写后端的代码时，需要Apache 或者 Nginx 的HTTP 服务器，并配上 mod_php5 模块和php-cgi。
 从这个角度看，整个"接收 HTTP 请求并提供 Web 页面"的需求根本不需 要 PHP 来处理。
 不过对 Node.js 来说，概念完全不一样了。使用 Node.js 时，我们不仅仅 在实现一个应用，同时还实现了整个 HTTP 服务器。事实上，我们的 Web 应用以及对应的 Web 服务器基本上是一样的。
 在我们创建 Node.js 第一个 "Hello, World!" 应用前，让我们先了解下 Node.js 应用是由哪几部分组成的：
 引入 required 模块：我们可以使用 require 指令来载入 Node.js 模块。
 创建服务器：服务器可以监听客户端的请求，类似于 Apache 、Nginx 等 HTTP 服务器。
 接收请求与响应请求 服务器很容易创建，客户端可以使用浏览器或终端发送 HTTP 请求，服务器接收请求后返回响应数据。
 
 */
@interface NodeDotJSViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listData;

@end

@implementation NodeDotJSViewController

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
    
    [_listData addObject:@"Node.js 入门"];
    [_listData addObject:@"GET服务"];
    [_listData addObject:@"POST服务"];
    [_listData addObject:@"Web服务Express框架"];
    
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
            [self test0];
            break;
        case 1:
            [self test1];
            break;
        case 2:
            [self test2];
            break;
        case 3:
            [self test3];
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
    //    cell.detailTextLabel.text = [self.listData objectForKey:[self.listData allKeys][indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - private method

- (void)test0
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:@"Node.js® is a JavaScript runtime built on Chrome's V8 JavaScript engine. Node.js uses an event-driven, non-blocking I/O model that makes it lightweight and efficient. Node.js' package ecosystem, npm, is the largest ecosystem of open source libraries in the world." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)test1
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setHTTPMethod:@"GET"]; // 设置请求方式
//    [request setURL:[NSURL URLWithString:@"http://localhost:8081/t1.txt"]]; // 设置网络请求的URL
        [request setURL:[NSURL URLWithString:@"http://localhost:8081"]]; // 设置网络请求的URL
    [request setTimeoutInterval:10]; // 设置超出时间 10s
    // 发送异步请求
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         // 返回结果
         NSString *message = nil;
         if (connectionError) {
//             NSLog(@"%@",connectionError);
             message = connectionError.description;
         } else {
//             NSLog(@"%@",data);
             message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         }
         
         dispatch_async(dispatch_get_main_queue(), ^{
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
             [alertView show];
         });
         
         

     }];
}

- (void)test2
{
    NSURL *URL=[NSURL URLWithString:@"http://localhost:8081"];//不需要传递参数
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
         NSString *message = nil;
         if (connectionError) {
             //             NSLog(@"%@",connectionError);
             message = connectionError.description;
         } else {
             //             NSLog(@"%@",data);
             message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         }
         dispatch_async(dispatch_get_main_queue(), ^{
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
             [alertView show];
         });

     }];
}

- (void)test3
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setHTTPMethod:@"GET"]; // 设置请求方式
        [request setURL:[NSURL URLWithString:@"http://localhost:8081/t1.txt"]]; // 设置网络请求的URL
//    [request setURL:[NSURL URLWithString:@"http://localhost:8081"]]; // 设置网络请求的URL
    [request setTimeoutInterval:10]; // 设置超出时间 10s
    // 发送异步请求
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         // 返回结果
         NSString *message = nil;
         if (connectionError) {
             //             NSLog(@"%@",connectionError);
             message = connectionError.description;
         } else {
             //             NSLog(@"%@",data);
             message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         }
         
         dispatch_async(dispatch_get_main_queue(), ^{
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
             [alertView show];
         });
         
         
         
     }];

}

@end
