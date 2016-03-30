//
//  TestPortalViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/30.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "TestPortalViewController.h"
#import "LEDPortal.h"

static NSString * const kLEDURLTestPortal = @"ipuny://portal/launch";

@implementation TestPortalViewController

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [LEDPortal registerPortalWithHandler:^UIViewController * _Nullable(NSURL * _Nonnull URL, BOOL shouldTransfer, UIViewController * _Nonnull sourceViewController) {
            if ([URL hasSameTrunkWithURL:[NSURL URLWithString:kLEDURLTestPortal]]) {
                // 根据该页面的需求，设置导航push 或者 present
                if (sourceViewController.navigationController) {
                    TestPortalViewController *vc = [[TestPortalViewController alloc] init];
                    [sourceViewController.navigationController pushViewController:vc animated:YES];
                    return vc;
                }
//                TestPortalViewController *vc = [[TestPortalViewController alloc] init];
//                [sourceViewController presentViewController:vc animated:YES completion:^{
//                    
//                }];
                return nil;
            } else {
                return nil;
            }
        } prefixURL:[NSURL URLWithString:kLEDURLTestPortal]];
    });
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
   
}

- (void)dealloc
{
    
}

@end
