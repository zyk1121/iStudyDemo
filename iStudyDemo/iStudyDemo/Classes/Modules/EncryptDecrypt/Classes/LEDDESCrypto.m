//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "LEDDESCrypto.h"
#import <Security/Security.h>

#define NUMBER_OF_CHARS 8  // 随机产出的密钥长度，DES为8位，

#define Alphabet @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"// DES 密钥将从其中

static LEDDESCrypto *sharedDESCryptor = nil;

@implementation LEDDESCrypto {
    NSString *_desKey;//
}

+ (instancetype)sharedCrypto
{
    if (sharedDESCryptor) {
        return sharedDESCryptor;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDESCryptor = [[self alloc] init];
    });
    
    return sharedDESCryptor;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self resetDESKey];
    }
    
    return self;
}

- (NSString *)resetDESKey
{
    NSMutableString *key = [[NSMutableString alloc] init];
    for (int x = 0;x < NUMBER_OF_CHARS; x ++ ) {
        NSString *letter = [Alphabet substringWithRange:NSMakeRange((arc4random_uniform(62)), 1)];
        [key appendString:letter];
    }
    _desKey =  key;
    
    return _desKey;
}

- (NSData *)encrypt:(NSData *)data
                key:(NSString *)key
{
    char keyPtr[kCCKeySizeDES+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    if (!key) {
        [_desKey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    } else {
        [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    }
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeDES;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCBlockSizeDES,
                                          keyPtr,// 实际运用中，密钥只用到了64位中的56位，这个向量必须与服务器保持一致，目前服务器采用密钥的8位；
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    NSData *result = nil;
    if (cryptStatus == kCCSuccess) {
        result =  [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    } else {
        free(buffer);
    }
    
    return result;
}

- (NSData *)decrypt:(NSData *)data
                key:(NSString *)key
{
    char keyPtr[kCCKeySizeDES+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    if (!key) {
        [_desKey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    } else {
        [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    }
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeDES;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCBlockSizeDES,
                                          keyPtr, // 实际运用中，密钥只用到了64位中的56位，这个向量必须与服务器保持一致，目前服务器采用密钥的8位；
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);
    
    NSData *result = nil;
    if (cryptStatus == kCCSuccess) {
        result =  [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    } else {
        free(buffer);
    }
        
    return result;
}
@end
