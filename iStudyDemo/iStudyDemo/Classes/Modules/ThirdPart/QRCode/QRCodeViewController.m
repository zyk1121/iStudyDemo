//
//  QRCodeViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "QRCodeViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "ZBarSDK.h"
#import <AVFoundation/AVFoundation.h>
#import "QRCodeScanViewController.h"
#import "QRCodeCreateViewController.h"

// 扫描二维码的开源库有很多如 ZBar、ZXing等
// 系统iOS7.0后AVFoundation框架提供的原生二维码扫描

@interface QRCodeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) NSMutableArray *listViewControllers;


@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupData];
    [self setupUI];
    [self.view setNeedsUpdateConstraints];
}

#pragma mark - masonry

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - private method

- (void)setupUI
{
    _tableView = ({
        UITableView *tableview = [[UITableView alloc] init];
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        tableview;
    });
    [self.view addSubview:_tableView];
}

- (void)setupData
{
    _listData = [[NSMutableArray alloc] init];
    _listViewControllers = [[NSMutableArray alloc] init];
    
    // 1.二维码扫描
    [_listData addObject:@"二维码扫描"];
    QRCodeScanViewController *thirdShareViewController = [[QRCodeScanViewController alloc] init];
    [_listViewControllers addObject:thirdShareViewController];
    // 2.二维码生成
    [_listData addObject:@"二维码生成"];
    QRCodeCreateViewController *qrcodeViewController = [[QRCodeCreateViewController alloc] init];
    [_listViewControllers addObject:qrcodeViewController];

}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.listData.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *vc = [self.listViewControllers objectAtIndex:indexPath.row];
    vc.title = [self.listData objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        [self.navigationController presentViewController:vc animated:YES completion:^{
            
        }];
    } else {
        
            [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdetify = @"tableViewCellIdetify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdetify];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.showsReorderControl = YES;
    }
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [self.listData objectAtIndex:indexPath.row];
    //    cell.detailTextLabel.text = [self.listData objectForKey:[self.listData allKeys][indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


//    _device = [ AVCaptureDevice defaultDeviceWithMediaType : AVMediaTypeVideo ];
//    
//    // Input
//    
//    _input = [ AVCaptureDeviceInput deviceInputWithDevice : self . device error : nil ];
//    
//    // Output
//    
//    _output = [[ AVCaptureMetadataOutput alloc ] init ];
//    
//    [ _output setMetadataObjectsDelegate : self queue : dispatch_get_main_queue ()];
//    
//    // Session
//    
//    _session = [[ AVCaptureSession alloc ] init ];
//    
//    [ _session setSessionPreset : AVCaptureSessionPresetHigh ];
//    
//    if ([ _session canAddInput : self . input ])
//        
//    {
//        
//        [ _session addInput : self . input ];
//        
//    }
//    
//    if ([ _session canAddOutput : self . output ])
//        
//    {
//        
//        [ _session addOutput : self . output ];
//        
//    }
//    
//    // 条码类型 AVMetadataObjectTypeQRCode
//    
//    _output . metadataObjectTypes = @[ AVMetadataObjectTypeQRCode ] ;
//    
//    // Preview
////    [_output setRectOfInterest : CGRectMake (( SCREEN_WIDTH - 220 )/ 2 , 60 + 64 , 220 , 220 )];
//    [ _output setRectOfInterest : CGRectMake (( 124 )/ SCREEN_HEIGHT ,(( SCREEN_WIDTH - 220 )/ 2 )/ SCREEN_WIDTH , 220 / SCREEN_HEIGHT , 220 / SCREEN_WIDTH )];
//    
//    _preview =[ AVCaptureVideoPreviewLayer layerWithSession : _session ];
//    
//    _preview . videoGravity = AVLayerVideoGravityResizeAspectFill ;
//    
////    _preview . frame = self . view . layer . bounds ;
//    _preview.frame = CGRectMake(100, 100, 50, 50);
//    
//    [ self . view . layer insertSublayer : _preview atIndex : 100 ];
//}
//
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//
//    
//    // Start
//    
//    [ _session startRunning ];
//}
//
//
//#pragma mark AVCaptureMetadataOutputObjectsDelegate
//
//- ( void )captureOutput:( AVCaptureOutput *)captureOutput didOutputMetadataObjects:( NSArray *)metadataObjects fromConnection:( AVCaptureConnection *)connection
//
//{
//    
//    NSString *stringValue;
//    
//    if ([metadataObjects count ] > 0 )
//        
//    {
//        
//        // 停止扫描
//        
//        [ _session stopRunning ];
//        
//        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
//        
//        stringValue = metadataObject. stringValue ;        
//        
//    }
//    
//}


@end
