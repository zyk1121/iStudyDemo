//
//  WXMiFlySpeechPlayer.h
//  WXMapiPhone
//
//  Created by ishowmap on 16/6/30.
//
//

#import <Foundation/Foundation.h>
#import "TTS/ivTTS.h"
#import "AudioBufferPlayer.h"
#import "XYMTTSPlayItem.h"
#import "iflyMSC/IFlyMSC.h"

@interface WXMiFlySpeechPlayer : NSObject

@property (atomic, assign) BOOL isPhoneCalling;

+ (instancetype)sharediFlySpeechPlayer;
// 配置入口
- (void)configIFlySpeech;
// 语音播放
- (void)play:(XYMTTSPlayItem *)item;
// 停止语音
- (void)stopPlay;

@end
