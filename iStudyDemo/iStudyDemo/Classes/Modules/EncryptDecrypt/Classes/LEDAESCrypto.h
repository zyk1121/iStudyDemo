//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "LEDCrypto.h"

@interface LEDAESCrypto : LEDCrypto

+ (NSData *)encrypt:(NSData *)plainData
                key:(NSString *)key
                 iv:(NSString *)iv;
+ (NSData *)decrypt:(NSData *)cipherData
                key:(NSString *)key
                 iv:(NSString *)iv;

@end
