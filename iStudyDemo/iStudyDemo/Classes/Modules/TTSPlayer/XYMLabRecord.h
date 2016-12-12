//
//  XYMLabRecord.h
//  WXMapiPhone
//
//  Created by Leador on 1/4/12.
//  Copyright (c) 2012 IShowChina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYMLabRecord : NSObject <NSCoding, NSCopying>{
    NSString    *_ID;
    NSString    *_type;
    NSString    *_title;
    NSString    *_subTitle;
    NSString    *_isAvailable;
    NSString    *_action;
    NSString    *_image;
    NSString    *_subImage;
    NSString    *_expire;
    NSString    *_hasDetail;
}
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, copy) NSString *isAvailable;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *subImage;
@property (nonatomic, copy) NSString *expire;
@property (nonatomic, copy) NSString *hasDetail;

- (NSString*) description;
@end
