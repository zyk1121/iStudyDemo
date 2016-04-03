//
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "NSString+LEDDigest.h"
#import "LEDDigest.h"

@implementation NSString (LEDDigest)

- (NSString *)led_SHA1String
{
    LEDDigest *digest = [LEDDigest sha1Digest];
    [digest addString:self];
    return [digest digestString];
}

- (NSString *)led_MD5String
{
    LEDDigest *digest = [LEDDigest md5Digest];
    [digest addString:self];
    return [digest digestString];
}


@end
