//
//  XYMLabRecord.m
//  WXMapiPhone
//
//  Created by Leador on 1/4/12.
//  Copyright (c) 2012 IShowChina. All rights reserved.
//

#import "XYMLabRecord.h"
#import "XYMLabDefine.h"

@implementation XYMLabRecord
@synthesize ID = _ID, type = _type, title = _title, subTitle = _subTitle, isAvailable = _isAvailable, action = _action, image = _image, subImage = _subImage, expire = _expire, hasDetail = _hasDetail;

- (id) init
{
    if (self = [super init]) {
        _ID         = nil;
        _type       = nil;
        _title      = nil;
        _subTitle   = nil;
        _isAvailable  = nil;
        _action     = nil;
        _image      = nil;
        _subImage   = nil;
        _expire     = nil;
        _hasDetail  = nil;
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:_ID       forKey:LAB_ID];
	[encoder encodeObject:_type     forKey:LAB_TYPE];
	[encoder encodeObject:_title	forKey:LAB_TITLE];
	[encoder encodeObject:_subTitle forKey:LAB_SUBTITLE];
	[encoder encodeObject:_isAvailable forKey:LAB_ISAVAILABLE];
    [encoder encodeObject:_action   forKey:LAB_ACTION];
	[encoder encodeObject:_image	forKey:LAB_IMAGE];
	[encoder encodeObject:_subImage forKey:LAB_SUBIMAGE];
    [encoder encodeObject:_expire   forKey:LAB_EXPIRE];
    [encoder encodeObject:_hasDetail forKey:LAB_HASDETAIL];
}

- (id) initWithCoder:(NSCoder*)decoder
{
	if (self = [super init]) {
		self.ID         = [decoder decodeObjectForKey:LAB_ID];
		self.type       = [decoder decodeObjectForKey:LAB_TYPE];
		self.title      = [decoder decodeObjectForKey:LAB_TITLE];
		self.subTitle   = [decoder decodeObjectForKey:LAB_SUBTITLE];
		self.isAvailable= [decoder decodeObjectForKey:LAB_ISAVAILABLE];
        self.action     = [decoder decodeObjectForKey:LAB_ACTION];
		self.image      = [decoder decodeObjectForKey:LAB_IMAGE];
		self.subImage   = [decoder decodeObjectForKey:LAB_SUBIMAGE];
        self.expire     = [decoder decodeObjectForKey:LAB_EXPIRE];
        self.hasDetail  = [decoder decodeObjectForKey:LAB_HASDETAIL];
	}
	
	return self;
}

- (id) copyWithZone:(NSZone *)zone
{
	XYMLabRecord *copy = [[XYMLabRecord allocWithZone:zone] init];
	
	copy.ID         = self.ID;
	copy.type       = self.type;
    copy.title      = self.title;
	copy.subTitle   = self.subTitle;
	copy.isAvailable= self.isAvailable;
    copy.action     = self.action;
    copy.image      = self.image;
    copy.subImage   = self.subImage;
    copy.expire     = self.expire;
    copy.hasDetail  = self.hasDetail;
	
	return copy;
}

- (void) dealloc
{
    [_ID        release];
    [_type      release];
    [_title     release];
    [_subTitle  release];
    [_isAvailable release];
    [_action    release];
    [_image     release];
    [_subImage  release];
    [_expire    release];
    [_hasDetail release];
    
    [super dealloc];
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"ID:%@ type:%@ titel:%@ subTitle: %@ isAvailabel:%@ action:%@", _ID, _type,
            _title, _subTitle, _isAvailable, _action];
}
@end
