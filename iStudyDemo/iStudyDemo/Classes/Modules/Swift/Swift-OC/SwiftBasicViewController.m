//
//  SwiftBasicViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/4/17.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "SwiftBasicViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
// OC 调用 Swift
// http://blog.sina.com.cn/s/blog_8d1bc23f0102v5tl.html
/*
这样，工程中如查Swift要使用OC,则把需要使用的OC类的头文件，全写在MixDemo-Bridging-Header.h里。同样如果OC中所使用的swift类，只需要Clean一把，再编就可以了，但不要忘了导入SwiftModule-swift.h哦（名称自取，但-swift.h是固定的），另外还有一个需要读者注意的。
 注：
 凡是用Swift写的类，如果不继成自NSObject或NSObject 的派生类，哪么编译后将不会生成对应的转换类。从而使得OC 中找不到相应的声明。
 如我的例子中 class Act 这样不会被编译到SwiftModule-swift.h中，但写为 class Act : NSObject，就可以编译出相应的声明。另外可以使用@objc加以声明，但这个还是一样，类最好继承NSObject下来。就像
 */
#import "iStudyDemo-swift.h"

@interface SwiftBasicViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) NSMutableArray *listViewControllers;

@end

@implementation SwiftBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    // 1.OC call Swift
    [_listData addObject:@"OC Call Swift"];
    // 2.Swift call oc
    [_listData addObject:@"Swift Call OC"];
    // 3.OC call Swift Global Class
    [_listData addObject:@"OC call Swift Global Class"];
    // 4.call swift VC
    [_listData addObject:@"OC Call swift VC"];
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
    [self testForRow:indexPath.row];
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

- (void)testForRow:(NSUInteger)row
{
    switch (row) {
        case 0:
            [self OCCallSwift];
            break;
        case 1:
            [self swiftCallOC];
            break;
        case 2:
            [self OCCAllSwiftGlobalClass];
            break;
        case 3:
            [self OCCallSwiftVC];
            break;
        default:
            break;
    }
}

- (void)OCCallSwift
{
    /*import Foundation
     import UIKit
     
     class SwiftClass: NSObject {
     // 声明变量
     var tempStr = "hello world"
     
     // 函数入口
     func run() {
     // log
     NSLog("NSLog:\(tempStr)")
     print("print:\(tempStr)")
     }
     }*/
    SwiftClass *cls = [[SwiftClass alloc] init];
    [cls runOCCallSwift];
    [cls test3];
//    testGlobal();// oc 不能调用 swift 的全局方法和变量，
    /*
     
     swift项目，OC中如何使用swift里定义的全局变量和常量？以及全局方法
     ：
     我自己回答一下，目前找到的折中方法是：建一个swift类，然后将所有的全局变量和常量改成这个类的属性（储存或者计算），然后swift和OC都能够用了，只是使用的时候需要用类名调用，而不是直接写 变量名称。。
     */
}

- (void)swiftCallOC
{
    SwiftClass *cls = [[SwiftClass alloc] init];
    [cls runSwiftCallOC];
}

- (void)OCCAllSwiftGlobalClass
{
    //    testGlobal();// oc 不能调用 swift 的全局方法和变量，
    /*
     
     swift项目，OC中如何使用swift里定义的全局变量和常量？以及全局方法
     ：
     我自己回答一下，目前找到的折中方法是：建一个swift类，然后将所有的全局变量和常量改成这个类的属性（储存或者计算），然后swift和OC都能够用了，只是使用的时候需要用类名调用，而不是直接写 变量名称。。
     */
    [GlobalOCSwiftData setName:@"12345678"];
    [GlobalOCSwiftData testFunc];
}
- (void)OCCallSwiftVC
{
    TestSwiftViewController *vc = [[TestSwiftViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
