//
//  DeviceInfoViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/14.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "DeviceInfoViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <CoreLocation/CoreLocation.h>
#import <SystemConfiguration/CaptiveNetwork.h>

#include <sys/types.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <MediaPlayer/MediaPlayer.h>

#define MIB_SIZE 2

extern NSString *CTSettingCopyMyPhoneNumber();

@interface DeviceInfoViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *listData;

@end

@implementation DeviceInfoViewController

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

- (NSString *)batteryState
{
    UIDevice *currentDevice = [UIDevice currentDevice];
    currentDevice.batteryMonitoringEnabled = YES;
    switch (currentDevice.batteryState) {
        case UIDeviceBatteryStateUnknown:
            return @"Unknown";
            break;
        case UIDeviceBatteryStateUnplugged:
            return @"Unplugged";
            break;
        case UIDeviceBatteryStateCharging:
            return @"Charging";
            break;
        case UIDeviceBatteryStateFull:
            return @"Fully Charged";
            break;
            
        default:
            return @"";
            break;
    }
}

- (CGFloat)batteryLevel
{
    return ([UIDevice currentDevice].batteryLevel * 100.0);
}
// 文档创建时间
- (NSTimeInterval)documentCreationDate
{
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] error:nil];
    return [[fileAttributes objectForKey:NSFileCreationDate] timeIntervalSince1970];
}

// 总容量
- (NSNumber *)totalDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemSize];
}

// 可用容量
- (NSNumber *)freeDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [fattributes objectForKey:NSFileSystemFreeSize];
}

- (NSInteger)bootTime
{
    int mib[MIB_SIZE];
    size_t size;
    struct timeval  boottime;
    
    mib[0] = CTL_KERN;
    mib[1] = KERN_BOOTTIME;
    size = sizeof(boottime);
    if (sysctl(mib, MIB_SIZE, &boottime, &size, NULL, 0) != -1)
    {
        // successful call
        return boottime.tv_sec;
    } else {
        return 0;
    }
}


- (NSString *)currentWifiSSID {
    // Does not work on the simulator.
    NSString *ssid = nil;
    NSArray *ifs = (id)CFBridgingRelease(CNCopySupportedInterfaces());
    NSLog(@"ifs:%@",ifs);
    for (NSString *ifnam in ifs) {
        NSDictionary *info = (id)CFBridgingRelease(CNCopyCurrentNetworkInfo((CFStringRef)ifnam));
        NSLog(@"dici：%@",[info  allKeys]);
        if (info[@"SSID"]) {
            ssid = info[@"SSID"];// kCNNetworkInfoKeyBSSID kCNNetworkInfoKeySSID
            
        }
    }
    return ssid;
}

- (NSArray*)getWiFiMac
{
    NSMutableArray *array = [NSMutableArray array];
    // 已连接的wifi信息
    // 调用私有api，故无法提交appsotre审核
    CFArrayRef interfaces = CNCopySupportedInterfaces();
    if (interfaces) {
        CFIndex count = CFArrayGetCount(interfaces);
        
        for (int i = 0; i < count; i++) {
            CFStringRef interface = CFArrayGetValueAtIndex(interfaces, i);
            CFDictionaryRef netinfo = CNCopyCurrentNetworkInfo(interface);
            if (netinfo && CFDictionaryContainsKey(netinfo, kCNNetworkInfoKeySSID)) {
                NSString *bssid = (__bridge NSString *)CFDictionaryGetValue(netinfo, kCNNetworkInfoKeyBSSID);
                NSString *ssid = (__bridge NSString *)CFDictionaryGetValue(netinfo, kCNNetworkInfoKeySSID);
//                [array addObject:@{@"bssid" : bssid ? : @"",
//                                   @"ssid" : ssid ? : @""}];
                [array addObject:bssid];// wifi  mac  address
            }
            if (netinfo)
                CFRelease(netinfo);
        }
        CFRelease(interfaces);
    }
    return [array copy];
}

- (void)setupData
{
    _listData = [[NSMutableDictionary alloc] init];
    // 获取设备信息
    UIDevice *device = [UIDevice currentDevice];
    NSString *name = device.name;       //获取设备所有者的名称 // e.g. "My iPhone"
    NSString *model = device.model;      //获取设备的类别 e.g. @"iPhone", @"iPod touch"
    NSString *type = device.localizedModel; //获取本地化版本  // localized version of model
    NSString *systemName = device.systemName;   //获取当前运行的系统  e.g. @"iOS"
    NSString *systemVersion = device.systemVersion;//获取当前系统的版本 e.g. @"4.0"
    NSString *identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//    NSString *udid = [[UIDevice currentDevice] uniqueIdentifier];// 废弃
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat width = rect.size.width * scale;
    CGFloat height = rect.size.height * scale;
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString *mCarrier = [NSString stringWithFormat:@"%@",[carrier carrierName]];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleName"];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];// 1.0.1
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"]; //1

    
    // network
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    SCNetworkReachabilityFlags flags ;
    NSString * etwork;
    CTTelephonyNetworkInfo *telephonyNetworkInfo = [[CTTelephonyNetworkInfo alloc] init];
    if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
        if (flags & kSCNetworkReachabilityFlagsReachable) {
            if (flags & kSCNetworkReachabilityFlagsTransientConnection) {
#pragma deploymate push "ignored-api-availability"
                if ([telephonyNetworkInfo respondsToSelector:@selector(currentRadioAccessTechnology)]) {
                    etwork = telephonyNetworkInfo.currentRadioAccessTechnology;
                    
                    
                    if ([etwork isEqualToString:CTRadioAccessTechnologyLTE])
                    {
                        etwork =  @"4G";
                    }
                    else if ([etwork isEqualToString:CTRadioAccessTechnologyEdge] || [etwork isEqualToString:CTRadioAccessTechnologyGPRS])
                    {
                        etwork =  @"2G";
                    }
                    else
                    {
                        etwork =  @"3G";
                    }
#pragma deploymate pop
                } else {
                    etwork = @"4G/3G/2G";
                }
            } else {
                etwork  = @"WIFI";
            }
        } else {
            etwork  = @"noNetWork";
        }
    } else {
        etwork  = @"unknown";
    }
    
    CGFloat systemVolume = 0;
