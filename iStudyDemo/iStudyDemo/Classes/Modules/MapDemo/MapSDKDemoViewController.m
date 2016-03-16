//
//  MapSDKDemoViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/6.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "MapSDKDemoViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <MapKit/MapKit.h>

// http://lbs.amap.com/api/ios-sdk/guide/mapkit/ 开发文档

@interface MapSDKDemoViewController () <MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) MAMapView *mapView2;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation MapSDKDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initMapView];
}

- (void)initMapView
{
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager requestAlwaysAuthorization];
    }
    self.mapView.frame = CGRectMake(0, 100, 300, 300);
//    self.mapView.showsCompass = NO;
    //    self.mapView.frame = self.view.frame;

    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    //
    self.mapView.showsUserLocation = YES; // 显示位置
    
    
    self.mapView2 = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView2.showsCompass = NO;
    self.mapView2.frame = CGRectMake(0, 450, 200, 200);
    //    self.mapView.frame = self.view.frame;
    
    self.mapView2.delegate = self;
    [self.mapView2 setVisibleMapRect:MAMapRectMake(220947791,101641847, 11312, 11815) animated:YES];
    [self.view addSubview:self.mapView2];
    
    //
    self.mapView.showsUserLocation = YES; // 显示位置
    //显示卫星地图
//    _mapView.mapType = MAMapTypeSatellite;
//    _mapView.showTraffic= YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(39.989631, 116.481018);
    pointAnnotation.title = @"方恒国际";
    pointAnnotation.subtitle = @"阜通东大街6号";
    
    [_mapView addAnnotation:pointAnnotation];
}

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}

@end
