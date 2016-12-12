//
//  XYMTTSPlayer.m
//  WXMapiPhone
//
//  Created by Leador  on 11-12-21.
//  Copyright (c) 2011年 IShowChina. All rights reserved.
//

#import "XYMTTSPlayer.h"
#import "WXMapAPPDefines.h"
#import "WXMDialectDefines.h"
#import "XYMCommonConfigUtility.h"
#import "ogg.h"
#import "vorbisfile.h"
#import "WXMVADefines.h"
#import "WXMVAManager.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>

#define LZL_VOICE_SPEED

typedef enum {
	TTSWaiting =	0,
	TTSGenPCM,
	TTSPCMFinish,
	TTSPlaying,
	TTSPlayEnd
} TTSStatus;

//#define DEBUG_TTS_PRIORITY 
//#define ivTTS_HEAP_SIZE		70000 /* 混合，音效 */
#define ivTTS_HEAP_SIZE		80*1024 /* 混合，音效 */

static TTSStatus _ttsStatus = TTSWaiting;
static NSMutableData *_pcmData = nil;
static BOOL _bInterruptionInOneSentence;

#pragma mark -
/* Message */
ivTTSErrID DoMessage()
{
	/* 获取消息，用户实现 */
	if(1)
	{
		/* 继续合成 */
		return ivTTS_ERR_OK;
	}
	else
	{
		/* 退出合成 */
		return ivTTS_ERR_EXIT;
	}
}

/* output callback */
ivTTSErrID OnOutput(
                    ivUInt16		nCode,			/* [in] output data code */
                    ivCPointer		pcData,			/* [in] output data buffer */
                    ivSize			nSize )			/* [in] output data size */
{
	/* play */
	NSData *buffer = [[NSData alloc] initWithBytes:pcData length:nSize];
    
    if (!_bInterruptionInOneSentence) {
        @synchronized(_pcmData) {
            [_pcmData appendData:buffer];
        }
    }
    
	[buffer release];
    
	return ivTTS_ERR_OK;
}

/* read resource callback */
ivBool ivCall ReadResCB(
                        ivPointer		pParameter,		/* [in] user callback parameter */
                        ivPointer		pBuffer,		/* [out] read resource buffer */
                        ivResAddress	iPos,			/* [in] read start position */
                        ivResSize		nSize )			/* [in] read size */
{
	FILE* pFile = (FILE*)pParameter;
    int err;
    
	fseek(pFile, iPos, SEEK_SET);
	err = (int)fread(pBuffer, 1, nSize, pFile);
    if ( err == (int)nSize )
	    return ivTrue;
    else
        return ivFalse;
}

/* output callback */
ivTTSErrID ivCall OutputCB(
                           ivPointer		pParameter,		/* [in] user callback parameter */
                           ivUInt16		nCode,			/* [in] output data code */
                           ivCPointer		pcData,			/* [in] output data buffer */
                           ivSize			nSize )			/* [in] output data size */
{
	/* 获取线程消息，是否退出合成 */
	ivTTSErrID tErr = DoMessage();
	if ( tErr != ivTTS_ERR_OK ) return tErr;
	/* 把语音数据送去播音 */
	return OnOutput(nCode, pcData, nSize);
}

/* parameter change callback */
ivTTSErrID ivCall ParamChangeCB(
                                ivPointer       pParameter,		/* [in] user callback parameter */
                                ivUInt32		nParamID,		/* [in] parameter id */
                                ivUInt32		nParamValue )	/* [in] parameter value */
{
	return ivTTS_ERR_OK;
}

/* progress callback */
ivTTSErrID ivCall ProgressCB(
                             ivPointer       pParameter,		/* [in] user callback parameter */
                             ivUInt32		iProcPos,		/* [in] current processing position */
                             ivUInt32		nProcLen )		/* [in] current processing length */
{
	return ivTTS_ERR_OK;
}

#pragma mark -

@interface XYMTTSPlayer () {
    BOOL    _isOggFilePlaying;
    dispatch_queue_t _playerSerialQueue;
    CTCallCenter *_callCenter;
}

@property (nonatomic, retain) NSMutableArray *playItemsArray;

- (void)addSubscriber:(id<TTSPlayerSubscriber>)subscriber;
- (void)removeSubscriber:(id<TTSPlayerSubscriber>)subscriber;

- (BOOL)prepareTTSEngine;
- (void)prepareBufferPlayer;
- (void)prepareTTSPlayer;
- (void)prepareTTS;
- (BOOL)switchTTSEngine2Role;
- (void)destroyTTSEngine;