#pragma deploymate push "ignored-api-availability"
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    // 上报当前系统音量（注：该API已经在iOS 7上被弃用，但是iOS 8还能获取到数值，暂时使用该API）
    systemVolume = [[MPMusicPlayerController applicationMusicPlayer] volume] * 100;// forKey:@"systemVolume"];
#pragma clang diagnostic pop
#pragma deploymate pop
    
    // 手机mac地址 ios7之后不能获取
    NSString *macID = [[UIDevice currentDevice] saka_macAddress];

    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    CLLocationCoordinate2D coordinate = locationManager.location.coordinate;
    
    NSString *paltform_str = [[UIDevice currentDevice] saka_platformString];

//    CFArrayRef interfaceArray = CNCopySupportedInterfaces();
//    if (interfaceArray) {
//        CFDictionaryRef interfaceInfo = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(interfaceArray, 0));
//        NSString *SSID = ((__bridge_transfer NSDictionary*)interfaceInfo)[@"SSID"];
//        CFRelease(interfaceArray);
//    }
    
    NSArray *wifiMacArray = [self getWiFiMac];
    NSString *currentWifi = [self currentWifiSSID];
    
    [_listData setObject:name forKey:@"设备所有者名称 "];
    [_listData setObject:model forKey:@"手机型号"];
    [_listData setObject:type forKey:@"国际化化版本区域手机型号"];
    [_listData setObject:systemName forKey:@"系统名称"];
    [_listData setObject:systemVersion forKey:@"系统版本"];
    [_listData setObject:identifier forKey:@"UUID"];
    [_listData setObject:[NSString stringWithFormat:@"%0.lf*%0.lf",width,height] forKey:@"分辨率"];
    if (mCarrier) {
         [_listData setObject:mCarrier forKey:@"运营商名称"];
    }
    if (carrier) {
        [_listData setObject:[carrier mobileCountryCode] forKey:@"运营商所在国家编号"];
        [_listData setObject:[carrier mobileNetworkCode] forKey:@"供应商网络编号"];
    }
   
    
    [_listData setObject:appCurName forKey:@"应用名称"];
    [_listData setObject:appCurVersion forKey:@"应用版本"];
    [_listData setObject:appCurVersionNum forKey:@"应用版本build号"];
    [_listData setObject:etwork forKey:@"网络类型"];
    [_listData setObject:[NSString stringWithFormat:@"%lf",coordinate.longitude] forKey:@"经度"];
    [_listData setObject:[NSString stringWithFormat:@"%lf",coordinate.latitude] forKey:@"纬度"];
    [_listData setObject:macID forKey:@"mac地址(iOS7之前可用)"];
    [_listData setObject:paltform_str forKey:@"系统平台类型"]; // iphone6 iphone6s
    [_listData setObject:[self batteryState] forKey:@"电池状态"];
    [_listData setObject:[NSString stringWithFormat:@"%lf",[self batteryLevel]] forKey:@"电池电量"];
    [_listData setObject:[NSString stringWithFormat:@"%ld",[self bootTime]] forKey:@"开机时间"];
    [_listData setObject:[NSString stringWithFormat:@"%lf",systemVolume] forKey:@"系统音量(iOS 7 废弃)"];
    
    
    
    id   ddd = [[NSUserDefaults standardUserDefaults] valueForKey:@"SBFormattedPhoneNumber"];
    
//    NSString *number = CTSettingCopyMyPhoneNumber();
//    NetworkController *ntc=[[NetworkController sharedInstance] autorelease];
//    NSString *imeistring = [ntc IMEI];

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
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdetify = @"tableViewCellIdetify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdetify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdetify];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.showsReorderControl = YES;
    }
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    [self.listData allKeys];
    cell.textLabel.text = [self.listData allKeys][indexPath.row];
    cell.detailTextLabel.text = [self.listData objectForKey:[self.listData allKeys][indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


@end



@implementation UIDevice (SAKAnalytics)

- (NSString *)saka_platform_
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

// maybe json or xml config file is better
- (NSString *)saka_platformString
{
    // @see http://theiphonewiki.com/wiki/Models
    NSString *platform = [self saka_platform_];
    
    // iPhone
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4 (GSM)";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4 (GSM Rev A)";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (Global)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (Global)";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6S";
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6S Plus";
    
    // iPod
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPod7,1"])      return @"iPod Touch 6G";
    
    // iPad
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi Rev A)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([platform isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([platform isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad5,5"])      return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad6,7"])      return @"iPad Pro";
    if ([platform isEqualToString:@"iPad6,8"])      return @"iPad Pro";
    
    // iPad Mini
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini Retina (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini Retina (Cellular)";
    if ([platform isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([platform isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad5,1"])      return @"iPad Mini 4";
    if ([platform isEqualToString:@"iPad5,2"])      return @"iPad Mini 4";
    
    // Xcode iOS Simulator
    if ([platform isEqualToString:@"i386"])         return @"iOS i386 Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"iOS x86_64 Simulator";
    return platform;
}


- (NSString *)saka_macAddress
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

@end