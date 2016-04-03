//
//  EncryptDecryptViewController.m
//  iStudyDemo
//
//  Created by zhangyuanke on 16/3/26.
//  Copyright © 2016年 zhangyuanke. All rights reserved.
//

#import "EncryptDecryptViewController.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "masonry.h"
#import "UIKitMacros.h"
#import "NSStringAdditions.h"
#import "NSData+Base64.h"
#import "SecurityUtil.h"
#import "NSString+LEDDigest.h"
#import "NSData+AES.h"
#import "LEDDESCrypto.h"
#import "GTMBase64.h"
#import "LEDRSACrypto.h"

@interface EncryptDecryptViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listData;

@end

@implementation EncryptDecryptViewController

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
    
    [_listData addObject:@"URLEncode"];
    [_listData addObject:@"URLDecode"];
    [_listData addObject:@"Base64Encode"];
    [_listData addObject:@"Base64Decode"];
    [_listData addObject:@"MD5校验值"];
    [_listData addObject:@"SHA1哈希算法(校验)"];
    [_listData addObject:@"DES加密（对称加密）"];
    [_listData addObject:@"DES解密（对称加密）"];
    [_listData addObject:@"AES加密（对称加密）"];
    [_listData addObject:@"AES解密（对称加密）"];
    [_listData addObject:@"RSA加密（非对称加密）"];
    [_listData addObject:@"RSA解密（非对称加密）"];
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
    switch (indexPath.row) {
        case 0:
            [self testURLEncode];
            break;
        case 1:
            [self testURLDecode];
            break;
        case 2:
            [self testBase64Encode];
            break;
        case 3:
            [self testBase64Decode];
            break;
        case 4:
            [self testMD5];
            break;
        case 5:
            [self testSHA1];
            break;
        case 6:
            [self testDesEncrypt];
            break;
        case 7:
            [self testDesDecrypt];
        case 8:
            [self testAESEncrypt];
            break;
        case 9:
            [self testAESDecrypt];
            break;
        case 10:
            [self testRSAEncrypt];
            break;
        case 11:
            [self testRSADecrypt];
            break;
        default:
            break;
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
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - 数据编码&加解密

#pragma mark - URL encode & decode

- (void)testURLEncode
{
    
    /*
     http://blog.csdn.net/typingios/article/details/9136005
     
     方法1:
     NSString* encodedString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     
     方法2:
     NSString * encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)urlString,NULL,NULL,kCFStringEncodingUTF8);
     
     这两种方法当urlString里含有中文时URL编码是正确的,但是如果其中含有已转义的%等符号时,又会再次转义而导致错误.
     
     */
    
    
    NSString *URLString = @"http://192.168.120.14:15001/v3/search/poi?query=皇冠假日酒店&region=北京&ak=ec85d3648154874552835438ac6a02b2";
    NSString *URLEncodeString = [URLString URLEncodedString];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:URLEncodeString delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
    
    NSLog(@"%@",URLEncodeString);
    
//    NSString *URLString = @"http://192.168.120.14:15001/v3/search/poi?query=皇冠假日酒店&region=北京&ak=ec85d3648154874552835438ac6a02b2";
}

- (void)testURLDecode
{
    NSString *URLString = @"http://192.168.120.14:15001/v3/search/poi?query=%E7%9A%87%E5%86%A0%E5%81%87%E6%97%A5%E9%85%92%E5%BA%97&region=%E5%8C%97%E4%BA%AC&ak=ec85d3648154874552835438ac6a02b2";
    
    NSString *URLDecodeString = [URLString URLDecodedString];
    NSLog(@"%@",URLDecodeString);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:URLDecodeString delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

#pragma mark - Base64

- (void)testBase64Encode
{
    NSString *dataStr = @"123456abc";
    NSString *base64encodeStr = [SecurityUtil encodeBase64String:dataStr];
    NSLog(@"%@",base64encodeStr);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:base64encodeStr delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}
- (void)testBase64Decode
{
    NSString *base64EncodeStr = @"MTIzNDU2YWJj";
    NSString *base64decode = [SecurityUtil decodeBase64String:base64EncodeStr];
    NSLog(@"%@",base64decode);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:base64decode delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

#pragma mark - MD5
- (void)testMD5
{
    NSString *testString = @"abc12345";
    NSLog(@"%@",[testString led_MD5String]);
    NSString *md5String = [testString stringByComputingMD5];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:md5String delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

#pragma mark - sha1

- (void)testSHA1
{
    NSString *str = @"123456abc";
    NSString *sha1Str = [str led_SHA1String];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:sha1Str delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

#pragma mark - DES加密解密（对称加密）

+ (NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key
{
    NSString *ciphertext = nil;
    const char *textBytes = [plainText UTF8String];
    NSUInteger dataLength = [plainText length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    Byte iv[] = {1,2,3,4,5,6,7,8};
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,
                                          textBytes, dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        
        ciphertext = [[NSString alloc] initWithData:[GTMBase64 encodeData:data] encoding:NSUTF8StringEncoding];
    }
    return ciphertext;
}

//解密
+ (NSString *)decryptUseDES:(NSString*)cipherText key:(NSString*)key
{
    NSData* cipherData = [GTMBase64 decodeString:cipherText];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    Byte iv[] = {1,2,3,4,5,6,7,8};
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          iv,
                                          [cipherData bytes],
                                          [cipherData length],
                                          buffer,
                                          1024,
                                          &numBytesDecrypted);
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return plainText;
}

- (void)testDesEncrypt
{
    NSString *str = @"123456abc";
    NSString *desStr = [EncryptDecryptViewController encryptUseDES:str key:@"abcd123456"];// ExXHu23sIpuDVAM3mzvR+Q==
    NSLog(@"%@",desStr);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:desStr delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];

}
- (void)testDesDecrypt
{
    NSString *str = @"ExXHu23sIpuDVAM3mzvR+Q==";
    NSString *desStr = [EncryptDecryptViewController decryptUseDES:str key:@"abcd123456"];
    NSLog(@"%@",desStr);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:desStr delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

#pragma mark - AES加密解密（对称加密，高级加密标准（英语：Advanced Encryption Standard，缩写：AES，用来取代DES）
- (void)testAESEncrypt
{
    NSString *str = @"123456abc";
    NSData *AESData = [SecurityUtil encryptAESData:str];
    NSLog(@"%@",AESData);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:@"加密成NSData" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}
- (void)testAESDecrypt
{
    NSString *str = @"123456abc";
    NSData *AESData = [SecurityUtil encryptAESData:str];
    NSString *AESStr = [SecurityUtil decryptAESData:AESData];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:AESStr delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}
#pragma mark - RSA加密解密,非对称加密解密
- (void)testRSAEncrypt
{
//    NSString *str = @"abcdefg12345";
//    NSData *data = [[LEDRSACrypto sharedCrypto] encrypt:[str dataUsingEncoding:NSUTF8StringEncoding] key:@"key12345678abc"];
//    NSData *dataDecode = [[LEDRSACrypto sharedCrypto] decrypt:data key:@"key12345678abc"];
//    NSLog(@"%@",[[NSString alloc] initWithData:dataDecode encoding:NSUTF8StringEncoding]);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:@"需要生成秘钥对" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}
- (void)testRSADecrypt
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"title" message:@"需要生成秘钥对" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

@end

/*
 使用方式如下:
 MD5加密方式
 
 SString *) md5
 {
 const charchar *cStr = [self UTF8String];
 unsigned char digest[CC_MD5_DIGEST_LENGTH];
 CC_MD5( cStr, strlen(cStr), digest );
 
 NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
 
 for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
 [output appendFormat:@"%02x", digest[i]];
 
 return output;
 }
 SHA1加密方式
 
 - (NSString*) sha1
 {
 const charchar *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
 NSData *data = [NSData dataWithBytes:cstr length:self.length];
 
 uint8_t digest[CC_SHA1_DIGEST_LENGTH];
 
 CC_SHA1(data.bytes, data.length, digest);
 
 NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
 
 for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
 [output appendFormat:@"%02x", digest[i]];
 
 return output;
 }
 当然也可以结合BASE64来使用,这里的BASE64编码使用 GTMBase64实现，需要导入
 
 - (NSString *) sha1_base64
 {
 const charchar *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
 NSData *data = [NSData dataWithBytes:cstr length:self.length];
 
 uint8_t digest[CC_SHA1_DIGEST_LENGTH];
 
 CC_SHA1(data.bytes, data.length, digest);
 
 NSData * base64 = [[NSData alloc]initWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
 base64 = [GTMBase64 encodeData:base64];
 
 NSString * output = [[NSString alloc] initWithData:base64 encoding:NSUTF8StringEncoding];
 return output;
 }
 
 - (NSString *) md5_base64
 {
 const charchar *cStr = [self UTF8String];
 unsigned char digest[CC_MD5_DIGEST_LENGTH];
 CC_MD5( cStr, strlen(cStr), digest );
 
 NSData * base64 = [[NSData alloc]initWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
 base64 = [GTMBase64 encodeData:base64];
 
 NSString * output = [[NSString alloc] initWithData:base64 encoding:NSUTF8StringEncoding];
 return output;
 }
 */
