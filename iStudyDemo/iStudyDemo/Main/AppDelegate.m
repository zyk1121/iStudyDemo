//
//  AppDelegate.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/6.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import <MAMapKit/MAMapKit.h>

#import <ShareSDK/ShareSDK.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"

//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"
#import "JSPatchProcessKit.h"
//#import "JPEngine.h"
#import "SHCZMainView.h"
#import "NewfeatureViewController.h"


@interface AppDelegate () <WXApiDelegate>


@end

@implementation AppDelegate


- (void)configureMapAPIKey
{
    [MAMapServices sharedServices].apiKey = @"f6d92d3a67f7eecd0462f0df04526bf9";
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //
    [self configureMapAPIKey];
    [[JSPatchProcessKit defaultJSPatchKit] execJSProcess];
    //
//    _leftVC = [[QQLeftViewController alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //在window上创建一个透明的View
//    SHCZMainView *mainView=[[SHCZMainView alloc]initWithFrame:CGRectMake(-self.window.frame.size.width*0.25,0,self.window.bounds.size.width,self.window.bounds.size.height)];
    
    //    设置冰川背景图
//    UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sidebar_bg.jpg"]];
//    img.frame=CGRectMake(0,0,self.window.frame.size.width,self.window.frame.size.height*0.4);
    
//    [self.window addSubview:img];
//    
//    //    添加
//    [self.window addSubview:mainView];
//    //
//    UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:[[MainViewController alloc] init]];
//    
//    self.window.rootViewController = mainNav;
    
    
    NSString *versionKey = @"CFBundleVersion";
    // 上一次的使用版本（存储在沙盒中的版本号）
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:versionKey];
    // 当前app的版本号（从Info.plist中获得）
//    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:versionKey];
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    if ([lastVersion isEqualToString:currentVersion]) {
        UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:[[MainViewController alloc] init]];
        
        self.window.rootViewController = mainNav;
    } else {
        self.window.rootViewController = [[NewfeatureViewController alloc] init];
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:versionKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    
    [self.window makeKeyAndVisible];
    
    //1.初始化ShareSDK应用,字符串"iosv1101"是应该换成你申请的ShareSDK应用中的Appkey
    [ShareSDK registerApp:@"106bbd93e7498"];
//    [ShareSDK registerApp:@"4a88b2fb067c"]; // cn.sharesdk.CommentDemo
    
    //2. 初始化社交平台
    //2.1 代码初始化社交平台的方法
    [self initializePlat];
    return YES;
}

- (void)initializePlat
{
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
//    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885"
//                           appSecret:@"64020361b8ec4c99936c0e3999a9f249"
//                           wechatCls:[WXApi class]];
    [ShareSDK connectWeChatWithAppId:@"wx98d0898bb18f694f"
                           appSecret:@"88cc04ff9a0740de17ac64487d138e31"
                           wechatCls:[WXApi class]];
    
    /**
     连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和QQApi.framework库
     http://mobile.qq.com/api/上注册应用，并将相关信息填写到以下字段
     **/
    //旧版中申请的AppId（如：QQxxxxxx类型），可以通过下面方法进行初始化
    //    [ShareSDK connectQQWithAppId:@"QQ075BCD15" qqApiCls:[QQApi class]];
    
   // [ShareSDK connectQQWithQZoneAppKey:@"100371282"
     //                qqApiInterfaceCls:[QQApiInterface class]
       //                tencentOAuthCls:[TencentOAuth class]];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}

#pragma mark - WXApiDelegate

/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
-(void) onReq:(BaseReq*)req{
    
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
-(void) onResp:(BaseResp*)resp{
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
