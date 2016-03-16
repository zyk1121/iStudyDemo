//
//  JSPatchViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/8.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "JSPatchViewController.h"
#import "UIKitMacros.h"

// http://jspatch.com/Docs/intro 一个即将要可用的jspatch开放平台
// https://github.com/bang590/JSPatch 

@interface JSPatchViewController ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation JSPatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _button = ({
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(SCREEN_WIDTH / 2 - 100, SCREEN_HEIGHT / 2, 200, 50);
        [button setTitle:@"测试JSPatch" forState:UIControlStateNormal];
        [button setTitle:@"测试JSPatch" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.view addSubview:_button];
}

- (void)buttonClicked
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"title"
                                                                             message:@"message"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    // cancled action
    // 如果cancelTitle为nil 会crash
    NSString *cancelTitle = nil;
    UIAlertAction *canceldAction = [UIAlertAction actionWithTitle:cancelTitle
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              NSLog(@"您点击了取消按钮");                                                        }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了确认");
    }];
    // addAction：参数为nil也会crash
    [alertController addAction:canceldAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
    
    /*
     
     
     require('UIAlertAction')
     
     defineClass("UIAlertAction",{},{
     actionWithTitle_style_handler:function(cancelTitle,style,handler) {
     if (cancelTitle) {
     var tempBlock = block('UIAlertAction*',function(alertAction){
     handler(alertAction);
     });
     return UIAlertAction.ORIGactionWithTitle_style_handler(cancelTitle,style,tempBlock);
     } else {
     return null;
     }
     }
     });
     
     require('UIAlertController')
     
     defineClass("UIAlertController",{
     addAction:function(action){
     if (action) {
     self.ORIGaddAction(action);
     };
     }
     },{});
     
     
     
     */

}

@end
