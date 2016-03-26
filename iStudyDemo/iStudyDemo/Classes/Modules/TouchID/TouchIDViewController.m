//
//  TouchIDViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "TouchIDViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "TouchIDManager.h"

@implementation TouchIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2, 200, 40)];
    button.tag = 1;
    [button setTitle:@"TouchID" forState:UIControlStateNormal];
    [button setTitle:@"TouchID" forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonClick:(UIButton *)button{
 
    if ([TouchIDManager fingerPrintAvailable]) {
        [TouchIDManager verifyFingerPrintSuccessBlock:^{
            NSLog(@"success");
        } userFallbackBlock:^{
             NSLog(@"fallback");
        } userCancelBlock:^{
             NSLog(@"cancel");
        } authenticationFailedBlock:^{
             NSLog(@"fail");
        }];
    }
}

@end
