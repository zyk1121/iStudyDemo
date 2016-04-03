//
//  ScreenShotViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/30.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "ScreenShotViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"


@interface ScreenShotViewController ()

@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button3;
@property (nonatomic, strong) UIButton *button4;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ScreenShotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.button1 = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
        [button setTitle:@"截屏" forState:UIControlStateNormal];
        [button setTitle:@"截屏" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(button1Click:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    

    
    self.imageView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        imageView.layer.borderWidth = 1;
        imageView.backgroundColor = [UIColor blackColor];
        imageView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:imageView];
        imageView;
    });

}
// http://www.cnblogs.com/pengyingh/articles/2466955.html

- (void)button1Click:(UIButton *)button
{

    // 1 从view的原点开始截图
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(400, 400), NO, 1);
//    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *uiImage = UIGraphicsGetImageFromCurrentImageContext();
//    self.imageView.image = uiImage;
//    UIGraphicsEndImageContext();
    self.imageView.image  =[self getImage];
    
}

- (UIImage *)getImage {
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(200, 200), NO, 1.0);  //NO，YES 控制是否透明
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 生成后的image
    
    return image;
}

- (UIImage *)getImage1 {
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT), NO, 1.0);  //NO，YES 控制是否透明,NO为不透明
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 生成后的image
    
    return image;
}

/*调整图片大小
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
 
 */


/*
 // 从view上截图
 - (UIImage *)getImage {
 
 UIGraphicsBeginImageContextWithOptions(CGSizeMake(150, 150), NO, 1.0);  //NO，YES 控制是否透明
 [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
 UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
 UIGraphicsEndImageContext();
 // 生成后的image
 
 return image;
 }
 
 // 根据给定得图片，从其指定区域截取一张新得图片
 -(UIImage *)getImageFromImage{
 //大图bigImage
 //定义myImageRect，截图的区域
 CGRect myImageRect = CGRectMake(70, 10, 150, 150);
 UIImage* bigImage= [UIImage imageNamed:@"mm.jpg"];
 CGImageRef imageRef = bigImage.CGImage;
 CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
 CGSize size;
 size.width = 150;
 size.height = 150;
 UIGraphicsBeginImageContext(size);
 CGContextRef context = UIGraphicsGetCurrentContext();
 CGContextDrawImage(context, myImageRect, subImageRef);
 UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
 UIGraphicsEndImageContext();
 return smallImage;
 }
 */


/*
 
 UIView 转 UIImage 方法如下（关键是自适配分辨率）：
 
 - (UIImage*)lineImage:(UIColor *)color lineWidth:(float)width lineType:(int)type
 {
 self.lineColor = color;
 lineWidth = width;
 lineType = type;
 
 //opaque：NO 不透明
 UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 1.0);
 //渲染自身
 [self.layer renderInContext:UIGraphicsGetCurrentContext()];
 
 UIImage *uiImage = UIGraphicsGetImageFromCurrentImageContext();
 UIGraphicsEndImageContext();
 
 //    [UIImagePNGRepresentation(uiImage) writeToFile:@"/users/test/desktop/a.png" atomically:YES];
 
 return uiImage;
 }
 */

@end
