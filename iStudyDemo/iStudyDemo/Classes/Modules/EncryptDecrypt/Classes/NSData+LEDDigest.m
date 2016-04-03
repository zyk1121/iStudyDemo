//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//
//

#import "NSData+LEDDigest.h"
#import "LEDDigest.h"

@implementation NSData (LEDDigest)

- (NSString *)led_SHA1String
{
    LEDDigest *digest = [LEDDigest sha1Digest];
    [digest addData:self];
    return [digest digestString];
}

- (NSString *)led_MD5String
{
    LEDDigest *digest = [LEDDigest md5Digest];
    [digest addData:self];
    return [digest digestString];
}

@end
