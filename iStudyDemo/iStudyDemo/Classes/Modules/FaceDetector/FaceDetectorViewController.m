//
//  FaceDetectorViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/8/6.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "FaceDetectorViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"


@interface FaceDetectorViewController ()

@property (nonatomic, strong) UIImageView *imageViewSrc;
@property (nonatomic, strong) UIImage *srcImage;
@property (nonatomic, strong) UIImageView *imageViewDst;

@property(nonatomic,strong) CIContext *context;

/**
 *  检测器
 */
@property(nonatomic,strong)CIDetector *detector;

@end

@implementation FaceDetectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   
    [self setupUI];
     [self setupData];
    [self.view setNeedsUpdateConstraints];
}

#pragma mark - masonry

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    [_imageViewSrc mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
//    [_imageViewDst mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.top.equalTo(self.imageViewSrc.mas_bottom).offset(20);
//        make.width.height.equalTo(@200);
//    }];
}

#pragma mark - private method

- (void)setupUI
{
    _imageViewSrc = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        imageView.image = self.srcImage;
        imageView;
    });
    
    [self.view addSubview:_imageViewSrc];
    
    _imageViewDst = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView;
    });
    
//    [self.view addSubview:_imageViewDst];
}

- (void)setupData
{
    _srcImage = [UIImage imageNamed:@"3430277559670220261.jpg"];
    self.imageViewSrc.image = self.srcImage;
    //转成ciimage
    CIImage *ciImage = [CIImage imageWithCGImage:_srcImage.CGImage];
    //拿到所有的脸
    NSArray <CIFeature *> *featureArray = [self.detector featuresInImage:ciImage];
    //遍历
    for (CIFeature *feature in featureArray)
    {
        //将image沿y轴对称
        CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, -1);
        //将image往上移动
        CGFloat imageH = ciImage.extent.size.height;
        transform = CGAffineTransformTranslate(transform, 0, -imageH);
        //在image上画出方框
        CGRect feaRect = feature.bounds;
        //调整后的坐标
        CGRect newFeaRect = CGRectApplyAffineTransform(feaRect, transform);
        //调整imageView的frame
        CGFloat imageViewW = self.view.bounds.size.width;
        CGFloat imageViewH = self.view.bounds.size.height;
        CGFloat imageW = ciImage.extent.size.width;
        //显示
        CGFloat scale = MIN(imageViewH / imageH, imageViewW / imageW);
        //缩放
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
        
        //修正
        newFeaRect = CGRectApplyAffineTransform(newFeaRect, scaleTransform);
        newFeaRect.origin.x +=  (imageViewW - imageW * scale) / 2;
        newFeaRect.origin.y += (imageViewH - imageH * scale) / 2;
        
        //绘画
        UIView *breageView = [[UIView alloc] initWithFrame:newFeaRect];
        breageView.layer.borderColor = [UIColor redColor].CGColor;
        breageView.layer.borderWidth = 2;
        [self.imageViewSrc addSubview:breageView];
    }

    
}


#pragma mark -- 懒加载
- (CIContext *)context
{
    if (_context == nil)
    {
        _context = [CIContext contextWithOptions:nil];
    }
    return _context;
}

- (CIDetector *)detector
{
    if (_detector == nil)
    {
        NSDictionary *dict = @{
                               CIDetectorAccuracy : CIDetectorAccuracyHigh
                               };
        _detector = [CIDetector detectorOfType:CIDetectorTypeFace context:self.context options:dict];
    }
    return _detector;
}


@end
