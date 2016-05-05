//
//  DPSFObject.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/5/5.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "DPSFObject.h"

@implementation DPSFMailSender

-(void)send
{
    NSLog(@"Mail sender");
}

@end


@implementation DPSFSmsSender

-(void)send
{
    NSLog(@"Sms sender");
}

@end


@implementation DSFSSimpleFactory

- (id<DPSFSender>)produce:(NSString *)type
{
    if ([type isEqualToString:@"sms"]) {
        return [DPSFSmsSender new];
    } else if ([type isEqualToString:@"mail"]){
        return [DPSFMailSender new];
    } else {
    }
    return nil;
}

@end

//@implementation DSFSSendFactory
//
//- (id<DPSFSender>)produceMail
//{
//    return [DPSFMailSender new];
//}
//- (id<DPSFSender>)produceSms
//{
//    return [DPSFSmsSender new];
//}
//
//@end

@implementation DSFSSendFactory

+ (id<DPSFSender>)produceMail
{
    return [DPSFMailSender new];
}
+ (id<DPSFSender>)produceSms
{
    return [DPSFSmsSender new];
}

@end


// 工厂方法模式

@implementation SendMailFactory

- (id<DPSFSender>)produce
{
     return [DPSFMailSender new];
}

@end

@implementation SendSmsFactory

- (id<DPSFSender>)produce
{
     return [DPSFSmsSender new];
}

@end
