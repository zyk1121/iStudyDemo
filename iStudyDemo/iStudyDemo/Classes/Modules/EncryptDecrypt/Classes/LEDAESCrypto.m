//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "LEDAESCrypto.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation LEDAESCrypto

static LEDAESCrypto *sharedAESCryptor = nil;

+ (instancetype)sharedCrypto
{
    if (sharedAESCryptor) {
        return sharedAESCryptor;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAESCryptor = [[self alloc] init];
    });
    
    return sharedAESCryptor;
}

- (NSData *)encrypt:(NSData *)plainData key:(NSString *)key
{
    return [[self class] encrypt:plainData key:key iv:nil];
}

- (NSData *)decrypt:(NSData *)cipherData key:(NSString *)key
{
    return [[self class] decrypt:cipherData key:key iv:nil];
}

+ (NSData *)encrypt:(NSData *)plainData
                key:(NSString *)key
                 iv:(NSString *)iv
{
    return [self AES128Operation:kCCEncrypt data:plainData key:key iv:iv];
}

+ (NSData *)decrypt:(NSData *)cipherData
                key:(NSString *)key
                 iv:(NSString *)iv
{
    return [self AES128Operation:kCCDecrypt data:cipherData key:key iv:iv];
}

+ (NSData *)AES128Operation:(CCOperation)operation
                       data:(NSData *)data
                        key:(NSString *)key
                         iv:(NSString *)iv
{
    char keyPtr[kCCKeySizeAES128 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128 + 1];
    bzero(ivPtr, sizeof(ivPtr));
    if (iv) {
        [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    }
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          ivPtr,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}

@end
