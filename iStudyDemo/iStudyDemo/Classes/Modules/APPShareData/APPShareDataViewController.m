//
//  APPShareDataViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/6/15.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "APPShareDataViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "SSKeychain.h"

// http://www.jianshu.com/p/169e31cacf42

@interface APPShareDataViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) NSMutableArray *listViewControllers;

@end

@implementation APPShareDataViewController

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
    _listViewControllers = [[NSMutableArray alloc] init];
    
    // 1.APP Groups
    [_listData addObject:@"APP Groups"];
    // 2.UIPasteboard
    [_listData addObject:@"UIPasteboard剪贴板"];
    // 3.custom url scheme
    [_listData addObject:@"custom url scheme"];
    // 4.Shared Keychain Access
    [_listData addObject:@"Shared Keychain Access"];
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
            [self appGroups];
            break;
        case 1:
            [self uiUIPasteboard];
            break;
        case 2:
            [self customurlscheme];
            break;
        case 3:
            [self SharedKeychainAccess];
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
    return 40;
}

#pragma mark - private method

- (void)appGroups
{
    // 需要去https://developer.apple.com/account/ios/identifier/applicationGroup创建app group
    // group.com.ishowchina
    // 那么我们的app的前缀也必须是com.ishowchina
    /*
     App Groups
     iOS8之后苹果加入了App Groups功能，应用程序之间可以通过同一个group来共享资源，app group可以通过NSUserDefaults进行小量数据的共享，如果需要共享较大的文件可以通过NSFileCoordinator、NSFilePresenter等方式。
     开启app groups，需要添加一个group name，app之间通过这个group共享数据：
     
     文／树下的老男孩（简书作者）
     原文链接：http://www.jianshu.com/p/169e31cacf42
     著作权归作者所有，转载请联系作者获得授权，并标注“简书作者”。*/
 
    // 写入数据
    NSUserDefaults *myDefaults = [[NSUserDefaults alloc]
                                  initWithSuiteName:@"group.com.ishowchina"];
    [myDefaults setObject:@"shared data for ishowchina" forKey:@"mykey"];
    
    // 读取数据
//    NSUserDefaults *myDefaults2 = [[NSUserDefaults alloc]
//                                  initWithSuiteName:@"group.com.ishowchina"];
//    NSString *content = [myDefaults2 objectForKey:@"mykey"];
//    NSLog(@"%@",content);
}

- (void)uiUIPasteboard
{
    // 剪贴板
    UIPasteboard *pasteboard = [UIPasteboard pasteboardWithName:@"myPasteboard" create:YES];
    pasteboard.string = @"myShareData";
//    UIPasteboard *pasteboard = [UIPasteboard pasteboardWithName:@"myPasteboard" create:NO];
//    NSString *content = pasteboard.string;
}

- (void)customurlscheme
{
    // identifier:com.xiuyou.map  url scheme:Xiuyou
    /*
     Identifier用于标示名称，为了唯一性可以采用反转域名的形式，另外我们设置URL Scheme为Example2，以及role为Viewer(Viewer表示只能读取改URL但不能修改，Editor可以对URL进行读写)，这样Example2就能够接受类似"Example2:\"的URL请求了，可以在浏览器中输入"Example2:\"链接打开app
     
     文／树下的老男孩（简书作者）
     原文链接：http://www.jianshu.com/p/169e31cacf42
     著作权归作者所有，转载请联系作者获得授权，并标注“简书作者”。*/
    
    NSString *string = @"Xiuyou://name=zhangyuanke&age=26&url=http://www.baidu.com";
    NSURL *url = [NSURL URLWithString:string];
    [[UIApplication sharedApplication] openURL:url];
    
    /*
    -(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
    {
        if ([[url scheme] isEqualToString:@"Xiuyou"]) {
            NSString *content = [url resourceSpecifier];
            //解析content获取数据
            //...
            return YES;
        }
        return NO;
    }
     */
    
}

- (void)SharedKeychainAccess
{
    /*Shared Keychain Access
     iOS的keychain提供一种安全保存信息的方式，可以保存密码等数据，而且keychain中的数据不会因为你删除app而丢失，你可以在重新安装后继续读取keychain中的数据。通常每个应用程序只允许访问自己在keychain中保存的数据，不过假如你使用同一个证书的话，不同的app也可以通过keychain来实现应用间的数据共享，之前下载百度贴吧应用的时候发现首次打开它就自动登录了，可能百度的应用之间就是通过这种方式共享用户名密码进行登录的，之前登录过百度云。
     
     为了实现keychain共享数据，我们需要开启Keychain Sharing，开启方法如下，然后添加设置相同的Keychain Group，不过别忘记了添加Security.framework。
     
     文／树下的老男孩（简书作者）
     原文链接：http://www.jianshu.com/p/169e31cacf42
     著作权归作者所有，转载请联系作者获得授权，并标注“简书作者”。*/
    
    // Keachina Groups:com.ishowchina.map1 com.ishowchina.map2
//    [SSKeychain setPassword:@"shareDatakkk" forService:@"ishowchina" account:@"zhangyuanke"];
     NSString *myDataStr = [SSKeychain passwordForService:@"ishowchina" account:@"zhangyuanke"];
    NSLog(@"%@",myDataStr);
    
    
}

// iOS 应用程序间共享数据

@end
