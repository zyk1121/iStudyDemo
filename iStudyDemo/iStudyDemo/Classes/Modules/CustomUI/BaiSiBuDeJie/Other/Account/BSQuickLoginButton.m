//
//  BSQuickLoginButton.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/6/28.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "BSQuickLoginButton.h"
#import "UIView+Extension.h"

@implementation BSQuickLoginButton

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.backgroundColor = [UIColor redColor];
//    self.imageView.backgroundColor = [UIColor blueColor];
//    self.titleLabel.backgroundColor = [UIColor yellowColor];
    self.imageView.centerX = self.width * 0.5;
    self.imageView.y = 0;
    
    self.titleLabel.x = 0;
    self.titleLabel.width = self.width;
    self.titleLabel.y = self.imageView.y + self.imageView.height + 5;
}

@end
