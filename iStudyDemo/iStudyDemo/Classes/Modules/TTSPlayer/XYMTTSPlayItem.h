//
//  XYMTTSPlayItem.h
//  WXMapiPhone
//
//  Created by Leador  on 12-1-7.
//  Copyright (c) 2012年 IShowChina. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TTS_PLAY_PRIORITY_0,//立刻播放（导航引导信息）
    TTS_PLAY_PRIORITY_1,//可以暂缓播放，超过时限就丢弃（前方路况雷达）
    TTS_PLAY_PRIORITY_2,//当前不能够播放，就丢弃
    TTS_PLAY_PRIORITY_COUNT,
}TTSPlayPriority;

#define WXM_TAG_VA       1000

@interface XYMTTSPlayItem : NSObject
{
    NSString* _playText;//播放字符串
    TTSPlayPriority _playPriority;//播放优先级
    int _delaySecond;//从当前时间计时，可以延缓的时间长度（单位秒）
    int _tag;
}
@property (nonatomic,  retain) NSString* playText;
@property (nonatomic, assign) TTSPlayPriority playPriority;
@property (nonatomic, assign) int delaySecond;
@property (nonatomic, assign) int tag;
- (id) initWithText:(NSString*) text priority:(TTSPlayPriority) priority delaySecond:(int)delay;
@end
