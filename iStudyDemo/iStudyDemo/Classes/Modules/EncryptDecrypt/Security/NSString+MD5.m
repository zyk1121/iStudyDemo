//
//  NSString+MD5Encrypt.h
//  Smile
//
//  Created by 蒲晓涛 on 12-11-24.
//  Copyright (c) 2012年 BOX. All rights reserved.
//

#import "NSString+MD5.h"

@implementation NSString (MD5)

- (NSString *)md5Encrypt {
//    const char *original_str = [self UTF8String];
//    unsigned char result[CC_MD5_DIGEST_LENGTH];
//    CC_MD5(original_str, strlen(original_str), result);
//    NSMutableString *hash = [NSMutableString string];
//    for (int i = 0; i < 16; i++)
//        [hash appendFormat:@"%02X", result[i]];
//    return [hash lowercaseString];
    
//    const char *cStr = [self UTF8String];
//    unsigned char result[32];
//    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
//    return [NSString stringWithFormat:
//            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
//            result[0], result[1], result[2], result[3],
//            result[4], result[5], result[6], result[7],
//            result[8], result[9], result[10], result[11],
//            result[12], result[13], result[14], result[15]
//            ];
    
    const char *cStr = (char *)[self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end


//  文件MD5
/*
 //
 //  ViewController.m
 //  testapp
 //
 //  Created by zhangyuanke on 16/3/31.
 //  Copyright © 2016年 zhangyuanke. All rights reserved.
 //
 
 #import "ViewController.h"
 #import "LDKBaseModel.h"
 #import <CommonCrypto/CommonDigest.h>
 
 
 
 #define FileHashDefaultChunkSizeForReadingData 1024*20
 
 CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath,size_t chunkSizeForReadingData) {
 
 // Declare needed variables
 
 CFStringRef result = NULL;
 
 CFReadStreamRef readStream = NULL;
 
 // Get the file URL
 
 CFURLRef fileURL =
 
 CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
 
 (CFStringRef)filePath,
 
 kCFURLPOSIXPathStyle,
 
 (Boolean)false);
 
 if (!fileURL) goto done;
 
 // Create and open the read stream
 
 readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
 
 (CFURLRef)fileURL);
 
 if (!readStream) goto done;
 
 bool didSucceed = (bool)CFReadStreamOpen(readStream);
 
 if (!didSucceed) goto done;
 
 // Initialize the hash object
 
 CC_MD5_CTX hashObject;
 
 CC_MD5_Init(&hashObject);
 
 // Make sure chunkSizeForReadingData is valid
 
 //        if (!chunkSizeForReadingData) {
 //
 //        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
 //
 //    }
 
 // Feed the data to the hash object
 
 bool hasMoreData = true;
 
 while (hasMoreData) {
 
 uint8_t *buffer = malloc(chunkSizeForReadingData);
 
 CFIndex readBytesCount = CFReadStreamRead(readStream,(UInt8 *)buffer,chunkSizeForReadingData);
 
 if (readBytesCount == -1) break;
 
 if (readBytesCount == 0) {
 
 hasMoreData = false;
 
 continue;
 
 }
 
 CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);
 
 }
 
 // Check if the read operation succeeded
 
 didSucceed = !hasMoreData;
 
 // Compute the hash digest
 
 unsigned char digest[CC_MD5_DIGEST_LENGTH];
 
 CC_MD5_Final(digest, &hashObject);
 
 // Abort if the read operation failed
 
 if (!didSucceed) goto done;
 
 // Compute the string result
 
 char hash[2 * sizeof(digest) + 1];
 
 for (size_t i = 0; i < sizeof(digest); ++i) {
 
 snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
 
 }
 
 result = CFStringCreateWithCString(kCFAllocatorDefault,(const char *)hash,kCFStringEncodingUTF8);
 
 
 
 done:
 
 if (readStream) {
 
 CFReadStreamClose(readStream);
 
 CFRelease(readStream);
 
 }
 
 if (fileURL) {
 
 CFRelease(fileURL);
 
 }
 
 return result;
 
 }
 
 @interface ViewController ()
 
 @end
 
 @implementation ViewController
 
 
 +(NSString*)getFileMD5WithPath:(NSString*)path
 
 {size_t dd;
 NSFileManager* manager = [NSFileManager defaultManager];
 if ([manager fileExistsAtPath:path]){
 dd =  [[manager attributesOfItemAtPath:path error:nil] fileSize];
 }
 
 
 
 return (__bridge_transfer NSString *)FileMD5HashCreateWithPath((__bridge CFStringRef)path, dd);
 
 }
 
 - (void)viewDidLoad {
 [super viewDidLoad];
 // Do any additional setup after loading the view, typically from a nib.
 }
 
 - (void)didReceiveMemoryWarning {
 [super didReceiveMemoryWarning];
 // Dispose of any resources that can be recreated.
 }
 
 - (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
 {
 //    LDKBaseModel *basemodel = [[LDKBaseModel alloc] init];
 //    [basemodel getFromURL:@"http://www.baidu.com" withURLParameters:nil finished:^(id data, NSURLRequest *request, NSError *error) {
 //        NSLog(@"%@",data);
 //    }];
 NSString * dmd5 = [ViewController getFileMD5WithPath:@"/Users/zhangyuanke/Desktop/Projects/Test/testapp/testapp/testapp/quanguogaiyaotu.zip"];
 NSLog(@"%@",dmd5);
 
 
 
 
 
 
 
 NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:@"/Users/zhangyuanke/Desktop/Projects/Test/testapp/testapp/testapp/全国概要图.zip"];
 if( handle== nil ) {
 //        return nil;
 }
 CC_MD5_CTX md5;
 CC_MD5_Init(&md5);
 BOOL done = NO;
 while(!done)
 {
 NSData* fileData = [handle readDataOfLength: 256 ];
 CC_MD5_Update(&md5, [fileData bytes], (CC_LONG)[fileData length]);
 if( [fileData length] == 0 ) done = YES;
 }
 unsigned char digest[CC_MD5_DIGEST_LENGTH];
 CC_MD5_Final(digest, &md5);
 // 38665db3f32aae038b8a24e041f81ac6
 NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
 digest[0], digest[1],
 digest[2], digest[3],
 digest[4], digest[5],
 digest[6], digest[7],
 digest[8], digest[9],
 digest[10], digest[11],
 digest[12], digest[13],
 digest[14], digest[15]];
 NSLog(@"%@",s);
 
 //    return s;
 }
 
 @end

 */
