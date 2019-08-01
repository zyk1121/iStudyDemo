//
//  MainViewController.m
//  iDemo
//
//  Created by 张元科 on 2019/7/27.
//  Copyright © 2019年 张元科. All rights reserved.
//

#import "MainViewController.h"
#import <GLKit/GLKit.h>
#import <GLKit/GLKView.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/EAGL.h>
#import "MainGLView.h"


@interface MainViewController ()

@property (nonatomic, strong)   MainGLView       *glView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.glView = [[MainGLView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:self.glView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
