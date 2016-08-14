//
//  YKModalPopup.m
//  YKModalPopup
//
//  Created by zhangyuanke on 16/8/14.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "YKModalPopup.h"

static YKModalPopup                     *kYKModelPopupInstance;
static UITapGestureRecognizer           *kYKBackgroundSingleTapGesture;
static UIView                           *kYKCustomBackgroundView;
static UIView                           *kYKCustomView;

@interface YKModalPopup ()

@property (nonatomic, weak) id<YKModalPopupDelegate> delegate;

@end

@implementation YKModalPopup

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

+ (void)showWithCustomView:(UIView *)customView delegate:(id<YKModalPopupDelegate>)delegate
{
    [self showWithCustomView:customView delegate:delegate forced:NO];
}

+ (void)showWithCustomView:(UIView *)customView delegate:(id<YKModalPopupDelegate>)delegate forced:(BOOL)forced
{
    if (!customView || ![customView isKindOfClass:[UIView class]]) {
        return;
    }
    if (!forced && kYKModelPopupInstance) {
        return;
    }
    if (forced && kYKModelPopupInstance) {
        if (kYKModelPopupInstance) {
            [YKModalPopup removed];
        }
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    kYKModelPopupInstance = [[YKModalPopup alloc] init];
    kYKModelPopupInstance.delegate = delegate;
    kYKCustomBackgroundView = [[UIView alloc] initWithFrame:window.bounds];
    kYKCustomBackgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    kYKBackgroundSingleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:kYKModelPopupInstance action:@selector(handleCustomBackgroundTouched:)];
    [kYKCustomBackgroundView addGestureRecognizer:kYKBackgroundSingleTapGesture];
    kYKCustomView = customView;
    [window addSubview:kYKCustomBackgroundView];
    [window addSubview:kYKCustomView];
    
    [[NSNotificationCenter defaultCenter] addObserver:kYKModelPopupInstance selector:@selector(_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:kYKModelPopupInstance selector:@selector(_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

+ (void)dismiss
{
    [self removed];
}

#pragma mark - private method

+ (void)removed
{
    if (kYKModelPopupInstance) {
        [[NSNotificationCenter defaultCenter] removeObserver:kYKModelPopupInstance name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:kYKModelPopupInstance name:UIKeyboardWillHideNotification object:nil];
    }
    if (kYKCustomBackgroundView && kYKBackgroundSingleTapGesture) {
        [kYKCustomBackgroundView removeGestureRecognizer:kYKBackgroundSingleTapGesture];
        kYKBackgroundSingleTapGesture = nil;
    }
    if (kYKCustomBackgroundView) {
        [kYKCustomBackgroundView removeFromSuperview];
        kYKCustomBackgroundView = nil;
    }
    if (kYKCustomView) {
        [kYKCustomView removeFromSuperview];
        kYKCustomView = nil;
    }
    if (kYKModelPopupInstance) {
        kYKModelPopupInstance = nil;
    }
}

#pragma mark - keyboard

- (void)_keyboardWillShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    if (kbSize.height > 0) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
        [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
//        CGRect fr = kYKCustomView.frame;
//        fr.origin.y = self.originalBottomOfContentView - self.containerView.height - kbSize.height / 2.0;
//        if (fr.origin.y < 0) {
//            fr.origin.y = 0;
//        }
//        self.currentBottomOfContentView = self.containerView.height + fr.origin.y;
//        self.containerView.frame = fr;
        
        [UIView commitAnimations];
    }
}

- (void)_keyboardWillHide:(NSNotification *)notification
{
//    if (self.currentBottomOfContentView < self.originalBottomOfContentView) {
//        [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
//            self.containerView.bottom = self.originalBottomOfContentView;
//            self.currentBottomOfContentView = self.originalBottomOfContentView;
//        }];
//    }
}


#pragma mark - event

- (void)handleCustomBackgroundTouched:(UIGestureRecognizer *)gesture
{
    [kYKCustomView endEditing:YES];
    [YKModalPopup dismiss];
}

@end
