//
//  KBViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/23.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "SPKBannerPagingView.h"
#import "SPKBanner.h"
#import "SPKBannerView.h"
#import "UIViewAdditions.h"
#import "SPKBannerPageControl.h"
#import "EXTScope.h"
#import "UIView+Extension.h"
#import "UIView+SHCZExt.h"

@interface SPKBannerPagingView ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIScrollView *pageView;
@property (nonatomic, strong) SPKBannerPageControl *pageControl;
@property (nonatomic, weak) id target;
@property (nonatomic) SEL tapAction;

@end

@implementation SPKBannerPagingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _pageView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _pageView.showsHorizontalScrollIndicator = NO;
        _pageView.pagingEnabled = YES;
        _pageView.bounces = NO;
        _pageView.delegate = self;
        _pageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_pageView];
        
        _pageControl = [[SPKBannerPageControl alloc] init];
        _pageControl.hidesForSinglePage = YES;
        [self addSubview:_pageControl];
        
        [self registerNotificationForBannerAnimation];
    }
    
    return self;
}

- (void)setBanners:(NSArray *)banners
{
    _banners = banners;
    [self setUpPagingViewWithBanners];
    
    CGSize size = [self.pageControl sizeForNumberOfPages:self.banners.count];
    self.pageControl.frame = CGRectMake((self.width - size.width) / 2, (self.height - 12), size.width, 10);
    self.pageControl.numberOfPages = [self.banners count];
    
    if (self.timer) {
        [self stopTimer];
    }
    
    [self startTimer];
}

- (void)startTimer
{
    if (self.banners.count > 1 && !self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(ticking) userInfo:nil repeats:YES];
    }
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)ticking
{
    if (self.pageView == nil || self.banners.count == 0) {
        return;
    }
    
    int curPage = [self currentPage];
    
    if (curPage == 0) {
        [self.pageView scrollRectToVisible:CGRectMake(self.width * [self.banners count], 0, self.width, self.height) animated:YES];
    } else if (curPage == ([self.banners count] + 1)) {
        [self.pageView scrollRectToVisible:CGRectMake(self.width, 0, self.width, self.height) animated:YES];
    } else {
        [self.pageView scrollRectToVisible:CGRectMake(self.width * (curPage + 1), 0, self.width, self.height) animated:YES];
    }
}

- (void)setUpPagingViewWithBanners
{
    [self.pageView removeAllSubviews];
    if (self.banners.count == 0) {
        return;
    } else if (self.banners.count == 1) {
        SPKBannerView *bannerView = [[SPKBannerView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        [bannerView setTarget:self.target andTapAction:self.tapAction];
        bannerView.banner = [self.banners objectAtIndex:0];
        [self.pageView addSubview:bannerView];
        self.pageView.contentSize = CGSizeMake(self.pageView.width, self.pageView.height);
        self.pageView.scrollEnabled = NO;
    } else if (self.banners.count > 1) {
        for (int index = 0; index < self.banners.count + 2; index++) {
            SPKBannerView *bannerView = [[SPKBannerView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
            [bannerView setTarget:self.target andTapAction:self.tapAction];
            SPKBanner *banner;
            if (index == 0) {
                banner = [self.banners objectAtIndex:self.banners.count - 1];
            } else if (index == self.banners.count + 1) {
                banner = [self.banners objectAtIndex:0];
            } else {
                banner = [self.banners objectAtIndex:index - 1];
            }
            bannerView.banner = banner;
            bannerView.left = bannerView.width * index;
            [self.pageView addSubview:bannerView];
        }
        self.pageView.contentSize = CGSizeMake(self.width * (self.banners.count + 2), self.pageView.height);
        self.pageView.contentOffset = CGPointMake(self.width, 0);
        self.pageView.scrollEnabled = YES;
    } else {
        //donothing
    }
}

- (int)currentPage
{
    return floor(self.pageView.contentOffset.x / self.pageView.width);
}

- (void)clearAdvertise
{
    [self stopTimer];
    
    self.pageView.delegate = nil;
    self.pageView = nil;
}

- (void)setTarget:(id)target andTapAction:(SEL)tapAction
{
    self.target = target;
    self.tapAction = tapAction;
}

- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
    
    self.pageView.delegate = nil;
    self.pageView = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma - mark private

- (void)registerNotificationForBannerAnimation
{
    // UIApplication state notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startTimer) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startTimer) name:UIApplicationDidBecomeActiveNotification object:nil];
}

#pragma UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = floor((self.pageView.contentOffset.x - self.pageView.width / 2) / self.pageView.width);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int curPage = [self currentPage];
    
    if (curPage == 0) {
        [self.pageView scrollRectToVisible:CGRectMake(self.width * [self.banners count], 0, self.width, self.height) animated:NO];
    } else if (curPage == ([self.banners count] + 1)) {
        [self.pageView scrollRectToVisible:CGRectMake(self.width, 0, self.width, self.height) animated:NO];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    int curPage = [self currentPage];
    
    if (curPage == self.banners.count + 1) {
        [scrollView scrollRectToVisible:CGRectMake(self.width, 0, self.width, self.height) animated:NO];
    }
}
@end
