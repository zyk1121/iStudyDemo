//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    kLEDDigestMD5,
    kLEDDigestSHA1
} LEDDigestType;

@interface LEDDigest : NSObject

+ (LEDDigest *)md5Digest;
+ (LEDDigest *)sha1Digest;
+ (NSString *)md5DigestStringWithString:(NSString *)string;
+ (NSString *)md5DigestStringWithData:(NSData *)data;
+ (NSString *)sha1DigestStringWithString:(NSString *)string;
+ (NSString *)sha1DigestStringWithData:(NSData *)data;

- (instancetype)initWithDigestType:(LEDDigestType)aType;
- (void)reset;
- (void)addBytes:(void *)bytes length:(uint32_t)length;
- (void)addData:(NSData *)data;
- (void)addString:(NSString *)string;
- (unsigned char *)digestBytes;
- (NSString *)digestString;

@end