- (void)ttsPlayItemBackground:(XYMTTSPlayItem *)item;
- (void)ttsPlayItem:(XYMTTSPlayItem *)item;
- (void)finishOneItem;

- (void)createWaitTimerInMainThread;
- (void)createWaitTimer;
- (void)destroyWaitTimerInMainThread;
- (void)destroyWaitTimer;
- (void)onWaitScheduleTimer;

- (void)collectTTSSubscribersBookInfo;
- (float)getPlayTextTimeCost:(NSString *)text;
- (float)getPlayItemTimeCost:(XYMTTSPlayItem *)item;
- (BOOL)isTimeEnoughForItem:(XYMTTSPlayItem *)item;

- (void)ttsSchedulePriority0:(XYMTTSPlayItem *)item;
- (void)ttsSchedulePriority1:(XYMTTSPlayItem *)item;
- (void)ttsSchedulePriority2:(XYMTTSPlayItem *)item;

- (void)ttsSchedulePlayItem:(XYMTTSPlayItem *)item;
- (void)scheduleItemToWaitArray:(XYMTTSPlayItem *) item;

- (XYMTTSPlayItem* )debugCreatePriority1Item;
- (XYMTTSPlayItem* )debugCreatePriority2Item;
- (void)switchDialectNotify;
@end

static XYMTTSPlayer *_globalTTSPlayer = nil;

@implementation XYMTTSPlayer
@synthesize subscriberArray = _subscriberArray;
@synthesize subscriberBookArray = _subscriberBookArray;
@synthesize waitPlayArray = _waitPlayArray;
@synthesize waitPlayTimer = _waitPlayTimer;
@synthesize player = _player;
@synthesize pcmPlayTimer = _pcmPlayTimer;
@synthesize pcmPlaying = _pcmPlaying;
@synthesize currentItem = _currentItem;


+ (id)shareInstanceWithSubscriber:(id<TTSPlayerSubscriber>)subscriber
{
    return nil;
    if (nil == _globalTTSPlayer) {
        _globalTTSPlayer = [[XYMTTSPlayer alloc] init];
    }
    
    [_globalTTSPlayer addSubscriber:subscriber];
    return _globalTTSPlayer;
}

+ (void)removeSubscriber:(id<TTSPlayerSubscriber>)subscriber
{    
    if ((nil == _globalTTSPlayer) || (nil == subscriber)) {
        return;
    }
    
    [_globalTTSPlayer removeSubscriber:subscriber];
    
    if (0 == [_globalTTSPlayer.subscriberArray count]) {
        [_globalTTSPlayer release];
        _globalTTSPlayer = nil;
    }
}

+ (AudioBufferPlayer *)getAudioBufferPlayer {
    if (nil != _globalTTSPlayer) {
        return _globalTTSPlayer.player;
    }
    
    return nil;
}
    
#pragma mark 初始化 & 释放
- (id)init{
	if ((self = [super init])) {
        _isOggFilePlaying = NO;
        _playerSerialQueue = dispatch_queue_create("com.ishowmap.ttsplayer", DISPATCH_QUEUE_SERIAL);
        
        [self prepareTTS];
        
        [self setupCallEvent];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchDialectNotify) name:WXF_SWITCH_DIALECT object:nil];
    }

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WXF_SWITCH_DIALECT object:nil];

    _callCenter.callEventHandler = nil;
    [_callCenter release];
    _callCenter = nil;
    
    [self destroyTTSEngine];

    dispatch_release(_playerSerialQueue);
    
    self.playItemsArray = nil;
    
    [_currentItem release];
    _currentItem = nil;
    
    if (_itemFinishHandler)
    {
        [_itemFinishHandler release];
        _itemFinishHandler = nil;
    }
    
	[_player release];
    _player = nil;
    
	[_pcmData release];
    _pcmData = nil;
    
    [_subscriberArray release];
    _subscriberArray = nil;
    
    [_subscriberBookArray release];
    _subscriberBookArray = nil;

    [self destroyWaitTimer];
    
    [_waitPlayArray release];
    _waitPlayArray = nil;
    
    [self destroyPcmPlayTimerWithWaitingDone:YES];
    
    [super dealloc];
}

- (void)setupCallEvent
{
#ifdef DUCK_MIXABLE_AUDIO
    __block XYMTTSPlayer *weakSelf = self;
    _callCenter = [[CTCallCenter alloc] init];
    _callCenter.callEventHandler = ^(CTCall * call) {
        if ([call.callState isEqualToString:CTCallStateDialing]
            || [call.callState isEqualToString:CTCallStateIncoming]
            || [call.callState isEqualToString:CTCallStateConnected]) {
            weakSelf.isPhoneCalling = YES;
            [weakSelf.player stop];
        } else {
            weakSelf.isPhoneCalling = NO;
            [weakSelf onInterruptionEnd];
        }
    };
#endif
}

