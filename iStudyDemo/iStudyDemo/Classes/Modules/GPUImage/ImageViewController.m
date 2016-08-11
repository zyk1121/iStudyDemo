//
//  ViewController.m
//  ImgTest
//
//  Created by gaoyh on 16/8/9.
//  Copyright © 2016年 leador. All rights reserved.
//

#import "ViewController.h"

/**
 *  图像数据结构
 */
typedef struct _IShowImageData {
    CGContextRef  context;  // 上下文
    unsigned char *data;    // 图像数据区
    size_t        width;    // 图像宽
    size_t        height;   // 图像高
    size_t        component;// 通道
} IShowImageData;

/**
 *  createBitmapRGBA8Context
 */
CGContextRef createBitmapRGBA8ContextFromImage(CGImageRef image) {
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    uint32_t *bitmapData;
    size_t bitsPerPixel = 32;
    size_t bitsPerComponent = 8;
    size_t bytesPerPixel = bitsPerPixel / bitsPerComponent;
    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    size_t bytesPerRow = width * bytesPerPixel;
    size_t bufferLength = bytesPerRow * height;
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if(!colorSpace) {
        printf("Error allocating color space RGB\n");
        return NULL;
    }
    // Allocate memory for image data
    bitmapData = (uint32_t *)malloc(bufferLength);
    memset(bitmapData, 0, bufferLength);
    if(!bitmapData) {
        printf("Error allocating memory for bitmap\n");
        CGColorSpaceRelease(colorSpace);
        return NULL;
    }
    /*
     #if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
     int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
     #else
     int bitmapInfo = kCGImageAlphaPremultipliedLast;
     #endif
     */
    context = CGBitmapContextCreate(bitmapData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast);
    if(!context) {
        free(bitmapData);
        printf("Bitmap context not created");
    }
    CGColorSpaceRelease(colorSpace);
    return context;
}

IShowImageData *iShowCreateImageFormImagePath(NSString *path)
{
    IShowImageData *imageData = NULL;
    // 1.读取数据
    /* 读取图像，方式1
    NSData * byteDatas = [NSData dataWithContentsOfFile:path];
    if (!byteDatas) {
        return NULL;
    }
    Byte * data = (Byte*)[byteDatas bytes];
    unsigned long dataSize = [byteDatas length];
    // 2.创建CGImageRef
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, data, dataSize, NULL);
    if (!dataProvider) {
        return NULL;
    }
    CGImageRef imageRef = CGImageCreateWithPNGDataProvider(dataProvider, NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
     */
    // 读取图像方式2，不用区分是jpg还是png
    CGImageRef imageRef = [UIImage imageNamed:path].CGImage;
    if (!imageRef) {
        return NULL;
    }
    // 3.CGContextRef
    CGContextRef context = createBitmapRGBA8ContextFromImage(imageRef);
    if(!context) {
//         CGImageRelease(imageRef);// 读取图像方式2不需要释放
        return NULL;
    }
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    CGRect rect = CGRectMake(0, 0, width, height);
    size_t bytesPerRow = CGBitmapContextGetBytesPerRow(context);
    size_t component = bytesPerRow / width;
    // Draw image into the context to get the raw image data
    CGContextDrawImage(context, rect, imageRef);
//    CGImageRelease(imageRef); // 读取图像方式2不需要释放
    // Get a pointer to the data
    unsigned char *bitmapData = (unsigned char *)CGBitmapContextGetData(context);
    // imagedata
    if (bitmapData) {
        imageData = (IShowImageData *)malloc(sizeof(IShowImageData));
        if (!imageData) {
            free(bitmapData);
            CGContextRelease(context);
            context = NULL;
            return NULL;
        }
        imageData->component = component;
        imageData->width = width;
        imageData->height = height;
        imageData->data = bitmapData;
        imageData->context = context;
    }
    // return
    return imageData;
}

