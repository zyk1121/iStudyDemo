//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "LEDDigest.h"
#import <CommonCrypto/CommonDigest.h>

@implementation LEDDigest
{
    CC_MD5_CTX *md5Ctx;
    CC_SHA1_CTX *sha1Ctx;
    unsigned char *result;
    LEDDigestType type;
}

#pragma mark - init & release

+ (LEDDigest *)md5Digest
{
    return [[self alloc] initWithDigestType:kLEDDigestMD5];
}

+ (LEDDigest *)sha1Digest
{
    return [[self alloc] initWithDigestType:kLEDDigestSHA1];
}

+ (NSString *)md5DigestStringWithString:(NSString *)string
{
    LEDDigest *digest = [self md5Digest];
    [digest addString:string];
    return [digest digestString];
}

+ (NSString *)md5DigestStringWithData:(NSData *)data
{
    LEDDigest *digest = [self md5Digest];
    [digest addData:data];
    return [digest digestString];
}

+ (NSString *)sha1DigestStringWithString:(NSString *)string
{
    LEDDigest *digest = [self sha1Digest];
    [digest addString:string];
    return [digest digestString];
}

+ (NSString *)sha1DigestStringWithData:(NSData *)data
{
    LEDDigest *digest = [self sha1Digest];
    [digest addData:data];
    return [digest digestString];
}

- (id)init
{
    return [self initWithDigestType:kLEDDigestMD5];
}

- (id)initWithDigestType:(LEDDigestType)aType
{
    if (self = [super init]) {
        md5Ctx = NULL;
        sha1Ctx = NULL;
        result = NULL;
        type = aType;
        [self reset];
    }
    return self;
}

- (void)dealloc
{
    if (md5Ctx) {
        free(md5Ctx);
    }
    if (sha1Ctx) {
        free(sha1Ctx);
    }
    if (result) {
        free(result);
    }
}

- (void)reset
{
    if (result) {
        free(result);
        result = NULL;
    }
    
    switch(type) {
        case kLEDDigestSHA1:
            result = malloc(CC_SHA1_DIGEST_LENGTH);
            if (sha1Ctx) {
                free(sha1Ctx);
            }
            sha1Ctx = malloc(sizeof(CC_SHA1_CTX));
            CC_SHA1_Init(sha1Ctx);
        break;
        case kLEDDigestMD5:
        default:
            result = malloc(CC_MD5_DIGEST_LENGTH);
            if (md5Ctx) {
                free(md5Ctx);
            }
            md5Ctx = malloc(sizeof(CC_MD5_CTX));
            CC_MD5_Init(md5Ctx);
        break;
    }
}

#pragma mark - create digest

- (void)addBytes:(void *)bytes length:(uint32_t)length
{
    if (!bytes) {
        length = 0;
    }
    
    switch (type) {
        case kLEDDigestSHA1:
            CC_SHA1_Update(sha1Ctx, bytes, length);
            break;
        
        case kLEDDigestMD5:
        default:
            CC_MD5_Update(md5Ctx, bytes, length);
            break;
    }
}

- (void)addData:(NSData *)data
{
    switch (type) {
        case kLEDDigestSHA1:
            CC_SHA1_Update(sha1Ctx, [data bytes], (CC_LONG)[data length]);
            break;
        
        case kLEDDigestMD5:
        default:
            CC_MD5_Update(md5Ctx, [data bytes], (CC_LONG)[data length]);
            break;
    }
}

- (void)addString:(NSString *)str
{
    switch (type) {
        case kLEDDigestSHA1:
            CC_SHA1_Update(sha1Ctx, [str UTF8String], (CC_LONG)[str lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
        break;
        case kLEDDigestMD5:
        default:
            CC_MD5_Update(md5Ctx, [str UTF8String], (CC_LONG)[str lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
        break;
    }
}

- (unsigned char *)digestBytes
{
    [self getDigest];
    return result;
}

- (NSString *)digestString
{
    [self getDigest];
    
    NSString *resultStr = nil;
    
    switch (type) {
        case kLEDDigestSHA1:
        resultStr = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                     result[0], result[1],
                     result[2], result[3],
                     result[4], result[5],
                     result[6], result[7],
                     result[8], result[9],
                     result[10], result[11],
                     result[12], result[13],
                     result[14], result[15],
                     result[16], result[17],
                     result[18], result[19]
                     ];
        break;
        case kLEDDigestMD5:
        default:
        resultStr = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                     result[0], result[1],
                     result[2], result[3],
                     result[4], result[5],
                     result[6], result[7],
                     result[8], result[9],
                     result[10], result[11],
                     result[12], result[13],
                     result[14], result[15]
                     ];
        break;
    }
    
    return resultStr;
}

- (void)getDigest
{
    switch (type) {
        case kLEDDigestSHA1:
            CC_SHA1_Final(result, sha1Ctx);
        break;
        case kLEDDigestMD5:
            CC_MD5_Final(result, md5Ctx);
            default:
        break;
    }
}
@end