#pragma mark 订阅者管理或者通知
- (void)addSubscriber:(id<TTSPlayerSubscriber>)subscriber {
    if (subscriber == nil) {
        return;
    }
    
    if (nil == self.subscriberArray) {
        NSMutableArray* tempArray = [[NSMutableArray alloc] init];
        self.subscriberArray = tempArray;
        [tempArray release];
        tempArray = nil;
    }
    
    if (![self.subscriberArray containsObject:subscriber]) {
        [self.subscriberArray addObject:subscriber];
    }
    
    return;
}

- (void)removeSubscriber:(id<TTSPlayerSubscriber>)subscriber {
    if (nil == subscriber) {
        return;
    }
    
    [self.subscriberArray removeObject:subscriber];
}

#pragma mark tts引擎
- (BOOL)createTTSEngine:(NSString *)resourceFolder role:(int)role {
#if TARGET_IPHONE_SIMULATOR
#else
	// Create the synthesizer before we create the AudioBufferPlayer, because
	// the AudioBufferPlayer will ask for buffers right away when we start it.
	// Create the AudioBufferPlayer, set ourselves as the delegate, and start it.
	_pHeap = (ivPByte)malloc(ivTTS_HEAP_SIZE);
	memset(_pHeap, 0, ivTTS_HEAP_SIZE);
	
	/* 初始化资源 */
	_tResPackDesc.pCBParam = fopen([resourceFolder UTF8String], "rb");
	_tResPackDesc.pfnRead = ReadResCB;
	_tResPackDesc.pfnMap = NULL;
	_tResPackDesc.nSize = 0;
	
	/* TTS内部使用 */
	_tResPackDesc.pCacheBlockIndex = NULL;
	_tResPackDesc.pCacheBuffer = NULL;
	_tResPackDesc.nCacheBlockSize = 0;
	_tResPackDesc.nCacheBlockCount = 0;
	_tResPackDesc.nCacheBlockExt = 0;
	
	
	if(!_tResPackDesc.pCBParam) {
		return FALSE;
	}
	
	/* 创建 TTS 实例 */
	_ivReturn = ivTTS_Create(&_hTTS, (ivPointer)_pHeap, ivTTS_HEAP_SIZE, ivNull, (ivPResPackDescExt)&_tResPackDesc, (ivSize)1, NULL);
	/*
	 //使用Log，就将最后1个参数设为&tUserInfo
	 ivReturn = ivTTS_Create(&_hTTS, (ivPointer)_pHeap, ivTTS_HEAP_SIZE, ivNull, (ivPResPackDescExt)&tResPackDesc, (ivSize)1,&tUserInfo);
	 */
	
	/* 设置音频输出回调 */
	_ivReturn = ivTTS_SetParam(_hTTS, ivTTS_PARAM_OUTPUT_CALLBACK, (ivSize)OutputCB);
	/* 设置参数改变回调 */
	_ivReturn = ivTTS_SetParam(_hTTS, ivTTS_PARAM_PARAMCH_CALLBACK, (ivSize)ParamChangeCB);
	/* 设置处理进度回调 */
	_ivReturn = ivTTS_SetParam(_hTTS, ivTTS_PARAM_PROGRESS_CALLBACK, (ivSize)ProgressCB);
	
	/* 设置输入文本代码页 */
	_ivReturn = ivTTS_SetParam(_hTTS, ivTTS_PARAM_INPUT_CODEPAGE, ivTTS_CODEPAGE_UTF8);
	
	/* 设置语种 */
	_ivReturn = ivTTS_SetParam(_hTTS, ivTTS_PARAM_LANGUAGE, ivTTS_LANGUAGE_AUTO);	
	
	/* 设置音量 */
	_ivReturn = ivTTS_SetParam(_hTTS, ivTTS_PARAM_VOLUME, ivTTS_VOLUME_MAX);
	
	/************************************************************************
	 块式合成
	 ************************************************************************/
	
	/* 设置发音人*/
//	_ivReturn = ivTTS_SetParam(_hTTS, ivTTS_PARAM_ROLE, role);
    
#ifdef LZL_VOICE_SPEED
    if (role == ivTTS_ROLE_USER) {
        _ivReturn = ivTTS_SetParam( _hTTS, ivTTS_PARAM_VOICE_SPEED,2000);
    }
    else {
        _ivReturn = ivTTS_SetParam( _hTTS, ivTTS_PARAM_VOICE_SPEED,0);
    }
#endif
#endif
    
    return TRUE;
}

