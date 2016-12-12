//
//  OggFilePlayer.m
//  AMapiPhone
//
//  Created by Fang xiaorong on 12/10/13.
//
//

#import "OggFilePlayer.h"
#import "ogg.h"
#import "vorbisfile.h"
#import "AMTTSPlayer.h"

@interface OggFilePlayer () {
    NSString*           _voiceFile;
    NSMutableData*      _pcmData;

    NSInteger           _playLocation;
    AudioBufferPlayer*  _player;
}

@property (nonatomic, copy)   NSString*         voiceFile;
@property (nonatomic, retain) NSMutableData*    pcmData;
@end

@implementation OggFilePlayer

- (id)initWithFile:(NSString *)oggFile {
    self = [super init];
    if (self != nil) {
        self.voiceFile = oggFile;
        _pcmData = [[NSMutableData alloc] init];
        _playLocation = 0;
    }
    return self;
}
- (void)play {
    OggVorbis_File vf;
    
    AMTTSPlayer* ttsPlay = [AMTTSPlayer shareInstanceWithSubscriber:nil];
    [ttsPlay onInterruptionBegin];
    
    FILE* oggHandle = fopen([_voiceFile UTF8String], "rb");
    if (oggHandle == NULL) {
        [self _onPlayEndAction];
        return;
    }
    
    if (ov_open_callbacks(oggHandle, &vf, NULL, 0, OV_CALLBACKS_DEFAULT) < 0) {
        [self _onPlayEndAction];
        fclose(oggHandle);
        return;
    }
    
    vorbis_info* vi = ov_info(&vf, -1);
    int rate = vi->rate;
    int channels = vi->channels;
    ov_pcm_total(&vf, -1);
    
    BOOL isEnd = NO;
    char pcmBuffer[4096];
    while (!isEnd) {
        long ret = ov_read(&vf, pcmBuffer, sizeof(pcmBuffer), 0, 2, 1, 0);
        if (ret == 0) {
            isEnd = YES;
        } else if (ret < 0) {
            break;
        } else {
            //
            [_pcmData appendBytes:pcmBuffer length:ret];
        }
    }
    ov_clear(&vf);
    fclose(oggHandle);
    
    _playLocation = 0;
    
    _player = [[AudioBufferPlayer alloc] initWithSampleRate:rate channels:channels bitsPerChannel:16 packetsPerBuffer:1024];
    _player.delegate = (id<AudioBufferPlayerDelegate>)self;
	_player.gain = 0.9f;
	[_player start];
}

- (void)audioBufferPlayer:(AudioBufferPlayer*)audioBufferPlayer fillBuffer:(AudioQueueBufferRef)buffer
                   format:(AudioStreamBasicDescription)audioFormat {
    static NSInteger bufferLength = 0;
    
    memset(buffer->mAudioData, 0, buffer->mAudioDataBytesCapacity);
	@synchronized(_pcmData) {
		if(_pcmData.length > 0) {
			if(_pcmData.length >= (_playLocation + buffer->mAudioDataBytesCapacity)) {
				bufferLength = buffer->mAudioDataBytesCapacity;
			} else {
				bufferLength = _pcmData.length - _playLocation;
			}
			[_pcmData getBytes:buffer->mAudioData range:NSMakeRange(_playLocation, bufferLength)];
			_playLocation += bufferLength;
		} else {
			bufferLength = buffer->mAudioDataBytesCapacity;
		}
	}
	
	if(bufferLength <= 0) {
        [self stopPlay];
	}
    
	// We have to tell the buffer how many bytes we wrote into it.
	buffer->mAudioDataByteSize = buffer->mAudioDataBytesCapacity;
}

- (void)stopPlay {
    if (_player != nil) {
        [_player stop];
        [_player release];
        _player = nil;
    }
}

- (void)_onPlayEndAction {
    if (_player != nil) {
        [_player release];
        _player = nil;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(onPlayerEnded:)]) {
        [_delegate onPlayerEnded:self];
    }
}

- (void)dealloc {
    self.voiceFile = nil;
    self.pcmData = nil;
    [self stopPlay];
    
    [super dealloc];
}

@end