void iShowReleaseImageData(IShowImageData * imageData)
{
    if (imageData) {
        if (imageData->data) {
            free(imageData->data);
            imageData->data = NULL;
        }
        if (imageData->context) {
            CGContextRelease(imageData->context);
            imageData->context = NULL;
        }
        free(imageData);
        imageData = NULL;
    }
}

void saveImageDataToPath(IShowImageData * imageData, NSString *path)
{
    size_t bitsPerComponent = 8;
    size_t bitsPerPixel = 32;
    size_t bytesPerRow2 = 4 * imageData->width;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentAbsoluteColorimetric;
    // make the cgimage
    unsigned char *bitmapData = (unsigned char *)imageData->data;
    
    
    NSInteger dataLength = imageData->width*imageData->height* 4;
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, bitmapData, dataLength, NULL);
    
    
    CGImageRef imageRef2 = CGImageCreate(imageData->width,   imageData->height,   bitsPerComponent,    bitsPerPixel,   bytesPerRow2,
                                         colorSpaceRef,bitmapInfo,provider,NULL, NO, renderingIntent);
    UIImage *my_Image = [UIImage imageWithCGImage:imageRef2];
    
    NSData *ff = UIImagePNGRepresentation(my_Image);
    [ff writeToFile:path atomically:YES];
    CGDataProviderRelease(provider);
}


void createSmallImageForm(IShowImageData * imageData)
{
    size_t width = 256;
    size_t height = 256;
    size_t component = 4;
    int row = 3;
    int col = 4;
    
    static int index = 0;
    for (int i = 0; i < row; i++) {
        for (int j = 0; j < col; j++) {
            //
            IShowImageData  *image = malloc(sizeof(IShowImageData));
            size_t imageLen = width * height *component;
            image->data = malloc(imageLen);
            memset(image->data, 0, imageLen);
            image->width = width;
            image->height = height;
            image->component = component;
            
            // 复制数据
            for (int m = 0; m < 256; m++) {
                for (int n = 0; n < 256; n++) {
                    image->data[(m * 256 + n) * 4 + 0] = imageData->data[((i*256) * 1024 + m * 1024 +n + j*256) * 4 + 0];
                    image->data[(m * 256 + n) * 4 + 1] = imageData->data[((i*256) * 1024 + m * 1024 +n + j*256) * 4 + 1];
                    image->data[(m * 256 + n) * 4 + 2] = imageData->data[((i*256) * 1024 + m * 1024 +n + j*256) * 4 + 2];
                    image->data[(m * 256 + n) * 4 + 3] = imageData->data[((i*256) * 1024 + m * 1024 +n + j*256) * 4 + 3];
                }
            }
            
            index++;
            saveImageDataToPath(image, [NSString stringWithFormat:@"/Users/zhangyuanke/Desktop/Temp/Image/%d.png",index]);
            iShowReleaseImageData(image);
        }
    }
    

}

@interface ViewController ()

@end

@implementation ViewController

CGContextRef newBitmapRGBA8ContextFromImage(CGImageRef image) {
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    uint32_t *bitmapData;
    size_t bitsPerPixel = 32;
    size_t bitsPerComponent = 8;
    size_t bytesPerPixel = bitsPerPixel / bitsPerComponent;
    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    size_t bytesPerRow = width * bytesPerPixel;
    size_t bufferLength = bytesPerRow * height;
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if(!colorSpace) {
        printf("Error allocating color space RGB\n");
        return NULL;
    }
    // Allocate memory for image data
    bitmapData = (uint32_t *)malloc(bufferLength);
    memset(bitmapData, 0, bufferLength);
    if(!bitmapData) {
        printf("Error allocating memory for bitmap\n");
        CGColorSpaceRelease(colorSpace);
        return NULL;
    }
    //Create bitmap context
    //context = CGBitmapContextCreate(bitmapData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaNoneSkipLast);// BGR
    /*
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
     */
    context = CGBitmapContextCreate(bitmapData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast);// BGR
    if(!context) {
        free(bitmapData);
        printf("Bitmap context not created");
    }
    CGColorSpaceRelease(colorSpace);
    return context;
}


