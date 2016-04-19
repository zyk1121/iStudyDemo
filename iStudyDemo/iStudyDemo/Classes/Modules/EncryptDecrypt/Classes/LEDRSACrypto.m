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

/*
 最近几天折腾了一下如何在iOS上使用RSA来加密。iOS上并没有直接的RSA加密API。但是iOS提供了x509的API，而x509是支持RSA加密的。因此，我们可以通过制作自签名的x509证书（由于对安全性要求不高，我们并不需要使用CA认证的证书），再调用x509的相关API来进行加密。接下来记录一下整个流程。
 第一步，制作自签名的证书
 1.最简单快捷的方法，打开Terminal，使用openssl（Mac OS X自带）生成私钥和自签名的x509证书。
 openssl req -x509 -out public_key.der -outform der -new -newkey rsa:1024 -keyout private_key.pem -days 3650
 按照命令行的提示输入内容就行了。
 几个说明：
 public_key.der是输出的自签名的x509证书，即我们要用的。
 private_key.pem是输出的私钥，用来解密的，请妥善保管。
 rsa:1024这里的1024是密钥长度，1024是比较安全的，如果需要更安全的话，可以用2048，但是加解密代价也会增加。
 -days：证书过期时间，一定要加上这个参数，默认的证书过期时间是30天，一般我们不希望证书这么短就过期，所以写上比较合适的天数，例如这里的3650(10年)。
 事实上，这一行命令包含了好几个步骤（我研究下面这些步骤的原因是我手头已经由一个private_key.pem私钥了，想直接用这个来生成x509证书，也就是用到了下面的2-3）
 1)创建私钥
 openssl genrsa -out private_key.pem 1024
 2)创建证书请求（按照提示输入信息）
 openssl req -new -out cert.csr -key private_key.pem
 3)自签署根证书
 openssl x509 -req -in cert.csr -out public_key.der -outform der -signkey private_key.pem -days 3650
 2.验证证书。把public_key.der拖到xcode中，如果文件没有问题的话，那么就可以直接在xcode中打开，看到证书的各种信息。
 
 第二步，使用public_key.der来进行加密。
 1.导入Security.framework。
 2.把public_key.der放到mainBundle中（一般直接拖到Xcode就行啦）。
 3.从public_key.der读取公钥。
 4.加密。
 下面是参考代码（只能用于加密长度小于等于116字节的内容，适合于对密码进行加密。使用了ARC，不过还是要注意部分资源需要使用CFRealse来释放）
 RSA.h
 //
 // RSA.h
 //
 #import <Foundation/Foundation.h>
 
 @interface RSA : NSObject {
 SecKeyRef publicKey;
 SecCertificateRef certificate;
 SecPolicyRef policy;
 SecTrustRef trust;
 size_t maxPlainLen;
 }
 
 - (NSData *) encryptWithData:(NSData *)content;
 - (NSData *) encryptWithString:(NSString *)content;
 
 @end
 
 RSA.m
 //
 // RSA.m
 //
 #import "RSA.h"
 
 @implementation RSA
 
 - (id)init {
 self = [super init];
 
 NSString *publicKeyPath = [[NSBundle mainBundle] pathForResource:@"public_key"
 ofType:@"der"];
 if (publicKeyPath == nil) {
 NSLog(@"Can not find pub.der");
 return nil;
 }
 
 NSDate *publicKeyFileContent = [NSData dataWithContentsOfFile:publicKeyPath];
 if (publicKeyFileContent == nil) {
 NSLog(@"Can not read from pub.der");
 return nil;
 }
 
 certificate = SecCertificateCreateWithData(kCFAllocatorDefault, ( __bridge CFDataRef)publicKeyFileContent);
 if (certificate == nil) {
 NSLog(@"Can not read certificate from pub.der");
 return nil;
 }
 
 policy = SecPolicyCreateBasicX509();
 OSStatus returnCode = SecTrustCreateWithCertificates(certificate, policy, &trust);
 if (returnCode != 0) {
 NSLog(@"SecTrustCreateWithCertificates fail. Error Code: %ld", returnCode);
 return nil;
 }
 
 SecTrustResultType trustResultType;
 returnCode = SecTrustEvaluate(trust, &trustResultType);
 if (returnCode != 0) {
 NSLog(@"SecTrustEvaluate fail. Error Code: %ld", returnCode);
 return nil;
 }
 
 publicKey = SecTrustCopyPublicKey(trust);
 if (publicKey == nil) {
 NSLog(@"SecTrustCopyPublicKey fail");
 return nil;
 }
 
 maxPlainLen = SecKeyGetBlockSize(publicKey) - 12;
 return self;
 }
 
 - (NSData *) encryptWithData:(NSData *)content {
 
 size_t plainLen = [content length];
 if (plainLen > maxPlainLen) {
 NSLog(@"content(%ld) is too long, must < %ld", plainLen, maxPlainLen);
 return nil;
 }
 
 void *plain = malloc(plainLen);
 [content getBytes:plain
 length:plainLen];
 
 size_t cipherLen = 128; // 当前RSA的密钥长度是128字节
 void *cipher = malloc(cipherLen);
 
 OSStatus returnCode = SecKeyEncrypt(publicKey, kSecPaddingPKCS1, plain,
 plainLen, cipher, &cipherLen);
 
 NSData *result = nil;
 if (returnCode != 0) {
 NSLog(@"SecKeyEncrypt fail. Error Code: %ld", returnCode);
 }
 else {
 result = [NSData dataWithBytes:cipher
 length:cipherLen];
 }
 
 free(plain);
 free(cipher);
 
 return result;
 }
 
 - (NSData *) encryptWithString:(NSString *)content {
 return [self encryptWithData:[content dataUsingEncoding:NSUTF8StringEncoding]];
 }
 
 - (void)dealloc{
 CFRelease(certificate);
 CFRelease(trust);
 CFRelease(policy);
 CFRelease(publicKey);
 }
 
 @end
 
 使用方法：
 RSA *rsa = [[RSA alloc] init];
 if (rsa != nil) {
 NSLog(@"%@",[rsa encryptWithString:@"test"]);
 }
 else {
 NSLog(@"init rsa error");
 }
 */
