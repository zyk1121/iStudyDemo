//
//  CustomTakePhotoViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/29.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "CustomTakePhotoViewController.h"
#import <objc/runtime.h>
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import <AVFoundation/AVFoundation.h>
//由于后面我们需要将拍摄好的照片写入系统相册中，所以我们在这里还需要导入一个相册需要的头文件
 #import <AssetsLibrary/AssetsLibrary.h>

//+(void)load
//{
//    Method viewDidAppear = class_getInstanceMethod([UIViewController class], @selector(takePicture));
//    Method trackPageViewDidAppear = class_getInstanceMethod([UIViewController class], @selector(takePictureStart));
//    method_exchangeImplementations(viewDidAppear, trackPageViewDidAppear);
//}
//
//- (void)takePictureStart
//{
//    [self takePicture];
//}


/*AVFoundation vs. UIImagePickerController
 UIImagePickerController 提供了一种非常简单的拍照方法。它支持所有的基本功能，比如切换到前置摄像头，开关闪光灯，点击屏幕区域实现对焦和曝光，以及在 iOS 8 中像系统照相机应用一样调整曝光。
 
 然而，当有直接访问相机的需求时，也可以选择 AVFoundation 框架。它提供了完全的操作权，例如，以编程方式更改硬件参数，或者操纵实时预览图。*/

@interface CustomTakePhotoViewController () <UIGestureRecognizerDelegate>
{
    BOOL isUsingFrontFacingCamera;
}

@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button3;
@property (nonatomic, strong) UIImageView *imageView;

//
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;


@property(nonatomic,assign)CGFloat beginGestureScale;
//后的缩放比例

@property(nonatomic,assign)CGFloat effectiveScale;

@property (nonatomic, strong) UIPinchGestureRecognizer *pinGes;


@end

@implementation CustomTakePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.button1 = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, 40, 40)];
        [button setTitle:@"拍照" forState:UIControlStateNormal];
        [button setTitle:@"拍照" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(button1Click:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    
    self.button2 = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50, 64, 80, 40)];
        [button setTitle:@"flashOn" forState:UIControlStateNormal];
        [button setTitle:@"flashOn" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(flashButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    
    self.button3 = ({
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(130, 64, 100, 40)];
        [button setTitle:@"前后摄像头" forState:UIControlStateNormal];
        [button setTitle:@"前后摄像头" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(switchCameraSegmentedControlClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    
    self.imageView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        imageView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
      //  [self.view addSubview:imageView];
        imageView;
    });
    
    [self initAVCaptureSession];
    isUsingFrontFacingCamera = NO;
    
    self.pinGes = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    [self.view addGestureRecognizer:self.pinGes];
    self.beginGestureScale = 1.0;
}

#pragma mark - event

- (void)button1Click:(UIButton *)button
{
//    文／敖老黑（简书作者）
//    原文链接：http://www.jianshu.com/p/5860087c8981
//    著作权归作者所有，转载请联系作者获得授权，并标注“简书作者”。
//    
    AVCaptureConnection *stillImageConnection = [self.stillImageOutput        connectionWithMediaType:AVMediaTypeVideo];
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avcaptureOrientation = [self avOrientationForDeviceOrientation:curDeviceOrientation];
    [stillImageConnection setVideoOrientation:avcaptureOrientation];
    [stillImageConnection setVideoScaleAndCropFactor:self.beginGestureScale];
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault,
                                                                    imageDataSampleBuffer,
                                                                    kCMAttachmentMode_ShouldPropagate);
        
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied){
            //无权限
            return ;
        }
//        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//        [library writeImageDataToSavedPhotosAlbum:jpegData metadata:(__bridge id)attachments completionBlock:^(NSURL *assetURL, NSError *error) {
//            
//        }];
        
    }];
}


//文／敖老黑（简书作者）
//原文链接：http://www.jianshu.com/p/5860087c8981
//著作权归作者所有，转载请联系作者获得授权，并标注“简书作者”。

- (void)flashButtonClick:(UIButton *)sender {
    
    NSLog(@"flashButtonClick");
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //修改前必须先锁定
    [device lockForConfiguration:nil];
    //必须判定是否有闪光灯，否则如果没有闪光灯会崩溃
    if ([device hasFlash]) {
        
        if (device.flashMode == AVCaptureFlashModeOff) {
            device.flashMode = AVCaptureFlashModeOn;
            
            [sender setTitle:@"flashOn" forState:UIControlStateNormal];
        } else if (device.flashMode == AVCaptureFlashModeOn) {
            device.flashMode = AVCaptureFlashModeAuto;
            [sender setTitle:@"flashAuto" forState:UIControlStateNormal];
        } else if (device.flashMode == AVCaptureFlashModeAuto) {
            device.flashMode = AVCaptureFlashModeOff;
            [sender setTitle:@"flashOff" forState:UIControlStateNormal];
        }
        
    } else {
        
        NSLog(@"设备不支持闪光灯");
    }
    [device unlockForConfiguration];
}



//文／敖老黑（简书作者）
//原文链接：http://www.jianshu.com/p/5860087c8981
//著作权归作者所有，转载请联系作者获得授权，并标注“简书作者”。

- (void)switchCameraSegmentedControlClick:(UIButton *)sender {
    
//    NSLog(@"%ld",(long)sender.selectedSegmentIndex);
    
    AVCaptureDevicePosition desiredPosition;
    if (isUsingFrontFacingCamera){
        desiredPosition = AVCaptureDevicePositionBack;
    }else{
        desiredPosition = AVCaptureDevicePositionFront;
    }
    
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([d position] == desiredPosition) {
            [self.previewLayer.session beginConfiguration];
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:d error:nil];
            for (AVCaptureInput *oldInput in self.previewLayer.session.inputs) {
                [[self.previewLayer session] removeInput:oldInput];
            }
            [self.previewLayer.session addInput:input];
            [self.previewLayer.session commitConfiguration];
            break;
        }
    }
    
    isUsingFrontFacingCamera = !isUsingFrontFacingCamera;
}

