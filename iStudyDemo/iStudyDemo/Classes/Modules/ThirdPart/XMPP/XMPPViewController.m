//
//  XMPPViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "XMPPViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import <XMPPFramework.h>
#import "XMPPRoster.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPRoom.h"
//#import "SPKAlertView.h"

// 简单功能
// Adium  127.0.0.1  5222

// admin@puny.local 123456,密码都是123456

// http://www.cocoachina.com/ios/20141219/10703.html


// http://www.csdn123.com/html/topnews201408/59/10659.htm
// http://www.jianshu.com/p/68d5622db7b7
@interface XMPPViewController () <XMPPStreamDelegate>

@property (nonatomic, strong) XMPPStream * xmppStream;
@property (nonatomic, strong) XMPPRoster * xmppRoster;
@property (nonatomic, strong) XMPPRoom *xmppRoom;

@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button3;
@property (nonatomic, strong) UIButton *button4;
@property (nonatomic, strong) UIButton *button5;
@property (nonatomic, strong) UIButton *button6;
@property (nonatomic, strong) UIButton *button7;
@property (nonatomic, strong) UIButton *button8;

@end

@implementation XMPPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.button1 = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
        button.tag = 1;
        [button setTitle:@"Ejabberd2本地服务登录" forState:UIControlStateNormal];
        [button setTitle:@"Ejabberd2本地服务登录" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(button1Click:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });

    
    
    self.button2 = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH, 40)];
        button.tag = 1;
        [button setTitle:@"上线" forState:UIControlStateNormal];
        [button setTitle:@"上线" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(button2Click:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });

    
    
    self.button3 = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 144, SCREEN_WIDTH, 40)];
        button.tag = 1;
        [button setTitle:@"下线" forState:UIControlStateNormal];
        [button setTitle:@"下线" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(button3Click:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });

    self.button4 = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 184, SCREEN_WIDTH, 40)];
        button.tag = 1;
        [button setTitle:@"接收、发送消息" forState:UIControlStateNormal];
        [button setTitle:@"接收、发送消息" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(button4Click:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });

    self.button5 = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 224, SCREEN_WIDTH, 40)];
        button.tag = 1;
        [button setTitle:@"添加好友" forState:UIControlStateNormal];
        [button setTitle:@"添加好友" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(button5Click:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    
    self.button6 = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 264, SCREEN_WIDTH, 40)];
        button.tag = 1;
        [button setTitle:@"创建聊天室" forState:UIControlStateNormal];
        [button setTitle:@"创建聊天室" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(button6Click:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    
    
    self.button7 = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 304, SCREEN_WIDTH, 40)];
        button.tag = 1;
        [button setTitle:@"openfire服务" forState:UIControlStateNormal];
        [button setTitle:@"openfire服务" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(button7Click:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });


}

- (void)connect {
    if (self.xmppStream == nil) {
        self.xmppStream = [[XMPPStream alloc] init];
        [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        XMPPRosterCoreDataStorage *xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];//花名册存储  XMPP使用coreData 本地化存储
        self.xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];//初始化花名册
        self.xmppRoster.autoFetchRoster = YES;//是否自动获取花名册
        self.xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
        //激活组件
        [self.xmppRoster activate:self.xmppStream];
       // self.xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:<#(id<XMPPRosterStorage>)#> dispatchQueue:<#(dispatch_queue_t)#>];
    }
    if (![self.xmppStream isConnected]) {
        NSString *username = @"kdtm@puny.local";
        XMPPJID *jid = [XMPPJID jidWithString:username];
        [self.xmppStream setMyJID:jid];
        [self.xmppStream setHostName:@"www.test.com"];// http://www.cocoachina.com/bbs/read.php?tid=300212
        [self.xmppStream setHostPort:5222];
        NSError *error = nil;
        if (![self.xmppStream connectWithTimeout:5 error:&error]) {
            NSLog(@"Connect Error: %@", [[error userInfo] description]);
        } else {
            NSLog(@"connect success");
        }
    }
}

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
    NSLog(@"socketDidConnect");
}
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    //连接成功后认证用户名和密码
       NSError *error = nil;
         [self.xmppStream authenticateWithPassword:@"123456" error:&error];
       if (error) {
              NSLog(@"认证错误：%@",[error localizedDescription]);
        }
}

//认证成功后的回调
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:@"登录成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

