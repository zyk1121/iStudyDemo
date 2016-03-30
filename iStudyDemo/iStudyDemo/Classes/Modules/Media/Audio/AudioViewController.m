//
//  AudioViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/29.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "AudioViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreMedia/CoreMedia.h>

/*
 Bool     meteringEnabled 可以监控音量变化
 double     volume=1.0;//设置音量
 setDelegate设置代理
 这两个属性可以监控音频的回放进度
 double f=player.duration//音乐的播放总时间
 double      currentTime //当前播放的时间
 bool    playing//判断是否正在播放
 integer   numberOfLoops ；//设置循环播放的此次
 方法：
 -（double） averagePowerForChannel：0//平均音量
 -（double） peakPowerForChannel：0//最高音量
 -(void) updateMeters //更新音量
 -(void)prepareToPlay];//准备播放
 -(void) play;//播放
 -(void) pause//暂停;
 -(void)stop//停止
 
 
 文／陈旭冉（简书作者）
 原文链接：http://www.jianshu.com/p/cf111537f542
 著作权归作者所有，转载请联系作者获得授权，并标注“简书作者”。
 
 - (IBAction)restart:(id)sender
 {
 [[AFSoundManager sharedManager] restart];
 _audioPlayer = nil;
 currentTrackNumber = 0;
 [self startPlaying];
 }
 
 文／陈旭冉（简书作者）
 原文链接：http://www.jianshu.com/p/cf111537f542
 著作权归作者所有，转载请联系作者获得授权，并标注“简书作者”。
 
 - (void)startPlaying
 {
 if (_audioPlayer) {
 [_audioPlayer stop];
 _audioPlayer = nil;
 } else {
 _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[[NSString alloc] initWithString:[_arrayOfTracks objectAtIndex:currentTrackNumber]] ofType:@"mp3"]] error:NULL];
 _audioPlayer.delegate = self;
 [_audioPlayer play];
 }
 }
 
 */
@interface AudioViewController ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button3;
@property (nonatomic, strong) UIButton *button4;

@property (nonatomic, strong) NSMutableDictionary *lrcDic;
@property (nonatomic, strong) NSMutableArray *lrcTimeAry;

@end

@implementation AudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setAudioName:nil];
    [self parserLrc];
    self.button1 = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
        [button setTitle:@"播放音乐" forState:UIControlStateNormal];
        [button setTitle:@"播放音乐" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(button1Click:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    
    self.button2 = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH, 40)];
        [button setTitle:@"暂停" forState:UIControlStateNormal];
        [button setTitle:@"暂停" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(button2Click:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    
    self.button3 = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 144, SCREEN_WIDTH, 40)];
        [button setTitle:@"继续" forState:UIControlStateNormal];
        [button setTitle:@"继续" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(button3Click:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    
    self.button4 = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 184, SCREEN_WIDTH, 40)];
        [button setTitle:@"重播" forState:UIControlStateNormal];
        [button setTitle:@"重播" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(button4Click:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
}

#pragma mark - event

- (void)button1Click:(UIButton *)button
{
    [self.audioPlayer play];
}
- (void)button2Click:(UIButton *)button
{
    [self.audioPlayer pause];
}
- (void)button3Click:(UIButton *)button
{
    [self.audioPlayer play];
}
- (void)button4Click:(UIButton *)button
{

    self.audioPlayer = nil;
    NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"情非得已"] ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;//传地址,就说明要在该方法内部对对象进行修改;
    //初始化一个播放器;
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    if (error == nil) {
        NSLog(@"正常播放");
    } else {
        NSLog(@"播放失败%@", error);
    }
    self.audioPlayer.delegate = self;
    
    [self.audioPlayer play];
    
}


//对歌词进行解析;
- (void)parserLrc {
    
    //读取歌词内容;
    
    NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"情非得已"] ofType:@"lrc"];
    //NSString *error = nil;
    NSString *contentStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    // NSLog(@"%@",contentStr);
    self.lrcDic = [NSMutableDictionary dictionaryWithCapacity:0];
    self.lrcTimeAry = [NSMutableArray arrayWithCapacity:0];
    //换行进行分割; 获取每一行的歌词;
    NSArray *linArr = [contentStr componentsSeparatedByString:@"\n"];
    
    // NSLog(@"linArr= %@",linArr);
    for (NSString *string in linArr) {
        if (string.length > 7) {
            NSString *str1 = [string substringWithRange:NSMakeRange(3, 1)];
            NSString *str2 = [string substringWithRange:NSMakeRange(6, 1)];
            if ([str1 isEqualToString:@":"]&&[str2 isEqualToString:@"."]) {
                // NSLog(@"%@",string);
                //截取歌词和时间;
                NSString *timeStr = [string substringWithRange:NSMakeRange(1, 5)];
                NSString *lrcStr = [string substringFromIndex:10   ];
                //NSLog(@"%@,%@",timeStr,lrcStr);
                //放入集合中;
                [self.lrcTimeAry addObject:timeStr];
                [self.lrcDic setObject:lrcStr forKey:timeStr];
                
            }
        }
    }
    NSLog(@"%@",self.lrcDic);
    // 使用tableView播放歌词
    /*
     //计时器关联的方法;
     - (void)changTime {
     NSString *currentString = [self timeStringFromSecond:self.audioPlayer.currentTime];
     self.progressSlider.value  = self.audioPlayer.currentTime;
     self.currentTImeLabel.text = currentString;
     //判断数组是否包含某个元素;
     if ([self.lrcTimeAry containsObject:currentString]) {
     self.line = [self.lrcTimeAry indexOfObject:currentString];
     [self.lrcTableView reloadData];
     //选中 tableView 的这一行;
     NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.line inSection:0];
     [self.lrcTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
     
     
     }
     
     }
     */
    
}

- (void)setAudioName:(NSString *)name
{
    
    NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"情非得已"] ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;//传地址,就说明要在该方法内部对对象进行修改;
    //初始化一个播放器;
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    if (error == nil) {
        NSLog(@"正常播放");
    } else {
        NSLog(@"播放失败%@", error);
    }
    self.audioPlayer.delegate = self;
    
    
    //    NSFileManager *fileManage = [NSFileManager defaultManager];
    //    if(![fileManage fileExistsAtPath:PathOfFileNamed(name)]){
    //        [self performSelector:@selector(showAlertViewWithMessage:) withObject:@"语音文件不存在" afterDelay:.5];
    //        return ;
    //    }
//    NSURL *audioURL = [NSURL URLWithString:@"情非得已.mp3"];
//    
//    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:audioURL options:nil];
//    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:urlAsset];;
//    self.mediaPlayer = [AVPlayer playerWithPlayerItem:playerItem];
//    
//    ALog(@"totalDuration %f",totalDuration);
//    CMTime totalTime = playerItem.duration;  //获取音频的总时间
//    totalDuration = (CGFloat)totalTime.value/totalTime.timescale;
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [player play];
}

/*
 //远程控制;
 - (void)remoteControlReceivedWithEvent:(UIEvent *)event {
 switch (event.subtype) {
 case UIEventSubtypeRemoteControlPlay:
 NSLog(@"播放");
 break;
 case UIEventSubtypeRemoteControlStop:
 NSLog(@"停止播放");
 break;
 case UIEventSubtypeRemoteControlPause:
 NSLog(@"暂停");
 break;
 case UIEventSubtypeRemoteControlNextTrack:
 NSLog(@"下一曲");
 break;
 case UIEventSubtypeRemoteControlPreviousTrack:
 NSLog(@"上一曲");
 break;
 default:
 break;
 }
 
 
 
 
 
 }
 
 */

@end