- (BOOL)prepareTTSEngine {
#if TARGET_IPHONE_SIMULATOR
#else
    [self switchTTSEngine2Role];
#endif
    return TRUE;
}

- (void)destroyTTSEngine {
#if TARGET_IPHONE_SIMULATOR
#else
    if (NULL == _hTTS) {
        return;
    }
    
	_ivReturn = ivTTS_Destroy(_hTTS);
    _hTTS = NULL;
    
	if (_tResPackDesc.pCacheBlockIndex) {
		free(_tResPackDesc.pCacheBlockIndex);
        _tResPackDesc.pCacheBlockIndex = NULL;
	}
	if (_tResPackDesc.pCacheBuffer) {
		free(_tResPackDesc.pCacheBuffer);
        _tResPackDesc.pCacheBuffer = NULL;
	}
	if (_pHeap) {
		free(_pHeap);
        _pHeap = NULL;
	}
    
    fclose((FILE*)_tResPackDesc.pCBParam);
    _tResPackDesc.pCBParam = NULL;
#endif
}


- (void)prepareBufferPlayer {
	_player = [[AudioBufferPlayer alloc] initWithSampleRate:16000.0f channels:1 bitsPerChannel:16 packetsPerBuffer:1024];
	_player.delegate = self;

#ifndef DUCK_MIXABLE_AUDIO
	[_player start];
#endif
}

- (void)prepareTTSPlayer {
    if (nil == _pcmData) {
        _pcmData = [[NSMutableData alloc] init];
    }

    NSMutableArray* bookArray = [[NSMutableArray alloc] init];
    self.subscriberBookArray = bookArray;
    [bookArray release];
    bookArray = nil;
    
    NSMutableArray* waitArray = [[NSMutableArray alloc] init];
    self.waitPlayArray = waitArray;
    [waitArray release];
    waitArray = nil;
    
    NSMutableArray* itemsArray = [[NSMutableArray alloc] init];
    self.playItemsArray = itemsArray;
    [itemsArray release];
    
	_ttsStatus = TTSWaiting;
}

- (void)prepareTTS {
    [self prepareTTSPlayer];
    [self prepareTTSEngine];
    [self prepareBufferPlayer];
}

