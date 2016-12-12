//
//  OggFilePlayer.h
//  AMapiPhone
//
//  Created by Fang xiaorong on 12/10/13.
//
//

#import <Foundation/Foundation.h>

@class OggFilePlayer;

@protocol OggFilePlayerDelegate <NSObject>

- (void)onPlayerEnded:(OggFilePlayer *)player;

@end

@interface OggFilePlayer : NSObject {
    id<OggFilePlayerDelegate> _delegate;
}

- (id)initWithFile:(NSString *)oggFile;
- (void)play;

@property (nonatomic, assign) id<OggFilePlayerDelegate> delegate;

@end
