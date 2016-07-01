//
//  BSMeButton.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/7/1.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "BSMeButton.h"
#import "UIView+Extension.h"

@implementation BSMeButton

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
    self.imageView.height = self.height * 0.5;
    self.imageView.y = self.height * 0.1;
    self.imageView.width = self.imageView.height;
    self.imageView.centerX = self.width * 0.5;
    
    self.titleLabel.x = 0;
    self.titleLabel.width = self.width;
    self.titleLabel.y = self.imageView.y + self.imageView.height + 5;
    self.titleLabel.height = self.height - self.titleLabel.y;
}


@end