#pragma mark TTS内部处理
- (void)ttsPlayItemBackground:(XYMTTSPlayItem *)item {
#if TARGET_IPHONE_SIMULATOR
#else 
    @synchronized(self) {
        _bInterruptionInOneSentence = NO;
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        NSString *cleanString = [item.playText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
       
        if(cleanString && cleanString.length) {
             NSLog(@"ttsPlayItemBackground:%@",item.playText);
            _ttsStatus = TTSGenPCM;
            _ivReturn = ivTTS_SynthText(_hTTS, ivText([cleanString UTF8String]), -1);
            _ttsStatus = TTSPCMFinish;
        }
        
        [pool release];
    }
#endif
}

- (void)ttsPlayItem:(XYMTTSPlayItem *)item {
//    [self performSelectorInBackground:@selector(ttsPlayItemBackground:) withObject:item];
    
    if (self.isPhoneCalling) {
        return;
    }
    
    dispatch_async(_playerSerialQueue, ^{
        _bInterruptionInOneSentence = NO;
        
        [self.playItemsArray addObject:item];
        
        if ([self isPcmPlayEnd]) {
            [self ttsPlayNextItem];
        }
    });
}

- (void)ttsPlayNextItem
{
#if TARGET_IPHONE_SIMULATOR
#else
    dispatch_async(_playerSerialQueue, ^{
        if (self.playItemsArray.count == 0) {
            return;
        }
        
        if (_bInterruptionInOneSentence) {
            [self.playItemsArray removeAllObjects];
            return;
        }
        
        sleep(0.1); //for TTS crash issue
        
        @autoreleasepool {
            //获取下一个需要播放的item
            //(现在的策略是直接获取队列中第一个item，将来可以根据需要添加优先级判断)
            NSUInteger index = 0;
            XYMTTSPlayItem *item = self.playItemsArray[index];
            
            //交给TTS进行合成
            NSString *playText = [item.playText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if(playText.length > 0) {
                //防止连续播报时第一个字和最后一个字的听觉截断，此处各追加一个不播报的字符
                playText = [NSString stringWithFormat:@".%@.", playText];
                
                _ttsStatus = TTSGenPCM;
                _ivReturn = ivTTS_SynthText(_hTTS, ivText([playText UTF8String]), -1);
                _ttsStatus = TTSPCMFinish;
            }
            
            //从playItemsArray中移除即将播放的item
            [self.playItemsArray removeObjectAtIndex:index];
            
#ifdef DUCK_MIXABLE_AUDIO
            //启动播放
            //NSLog(@"[liyd]ready to play text %@", playText);
            [self.player start];
#endif
        } //@autoreleasepool end
    });
#endif
}

- (void)onInterruptionBegin {
    [self destroPcmPlayTimer];
    [self.player tearDownAudio];
}

- (void)onInterruptionEnd {
    _isOggFilePlaying = NO;
    _ttsStatus = TTSWaiting;
    _bInterruptionInOneSentence = YES;
    
    dispatch_async(_playerSerialQueue, ^{
        [self.playItemsArray removeAllObjects];
    });
    
    [self destroPcmPlayTimer];
    
    //清空等待数据和当前的播放数据
    [self.waitPlayArray removeAllObjects];
    @synchronized(_pcmData) {
        [_pcmData setData:nil];
        _playLocation = 0;
    }
    
#ifdef DUCK_MIXABLE_AUDIO
    [self.player resetupAudioSession];
    [self.player stop];
#else
    [self.player setUpAudio];
    [self.player start];
#endif
}

#pragma mark 等待队列排工定时器
- (void)destroyWaitTimerInMainThread {
    [self.waitPlayTimer invalidate];
    self.waitPlayTimer = nil;
    
    tts_NSLog(@"destroyWaitTimerInMainThread");
}

- (void)destroyWaitTimer {
    [self performSelectorOnMainThread:@selector(destroyWaitTimerInMainThread) withObject:nil waitUntilDone:YES];
}

- (void)onWaitScheduleTimer {
    tts_NSLog(@"onWaitScheduleTimer");
    if (0 == [self.waitPlayArray count]) {
        [self destroyWaitTimer];
    }
    
    //更新预定状态
    [self collectTTSSubscribersBookInfo];
    
    //更新delay时间
    NSMutableIndexSet *removeSet = nil;
    for (int i = 0; i < [self.waitPlayArray count]; i++) {
        XYMTTSPlayItem* playItem = [self.waitPlayArray objectAtIndex:i];
        
        if (playItem.delaySecond > 0) {
            playItem.delaySecond--;
        }
        
        if (0 == playItem.delaySecond) {
            if (nil == removeSet) {
                removeSet = [[NSMutableIndexSet alloc] init];
            }
            
            [removeSet addIndex:i];
        }
    }
    
    //移除过期的信息
    if (nil != removeSet) {
        [self.waitPlayArray removeObjectsAtIndexes:removeSet];
        [removeSet release];
        removeSet = nil;
    }
    
    tts_NSLog(@"onWaitScheduleTimer 420");
    
    if (0 != [self.waitPlayArray count]) {
        XYMTTSPlayItem* playItem = [self.waitPlayArray objectAtIndex:0];
        if ([self isTimeEnoughForItem:playItem]) {
            tts_NSLog(@"onWaitScheduleTimer play wait item play item = %@", playItem.playText);
            
            [self ttsPlayItem:playItem];
            [self.waitPlayArray removeObjectAtIndex:0];
        }
    }
}

- (void)createWaitTimerInMainThread {
    [self destroyWaitTimer];
    self.waitPlayTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onWaitScheduleTimer) userInfo:nil repeats:YES];
    
    tts_NSLog(@"createWaitTimerInMainThread");
}

- (void)createWaitTimer {
    [self performSelectorOnMainThread:@selector(createWaitTimerInMainThread) withObject:nil waitUntilDone:YES];
}

#pragma mark tts播报排工
- (void)collectTTSSubscribersBookInfo {
    tts_NSLog(@"collectTTSSubscribersBookInfo");
    [self.subscriberBookArray removeAllObjects];
    
    for (int i = 0; i < [self.subscriberArray count]; i++) {
        id<TTSPlayerSubscriber> subcriber = [self.subscriberArray objectAtIndex:i];
        if ([subcriber respondsToSelector:@selector(ttsSubscriberBookStatus:)]) {
            [subcriber ttsSubscriberBookStatus:self.subscriberBookArray];
        }
    }
}

- (float)getPlayTextTimeCost:(NSString *)text {
    return [text length] * TTS_TIMESPAN_PER_CHAR;
}

- (float)getPlayItemTimeCost:(XYMTTSPlayItem *)item {
    return [self getPlayTextTimeCost:item.playText];
}