- (void)initAVCaptureSession{
    
    self.session = [[AVCaptureSession alloc] init];
    
    NSError *error;
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
    [device lockForConfiguration:nil];
    //设置闪光灯为自动
    [device setFlashMode:AVCaptureFlashModeAuto];
    [device unlockForConfiguration];
    
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    //输出设置。AVVideoCodecJPEG   输出jpeg格式图片
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    
    //初始化预览图层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
//    NSLog(@"%f",SCREEN_WIDTH);
    self.previewLayer.frame = CGRectMake(0, 104,SCREEN_WIDTH, SCREEN_HEIGHT - 104);
//    self.view.layer.masksToBounds = YES;
    [self.view.layer addSublayer:self.previewLayer];
}

//文／敖老黑（简书作者）
//原文链接：http://www.jianshu.com/p/5860087c8981
//著作权归作者所有，转载请联系作者获得授权，并标注“简书作者”。

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    if (self.session) {
        
        [self.session startRunning];
    }
}


- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:YES];
    
    if (self.session) {
        
        [self.session stopRunning];
    }
}

//文／敖老黑（简书作者）
//原文链接：http://www.jianshu.com/p/5860087c8981
//著作权归作者所有，转载请联系作者获得授权，并标注“简书作者”。

-(AVCaptureVideoOrientation)avOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    AVCaptureVideoOrientation result = (AVCaptureVideoOrientation)deviceOrientation;
    if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
        result = AVCaptureVideoOrientationLandscapeRight;
    else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
        result = AVCaptureVideoOrientationLandscapeLeft;
    return result;
}

/*
 
 文／敖老黑（简书作者）
 原文链接：http://www.jianshu.com/p/5860087c8981
 著作权归作者所有，转载请联系作者获得授权，并标注“简书作者”。
 
 最后一步就是加入手势缩放，手动调节相机焦距。
 加入两个属性，并遵守这个协议<UIGestureRecognizerDelegate>
 

@property(nonatomic,assign)CGFloat beginGestureScale;
后的缩放比例
 
@property(nonatomic,assign)CGFloat effectiveScale;
这两个属性分别用于记录缩放的比例。相机支持的焦距是1.0~67.5，所以再控制器加载的时候分别给这两个属性附上一个初值 1.0。之后给view添加一个缩放手势，手势调用的方法如下

//缩放手势 用于调整焦距
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer{
    
    BOOL allTouchesAreOnThePreviewLayer = YES;
    NSUInteger numTouches = [recognizer numberOfTouches], i;
    for ( i = 0; i < numTouches; ++i ) {
        CGPoint location = [recognizer locationOfTouch:i inView:self.backView];
        CGPoint convertedLocation = [self.previewLayer convertPoint:location fromLayer:self.previewLayer.superlayer];
        if ( ! [self.previewLayer containsPoint:convertedLocation] ) {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
    }
    
    if ( allTouchesAreOnThePreviewLayer ) {
        
        
        self.effectiveScale = self.beginGestureScale * recognizer.scale;
        if (self.effectiveScale < 1.0){
            self.effectiveScale = 1.0;
        }
        
        NSLog(@"%f-------------->%f------------recognizerScale%f",self.effectiveScale,self.beginGestureScale,recognizer.scale);
        
        CGFloat maxScaleAndCropFactor = [[self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
        
        NSLog(@"%f",maxScaleAndCropFactor);
        if (self.effectiveScale > maxScaleAndCropFactor)
            self.effectiveScale = maxScaleAndCropFactor;
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:.025];
        [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale)];
        [CATransaction commit];
        
    }
    
}
这样之再实现一个delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
        self.beginGestureScale = self.effectiveScale;
    }
    return YES;
}
 
 */

//文／敖老黑（简书作者）
//原文链接：http://www.jianshu.com/p/5860087c8981
//著作权归作者所有，转载请联系作者获得授权，并标注“简书作者”。

//缩放手势 用于调整焦距
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer{
    
    BOOL allTouchesAreOnThePreviewLayer = YES;
    NSUInteger numTouches = [recognizer numberOfTouches], i;
    for ( i = 0; i < numTouches; ++i ) {
        CGPoint location = [recognizer locationOfTouch:i inView:self.view];
        CGPoint convertedLocation = [self.previewLayer convertPoint:location fromLayer:self.previewLayer.superlayer];
        if ( ! [self.previewLayer containsPoint:convertedLocation] ) {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
    }
    
    if ( allTouchesAreOnThePreviewLayer ) {
        
        
        self.effectiveScale = self.beginGestureScale * recognizer.scale;
        if (self.effectiveScale < 1.0){
            self.effectiveScale = 1.0;
        }
        
        NSLog(@"%f-------------->%f------------recognizerScale%f",self.effectiveScale,self.beginGestureScale,recognizer.scale);
        
        CGFloat maxScaleAndCropFactor = [[self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
        
        NSLog(@"%f",maxScaleAndCropFactor);
        if (self.effectiveScale > maxScaleAndCropFactor)
            self.effectiveScale = maxScaleAndCropFactor;
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:.025];
        [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(self.effectiveScale, self.effectiveScale)];
        [CATransaction commit];
        
    }
    
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
        self.beginGestureScale = self.effectiveScale;
    }
    return YES;
}
@end
