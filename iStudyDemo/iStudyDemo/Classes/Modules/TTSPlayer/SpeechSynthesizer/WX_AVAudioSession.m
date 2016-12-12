//
//  WX_AVAudioSession.m
//  WXMapiPhone
//
//  Created by 李帅 on 16/12/12.
//
//

#import "WX_AVAudioSession.h"

@implementation WX_AVAudioSession

- (BOOL)setCategory:(NSString *)category withOptions:(AVAudioSessionCategoryOptions)options error:(NSError **)outError
{
    [super setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionDuckOthers error:nil];
    return NO;
}

@end