- (BOOL)isTimeEnoughForItem:(XYMTTSPlayItem *)item {
    NSRange itemRange = NSMakeRange(0, (int)[self getPlayItemTimeCost:item]);
    
    for (int i = 0; i < [self.subscriberBookArray count]; i++) {
        NSRange range = [[self.subscriberBookArray objectAtIndex:i] rangeValue];
        
        tts_NSLog(@"isTimeEnoughForItem location = %d, length = %d", range.location, range.length);
        
        NSRange interSection = NSIntersectionRange(itemRange, range);
        if (interSection.length != 0) {
            return FALSE;
        }
    }
    
    return TRUE;
}

- (void)scheduleItemToWaitArray:(XYMTTSPlayItem *) item {
    [self.waitPlayArray addObject:item];

    if (nil == self.waitPlayTimer) {
        [self createWaitTimer];
    }
}

- (void)ttsSchedulePriority0:(XYMTTSPlayItem *)item {
    //最高等级，直接播放
    [self ttsPlayItem:item];
}

- (void)ttsSchedulePriority1:(XYMTTSPlayItem *)item {
    //收集预定信息
    [self collectTTSSubscribersBookInfo];
    
    if ([self isTimeEnoughForItem:item]) {
        //时间足够
        [self ttsPlayItem:item];
#ifdef DEBUG_TTS
        tts_NSLog(@"ttsSchedulePriority1 直接播放字符串=%@", item.playText);
#endif 
    } else {
        //时间不够，则进行等待队列
        [self scheduleItemToWaitArray:item];
#ifdef DEBUG_TTS
        tts_NSLog(@"ttsSchedulePriority1 进入播放队列字符串=%@", item.playText);
#endif 
    }
}

- (void)ttsSchedulePriority2:(XYMTTSPlayItem *)item {
    //收集预定信息
    [self collectTTSSubscribersBookInfo];
    
    if ([self isTimeEnoughForItem:item]) {
#ifdef DEBUG_TTS
        tts_NSLog(@"ttsSchedulePriority2 直接播放字符串=%@", item.playText);
#endif 

        [self ttsPlayItem:item];
    } else {
#ifdef DEBUG_TTS
        tts_NSLog(@"ttsSchedulePriority2 丢弃播放字符串=%@", item.playText);
#endif 
    }
}

- (void)ttsSchedulePlayItem:(XYMTTSPlayItem *)item {
#if TARGET_IPHONE_SIMULATOR
#else
//    if (!self.bufferPlayer.playing) {
//        return;
//    }
    
    switch (item.playPriority) {
        case TTS_PLAY_PRIORITY_0:
            [self ttsSchedulePriority0:item];
            break;

        case TTS_PLAY_PRIORITY_1:
            [self ttsSchedulePriority1:item];
            break;
            
        case TTS_PLAY_PRIORITY_2:
            [self ttsSchedulePriority2:item];
            break;
            
        default:
            break;
    }
#endif    
}

#pragma mark AudioBufferPlayerDelegate
- (void)audioBufferPlayer:(AudioBufferPlayer*)audioBufferPlayer fillBuffer:(AudioQueueBufferRef)buffer format:(AudioStreamBasicDescription)audioFormat
{
	memset(buffer->mAudioData, 0, buffer->mAudioDataBytesCapacity);
    
#ifdef DUCK_MIXABLE_AUDIO
    UInt32 bufferLength = 0;
    
	@synchronized(_pcmData) {
		if(_pcmData.length > _playLocation) {
            bufferLength = (UInt32)(_pcmData.length - _playLocation);
            
            if (bufferLength > buffer->mAudioDataBytesCapacity) {
                bufferLength = buffer->mAudioDataBytesCapacity;
            }
            
			[_pcmData getBytes:buffer->mAudioData range:NSMakeRange(_playLocation, bufferLength)];

            _playLocation += bufferLength;
		} else {
			bufferLength = 0;
		}
	}
    
    // We have to tell the buffer how many bytes we wrote into it.
    buffer->mAudioDataByteSize = bufferLength;
#else
	static NSInteger bufferLength = 0;
    
	@synchronized(_pcmData) {
		if(_pcmData.length > 0) {
			if(_pcmData.length >= (_playLocation+buffer->mAudioDataBytesCapacity)) {
				bufferLength = buffer->mAudioDataBytesCapacity;
			} else {
				bufferLength = _pcmData.length-_playLocation;
			}
			[_pcmData getBytes:buffer->mAudioData range:NSMakeRange(_playLocation, bufferLength)];

            _playLocation += bufferLength;
		} else {
			bufferLength = buffer->mAudioDataBytesCapacity;
		}
	}
	
    // We have to tell the buffer how many bytes we wrote into it. 
    buffer->mAudioDataByteSize = buffer->mAudioDataBytesCapacity;
#endif
    
	if(_ttsStatus == TTSPCMFinish && bufferLength <= 0) {
		_ttsStatus = TTSPlayEnd;
        [self finishOneItem];
	}
}