unsigned char *convertImageRefToBitmapRGB(CGImageRef imageRef) {
    // Create a bitmap context to draw the uiimage into
    CGContextRef context = newBitmapRGBA8ContextFromImage(imageRef);
    if(!context) {
        return NULL;
    }
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    CGRect rect = CGRectMake(0, 0, width, height);
    // Draw image into the context to get the raw image data
    CGContextDrawImage(context, rect, imageRef);
    // Get a pointer to the data
    unsigned char *bitmapData = (unsigned char *)CGBitmapContextGetData(context);
    

    NSInteger dataLength = width*height* 4;
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, bitmapData, dataLength, NULL);
    
    /*
    // prep the ingredients
    size_t bitsPerComponent = 8;
    size_t bitsPerPixel = 32;
    size_t bytesPerRow2 = 4 * width;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentAbsoluteColorimetric;
    // make the cgimage
    CGImageRef imageRef2 = CGImageCreate(width,   height,   bitsPerComponent,    bitsPerPixel,   bytesPerRow2,
                                        colorSpaceRef,bitmapInfo,provider,NULL, NO, renderingIntent);
    unsigned char data[1024] = {0};
    memcpy(data, bitmapData, 1024);
    int i = 0;
    UIImage *my_Image = [UIImage imageWithCGImage:imageRef2];
    
    NSData *ff = UIImagePNGRepresentation(my_Image);
    [ff writeToFile:@"/Users/zhangyuanke/Desktop/123.png" atomically:YES];
    */
    
    // Copy the data and release the memory (return memory allocated with new)
    
    
    size_t bytesPerRow = CGBitmapContextGetBytesPerRow(context);
    size_t bufferLength = bytesPerRow * height;
    size_t component = bytesPerRow / width;
    unsigned char *newBitmap = NULL;
    if(bitmapData) {
        newBitmap = (unsigned char *)malloc(sizeof(unsigned char) * width * height * 4);
        if(newBitmap) {
            // Copy the data
            int pos = 0;
            for(int i = 0; i < bufferLength; i+=4) {
                newBitmap[pos++] = bitmapData[i];
                newBitmap[pos++] = bitmapData[i+1];
                newBitmap[pos++] = bitmapData[i+2];
                newBitmap[pos++] = bitmapData[i+3];
            }
        }
        free(bitmapData);
    } else {
        printf("Error getting bitmap pixel data\n");
    }
    CGContextRelease(context);
    return newBitmap;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"start-----");
//    for (int i  = 0; i < 10000; i++) {
//        NSString * path = @"/Users/zhangyuanke/Desktop/10177.png";
         NSString * path = @"/Users/zhangyuanke/Desktop/Temp/Image/imgr.jpeg";
        IShowImageData *imageData = iShowCreateImageFormImagePath(path);
    createSmallImageForm(imageData);
//        saveImageDataToPath(imageData, @"/Users/zhangyuanke/Desktop/test.png");
        iShowReleaseImageData(imageData);
        imageData = NULL;
//        NSLog(@"%d",i);
//    }
    NSLog(@"end-----");
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
   
    /*
    NSData * byteDatas = [NSData dataWithContentsOfFile:path];
    Byte * data = (Byte*)[byteDatas bytes];
    unsigned long dataSize = [byteDatas length];

    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, data, dataSize, NULL);
    CGImageRef imageRef = CGImageCreateWithPNGDataProvider(dataProvider, NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    unsigned char * buffer = (unsigned char *)convertImageRefToBitmapRGB(imageRef);
    if(buffer){
        unsigned char data[1024] = {0};
        memcpy(data, buffer + 1024 *5, 1024);
        // 使用buffer
        // 释放buffer
    }
    CGImageRelease(imageRef);
     */
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
