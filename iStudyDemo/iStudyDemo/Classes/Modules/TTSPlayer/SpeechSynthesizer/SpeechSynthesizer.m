//
//  SpeechSynthesizer.m
//  LDNaviKit
//
//  Created by 李帅 on 16/4/1.
//  Copyright © 2016年 AutoNavi. All rights reserved.
//

#import "SpeechSynthesizer.h"

@interface SpeechSynthesizer () <AVSpeechSynthesizerDelegate>

@property (nonatomic, strong) AVSpeechSynthesizer *speechSynthesizer;

@end

@implementation SpeechSynthesizer

+ (instancetype)sharedSpeechSynthesizer
{
    static id sharedInstance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      sharedInstance = [[SpeechSynthesizer alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self buildSpeechSynthesizer];
    }
    return self;
}

- (void)buildSpeechSynthesizer
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        return;
    }
    //简单配置一个AVAudioSession以便可以在后台播放声音
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionDuckOthers error:NULL];

    self.speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
    [self.speechSynthesizer setDelegate:self];
}

- (void)speakString:(NSString *)string
{
    if (self.speechSynthesizer) {
        AVSpeechUtterance *aUtterance = [AVSpeechUtterance speechUtteranceWithString:string];
        AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];

        aUtterance.voice = voice;
        //aUtterance.volume = 1;
        //aUtterance.pitchMultiplier = 1;

        //iOS语音合成在iOS8及以下版本系统上语速异常
        //        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        //            aUtterance.rate = 0.25; //iOS7设置为0.25
        //        }
        //        else if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
        //            aUtterance.rate = 0.15; //iOS8设置为0.15
        //        }
        //        else {
        aUtterance.rate = AVSpeechUtteranceDefaultSpeechRate + 0.02f;
        //        }

        if ([self.speechSynthesizer isSpeaking]) {
            [self.speechSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryWord];
        }

        [self.speechSynthesizer speakUtterance:aUtterance];
    }
}

- (void)stopSpeak
{
    if (self.speechSynthesizer) {
        [self.speechSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
    //[[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    if ([self.delegate respondsToSelector:@selector(onCompleted:)]) {
        [self.delegate onCompleted:nil];
    }
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterance
{
    //[[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    if ([self.delegate respondsToSelector:@selector(onSpeakBegin)]) {
        [self.delegate onSpeakBegin];
    }
}

@end