- (BOOL)switchTTSEngine2Role {
    NSString* rftFolder = nil;
    int role = ivTTS_ROLE_XIAOYAN;

    //销毁旧的引擎
    [self destroyTTSEngine];
    
    NSString *dialect = [XYMCommonConfigUtility commonConfig].dialectPlayName;
    
    if (dialect) {
        if([dialect isEqualToString:WXM_DIALECT_DEFAULT2]){
            rftFolder = [WXM_HOME_DIALECT_DIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.irf", WXM_DIALECT_DEFAULT2]];
            role = ivTTS_ROLE_USER;
        }else{
            rftFolder = [WXM_HOME_DIALECT_DIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.irf", dialect]];
        }
    }

    //资源文件为空或者不存在，则将资源文件置为默认的ivTTS_ROLE_XIAOYAN
    if ((nil == rftFolder) || (![[NSFileManager defaultManager] fileExistsAtPath:rftFolder])) {
        rftFolder = [[NSBundle mainBundle] pathForResource:@"Resource" ofType:@"irf"];
        role = ivTTS_ROLE_XIAOYAN;
    }
    
    return [self createTTSEngine:rftFolder role:role];
}

#pragma mark --
- (BOOL)isPcmPlayEnd {
    if (![_pcmData length] && !_playLocation && (_ttsStatus == TTSWaiting || _ttsStatus == TTSPCMFinish)) {
        return YES;
    }
    else {
        return NO;
    }
}
- (void)destroyPcmPlayTimerInMainThread {
    [self.pcmPlayTimer invalidate];
    self.pcmPlayTimer = nil;
    
    _pcmPlaying = NO;
    
    tts_NSLog(@"destroyPcmPlayTimerInMainThread");
}

- (void)destroPcmPlayTimer {
    [self destroyPcmPlayTimerWithWaitingDone:NO];
}

- (void)destroyPcmPlayTimerWithWaitingDone:(BOOL)waiting {
    [self performSelectorOnMainThread:@selector(destroyPcmPlayTimerInMainThread) withObject:nil waitUntilDone:waiting];
}

- (void)onPcmPlayScheduleTimer {
    tts_NSLog(@"onPcmPlayScheduleTimer");
    if ([self isPcmPlayEnd] && (fabs([[NSDate date] timeIntervalSince1970]-_pcmPlayStart) > _pcmConst)) {
        [self destroPcmPlayTimer];
        //重置语音播放
        [XYMCommonConfigUtility commonConfig].mixSoundClose = NO;
        
        if (![XYMCommonConfigUtility commonConfig].cancelSoundInterrupt) {
            [self onInterruptionEnd];
        }
    }
}

- (void)createPcmPlayTimerInMainThread {
    [self destroyPcmPlayTimerInMainThread];
    self.pcmPlayTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onPcmPlayScheduleTimer) userInfo:nil repeats:YES];
    
    tts_NSLog(@"createPcmPlayTimerInMainThread");
}

- (void)createPcmPlayTimer {
    [self performSelectorOnMainThread:@selector(createPcmPlayTimerInMainThread) withObject:nil waitUntilDone:YES];
}

#pragma mark TTS对外接口
- (void)ttsPlay:(XYMTTSPlayItem *)item {
    if (_isOggFilePlaying) return;
    
#if TARGET_IPHONE_SIMULATOR
#else

    self.currentItem = item;
#ifdef DEBUG_TTS_PRIORITY
    XYMTTSPlayItem* item1 = [self debugCreatePriority2Item];
    [self ttsSchedulePlayItem:item1];
#endif

    [self ttsSchedulePlayItem:item];
    
    if (_pcmPlaying) {
        _pcmPlayStart = [[NSDate date] timeIntervalSince1970];
        _pcmConst = [self getPlayTextTimeCost:item.playText];
        [self createPcmPlayTimer];
    }
    
#endif    
}


-(void)ttsPlay:(XYMTTSPlayItem *)item withCompleteHandler:(TTSPlayDoneHandler)handler
{
    if (_isOggFilePlaying) return;
    
#if TARGET_IPHONE_SIMULATOR
#else
    
    self.currentItem = item;
//    self.itemFinishHandler = handler;
    [_itemFinishHandler release];
    _itemFinishHandler = [handler copy];
    
#ifdef DEBUG_TTS_PRIORITY
    XYMTTSPlayItem* item1 = [self debugCreatePriority2Item];
    [self ttsSchedulePlayItem:item1];
#endif
    
    [self ttsSchedulePlayItem:item];
    
    if (_pcmPlaying) {
        _pcmPlayStart = [[NSDate date] timeIntervalSince1970];
        _pcmConst = [self getPlayTextTimeCost:item.playText];
        [self createPcmPlayTimer];
    }
    
#endif
}

