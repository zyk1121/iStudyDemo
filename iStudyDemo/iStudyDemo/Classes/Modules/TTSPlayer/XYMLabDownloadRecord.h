//
//  XYMLabDownloadRecord.h
//  WXMapiPhone
//
//  Created by Leador on 1/4/12.
//  Copyright (c) 2012 IShowChina. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LABDETAIL_NAME        @"name"
#define LABDETAIL_SUBNAME     @"subname"
#define LABDETAIL_URL         @"url"
#define LABDETAIL_SIZE        @"size"
#define LABDETAIL_IMAGE       @"image"
#define LABDETAIL_SUBIMAGE    @"subimage"
#define LABDETAIL_VERSION     @"version"

@interface XYMLabDownloadRecord : NSObject <NSCoding, NSCopying>{
    NSString    *_name;
    NSString    *_subName;
    NSString    *_url;
    NSString    *_size;
    NSString    *_image;
    NSString    *_subImage;
    NSString    *_version;
}
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *subName;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *subImage;
@property (nonatomic, copy) NSString *version;

@end
