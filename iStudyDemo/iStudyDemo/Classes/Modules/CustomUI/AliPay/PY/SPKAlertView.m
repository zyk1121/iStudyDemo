////
////  SPKAlertView.m
////  Pods
////
////  Created by zhangyuanke on 15/11/4.
////
////
//
//#import "SPKAlertView.h"
////#import "UIAlertViewAdditions.h"
//#import <objc/runtime.h>
////#import "SPKFoundationMacros.h"
//
//// AlertView 上 buttonIndex 默认是 >= -1；此处是自己dismiss AlertView 时取的一个数字，可以是其他值
//static const NSInteger kSPKNoneButtonIndex = -99;
//// 全局的AlertView，用于标记当前显示的AlertView
//static id currentAlertView = nil;
//
//#pragma mark - SPKAlertView
//
//@implementation SPKAlertView
//
//// 参数：viewController 在iOS8之前可以为nil，之后（包括iOS8）不能为nil
//+ (void)showAlertViewWithViewController:(UIViewController *)viewController
//                                  title:(NSString *)title
//                                message:(NSString *)message
//                      cancelButtonTitle:(NSString *)cancelButtonTitle
//                      otherButtonTitles:(NSArray *)titleArray
//                              dismissed:(SPKAlertViewDismissedBlock)dismissedBlock
//                               canceled:(SPKAlertViewCanceledBlock)canceledBlock
//{
//    if (![title length]) {
//        title = @"";
//    }
//    if (kSystemVersionGreaterThanOrEqualiOS8) {
//        // systemVersion >= 8.0
//        if (!viewController || ![viewController isKindOfClass:[UIViewController class]]) {
//            return ;
//        }
//        
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
//                                                                                 message:message
//                                                                          preferredStyle:UIAlertControllerStyleAlert];
//        
//        // cancled action
//        if ([cancelButtonTitle length]) {
//            UIAlertAction *canceldAction = [UIAlertAction actionWithTitle:cancelButtonTitle
//                                                                    style:UIAlertActionStyleCancel
//                                                                  handler:^(UIAlertAction * _Nonnull action) {
//                                                                      if (canceledBlock) {
//                                                                          canceledBlock();
//                                                                      }
//                                                                      currentAlertView = nil;
//                                                                  }];
//            [alertController addAction:canceldAction];
//        }
//        
//        // other action
//        [titleArray enumerateObjectsUsingBlock:^(id  _Nonnull title, NSUInteger idx, BOOL * _Nonnull stop) {
//            if ([title isKindOfClass:[NSString class]]) {
//                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    if (dismissedBlock) {
//                        // 注意，此处的idx是从0开始的
//                        dismissedBlock(idx);
//                    }
//                    currentAlertView = nil;
//                }];
//                [alertController addAction:otherAction];
//            }
//        }];
//        
//        [viewController presentViewController:alertController animated:YES completion:nil];
//        
//        currentAlertView = alertController;
//    } else {
//        // systemVersion < 8.0
//        currentAlertView = [UIAlertView showAlertViewWithTitle:title
//                                                       message:message
//                                             cancelButtonTitle:cancelButtonTitle
//                                             otherButtonTitles:titleArray
//                                                     dismissed:dismissedBlock
//                                                      canceled:canceledBlock];
//    }
//}
//
//+ (void)dismissCurrentAlertView
//{
//    if (kSystemVersionGreaterThanOrEqualiOS8) {
//        // systemVersion >= 8.0
//        if (currentAlertView && [currentAlertView isKindOfClass:[UIAlertController class]]) {
//            [currentAlertView dismissViewControllerAnimated:YES completion:nil];
//            currentAlertView = nil;
//        }
//    } else {
//        // systemVersion < 8.0
//        if (currentAlertView && [currentAlertView isKindOfClass:[UIAlertView class]]) {
//            [currentAlertView dismissWithClickedButtonIndex:kSPKNoneButtonIndex animated:YES];
//            currentAlertView = nil;
//        }
//    }
//}
//
//@end
//
//#pragma mark - UIAlertView (SPKAlertView)
//
//@implementation UIAlertView (SPKAlertView)
//
//+ (void)load
//{
//    // 备注：此处使用 UIAlertViewAdditions 中的alertView:didDismissWithButtonIndex:方法的替换，后续使用的时候需要注意
//    Method alertViewDismissMethod = class_getInstanceMethod([UIAlertView class], @selector(alertView:didDismissWithButtonIndex:));
//    Method alertViewExchangedDismissMethod = class_getInstanceMethod([UIAlertView class], @selector(alertViewExchanged:didDismissWithButtonIndex:));
//    method_exchangeImplementations(alertViewDismissMethod, alertViewExchangedDismissMethod);
//}
//
//- (void)alertViewExchanged:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    // dismiss alertView 但是不执行block流程的情况
//    if (buttonIndex != kSPKNoneButtonIndex) {
//        [self alertViewExchanged:alertView didDismissWithButtonIndex:buttonIndex];
//    }
//    // 正常单击UIAlertView的按钮的时候也需要清空currentAlertView
//    currentAlertView = nil;
//}
//
//@end
