//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//
//

#import <Foundation/Foundation.h>

@interface NSString(LEDDigest)

/*
 MD5即Message Digest Algorithm 5（信息-摘要算法 5），用于确保信息传输完整一致。是计算机广泛使用的杂凑算法之一
 SHA即Secure Hash Algorithm（安全散列算法) 是美国国家安全局 (NSA) 设计，美国国家标准与技术研究院 (NIST) 发布的一系列密码散列函数。
 */
- (NSString *)led_SHA1String;
- (NSString *)led_MD5String;

@end
