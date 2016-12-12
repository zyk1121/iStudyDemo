//
//  SpeechSynthesizer.h
//  LDNaviKit
//
//  Created by 李帅 on 16/4/1.
//  Copyright © 2016年 AutoNavi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class WXMiFlySpeechPlayer;

@protocol SpeechSynthesizerDelegate <NSObject>

- (void)onCompleted:(NSError*) error;
- (void)onSpeakBegin;
@end

/**
 *  iOS7及以上版本可以使用 AVSpeechSynthesizer 合成语音
 *
 *  或者采用"科大讯飞"等第三方的语音合成服务
 */
@interface SpeechSynthesizer : NSObject

@property (nonatomic,weak) id<SpeechSynthesizerDelegate> delegate;

+ (instancetype)sharedSpeechSynthesizer;

- (void)speakString:(NSString *)string;

- (void)stopSpeak;



@end
