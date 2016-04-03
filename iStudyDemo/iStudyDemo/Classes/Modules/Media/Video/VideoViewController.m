//
//  VideoViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/29.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "VideoViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreMedia/CoreMedia.h>

// http://www.tuicool.com/articles/qmMVbe

/*
 在iOS开发中，播放视频通常有两种方式，一种是使用MPMoviePlayerController（需要导入MediaPlayer.Framework），还有一种是使用AVPlayer。关于这两个类的区别可以参考http://stackoverflow.com/questions/8146942/avplayer-and-mpmovieplayercontroller-differences，简而言之就是MPMoviePlayerController使用更简单，功能不如AVPlayer强大，而AVPlayer使用稍微麻烦点，不过功能更加强大。
 */


/*
 使用AVPlayer播放视频必须知道的三个类
 
 1.1 AVPlayer : 同样理解成播放器
 
 1.2 AVPlayerItem : 同样是播放器需要播放的资源,比如一首歌曲
 
 1.3 AVPlayerLayer : 要显示视频我们就要把AVPlayerLayer对象加到要显示的视图的layer层上,因此我们只要能拿到AVPlayer的layer,然后把拿到的layer 赋值给 AVPlayerLayer对象即可
 

 */
@interface VideoViewController ()

@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button3;
@property (nonatomic, strong) UIButton *button4;

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.button1 = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
        [button setTitle:@"播放视频" forState:UIControlStateNormal];
        [button setTitle:@"播放视频" forState:UIControlStateHighlighted];
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
    [self setupPlayer];

}

- (void)setupPlayer
{
    //创建一个item
//    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"xwlb"] ofType:@"mp4"];
    //讲layer添加到当期页面的layer层中
//    [self.view.layer addSublayer:playerLayer];
    //播发器开始播放
//    [self.player play];
}

//+ (Class)layerClass {
//    return [AVPlayerLayer class];
//}

- (AVPlayerLayer *)playerLayer
{
    if (_playerLayer == nil) {
        NSURL *url = [NSURL URLWithString:@"http://192.168.120.234:8888/xwlb.mp4"];
        AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
        //初始化播放器
        AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:item];
        //获取播放器的layer
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
        //设置播放器的layer
        _playerLayer.frame = CGRectMake(0, 225, SCREEN_WIDTH, SCREEN_HEIGHT - 225);
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;// AVLayerVideoGravityResizeAspectFill AVLayerVideoGravityResizeAspect
        _playerLayer.backgroundColor = [[UIColor lightGrayColor] CGColor];
    }
    return _playerLayer;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.playerLayer) {
       [self.view.layer addSublayer:self.playerLayer];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.playerLayer) {
        [_playerLayer removeFromSuperlayer];
        _playerLayer.player = nil;
        _playerLayer = nil;
    }
}

- (void)button1Click:(UIButton *)button
{
    [self.playerLayer.player play];
    
}
- (void)button2Click:(UIButton *)button
{
    [self.playerLayer.player pause];
}
- (void)button3Click:(UIButton *)button
{
    [self.playerLayer.player play];
}
- (void)button4Click:(UIButton *)button
{
//    if (self.playerLayer) {
//        [_playerLayer removeFromSuperlayer];
//        _playerLayer.player = nil;
//        NSURL *url = [NSURL URLWithString:@"http://192.168.120.234:8888/xwlb.mp4"];
//        AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
//        //初始化播放器
//        AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:item];
//        _playerLayer.player = player;
//        [_playerLayer.player play];
//        _playerLayer = nil;
//    }
//    if (self.playerLayer) {
//        [self.view.layer addSublayer:self.playerLayer];
//        [self.playerLayer.player play];
//    }
    
    
    [self.playerLayer.player seekToTime:CMTimeMake(0, 30)];
    [self.playerLayer.player play];
    
    /*
     CMTimeMake和CMTimeMakeWithSeconds 详解
     CMTimeMake(a,b)    a当前第几帧, b每秒钟多少帧.当前播放时间a/b
     
     CMTimeMakeWithSeconds(a,b)    a当前时间,b每秒钟多少帧.
     
     CMTimeMake
     
     CMTime CMTimeMake (
     int64_t value,
     int32_t timescale
     );
     CMTimeMake顧名思義就是用來建立CMTime用的,
     但是千萬別誤會他是拿來用在一般時間用的,
     CMTime可是專門用來表示影片時間用的類別,
     他的用法為: CMTimeMake(time, timeScale)
     
     time指的就是時間(不是秒),
     而時間要換算成秒就要看第二個參數timeScale了.
     timeScale指的是1秒需要由幾個frame構成(可以視為fps),
     因此真正要表達的時間就會是 time / timeScale 才會是秒.
     
     簡單的舉個例子
     
     CMTimeMake(60, 30);
     CMTimeMake(30, 15);
     在這兩個例子中所表達在影片中的時間都皆為2秒鐘,
     但是影隔播放速率則不同, 相差了有兩倍.
     */
}
- (void)dealloc
{
   
}

@end
