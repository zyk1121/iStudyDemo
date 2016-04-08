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
#import "LEDPortal.h"
#import "PortalViewController.h"


@interface AppDelegate () <WXApiDelegate, UIAlertViewDelegate>


@end

@implementation AppDelegate


- (void)configureMapAPIKey
{
    [MAMapServices sharedServices].apiKey = @"f6d92d3a67f7eecd0462f0df04526bf9";
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //  launchOptions 有当app未启动时候的推送消息,
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSString *message = [[userInfo objectForKey:@"aps"]objectForKey:@"alert"];
        NSString *msg = [NSString stringWithFormat:@"%@, 测试跳转到某一个页面",message];
        // LEDPortal可以直接跳转到某个页面
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
    NSDictionary *localUserInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localUserInfo) {
//        NSString *message = [[localUserInfo objectForKey:@"aps"]objectForKey:@"alert"];
//        NSString *msg = [NSString stringWithFormat:@"%@, 测试跳转到某一个页面",message];
        // LEDPortal可以直接跳转到某个页面
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"本地推送通知" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }


    
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        //IOS8
        [[UIApplication sharedApplication]registerUserNotificationSettings:[UIUserNotificationSettings
                                                                           settingsForTypes:(UIUserNotificationTypeSound |UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                                           categories:nil]];
        [[UIApplication sharedApplication]registerForRemoteNotifications];
    
    }
    
//    // 本地推送通知
//    [AppDelegate registerLocalNotification:5];
    
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

// 推送

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)pToken{
    NSString *token = [[pToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSString *deviceToken = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"deviceToken:%@", deviceToken);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    //  userInfo 有当app启动时候的推送消息,
    NSLog(@"userInfo == %@",userInfo);
    NSString *message = [[userInfo objectForKey:@"aps"]objectForKey:@"alert"];
    NSString *msg = [NSString stringWithFormat:@"%@, 测试跳转到某一个页面",message];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 下面的这些操作可以放到主vc中去做
    // http://www.cocoachina.com/bbs/read.php?tid=290239
    /*
     是这样的，如果你的程序在未启动的时候，如果用户点击通知，notification会通过didFinishLaunchingWithOptions:传递给您，如果用户未点击通知，则didFinishLaunchingWithOptions:的字典里不会有notification的信息，同理，如果你的程序正在后台运行，如果用户点击通知，则(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo会在你的程序进入前台后才会被调用（注意是通过点按通知启动才会被调用）如果用户收到了通知但是没有点按通知，而是点击屏幕上的App图标进入的app，则(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo不会被调用，里面的代码不会被执行。
     */
    
    // 如果直接进行跳转的话这样子就ok，返回直接返回首页
    // 如果返回不想返回首页，可以使用下面的方法，中间插入一个VC
    // 使用的时候还要注意，当前的VC可能不是当前的导航控制器，但是，只要不是AlertView就可以直接transferFromViewController：nil
    UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
    [LEDPortal transferFromViewController:nav.topViewController toURL:[NSURL URLWithString:@"ipuny://portal/launch"] completion:^(UIViewController * _Nullable viewController, NSError * _Nullable error) {
        // 可以对VC做一些后续的操作
//        NSLog(@"%@",[nav viewControllers]);
        // 导航控制器的VCs增加一个页面
        UINavigationController *currentNav = viewController.navigationController;
        NSMutableArray *navs = [[NSMutableArray alloc] initWithArray:[currentNav.viewControllers mutableCopy]];
        //
        [navs removeObject:viewController];
        //中间插入一个vc
        PortalViewController *vc = [[PortalViewController alloc] init];
        [navs addObject:vc];
        //
        [navs addObject:viewController];
        currentNav.viewControllers = [navs copy];
        
        if (viewController && !error) {
            viewController.title = @"远程跳转";
            viewController.view.backgroundColor = [UIColor blueColor];
        }
        
    }];

}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    NSLog(@"Regist fail%@",error);
}

// 本地推送通知

/*
 处理Local Notification
 在处理本地通知时，我们需要考虑三种情况：
 1. App没有启动，
 这种情况下，当点击通知时，会启动App，而在App中，开发人员可以通过实现*AppDelegate中的方法：- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions，然后从lauchOptions中获取App启动的原因，若是因为本地通知，则可以App启动时对App做对应的操作，比方说跳转到某个画面等等。栗子：
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
 {
 NSLog(@"Start App....");
 ....
 UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
 if ([self isWelcomeNotification:localNotification]) {
 NSLog(@"start with welcome notification");
 [self.mainViewController showOfficeIntroduction];
 }
 return YES;
 }
 2. App运行在后台
 3. App运行在前台
 上面的2种情况的处理基本一致， 不同点只有当运行再后台的时候，会有弹窗提示用户另外一个App有通知，对于本地通知单的处理都是通过*AppDelegate的方法：- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification来处理的。 栗子：
 - (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
 {
 if ([self isWelcomeNotification:notification]) {
 [self.mainViewController showOfficeIntroduction];
 }if ([self isCustomerDataNotification:notification]) {
 [self.mainViewController showCustomerDataIntroduction];
 }
 }
 */
// 设置本地通知
+ (void)registerLocalNotification:(NSInteger)alertTime {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 设置触发通知的时间
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:alertTime];
    NSLog(@"fireDate=%@",fireDate);
    
    notification.fireDate = fireDate;
    // 时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    // 设置重复的间隔
    notification.repeatInterval = kCFCalendarUnitSecond;
    
    // 通知内容
    notification.alertBody =  @"我是本地通知...";
//    notification.applicationIconBadgeNumber = 1;
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    // 通知参数
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:@"今天天气还不错" forKey:@"key"];
    notification.userInfo = userDict;
    
    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = NSCalendarUnitDay;
    } else {
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = NSDayCalendarUnit;
    }
    
    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

// 本地通知回调函数，当应用程序在前台时调用
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"noti:%@",notification);
    
    // 这里真实需要处理交互的地方
    // 获取通知所带的数据
    NSString *notMess = [notification.userInfo objectForKey:@"key"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"本地通知"
                                                    message:notMess
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    // 更新显示的徽章个数
//    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
//    badge--;
//    badge = badge >= 0 ? badge : 0;
//    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    
    // 在不需要再推送时，可以取消推送
    [AppDelegate cancelLocalNotificationWithKey:@"key"];
}

// 取消某个本地推送通知
// [[UIApplication sharedApplication] cancelAllLocalNotifications];
+ (void)cancelLocalNotificationWithKey:(NSString *)key {
    // 获取所有本地通知数组
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            // 根据设置通知参数时指定的key来获取通知参数
            NSString *info = userInfo[key];
            
            // 如果找到需要取消的通知，则取消
            if (info != nil) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                break;  
            }  
        }  
    }  
}

@end
