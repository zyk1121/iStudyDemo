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
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button3;

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
    // com.kdtm.iStudyDemo
    //  [ShareSDK registerApp:@"4a88b2fb067c"]; // cn.sharesdk.CommentDemo
//    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885"
//                           appSecret:@"64020361b8ec4c99936c0e3999a9f249"
//                           wechatCls:[WXApi class]];
    self.button1 = ({
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"第三方分享" forState:UIControlStateNormal];
        [button setTitle:@"第三方分享" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button setBackgroundColor:[UIColor grayColor]];
        [button addTarget:self action:@selector(button1Clicked) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.view addSubview:self.button1];
    
    self.button2 = ({
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"第三方登录" forState:UIControlStateNormal];
        [button setTitle:@"第三方登录" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button setBackgroundColor:[UIColor grayColor]];
        [button addTarget:self action:@selector(button2Clicked) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.view addSubview:self.button2];
    
    self.button3 = ({
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"第三方登出" forState:UIControlStateNormal];
        [button setTitle:@"第三方登出" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button setBackgroundColor:[UIColor grayColor]];
        [button addTarget:self action:@selector(button3Clicked) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.view addSubview:self.button3];
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

- (void)button2Clicked
{
    //设置授权选项
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    //在授权页面中添加关注官方微博
//    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
//                                    nil]];
    
    [ShareSDK getUserInfoWithType:ShareTypeWeixiSession authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        NSLog(@"%d",result);
        if (result) {
            NSLog(@"登录成功:%@",userInfo);
            //成功登录后，判断该用户的ID是否在自己的数据库中。
            //如果有直接登录，没有就将该用户的ID和相关资料在数据库中创建新用户。
            // [self reloadStateWithType:ShareTypeSinaWeibo];
        }
    }];
}

- (void)button3Clicked
{
    [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];
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
    
    [self.button2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.button1.mas_bottom).offset(20);
    }];
    
    [self.button3 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.button2.mas_bottom).offset(20);
    }];
}

@end
