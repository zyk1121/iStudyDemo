//
//  XYMLabDownloadRecord.m
//  WXMapiPhone
//
//  Created by Leador on 1/4/12.
//  Copyright (c) 2012 IShowChina. All rights reserved.
//

#import "XYMLabDownloadRecord.h"

@implementation XYMLabDownloadRecord
@synthesize name = _name, subName = _subName, url = _url, size = _size, image = _image, subImage = _subImage, version = _version;

- (id) init
{
    if (self = [super init]) {
        _name       = nil;
        _subName    = nil;
        _url        = nil;
        _size       = nil;
        _image      = nil;
        _subImage   = nil;
        _version    = nil;
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:_name     forKey:LABDETAIL_NAME];
	[encoder encodeObject:_subName  forKey:LABDETAIL_SUBNAME];
	[encoder encodeObject:_url		forKey:LABDETAIL_URL];
	[encoder encodeObject:_size     forKey:LABDETAIL_SIZE];
	[encoder encodeObject:_image    forKey:LABDETAIL_IMAGE];
	[encoder encodeObject:_subImage	forKey:LABDETAIL_SUBIMAGE];
	[encoder encodeObject:_version  forKey:LABDETAIL_VERSION];
}

- (id) initWithCoder:(NSCoder*)decoder
{
	if (self = [super init]) {
		self.name       = [decoder decodeObjectForKey:LABDETAIL_NAME];
		self.subName    = [decoder decodeObjectForKey:LABDETAIL_SUBNAME];
		self.url        = [decoder decodeObjectForKey:LABDETAIL_URL];
		self.size       = [decoder decodeObjectForKey:LABDETAIL_SIZE];
		self.image      = [decoder decodeObjectForKey:LABDETAIL_IMAGE];
		self.subImage   = [decoder decodeObjectForKey:LABDETAIL_SUBIMAGE];
		self.version    = [decoder decodeObjectForKey:LABDETAIL_VERSION];
	}
	
	return self;
}

- (id) copyWithZone:(NSZone *)zone
{
	XYMLabDownloadRecord *copy = [[XYMLabDownloadRecord allocWithZone:zone] init];
	
	copy.name       = self.name;
	copy.subName    = self.subName;
    copy.url        = self.url;
	copy.size       = self.size;
	copy.image      = self.image;
    copy.subImage   = self.subImage;
    copy.version    = self.version;
	
	return copy;
}

- (void) dealloc
{
    [_name      release];
    [_subName   release];
    [_url       release];
    [_size      release];
    [_image     release];
    [_subImage  release];
    [_version   release];
    
    [super      dealloc];
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"dialect record: <%@-%@-%@-%@-%@-%@-%@>", _name, _subName, _url, _size, _image, _subImage, _version]; 
}
@end
