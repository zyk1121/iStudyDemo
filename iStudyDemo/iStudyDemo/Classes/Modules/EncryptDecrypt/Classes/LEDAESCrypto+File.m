////  iStudyDemo
////
////  Created by zhangyuanke on 16/3/26.
////  Copyright © 2016年 zhangyuanke. All rights reserved.
////
//
//#import "LEDAESCrypto+File.h"
//#import <Security/Security.h>
//#import <AdSupport/AdSupport.h>
//#import "SFHFKeychainUtils.h"
//#import "LEDAnalytics.h"
//#import "LEDDigest.h"
//#import "LEDError+Crypto.h"
//
//
//@implementation LEDAESCrypto (File)
//
//+ (NSString *)secret
//{
//    uint8_t randomBytes[16];
//    SecRandomCopyBytes(kSecRandomDefault, 16, randomBytes);
//    
//    return [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
//     randomBytes[0], randomBytes[1],
//     randomBytes[2], randomBytes[3],
//     randomBytes[4], randomBytes[5],
//     randomBytes[6], randomBytes[7],
//     randomBytes[8], randomBytes[9],
//     randomBytes[10], randomBytes[11],
//     randomBytes[12], randomBytes[13],
//     randomBytes[14], randomBytes[15]
//     ];
//}
//
//+ (NSString *)led_SecretByName:(NSString *)name
//{
//    NSParameterAssert(name && [name length] > 0);
//    
//    NSError *error = nil;
//    NSString *secret = [SFHFKeychainUtils getPasswordForUsername:name andServiceName:name inKeychainGroup:nil error:&error];
//    if (error) {
//        [LEDAnalytics logError:[[LEDError getSecretErrorUserDescription:[error description] callstack:[NSThread callStackSymbols]] logDictionary]];
//        return nil;
//    }
//    
//    if (!secret) {
//        secret = [self secret];
//    
//        [SFHFKeychainUtils storeUsername:name andPassword:secret forServiceName:name inKeychainGroup:nil updateExisting:NO error:&error];
//        if (error) {
//            [LEDAnalytics logError:[[LEDError storeSecretErrorUserDescription:[error description] callstack:[NSThread callStackSymbols]] logDictionary]];
//            return nil;
//        }
//    }
//    
//    return secret;
//}
//
//+ (BOOL)led_EncryptText:(NSString *)txt intoFile:(NSString *)filePath withSecretName:(NSString *)name
//{
//    NSParameterAssert(txt && [txt length] > 0);
//    NSParameterAssert(filePath && [filePath length] > 0);
//    NSParameterAssert(name && [name length] > 0);
//    
//    NSData *data = [txt dataUsingEncoding:NSUTF8StringEncoding];
//    NSAssert(data && [data length] > 0, @"text to encrypt should be in utf-8 encoding");
//    
//    return [self led_EncryptData:data intoFile:filePath withSecretName:name];
//}
//
//+ (NSString *)led_DecryptTextFromFile:(NSString *)filePath withSecretName:(NSString *)name
//{
//    NSParameterAssert(filePath && [filePath length] > 0);
//    NSParameterAssert(name && [name length] > 0);
//
//    NSData* data = [self led_DecryptDataFromFile:filePath withSecretName:name];
//    
//    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//}
//
//+ (BOOL)led_EncryptText:(NSString *)txt intoFile:(NSString *)filePath withSecret:(NSString *)secret
//{
//    NSParameterAssert(txt && [txt length] > 0);
//    NSParameterAssert(filePath && [filePath length] > 0);
//    NSParameterAssert(secret && [secret length] > 0);
//
//    NSData *data = [txt dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSAssert(data && [data length] > 0, @"text to encrypt should be in utf-8 encoding");
//    
//    return [self led_EncryptData:data intoFile:filePath withSecret:secret];
//}
//
//+ (NSString *)led_DecryptTextFromFile:(NSString *)filePath withSecret:(NSString *)secret
//{
//    NSParameterAssert(filePath && [filePath length] > 0);
//    NSParameterAssert(secret && [secret length] > 0);
//    
//    NSData *data = [self led_DecryptDataFromFile:filePath withSecret:secret];
//    
//    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//}
//
//+ (BOOL)led_EncryptData:(NSData *)data intoFile:(NSString *)filePath withSecretName:(NSString *)name
//{
//    NSParameterAssert(data && [data length] > 0);
//    NSParameterAssert(filePath && [filePath length] > 0);
//    NSParameterAssert(name && [name length] > 0);
//    
//    NSString *key = [LEDAESCrypto LED_SecretByName:name];
//    if (!key || [key length] == 0) {
//        return NO;
//    }
//    
//    return [self led_EncryptData:data intoFile:filePath withSecret:key];
//}
//
//+ (NSData *)led_DecryptDataFromFile:(NSString *)filePath withSecretName:(NSString *)name
//{
//    NSParameterAssert(filePath && [filePath length] > 0);
//    NSParameterAssert(name && [name length] > 0);
//    
//    NSString *key = [LEDAESCrypto led_SecretByName:name];
//    
//    return [self led_DecryptDataFromFile:filePath withSecret:key];
//}
//
//+ (BOOL)led_EncryptData:(NSData *)data intoFile:(NSString *)filePath withSecret:(NSString *)secret
//{
//    NSParameterAssert(data && [data length] > 0);
//    NSParameterAssert(filePath && [filePath length] > 0);
//    NSParameterAssert(secret && [secret length] > 0);
//
//    NSData *encryptData = [LEDAESCrypto encrypt:data key:secret iv:nil];
//    if (!encryptData || [encryptData length] == 0) {
//        return NO;
//    }
//    
//    return [encryptData writeToFile:filePath atomically:YES];
//}
//
//+ (NSData *)led_DecryptDataFromFile:(NSString *)filePath withSecret:(NSString *)secret
//{
//    NSParameterAssert(filePath && [filePath length] > 0);
//    NSParameterAssert(secret && [secret length] > 0);
//    
//    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//        return nil;
//    }
//    
//    if (!secret || [secret length] == 0) {
//        return nil;
//    }
//    
//    NSData *encryptData = [NSData dataWithContentsOfFile:filePath];
//    
//    NSData *data = [LEDAESCrypto decrypt:encryptData key:secret iv:nil];
//    if (!data || [data length] == 0) {
//        return nil;
//    }
//    
//    return data;
//}
//
//@end