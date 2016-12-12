//
//  AVAudioSession+change.m
//  WXMapiPhone
//
//  Created by 李帅 on 16/12/12.
//
//

#import "AVAudioSession+change.h"
#import "WX_AVAudioSession.h"
#import <objc/message.h>

@implementation AVAudioSession (change)

//-(NSString *)category
//{
//    object_setClass(self, [WX_AVAudioSession class]);
//    
//    return @"AVAudioSessionCategoryPlayback";
//}

+(void)load
{
    Method m1 = class_getInstanceMethod([self class], @selector(setCategory2:withOptions:error:));
    
    Method m2 = class_getInstanceMethod([self class], @selector(setCategory:withOptions:error:));
    
    method_exchangeImplementations(m1,m2);
}


- (BOOL)setCategory2:(NSString *)category withOptions:(AVAudioSessionCategoryOptions)options error:(NSError **)outError
{
    return [self setCategory2:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionDuckOthers error:nil];
}

@end
