
#import "AudioBufferPlayer.h"
#import "XYMTTSPlayer.h"
#import "XYMCommonConfigUtility.h"
#import "WXMapAPPDefines.h"

static void interruptionListenerCallback(void* inUserData, UInt32 interruptionState)
{
    [XYMCommonConfigUtility commonConfig].resetMixSound = YES;
}

static void playCallback(void* inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer)
{
    AudioBufferPlayer* player = (AudioBufferPlayer*) inUserData;
    
#ifdef DUCK_MIXABLE_AUDIO
    [player.delegate audioBufferPlayer:player fillBuffer:inBuffer format:player.audioFormat];
    
    if (inBuffer->mAudioDataByteSize > 0) {
        AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
    } else {
        AudioQueueFlush(inAQ);
        [player stop];
    }
#else
    if (player.playing)
    {
        [player.delegate audioBufferPlayer:player fillBuffer:inBuffer format:player.audioFormat];
        AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
    }
#endif
}

@interface AudioBufferPlayer()
{
#ifdef DUCK_MIXABLE_AUDIO
    dispatch_queue_t _playerQueue;
#endif
}

@end

@implementation AudioBufferPlayer

@synthesize delegate;
@synthesize playing;
@synthesize gain;
@synthesize audioFormat;

- (id)initWithSampleRate:(Float64)sampleRate channels:(UInt32)channels bitsPerChannel:(UInt32)bitsPerChannel secondsPerBuffer:(Float64)secondsPerBuffer
{
	return [self initWithSampleRate:sampleRate channels:channels bitsPerChannel:bitsPerChannel packetsPerBuffer:(UInt32)(secondsPerBuffer * sampleRate)];
}

- (id)initWithSampleRate:(Float64)sampleRate channels:(UInt32)channels bitsPerChannel:(UInt32)bitsPerChannel packetsPerBuffer:(UInt32)packetsPerBuffer_
{
    if ((self = [super init]))
    {
#ifdef DUCK_MIXABLE_AUDIO
        _playerQueue = dispatch_queue_create("com.ishowmap.audiobufferplayer", DISPATCH_QUEUE_SERIAL);
#endif
        playing = NO;
        delegate = nil;
        playQueue = NULL;
        gain = 1.0;
        
        audioFormat.mFormatID         = kAudioFormatLinearPCM;
        audioFormat.mSampleRate       = sampleRate;
        audioFormat.mChannelsPerFrame = channels;
        audioFormat.mBitsPerChannel   = bitsPerChannel;
        audioFormat.mFramesPerPacket  = 1;  // uncompressed audio
        audioFormat.mBytesPerFrame    = audioFormat.mChannelsPerFrame * audioFormat.mBitsPerChannel/8;
        audioFormat.mBytesPerPacket   = audioFormat.mBytesPerFrame * audioFormat.mFramesPerPacket;
        audioFormat.mFormatFlags      = kLinearPCMFormatFlagIsSignedInteger
                                      | kLinearPCMFormatFlagIsPacked;
        
        packetsPerBuffer = packetsPerBuffer_;
        bytesPerBuffer = packetsPerBuffer * audioFormat.mBytesPerPacket;
        
        [self setUpAudio];
    }
    return self;
}

- (void)dealloc
{
    [self tearDownAudio];
    
#ifdef DUCK_MIXABLE_AUDIO
    dispatch_release(_playerQueue);
#endif
    
    [super dealloc];
}

- (void)setUpAudio
{
    [self tearDownAudio];//摄像后会影响导航的语音播报
	if (playQueue == NULL)
	{
		[self setUpAudioSession];
		[self setUpPlayQueue];
		[self setUpPlayQueueBuffers];
	}
}

- (void)tearDownAudio
{
	if (playQueue != NULL)
	{
#ifndef DUCK_MIXABLE_AUDIO
		[self stop];
#endif
		[self tearDownPlayQueue];
		[self tearDownAudioSession];
	}
}

- (void)setUpAudioSession
{
	AudioSessionInitialize(
		NULL,
		NULL,
		interruptionListenerCallback,
		self
		);
    
	UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
	AudioSessionSetProperty(
		kAudioSessionProperty_AudioCategory,
		sizeof(sessionCategory),
		&sessionCategory
		);
    
    UInt32 inDataSize = 1;
#ifdef MUTEX_SOUND
    if ([XYMCommonConfigUtility commonConfig].mixSoundClose) {
        inDataSize = 0;
    }
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(inDataSize), &inDataSize);
#else
    if ([XYMCommonConfigUtility commonConfig].mixSoundClose) {
        AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(inDataSize), &inDataSize);
        AudioSessionSetProperty(kAudioSessionProperty_OtherMixableAudioShouldDuck, sizeof(inDataSize), &inDataSize);
    }
    else {
        AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(inDataSize), &inDataSize);
    }
#endif

	AudioSessionSetActive(true);
}

- (void)tearDownAudioSession
{
    AudioSessionSetActive(false);
}

- (void)resetupAudioSession
{
//    [self tearDownAudioSession];
    [self setUpAudioSession];
}

- (void)setAudioSessionPropertyWithDuckOthers:(BOOL)duck
{
    AudioSessionSetActive(false);
    
    UInt32 value = 1;
    if (duck && [XYMCommonConfigUtility commonConfig].mixSoundClose) {
        AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(value), &value);
        AudioSessionSetProperty(kAudioSessionProperty_OtherMixableAudioShouldDuck, sizeof(value), &value);
    }
    else {
        AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(value), &value);
    }
    
    AudioSessionSetActive(true);
}

- (void)setUpPlayQueue
{
	AudioQueueNewOutput(
		&audioFormat,
		playCallback,
		self, 
		NULL,                   // run loop
		kCFRunLoopCommonModes,  // run loop mode
		0,                      // flags
		&playQueue
		);

	self.gain = 1.0;
}

- (void)tearDownPlayQueue
{
	AudioQueueDispose(playQueue, true);
	playQueue = NULL;
}

- (void)setUpPlayQueueBuffers
{
	for (int t = 0; t < NUMBER_AUDIO_DATA_BUFFERS; ++t)
	{
		AudioQueueAllocateBuffer(
			playQueue,
			bytesPerBuffer,
			&playQueueBuffers[t]
			);
	}
}

- (void)primePlayQueueBuffers
{
	for (int t = 0; t < NUMBER_AUDIO_DATA_BUFFERS; ++t)
	{
		playCallback(self, playQueue, playQueueBuffers[t]);
	}
}

- (void)start
{
#ifdef DUCK_MIXABLE_AUDIO
    dispatch_async(_playerQueue, ^{
        if (!playing)
        {
            [self setAudioSessionPropertyWithDuckOthers:YES];
            
            [self primePlayQueueBuffers];
            AudioQueueStart(playQueue, NULL);
            playing = YES;
        }
    });
#else
	if (!playing)
	{
		playing = YES;
		[self primePlayQueueBuffers];
		AudioQueueStart(playQueue, NULL);
	}
#endif
}

- (void)stop
{
#ifdef DUCK_MIXABLE_AUDIO
    dispatch_async(_playerQueue, ^{
        if (playing)
        {
            AudioQueueStop(playQueue, true);
            playing = NO;
            
            [self setAudioSessionPropertyWithDuckOthers:NO];
        }
    });
#else
	if (playing)
	{
		AudioQueueStop(playQueue, TRUE);
		playing = NO;
	}
#endif
}

- (void)setGain:(Float32)gain_
{
	gain = gain_;

	AudioQueueSetParameter(
		playQueue,
		kAudioQueueParam_Volume,
		gain
		);
}

@end
