//
//  APPUpdateViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/7/19.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "APPUpdateViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "LEDWebViewController.h"

// 在Mac OS X Yosemite (10.10) 下搭建JSP服务器:http://blog.csdn.net/lilin_emcc/article/details/40300217
/*
 首先，兼容性检查。
 
 在终端里运行：
 
 [plain] view plain copy 在CODE上查看代码片派生到我的代码片
 java -version
 如果得到的结果是：
 [plain] view plain copy 在CODE上查看代码片派生到我的代码片
 java version "1.6.0_65"
 Java(TM) SE Runtime Environment (build 1.6.0_65-b14-466.1-11M4716)
 Java HotSpot(TM) 64-Bit Server VM (build 20.65-b04-466.1, mixed mode)
 那么这是 Java 6，看看 Tomcat 官网对 Java 版本的要求（http://tomcat.apache.org/whichversion.html），应该使用 Tomcat 7.0.x。
 
 
 然后，下载并安装 Tomcat。
 
 访问 Tomcat 官网地址：http://tomcat.apache.org/download-70.cgi，下载 tar.gz 文件，解压到 /Library/Tomcat/Home 目录下（自己创建），在终端里输入：
 
 [plain] view plain copy 在CODE上查看代码片派生到我的代码片
 export CATALINA_HOME=/Library/Tomcat/Home
 回车之后不会有反馈，接着在终端继续输入：
 [plain] view plain copy 在CODE上查看代码片派生到我的代码片
 env
 能看到环境变量已经生效。
 
 最后，启动 Tomcat。
 
 在终端输入：
 
 [plain] view plain copy 在CODE上查看代码片派生到我的代码片
 /Library/Tomcat/Home/bin/startup.sh
 结果：
 [plain] view plain copy 在CODE上查看代码片派生到我的代码片
 Using CATALINA_BASE:   /Library/Tomcat/Home
 Using CATALINA_HOME:   /Library/Tomcat/Home
 Using CATALINA_TMPDIR: /Library/Tomcat/Home/temp
 Using JRE_HOME:        /Library/Java/Home
 Using CLASSPATH:       /Library/Tomcat/Home/bin/bootstrap.jar:/Library/Tomcat/Home/bin/tomcat-juli.jar
 Tomcat started.
 看上去服务器应该起来了，打开网页看看：http://localhost:8080/
 
 另外：
 
 Tomcat 的默认端口是 8080，在 /Library/Tomcat/Home/conf/server.xml 中可以配置。
 
 Tomcat 的站点目录在 /Library/Tomcat/Home/webapps/。
 
 这个命令可以关闭 Tomcat 服务器：
 
 [plain] view plain copy 在CODE上查看代码片派生到我的代码片
 /Library/Tomcat/Home/bin/shutdown.sh 
 
 
 */

//http://www.runoob.com/jsp/eclipse-jsp.html
// /Users/zhangyuanke/Desktop/Projects/Tomcat/apache-tomcat-8.0.36/bin
// ./startup.sh


@interface APPUpdateViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listData;

@end

@implementation APPUpdateViewController

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
    
    [_listData addObject:@"Mac OS搭建JSP服务器"];
    [_listData addObject:@"直接跳转到APP Store"];
    [_listData addObject:@"跳转到APP Store，经过Safari"];
    [_listData addObject:@"跳转到APP Store，不经过Safari"];
    [_listData addObject:@"WebVC跳转，POP VC后进入APPStore"];
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
    NSString *methodName = [NSString stringWithFormat:@"test%ld",indexPath.row];
    [self performSelector:NSSelectorFromString(methodName) withObject:nil afterDelay:0];
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

- (void)test0
{
    
}

- (void)test1
{
//       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/app/id461703208"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id461703208"]];
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://192.168.0.101:8080/update.jsp"]];
    /*
     UIWebView *webView = [[UIWebView alloc] init];
     [self.view addSubview:webView];
     [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.0.101:8080/update.jsp"]]];
     */
}

- (void)test2
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://192.168.0.101:8080/update.jsp"]];
}

- (void)test3
{
    UIWebView *webView = [[UIWebView alloc] init];
    [self.view addSubview:webView];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.0.101:8080/update.jsp"]]];
}
- (void)test4
{
    LEDWebViewController *vc = [[LEDWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://192.168.0.101:8080/update.jsp"]];
    [self.navigationController pushViewController:vc animated:NO];

}


@end