//认证失败后的回调
-(void)xmppStream:sender didNotAuthenticate:(DDXMLElement *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:@"登录失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

//- (void)disconnect {
//    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
//    [self.xmppStream sendElement:presence];
//    
//    [self.xmppStream disconnect];
//}


#pragma mark - private

-(void)goOnline{
    //发送在线状态
    XMPPPresence *presence = [XMPPPresence presence];
    [[self xmppStream] sendElement:presence];
}
-(void)goOffline{
    //发送下线状态
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [[self xmppStream] sendElement:presence];
}

// 下线
-(void)disconnect{
    [self goOffline];
    [self.xmppStream disconnect];
}

// 获取到好友状态
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
    NSString *presenceType = [presence type];
    NSString *presenceFromUser = [[presence from] user];
    if (![presenceFromUser isEqualToString:[[sender myJID] user]]) {
        if ([presenceType isEqualToString:@"available"]) {
            //
        } else if ([presenceType isEqualToString:@"unavailable"]) {
            //
        }
    }
}
//- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
//{
//    
//}
//收到消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    // NSLog(@"message = %@", message);
    NSString *msg = [[message elementForName:@"body"] stringValue];
    NSString *from = [[message attributeForName:@"from"] stringValue];
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setObject:msg forKey:@"msg"];
//    [dict setObject:from forKey:@"sender"];
    //消息委托(这个后面讲)
}

// 发送消息
- (void)sendMessage:(NSString *) message toUser:(NSString *) user {
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:message];
    NSXMLElement *message2 = [NSXMLElement elementWithName:@"message"];
    [message2 addAttributeWithName:@"type" stringValue:@"chat"];
    NSString *to = [NSString stringWithFormat:@"%@@puny.local", user];
    [message2 addAttributeWithName:@"to" stringValue:to];
    [message2 addChild:body];
    [self.xmppStream sendElement:message2];
}

/*
 好友列表和好友名片
 [_xmppRoster fetchRoster];//获取好友列表
 //获取到一个好友节点
 - (void)xmppRoster:(XMPPRoster *)sender didRecieveRosterItem:(NSXMLElement *)item
 //获取完好友列表
 - (void)xmppRosterDidEndPopulating:(XMPPRoster *)sender
 //到服务器上请求联系人名片信息
 - (void)fetchvCardTempForJID:(XMPPJID *)jid;
 //请求联系人的名片，如果数据库有就不请求，没有就发送名片请求
 - (void)fetchvCardTempForJID:(XMPPJID *)jid ignoreStorage:(BOOL)ignoreStorage;
 //获取联系人的名片，如果数据库有就返回，没有返回空，并到服务器上抓取
 - (XMPPvCardTemp *)vCardTempForJID:(XMPPJID *)jid shouldFetch:(BOOL)shouldFetch;
 //更新自己的名片信息
 - (void)updateMyvCardTemp:(XMPPvCardTemp *)vCardTemp;
 //获取到一盒联系人的名片信息的回调
 - (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule
 didReceivevCardTemp:(XMPPvCardTemp *)vCardTemp
 forJID:(XMPPJID *)jid
 */

// 添加好友


//name为用户账号
- (void)XMPPAddFriendSubscribe:(NSString *)name
{
    //XMPPHOST 就是服务器名，  主机名
    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",name,@"puny.local"]];
    //[presence addAttributeWithName:@"subscription" stringValue:@"好友"];
    [self.xmppRoster subscribePresenceToUser:jid];
    
}

// 收到添加好友的请求
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    //取得好友状态
    NSString *presenceType = [NSString stringWithFormat:@"%@", [presence type]]; //online/offline
    //请求的用户
    NSString *presenceFromUser =[NSString stringWithFormat:@"%@", [[presence from] user]];
    NSLog(@"presenceType:%@",presenceType);
    
    NSLog(@"presence2:%@  sender2:%@",presence,sender);
    
    XMPPJID *jid = [XMPPJID jidWithString:presenceFromUser];
    //接收添加好友请求
    [self.xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
    
}
// 聊天室

- (void)initRoom
{
    XMPPJID *roomJID = [XMPPJID jidWithString:@"ROOMJID"];
    
    self.xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:self jid:roomJID];
    
    [self.xmppRoom activate:self.xmppStream];
    [self.xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    /*
     - (void)xmppRoomDidCreate:(XMPPRoom *)sender
     {
     DDLogInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
     }
     加入聊天室，使用昵称
     
     1
     [xmppRoom joinRoomUsingNickname:@"quack" history:nil];
     获取聊天室信息
     
     1
     2
     3
     4
     5
     6
     7
     - (void)xmppRoomDidJoin:(XMPPRoom *)sender
     {
     [xmppRoom fetchConfigurationForm];
     [xmppRoom fetchBanList];
     [xmppRoom fetchMembersList];
     [xmppRoom fetchModeratorsList];
     }
     */
}

#pragma mark - event
- (void)button1Click:(UIButton *)button
{
    // 登录
    [self connect];
}

- (void)button2Click:(UIButton *)button
{
    [self goOnline];
}
- (void)button3Click:(UIButton *)button
{
    [self goOffline];
}
- (void)button4Click:(UIButton *)button
{
    [self sendMessage:@"messageabc" toUser:@"puny"];
}
- (void)button5Click:(UIButton *)button
{
    [self XMPPAddFriendSubscribe:@"puny"];
}

- (void)button6Click:(UIButton *)button
{
   
}

- (void)button7Click:(UIButton *)button
{
    
}

@end
