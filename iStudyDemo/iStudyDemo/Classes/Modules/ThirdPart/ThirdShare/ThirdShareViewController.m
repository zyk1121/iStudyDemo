//
//  ThirdShareViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/14.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "ThirdShareViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"

// https://www.douban.com/note/478358653/
// #warning: 尚未导入平台类型：[QZoneConnection (6)]
// 原因：http://bbs.mob.com/thread-118-1-1.html

@interface ThirdShareViewController ()

@property (nonatomic, strong) UIButton *button1;

@end

@implementation ThirdShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    [self.view setNeedsUpdateConstraints];
}

#pragma mark - private method

- (void)setupUI
{
    //  [ShareSDK registerApp:@"4a88b2fb067c"]; // cn.sharesdk.CommentDemo
//    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885"
//                           appSecret:@"64020361b8ec4c99936c0e3999a9f249"
//                           wechatCls:[WXApi class]];
    self.button1 = ({
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"分享" forState:UIControlStateNormal];
        [button setTitle:@"分享" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button setBackgroundColor:[UIColor grayColor]];
        [button addTarget:self action:@selector(button1Clicked) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.view addSubview:self.button1];
}

- (void)button1Clicked
{
    //创建分享内容
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"png"];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                       defaultContent:@"测试一下"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"ShareSDK"
                                                  url:@"http://www.mob.com"
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];
    //  选择要添加的功能
    NSArray *shareList = [ShareSDK customShareListWithType:
                          SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                          SHARE_TYPE_NUMBER(ShareTypeTwitter),
                          SHARE_TYPE_NUMBER(ShareTypeRenren),
                          SHARE_TYPE_NUMBER(ShareTypeMail),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                          SHARE_TYPE_NUMBER(ShareTypeYouDaoNote),
                          SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                          nil];
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
}

#pragma mark - masonry

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    //
    [self.button1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(80);
    }];
}

@end
