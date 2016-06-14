//
//  ViewController.m
//  播放gif图片
//
//  Created by wangguoliang on 15/9/11.
//  Copyright (c) 2015年 wangguoliang. All rights reserved.
//

#import "GIFViewController.h"
#import <ImageIO/ImageIO.h>
#import "GifView.h"

@interface GIFViewController ()<UIWebViewDelegate>

@property (nonatomic, strong)UIWebView *loadGifWebView;

@property (nonatomic, strong)UIActivityIndicatorView *indicatorView;

@end

@implementation GIFViewController

#pragma mark - 懒加载
- (UIWebView *)loadGifWebView
{
    if (_loadGifWebView == nil) {
        _loadGifWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _loadGifWebView.backgroundColor = [UIColor blackColor];
        _loadGifWebView.scalesPageToFit = YES;
        _loadGifWebView.delegate = self;
    }
    return _loadGifWebView;
}

- (UIActivityIndicatorView *)indicatorView
{
    if (_indicatorView == nil) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicatorView.center = self.view.center;
        _indicatorView.color = [UIColor lightGrayColor];
        [_indicatorView setHidesWhenStopped:YES];
    }
    return _indicatorView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self webViewLoadGif];
    [self loadGif];
    [self gifViewLoadGif];
}
#pragma mark - 第一种
- (void)webViewLoadGif
{
    NSData *gif = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"1" ofType:@"gif"]];
    [self.loadGifWebView loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    [self.view addSubview:self.loadGifWebView];
    [self.loadGifWebView addSubview:self.indicatorView];
}
#pragma mark - 第二种
- (void)loadGif
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"gif"];
    // 设定位置和大小
    CGRect frame = CGRectMake(-50.0f, 100.0, 0.0f, 0.0f);
    frame.size = [UIImage imageNamed:@"1.gif"].size;
    UIImageView *imageView = [self imageViewWithGIFFile:path frame:frame];
    [self.view addSubview:imageView];
}
#pragma mark - 第三种
- (void)gifViewLoadGif
{
    GifView *gifView = [[GifView alloc] initWithFrame:CGRectMake(0.0f, 400.0f, self.view.frame.size.width, 300.0f) filePath:[[NSBundle mainBundle] pathForResource:@"1" ofType:@"gif"]];
    gifView.tag = 2015;
    [self.view addSubview:gifView];
}
#pragma mark - #import <ImageIO/ImageIO.h>
- (UIImageView *)imageViewWithGIFFile:(NSString *)file frame:(CGRect)frame
{
    return [self imageViewWithGIFData:[NSData dataWithContentsOfFile:file] frame:frame];
}
- (UIImageView *)imageViewWithGIFData:(NSData *)data frame:(CGRect)frame
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    // 加载gif文件数据
    //NSData *gifData = [NSData dataWithContentsOfFile:file];
    
    // GIF动画图片数组
    NSMutableArray *frames = nil;
    // 图像源引用
    CGImageSourceRef src = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    // 动画时长
    CGFloat animationTime = 0.f;
    if (src) {
        // 获取gif图片的帧数
        size_t count = CGImageSourceGetCount(src);
        // 实例化图片数组
        frames = [NSMutableArray arrayWithCapacity:count];
        
        for (size_t i = 0; i < count; i++) {
            // 获取指定帧图像
            CGImageRef image = CGImageSourceCreateImageAtIndex(src, i, NULL);
            
            // 获取GIF动画时长
            NSDictionary *properties = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(src, i, NULL);
            NSDictionary *frameProperties = [properties objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
            NSNumber *delayTime = [frameProperties objectForKey:(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
            animationTime += [delayTime floatValue];
            if (image) {
                [frames addObject:[UIImage imageWithCGImage:image]];
                CGImageRelease(image);
            }
        }
        CFRelease(src);
    }
    [imageView setImage:[frames objectAtIndex:0]];
    [imageView setBackgroundColor:[UIColor clearColor]];
    [imageView setAnimationImages:frames];
    [imageView setAnimationDuration:animationTime];
    [imageView startAnimating];
    
    return imageView;
}
#pragma mark - UIWebViewDelegate 代理
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.indicatorView startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.indicatorView stopAnimating];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.indicatorView stopAnimating];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    GifView *gifView = (GifView *)[self.view viewWithTag:2015];
    [gifView stopGif];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
