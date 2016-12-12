//
//  WXMiFlySpeechPlayer.m
//  WXMapiPhone
//
//  Created by ishowmap on 16/6/30.
//
//

#import "WXMiFlySpeechPlayer.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import "WXMapAPPDefines.h"
#import "WXMToastView.h"
#import "SpeechSynthesizer.h"
#import "WXMNetworkReachability.h"

@interface WXMiFlySpeechPlayer ()<IFlySpeechSynthesizerDelegate,SpeechSynthesizerDelegate>
{
    dispatch_queue_t _playerSerialQueue;
    CTCallCenter *_callCenter;
    BOOL _isSpeeking;
}

@property (nonatomic, strong) NSMutableArray *playItemsArray;

@end

@implementation WXMiFlySpeechPlayer

+ (instancetype)sharediFlySpeechPlayer
{
    static WXMiFlySpeechPlayer *sharedConfiger;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedConfiger = [[WXMiFlySpeechPlayer alloc] init];
    });
    return sharedConfiger;
}

- (void)configIFlySpeech
{
    [IFlySetting showLogcat:NO];
    [IFlySpeechUtility createUtility:[NSString stringWithFormat:@"appid=%@,timeout=%@",IflyAPPID,@"20000"]];
    
    [IFlySetting setLogFile:LVL_NONE];
    
    // 设置语音合成的参数
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"50" forKey:[IFlySpeechConstant SPEED]];//合成的语速,取值范围 0~100
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"66" forKey:[IFlySpeechConstant VOLUME]];//合成的音量;取值范围 0~100
    
    // 发音人,默认为”xiaoyan”;可以设置的参数列表可参考个 性化发音人列表;
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"xiaoyan" forKey:[IFlySpeechConstant VOICE_NAME]];
    
    // 音频采样率,目前支持的采样率有 16000 和 8000;
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    
    // 当你再不需要保存音频时，请在必要的地方加上这行。
    [[IFlySpeechSynthesizer sharedInstance] setParameter:nil forKey:[IFlySpeechConstant TTS_AUDIO_PATH]];
    
    // 提前播放一句话，用于解决语音播放延迟问题
    XYMTTSPlayItem *item = [[XYMTTSPlayItem alloc] initWithText:@"......." priority:0 delaySecond:0];
    [self play:item];
    
     [SpeechSynthesizer sharedSpeechSynthesizer].delegate = self;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _isSpeeking = NO;
        _playerSerialQueue = dispatch_queue_create("com.ishowmap.iflyplayer", DISPATCH_QUEUE_SERIAL);
        _playItemsArray = [[NSMutableArray alloc] init];
        [IFlySpeechSynthesizer sharedInstance].delegate = self;
    
    }
    return self;
}


- (void)dealloc
{
    [[IFlySpeechSynthesizer sharedInstance] stopSpeaking];
    [IFlySpeechSynthesizer sharedInstance].delegate = nil;
    [_playItemsArray removeAllObjects];
}

- (void)setupCallEvent
{
    __weak WXMiFlySpeechPlayer *weakSelf = self;
    _callCenter = [[CTCallCenter alloc] init];
    _callCenter.callEventHandler = ^(CTCall * call) {
        if ([call.callState isEqualToString:CTCallStateDialing]
            || [call.callState isEqualToString:CTCallStateIncoming]
            || [call.callState isEqualToString:CTCallStateConnected]) {
            weakSelf.isPhoneCalling = YES;
            [weakSelf stopPlay];
        } else {
            weakSelf.isPhoneCalling = NO;
            [weakSelf onInterruptionEnd];
        }
    };
}

#pragma mark - public 

- (void)play:(XYMTTSPlayItem *)item// 语音播放队列
{
    NSString *playText = [item.playText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([playText length] == 0) {
        return ;
    }
    if (self.isPhoneCalling) {
        return;
    }
    
    dispatch_async(_playerSerialQueue, ^{
        
        [self.playItemsArray addObject:item];
        
        if (![self isSpeecking]) {
            [self playNextItem];
        }
    });
}

- (BOOL)isSpeecking
{
    return _isSpeeking;
}

- (void)stopPlay
{
    [[IFlySpeechSynthesizer sharedInstance] stopSpeaking];
    [[SpeechSynthesizer sharedSpeechSynthesizer] stopSpeak];
    dispatch_async(_playerSerialQueue, ^{
        [self.playItemsArray removeAllObjects];
        _isSpeeking = NO;
    });
}

- (void)onInterruptionEnd
{
    dispatch_async(_playerSerialQueue, ^{
        [self.playItemsArray removeAllObjects];
    });
    [self stopPlay];
}

- (void)playNextItem
{
    dispatch_async(_playerSerialQueue, ^{
        if (self.playItemsArray.count == 0) {
            return;
        }
        
        if([self isSpeecking]) {
            return;
        }
        
        @autoreleasepool {
            //获取下一个需要播放的item
            //(现在的策略是直接获取队列中第一个item，将来可以根据需要添加优先级判断)
            NSUInteger index = 0;
            XYMTTSPlayItem *item = self.playItemsArray[index];
            
            //交给TTS进行合成
            NSString *playText = [item.playText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if(playText.length > 0) {
                // 播放
                WXMNetworkStatus curStatus = [[WXMNetworkReachability reachability] getCurrentNetworkStatus];
                if (curStatus != kNotReachable)
                {
                    //防止连续播报时第一个字和最后一个字的听觉截断，此处各追加一个不播报的字符
                    playText = [NSString stringWithFormat:@".%@.", playText];
                    [[IFlySpeechSynthesizer sharedInstance] startSpeaking:playText];
                }else{
                    [[SpeechSynthesizer sharedSpeechSynthesizer] speakString:playText];
                }
                _isSpeeking = YES;
            } else {
                if (self.playItemsArray.count) {
                    [self.playItemsArray removeObjectAtIndex:0];
                    [self playNextItem];
                }
            }
        }
    });
}

// 测试代码
- (void)test
{
    XYMTTSPlayItem *item1 = [[XYMTTSPlayItem alloc] initWithText:@"开始导航，全程共2.5公里，大约25分钟" priority:0 delaySecond:0];
    XYMTTSPlayItem *item2 = [[XYMTTSPlayItem alloc] initWithText:@"开始导航，全程共2.5公里，大约25分钟" priority:0 delaySecond:0];
    XYMTTSPlayItem *item3 = [[XYMTTSPlayItem alloc] initWithText:@"开始导航，全程共2.5公里，大约25分钟" priority:0 delaySecond:0];
    [self play:item1];
    [self play:item2];
    [self play:item3];
}

#pragma mark - IFlySpeechSynthesizerDelegate

- (void)onSpeakBegin
{
    [[AVAudioSession sharedInstance] setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
}

/**
 *  结束回调
 *  当整个合成结束之后会回调此函数
 *
 *  @param error 错误码
 */
- (void)onCompleted:(IFlySpeechError*) error
{
    _isSpeeking = NO;
    if (self.playItemsArray.count) {
        [self.playItemsArray removeObjectAtIndex:0];
    }
    if (error.errorCode == 0 || error == nil) {
        // 成功，播放下一条数据
        if (self.playItemsArray.count) {
            [self playNextItem];
        }
    }
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
}

@end
