//
//  LDAPPLEPayViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/7/5.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "LDAPPLEPayViewController.h"
#import <PassKit/PassKit.h>

// http://www.cocoachina.com/ios/20160226/15443.html

@interface LDAPPLEPayViewController ()<PKPaymentAuthorizationViewControllerDelegate>

@end

@implementation LDAPPLEPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.view.backgroundColor = [UIColor whiteColor];
    // 判断当前设备是否支持苹果支付
    if(![PKPaymentAuthorizationViewController canMakePayments]) {
        NSLog(@"设备不支持Apple Pay");
    } else if (![PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:@[PKPaymentNetworkVisa,PKPaymentNetworkChinaUnionPay]]){
    // 没有添加visa或者银联卡
        PKPaymentButton *button = [PKPaymentButton buttonWithType:PKPaymentButtonTypeSetUp style:PKPaymentButtonStyleBlack];
        [button addTarget:self action:@selector(button1Click) forControlEvents:UIControlEventTouchUpInside];
        button.center = CGPointMake(100,100);
        [self.view addSubview:button];
    } else {
        PKPaymentButton *button = [PKPaymentButton buttonWithType:PKPaymentButtonTypeBuy style:PKPaymentButtonStyleBlack];
        [button addTarget:self action:@selector(button2Click) forControlEvents:UIControlEventTouchUpInside];
        button.center = CGPointMake(100,100);
        [self.view addSubview:button];

    }
}

- (void)button1Click
{
    // 添加银行卡
    PKPassLibrary *pk = [[PKPassLibrary alloc] init];
    [pk openPaymentSetup];
}

- (void)button2Click
{
    // 购买
    PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
    request.countryCode = @"CN";
    request.currencyCode = @"CNY";
    request.supportedNetworks = @[PKPaymentNetworkChinaUnionPay, PKPaymentNetworkVisa];
    request.merchantCapabilities = PKMerchantCapability3DS | PKMerchantCapabilityEMV;
    request.merchantIdentifier = @"merchant.com.ishowchina.map";
    
    PKPaymentSummaryItem *widget1 = [PKPaymentSummaryItem summaryItemWithLabel:@"Widget 1" amount:[NSDecimalNumber decimalNumberWithString:@"0.99"]];
    
    PKPaymentSummaryItem *widget2 = [PKPaymentSummaryItem summaryItemWithLabel:@"Widget 2" amount:[NSDecimalNumber decimalNumberWithString:@"1.00"]];
    
    PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel:@"Grand Total" amount:[NSDecimalNumber decimalNumberWithString:@"1.99"]];
    
    request.paymentSummaryItems = @[widget1, widget2, total];
    
    // 可以添加寄送地址，发票信息等
    // payRequest.requiredBillingAddressFields = PKAddressFieldEmail;
    //如果需要邮寄账单可以选择进行设置，默认PKAddressFieldNone(不邮寄账单)
    //楼主感觉账单邮寄地址可以事先让用户选择是否需要，否则会增加客户的输入麻烦度，体验不好，
//    request.requiredShippingAddressFields = PKAddressFieldPostalAddress|PKAddressFieldPhone|PKAddressFieldName;
    //送货地址信息，这里设置需要地址和联系方式和姓名，如果需要进行设置，默认PKAddressFieldNone(没有送货地址)
    
    //设置两种配送方式
    /*
    PKShippingMethod *freeShipping = [PKShippingMethod summaryItemWithLabel:@"包邮" amount:[NSDecimalNumber zero]];
    freeShipping.identifier = @"freeshipping";
    freeShipping.detail = @"6-8 天 送达";
    
    PKShippingMethod *expressShipping = [PKShippingMethod summaryItemWithLabel:@"极速送达" amount:[NSDecimalNumber decimalNumberWithString:@"10.00"]];
    expressShipping.identifier = @"expressshipping";
    expressShipping.detail = @"2-3 小时 送达";
    
    request.shippingMethods = @[freeShipping, expressShipping];
    
     */
    PKPaymentAuthorizationViewController *paymentPane = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
    paymentPane.delegate = self;
    [self presentViewController:paymentPane animated:TRUE completion:nil];
}


#pragma mark - PKPaymentAuthorizationViewControllerDelegate

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion
{
    BOOL payFlag = YES;
    // 支付处理（后台）
    if (payFlag) {
        //
        NSLog(@"%@",payment.token);
        NSLog(@"%@",payment.token.paymentData);
        completion(PKPaymentAuthorizationStatusSuccess);
    } else {
        completion(PKPaymentAuthorizationStatusFailure);
    }
}


// Sent to the delegate when payment authorization is finished.  This may occur when
// the user cancels the request, or after the PKPaymentAuthorizationStatus parameter of the
// paymentAuthorizationViewController:didAuthorizePayment:completion: has been shown to the user.
//
// The delegate is responsible for dismissing the view controller in this method.
- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    NSLog(@"Finishing payment view controller");
    
    // hide the payment window
    [controller dismissViewControllerAnimated:TRUE completion:nil];
}

@end
