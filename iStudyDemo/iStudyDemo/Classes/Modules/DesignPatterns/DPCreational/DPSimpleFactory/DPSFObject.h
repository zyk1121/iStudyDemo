//
//  DPSFObject.h
//  iStudyDemo
//
//  Created by zhangyuanke on 16/5/5.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DPSFSender <NSObject>

- (void)send;

@end

@interface DPSFMailSender : NSObject<DPSFSender>

@end

@interface DPSFSmsSender : NSObject<DPSFSender>

@end

// 简单工厂模式
// 简单工厂类
@interface DSFSSimpleFactory : NSObject

- (id<DPSFSender>)produce:(NSString *)type;

@end

/*02、多个方法
 是对普通工厂方法模式的改进，在普通工厂方法模式中，如果传递的字符串出错，则不能正确创建对象，而多个工厂方法模式是提供多个工厂方法，分别创建对象。*/

//@interface DSFSSendFactory : NSObject
//
//- (id<DPSFSender>)produceMail;
//- (id<DPSFSender>)produceSms;
//
//@end

@interface DSFSSendFactory : NSObject

+ (id<DPSFSender>)produceMail;
+ (id<DPSFSender>)produceSms;

@end

/*
03、多个静态方法
将上面的多个工厂方法模式里的方法置为静态的，不需要创建实例，直接调用即可。
*/


// 工厂方法模式

/*public class SendMailFactory implements Provider {
 
 @Override
 public Sender produce(){
 return new MailSender();
 }
 }
 [java] view plaincopy
 public class SendSmsFactory implements Provider{
 
 @Override
 public Sender produce() {
 return new SmsSender();
 }
 }  
 */

@interface SendMailFactory : NSObject

- (id<DPSFSender>)produce;

@end

@interface SendSmsFactory : NSObject

- (id<DPSFSender>)produce;

@end
