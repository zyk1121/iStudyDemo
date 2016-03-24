//
//  KBViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/23.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "SPKBanner.h"

@implementation SPKBanner

- (instancetype)initWithImageURL:(NSURL *)imgURL
                         linkURL:(NSURL *)linkURL
                        andImage:(UIImage *)image
{
    
    self = [super init];
    if (self) {
        _imgURL = imgURL;
        _linkURL = linkURL;
        _image = image;
    }
    return self;
}

@end
