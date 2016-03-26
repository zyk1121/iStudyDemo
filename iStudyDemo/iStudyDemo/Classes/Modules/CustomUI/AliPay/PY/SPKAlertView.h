////
////  SPKAlertView.h
////  Pods
////
////  Created by zhangyuanke on 15/11/4.
////
////
//
//#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>
//
//typedef void (^SPKAlertViewDismissedBlock)(NSInteger buttonIndex);
//typedef void (^SPKAlertViewCanceledBlock)();
//
//@interface SPKAlertView : NSObject
//
//// 参数：viewController 在iOS8之前可以为nil，之后（包括iOS8）不能为nil
//+ (void)showAlertViewWithViewController:(UIViewController *)viewController
//                                  title:(NSString *)title
//                                message:(NSString *)message
//                      cancelButtonTitle:(NSString *)cancelButtonTitle
//                      otherButtonTitles:(NSArray *)titleArray
//                              dismissed:(SPKAlertViewDismissedBlock)dismissedBlock
//                               canceled:(SPKAlertViewCanceledBlock)canceledBlock;
//// dismiss 当前的AlertView
//+ (void)dismissCurrentAlertView;
//
//@end
//
//@interface UIAlertView (SPKAlertView)
//
//@end
