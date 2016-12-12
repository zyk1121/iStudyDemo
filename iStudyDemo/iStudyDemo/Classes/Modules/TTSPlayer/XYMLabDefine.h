//
//  XYMLabDefine.h
//  WXMapiPhone
//
//  Created by Leador on 1/6/12.
//  Copyright (c) 2012 IShowChina. All rights reserved.
//

#define AMLABITEMSLIST          @"labItemsList.plist"
#define AMLABCONFIGUREFOLDER    [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/laboratory"]
#define AMLABCONFIGURE          [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/laboratory/labConfigureV2.plist"]
#define AMLABCONFIGUREV1        [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/laboratory/labConfigure.plist"]

#define LAB_ID          @"id"
#define LAB_TYPE        @"type"
#define LAB_TITLE       @"title"
#define LAB_SUBTITLE    @"subtitle"
#define LAB_ISAVAILABLE @"on"
#define LAB_ACTION      @"action"
#define LAB_IMAGE       @"image"
#define LAB_SUBIMAGE    @"subimage"
#define LAB_EXPIRE      @"expire"
#define LAB_HASDETAIL   @"hasDetail"

#define LAB_CONFIGURE_SELECTEDDIALECT       @"selectedDialect"
#define LAB_CONFIGURE_DIALECT_ISAVAILABLE   @"isAvailable"
#define LAB_CONFIGURE_ISTURNON              @"isTurnOn"

#ifndef LAB_TURNON
#define LAB_TURNON  
#endif
