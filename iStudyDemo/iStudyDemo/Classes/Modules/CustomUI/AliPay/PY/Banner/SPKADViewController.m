//
//  KBViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/23.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPKADViewController.h"
#import "SPKBannerPagingView.h"
#import "SPKBanner.h"
#import "Masonry.h"
#import "SDWebImageManager.h"
#import <libextobjc/extobjc.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIKitMacros.h"

@interface SPKADViewController()

@property (nonatomic, strong) SPKBannerPagingView *bannerPagingView;
@property (nonatomic, assign) CGFloat bannerHeight;

@end

@implementation SPKADViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    @weakify(self)
    [RACObserve(self, bannerArray) subscribeNext:^(NSArray *bannerArray) {
        @strongify(self)
        [self setupUI];
    }];
}

- (void)setupUI
{
    if ([self.bannerArray count]) {
        // 1.网络加载图片成功之前显示缓存图片
        @weakify(self);
        NSMutableArray *diskCacheBannerArray = [[NSMutableArray alloc] initWithCapacity:0];

        [self.bannerArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self);
            SPKBanner *banner = (SPKBanner *)obj;
//            [[SDWebImageManager sharedManager].imageCache removeImageForKey:[banner.imgURL absoluteString]];
            UIImage *image = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:[banner.imgURL absoluteString]];
            banner.image = image;
            if (banner.image) {
                self.bannerHeight = SCREEN_WIDTH / banner.image.size.width * banner.image.size.height;
                [diskCacheBannerArray addObject:banner];
            }
        }];
        [self setupBannerPagingView:[diskCacheBannerArray copy]];
        // 2.加载网络图片
        [self requestBannerImage:[self.bannerArray copy] finished:^(NSArray *bannerArray) {
            @strongify(self);
            NSMutableArray *validBannerArray = [[NSMutableArray alloc] initWithCapacity:0];
            [bannerArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                SPKBanner *banner = (SPKBanner *)obj;
                if (banner.image) {
                    self.bannerHeight = SCREEN_WIDTH / banner.image.size.width * banner.image.size.height;
                    [validBannerArray addObject:banner];
                }
            }];
            [self setupBannerPagingView:[validBannerArray copy]];
            if (self.bannerImgLoadingFinishedBlock) {
                self.bannerImgLoadingFinishedBlock([validBannerArray count] > 0);
            }
        }];
    } else {
        [self.bannerPagingView removeFromSuperview];
        self.bannerPagingView = nil;
    }
}

- (void)setupBannerPagingView:(NSArray *)bannerArray
{
    [self.bannerPagingView removeFromSuperview];
    if ([bannerArray count]) {
        self.bannerPagingView = ({
            SPKBannerPagingView *bannerPagingView = [[SPKBannerPagingView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.bannerHeight)];
            bannerPagingView.clipsToBounds = YES;
            [bannerPagingView setTarget:self andTapAction:@selector(didTapBanner:)];
            bannerPagingView.banners = [bannerArray copy];
            bannerPagingView;
        });
        [self.view addSubview:self.bannerPagingView];
        
        [self.bannerPagingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.height.equalTo(@(self.bannerHeight));
            make.width.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
    }
}

- (void)requestBannerImage:(NSArray *)bannerArray
                  finished:(void (^)(NSArray *))requestFinished
{
    __block NSUInteger requestNum = 0;
    [bannerArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SPKBanner *banner = (SPKBanner *)obj;
        [[SDWebImageManager sharedManager] downloadImageWithURL:banner.imgURL
                                                        options:SDWebImageRetryFailed
                                                       progress:^(NSInteger receivedSize, NSInteger expectedSize) {}
                                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                          banner.image = image;
                                                          
                                                          requestNum++;
                                                          if (requestNum == [bannerArray count]) {
                                                              if (requestFinished) {
                                                                  requestFinished(bannerArray);
                                                              }
                                                          }
                                                      }];
    }];
}

# pragma mark - event

- (void)didTapBanner:(SPKBanner *)banner
{
    if (self.didClickBannerBlock) {
        self.didClickBannerBlock(banner);
    }
}

@end
