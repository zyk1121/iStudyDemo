//
//  NSString+MD5Encrypt.h
//  Smile
//
//  Created by 蒲晓涛 on 12-11-24.
//  Copyright (c) 2012年 BOX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (MD5)

- (NSString *)md5Encrypt;

@end

