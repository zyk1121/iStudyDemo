//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "LEDRSACrypto.h"
#import <openssl/rsa.h>
#import <openssl/pem.h>
#include <openssl/md5.h>
#include <openssl/bio.h>
#include <openssl/sha.h>
#include <string.h>
#import <CommonCrypto/CommonDigest.h>
#define RSAPUBLICKEY @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDL7ig4RAWOrq1evFfCIVmQrHTw++Xb25cnRHraqivw75GiPJKzEKZbLSrzVKJty6mraeXTYW/X1ECpzSwdbrJLZSRSETvQTvz9w/xx2KgVO8q9KRSq9iyTtW4lbRgS9w1ciuDXSWF/QYmmxAsOutNiG8rkGrXZhGAVhTyH0s+FQQIDAQAB"

@implementation LEDRSACrypto {
    NSString *_keyString;
    NSMutableDictionary *_publicRSAs;
    dispatch_queue_t _accessPublicRSAQueue;
}

static LEDRSACrypto *sharedRSACryptor = nil;

+ (instancetype)sharedCrypto
{
    if (sharedRSACryptor) {
        return sharedRSACryptor;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedRSACryptor = [[self alloc] init];
    });
    
    return sharedRSACryptor;
}

- (id)init
{
    self = [super init];
    if (self) {
        _publicRSAs = [NSMutableDictionary dictionary];
        _accessPublicRSAQueue = dispatch_queue_create("access public key queue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (NSData *)encrypt:(NSData *)plainData
                key:(NSString *)key
{
    NSMutableData *resultData = nil;
    
    size_t plainLen = [plainData length];
    void *plain = malloc(plainLen);
    [plainData getBytes:plain
                 length:plainLen];
    
    resultData = [[NSMutableData alloc] init];
    
    RSA rsa = [self rsaPublicForKey:key];
    size_t cipherLen = RSA_size(&rsa);
    
    const size_t inputBlockSize = cipherLen - RSA_PKCS1_PADDING_SIZE;
    
    // RSA 最多加密长度为inputBlockSize，应该分段加密；
    for (size_t block = 0; block * inputBlockSize < plainLen; block++) {
        uint8_t *cipherBuffer = (uint8_t *) malloc(sizeof(uint8_t) * cipherLen);
        size_t blockOffset = block * inputBlockSize;
        const uint8_t *chunkToEncrypt = (plain + block * inputBlockSize);
        const size_t remainingSize = plainLen - blockOffset;
        const size_t subsize = remainingSize < inputBlockSize ? remainingSize : inputBlockSize;
        
        size_t actualOutputSize = 0;
        
        actualOutputSize = [self signWith:(char *)chunkToEncrypt
                                   length:subsize
                               cipherText:(char *)cipherBuffer
                                      rsa:rsa];
        
        if (actualOutputSize == -1) {
            free(plain);
            return nil;
        }
        
        [resultData appendBytes:cipherBuffer length:actualOutputSize];
        free(cipherBuffer);
    }
    free(plain);
    
    return resultData;
}

#pragma mark - openssl

- (NSString *)formatPublicKey:(NSString *)publicKey
{
    NSMutableString *result = [NSMutableString string];
    [result appendString:@"-----BEGIN PUBLIC KEY-----\n"];
    int count = 0;
    
    for (int i = 0; i < [publicKey length]; ++i) {
        
        unichar c = [publicKey characterAtIndex:i];
        if (c == '\n' || c == '\r') {
            continue;
        }
        [result appendFormat:@"%c", c];
        if (++count == 76) {
            [result appendString:@"\n"];
            count = 0;
        }
    }
    
    [result appendString:@"\n-----END PUBLIC KEY-----\n"];
    
    return result;
    
}

- (int)signWith:(char *)chunkToEncrypt length:(int)subsize cipherText:(char *)cipherBuffer rsa:(RSA)rsa
{
    int len = RSA_public_encrypt(subsize, (unsigned char *)chunkToEncrypt,(unsigned char*)cipherBuffer,&rsa,RSA_PKCS1_PADDING);
    return len;
}

- (NSString *)stringByComputingMD5:(NSString *)originString
{
    const char *ptr = [originString UTF8String];
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", md5Buffer[i]];
    }
    return output;
}


- (RSA)rsaPublicForKey:(NSString *)keyString
{
    keyString = [keyString length] > 0 ? keyString : RSAPUBLICKEY;
    __block NSValue *value;
    dispatch_sync(_accessPublicRSAQueue, ^{
        value = _publicRSAs[keyString];
    });
    if (value) {
        RSA result;
        [value getValue:&result];
        return result;
    } else {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *fileName = [self stringByComputingMD5:keyString];
        NSString *filePath = [NSString stringWithFormat:@"XM-RSAPublicKey-%@",fileName];
        NSString *path = [documentPath stringByAppendingPathComponent:filePath];
        
        // 把密钥写入文件
        NSString *formatKey = [self formatPublicKey:keyString];
        [formatKey writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        BIO *bioPublic = NULL;
        bioPublic = BIO_new(BIO_s_file());
        BIO_read_filename(bioPublic, (char *)[path UTF8String]);
        RSA *rsa = PEM_read_bio_RSA_PUBKEY(bioPublic, NULL, NULL, "");
        BIO_free(bioPublic);
        NSValue *value = [NSValue value:rsa withObjCType:@encode(RSA)];
        dispatch_barrier_sync(_accessPublicRSAQueue, ^{
            _publicRSAs[keyString] = value;
        });
        RSA result;
        [value getValue:&result];
        return result;
    }
}

@end
