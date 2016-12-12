//
//  XYMTTSPlayItem.m
//  WXMapiPhone
//
//  Created by Leador  on 12-1-7.
//  Copyright (c) 2012年 IShowChina. All rights reserved.
//

#import "XYMTTSPlayItem.h"

@implementation XYMTTSPlayItem
@synthesize playText = _playText;
@synthesize playPriority = _playPriority;
@synthesize delaySecond = _delaySecond;
@synthesize tag = _tag;

#pragma mark 初始化 & 释放
- (id) initWithText:(NSString*) text priority:(TTSPlayPriority) priority delaySecond:(int)delay {
    if (self = [super init]) {
        self.playText = text;
        self.playPriority = priority;
        self.delaySecond = delay;
    }
    
    return self;
}

- (void) dealloc {
    [_playText release];
    _playText = nil;
    
    [super dealloc];
}


@end
