//
//  XYMTTSPlayer.h
//  WXMapiPhone
//
//  Created by Leador  on 11-12-21.
//  Copyright (c) 2011年 IShowChina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTS/ivTTS.h"
#import "AudioBufferPlayer.h"
#import "XYMTTSPlayItem.h"
#import "iflyMSC/IFlyMSC.h"

#define TTS_TIMESPAN_PER_CHAR 0.25
#define TTS_MAX_BOOK_TIME (1000 * 60) //最大值预定为1000分钟

@protocol TTSPlayerSubscriber<NSObject>
@optional
- (void)ttsSubscriberBookStatus:(NSMutableArray *)bookArray;
- (void)oggFilePlayEnd;
@end

typedef void(^TTSPlayDoneHandler) (XYMTTSPlayItem *item);

@interface XYMTTSPlayer : NSObject <AudioBufferPlayerDelegate>
{
	AudioBufferPlayer	*_player;
    NSUInteger           _playLocation;
    
	ivHTTS				_hTTS;
	ivPByte				_pHeap;
	ivTResPackDescExt	_tResPackDesc;
	ivTTTsUserInfo		_tUserInfo;
	ivTTSErrID			_ivReturn;
    
    NSMutableArray      *_subscriberArray;//每一个成员为id<TTSPlayerSubscriber>
    NSMutableArray      *_subscriberBookArray;//每一个成员预定的时间

    NSTimer             *_waitPlayTimer;//查看是否可以播放等待play的timer
    NSMutableArray      *_waitPlayArray;//等待play的内容队列
    
    NSTimer             *_pcmPlayTimer;
    BOOL                _pcmPlaying;
    NSTimeInterval      _pcmPlayStart; 
    float               _pcmConst;
    XYMTTSPlayItem       *_currentItem;
    TTSPlayDoneHandler  _itemFinishHandler;
}
@property (nonatomic, retain) NSMutableArray* subscriberArray;
@property (nonatomic, retain) NSMutableArray* subscriberBookArray;
@property (nonatomic, retain) NSMutableArray* waitPlayArray;
@property (nonatomic, retain) NSTimer* waitPlayTimer;
@property (nonatomic, readonly) AudioBufferPlayer* player;
@property (nonatomic, retain) NSTimer *pcmPlayTimer;
@property (nonatomic, assign) BOOL pcmPlaying;
@property (nonatomic, retain) XYMTTSPlayItem *currentItem;

@property (atomic, assign) BOOL isPhoneCalling;

+ (id)shareInstanceWithSubscriber:(id<TTSPlayerSubscriber>)subscriber;
+ (void)removeSubscriber:(id<TTSPlayerSubscriber>)subscriber;

+ (AudioBufferPlayer *)getAudioBufferPlayer;

- (void)ttsPlay:(XYMTTSPlayItem *)item;
- (void)ttsPlay:(XYMTTSPlayItem *)item withCompleteHandler:(TTSPlayDoneHandler )handler;
- (void)ttsExcuetAndRemoveVAHandler;
- (void)ttsRemoveVAHandler;
- (void)stopAudioService;

- (void)onInterruptionBegin;
- (void)onInterruptionEnd;
- (BOOL)isPcmPlayEnd;
- (void)destroPcmPlayTimer;

- (BOOL)playOggFile:(NSString *)oggFile;

@end
