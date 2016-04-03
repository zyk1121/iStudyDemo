//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

typedef enum {
    kCryptorNone = 0,  //无加密
    kCryptorDES = 2,  // DES 加密
    kCryptorRSA = 4 // RSA 加密
}CryptorType;

@interface LEDCrypto : NSObject

// 子类须初始化
+ (instancetype)sharedCrypto;

/*!
 @function   encrypt:key
 @param      plainData       待加密的二进制流
 @param      key             如果为nil,使用默认密钥，否则使用传入的key; DES加密可以调用
                             resetDESKey 方法，重置密钥；
 @return                     加密后的数据，如果为nil,则加密失败
 */
- (NSData *)encrypt:(NSData *)plainData
                key:(NSString *)key;

/*!
 @function   decrypt:key
 @param      cipherData      待解密的二进制流 
 @param      key             如果为nil,使用默认密钥，否则使用传入的key; DES加密可以调用
                             resetDESKey 方法，重置密钥；
 @return                     解密后的数据，如果为nil,则解密失败
 */
- (NSData *)decrypt:(NSData *)cipherData
                key:(NSString *)key;
@end