- (void)finishOneItem {
	@synchronized(_pcmData) {
        [_pcmData setData:nil];
		_playLocation = 0;
	}
    
	_ttsStatus = TTSWaiting;
    
    [self ttsPlayNextItem];
    
    if (_isOggFilePlaying) {
        _isOggFilePlaying = NO;
        
        for (int i = 0; i < [self.subscriberArray count]; i++) {
            id<TTSPlayerSubscriber> subcriber = [self.subscriberArray objectAtIndex:i];
            if ([subcriber respondsToSelector:@selector(oggFilePlayEnd)]) {
                [subcriber oggFilePlayEnd];
            }
        }
    }
    
    [self ttsExcuetAndRemoveVAHandler];
}


- (void)startAudioService {
#ifndef DUCK_MIXABLE_AUDIO
    [self.player start];
#endif
}

- (void)stopAudioService {
	@synchronized(_pcmData) {
        [_pcmData setData:nil];
		_playLocation = 0;
	}
    
#ifndef DUCK_MIXABLE_AUDIO
    [self.player stop];
#endif
    
	_ttsStatus = TTSWaiting;
}

-(void)ttsExcuetAndRemoveVAHandler
{
    if (_currentItem && _currentItem.tag == WXM_TAG_VA)
    {
        if (_itemFinishHandler)
        {
            _itemFinishHandler(_currentItem);
            [_itemFinishHandler release];
            _itemFinishHandler = nil;
            
            [self ttsRemoveVAHandler];
        }
        self.currentItem = nil;
        
    }

}

-(void)ttsRemoveVAHandler
{
    for (int i = 0; i < [self.subscriberArray count]; i++)
    {
        id<TTSPlayerSubscriber> subcriber = [self.subscriberArray objectAtIndex:i];
        if ([subcriber isKindOfClass:[WXMVAManager class]])
        {
            ((WXMVAManager *)subcriber).itemFinishHandler = nil;
            break;
        }
    }
}

- (BOOL)playOggFile:(NSString *)oggFile {
    if (_isOggFilePlaying) return NO;
    
    OggVorbis_File vf;
    
    _isOggFilePlaying = YES;
    
    FILE* oggHandle = fopen([oggFile UTF8String], "rb");
    if (oggHandle == NULL) {
        _isOggFilePlaying = NO;
        return NO;
    }
    
    if (ov_open_callbacks(oggHandle, &vf, NULL, 0, OV_CALLBACKS_DEFAULT) < 0) {
        fclose(oggHandle);
        _isOggFilePlaying = NO;
        return NO;
    }
    
//    vorbis_info* vi = ov_info(&vf, -1);
//    int rate = vi->rate;
//    int channels = vi->channels;
    ov_pcm_total(&vf, -1);
    
    _ttsStatus = TTSGenPCM;
    
    BOOL isEnd = NO;
    char pcmBuffer[4096];
    while (!isEnd) {
        long ret = ov_read(&vf, pcmBuffer, sizeof(pcmBuffer), 0, 2, 1, 0);
        if (ret <= 0) {
            isEnd = YES;
        } else {
            /* 获取线程消息，是否退出合成 */
            ivTTSErrID tErr = DoMessage();
            if ( tErr != ivTTS_ERR_OK )
                break;
            /* 把语音数据送去播音 */
            @synchronized(_pcmData) {
                [_pcmData appendBytes:pcmBuffer length:ret];
            }
        }
    }
    ov_clear(&vf);
    fclose(oggHandle);
    
    _ttsStatus = TTSPCMFinish;
    
    return _isOggFilePlaying;
}

#pragma mark debug 
- (XYMTTSPlayItem* )debugCreatePriority1Item {
    XYMTTSPlayItem* item = [[XYMTTSPlayItem alloc] init];
    item.playText = @"测试北四环拥堵，其他路线都比较畅通";
    item.playPriority = TTS_PLAY_PRIORITY_1;
    item.delaySecond = 60;
    return [item autorelease];
}

- (XYMTTSPlayItem* )debugCreatePriority2Item {
    XYMTTSPlayItem* item = [[XYMTTSPlayItem alloc] init];
    item.playText = @"测试优先级最低的等级";
    item.playPriority = TTS_PLAY_PRIORITY_2;
    item.delaySecond = 60;
    return [item autorelease];
}

- (void)switchDialectNotify
{
    [self switchTTSEngine2Role];
}
@end
