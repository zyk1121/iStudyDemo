//
//  LDKTimer.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/27.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "LDKTimer.h"

@interface LDKTimer ()

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, weak) NSTimer* timer;

@end

@implementation LDKTimer


- (void) fire:(NSTimer *)timer {
    if(self.target) {
        [self.target performSelector:self.selector withObject:timer.userInfo];
    } else {
        [self.timer invalidate];
    }
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      target:(id)aTarget
                                    selector:(SEL)aSelector
                                    userInfo:(id)userInfo
                                     repeats:(BOOL)repeats {
    LDKTimer* timerTarget = [[LDKTimer alloc] init];
    timerTarget.target = aTarget;
    timerTarget.selector = aSelector;
    timerTarget.timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                         target:timerTarget
                                                       selector:@selector(fire:)
                                                       userInfo:userInfo
                                                        repeats:repeats];
    return timerTarget.timer;
}

- (void)dealloc
{
  
}

@end
