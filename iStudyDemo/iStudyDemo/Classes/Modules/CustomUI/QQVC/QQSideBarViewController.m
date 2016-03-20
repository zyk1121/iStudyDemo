//
//  QQLeftViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/20.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "QQSideBarViewController.h"

#import "UIView+SHCZExt.h"
#import "UIKitMacros.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "UIImage+IPLImageKit.h"
#import "QQTabbarViewController.h"
#import "SHCZMainView.h"

@interface QQSideBarViewController ()

//@property (nonatomic, strong) SHCZMainView *leftView;
//@property (nonatomic, strong) QQTabbarViewController *tabVC;
@property (nonatomic, strong) UIButton *maskView;

@property (nonatomic, strong)UIPanGestureRecognizer *pan;

@end

@implementation QQSideBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor yellowColor];
    
    UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sidebar_bg.jpg"]];
    img.frame=CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height*0.4);
    [self.view addSubview:img];
    _leftView = [[SHCZMainView alloc] initWithFrame:CGRectMake(-self.view.frame.size.width / 4,0,self.view.frame.size.width,self.view.frame.size.height)];
    _leftView.sidebarVC = self;
    [self.view addSubview:_leftView];
    
    //
    _tabVC = [[QQTabbarViewController alloc] init];
    _tabVC.sidebarVC = self;
    [self.view addSubview:_tabVC.view];
    
    [self.view bringSubviewToFront:_tabVC.view];
    
    
    _maskView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.tabVC.view addSubview:_maskView];
    _maskView.alpha = 0;
    _maskView.backgroundColor = [UIColor redColor];
    [_maskView addTarget:self action:@selector(maskViewClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
        _pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(didPanEvent:)];
    
    
//        [self.tabVC.view addGestureRecognizer:_pan];
//    [self addPanGesture];

}

- (void)addPanGesture
{
    [self.tabVC.view addGestureRecognizer:_pan];
}

- (void)removePanGesture
{
    [self.tabVC.view removeGestureRecognizer:_pan];
}


//实现拖拽
-(void)didPanEvent:(UIPanGestureRecognizer *)recognizer{
    
    // 1. 获取手指拖拽的时候, 平移的值
    CGPoint translation = [recognizer translationInView:recognizer.view];
    
    // 2. 让当前控件做响应的平移
    recognizer.view.transform = CGAffineTransformTranslate(recognizer.view.transform, translation.x, 0);
//    NSLog(@"%lf",recognizer.view.ttx);
    // ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
    
    self.leftView.ttx=recognizer.view.ttx/3;
    // ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
    // 3. 每次平移手势识别完毕后, 让平移的值不要累加
    [recognizer setTranslation:CGPointZero inView:recognizer.view];
    
    //获取最右边范围
    CGAffineTransform  rightScopeTransform=CGAffineTransformTranslate([[UIApplication sharedApplication].delegate window].transform,[UIScreen mainScreen].bounds.size.width*0.75, 0);
    
    //    当移动到右边极限时
    if (recognizer.view.transform.tx>rightScopeTransform.tx) {
        
        //        限制最右边的范围
        recognizer.view.transform=rightScopeTransform;
        //        限制透明view最右边的范围
        self.leftView.ttx=recognizer.view.ttx/3;
        
        //        当移动到左边极限时
    }else if (recognizer.view.transform.tx<0.0){
        
        //        限制最左边的范围
        recognizer.view.transform=CGAffineTransformTranslate([[UIApplication sharedApplication].delegate window].transform,0, 0);
        //    限制透明view最左边的范围
        self.leftView.ttx=recognizer.view.ttx/3;
        
    }
    //    当托拽手势结束时执行
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:0.2 animations:^{
            
            if (recognizer.view.x >[UIScreen mainScreen].bounds.size.width*0.5) {
                
                recognizer.view.transform=rightScopeTransform;
                self.leftView.ttx=recognizer.view.ttx/3;
                self.maskView.alpha = 1;
//                CGRect frame = self.maskView.frame;
//                NSArray *arr = [self.view subviews];
//                [self.view bringSubviewToFront:self.maskView];
                
//                [self.view bringSubviewToFront:self.maskView];
            }else{
                self.maskView.alpha = 0;
                recognizer.view.transform = CGAffineTransformIdentity;
//                [self.view bringSubviewToFront:self.tabVC.view];

                self.leftView.ttx=recognizer.view.ttx/3;
            }
        }];
    }
}

- (void)maskViewClicked
{
    //获取最右边范围
    CGAffineTransform  rightScopeTransform=CGAffineTransformTranslate([[UIApplication sharedApplication].delegate window].transform,[UIScreen mainScreen].bounds.size.width*0.75, 0);
    if (self.maskView.alpha == 1) {
        [UIView animateWithDuration:0.2 animations:^{
            
            self.maskView.alpha = 0;
            self.tabVC.view.transform = CGAffineTransformIdentity;
            
            self.leftView.ttx=self.tabVC.view.ttx/3;

        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            
            self.tabVC.view.transform=rightScopeTransform;
            self.leftView.ttx=self.tabVC.view.ttx/3;
            self.maskView.alpha = 1;
//            [self.view bringSubviewToFront:self.maskView];
            
        }];
    }
}


@end
