//
//  CTCCallCenterBusiness.m
//  CommunityCloud
//
//  Created by shilei on 17/11/22.
//  Copyright © 2017年 hikvision. All rights reserved.
//

#import "ZHYJSDK.h"
#import "EZOpenSDK.h"
#import "CTCCallCenterBusiness.h"
#include <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "XDSoundVibrate.h"

typedef NS_ENUM(NSInteger, CTCCallOpenDoorType) {
    CTCCallOpenDoorTypeRealPlay = 1,              //无通话或通话结束
    CTCCallOpenDoorTypeVoiceTalk = 2           //被叫响铃中
};

// 最长呼叫时间，超时即自动放弃
static const NSInteger kCallTimeOutSeconds = 30;

//接听后最长通话时间
static const NSInteger c_talkingTime = 60;

@interface CTCCallCenterBusiness () {
    AVAudioPlayer    *g_audioPlayer;            /**< 播放呼叫铃声*/
    NSTimer          *g_timer;                  /**< 计时器*/
    NSInteger        g_seconds;                 /**< 计时器*/
    NSTimer *deviceStatusTimer; // 获取设备状态的定时器
    ZHYJDeviceCallStatus deviceStatus;
}
@property (nonatomic, strong) NSDate  *startDate;
@end

@implementation CTCCallCenterBusiness

- (void)dealloc {
    
}

+ (instancetype)sharedInstance
{
    static CTCCallCenterBusiness *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CTCCallCenterBusiness alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.callInfo = [[ZHYJCallInfo alloc] init];
    }
    return self;
}

- (void)didBecomeActive {
    
}
#pragma mark - 视频预览
-(void)startVideoPlay:(CTCPlayerView *)playView{
    [playView startloading];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [ZHYJSDK startRealPlayWithDeviceSerial:self.callInfo.deviceSerial cameraNo:1 inView:playView completion:^(BOOL succeed, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (succeed) {
                    [playView endloading];
                } else {
                    [XDUtil showToast:error.localizedDescription];
                }
                NSLog(@"succeed = %d error = %@",succeed,error);
            });
        }];
    });
}

-(void)stopRealPlay{
    [ZHYJSDK stopRealPlay];
}

#pragma mark - 通话操作
-(void)answer {
    [ZHYJSDK answer:self.callInfo completion:^(BOOL succeed, NSError *error) {
        [self stopAlertSound];
        if (succeed) {
//            [XDUtil showToast:@"接听成功"];
            self.status = CTCCallStatusInCome;
            self.startDate = [NSDate date];
            [self revokeTimer];
            [self startTiming];
        } else {
//            NSLog(@"answer failed: %@ %@", @(error.code), error.localizedDescription);
//            NSString *errorStr = [NSString stringWithFormat:@"answer failed: error.code-%@ error.localizedDescription-%@", @(error.code), error.localizedDescription];
//            [XDUtil showToast:errorStr];
//            [XDUtil showToast:@"呼叫已取消"];
            [XDUtil showToast:error.localizedDescription];
            [self clearAll];
        }
    } hangUp:^{
        [self stopAlertSound];
        [self revokeDeviceStatusTimer];
        [self UploadCallTime];
        [self clearAll];
    }];
}

- (void)reject {
    [self stopAlertSound];
    [ZHYJSDK reject:self.callInfo completion:^(BOOL succeed, NSError *error) {
        [[XDSoundVibrate shareXDSoundVibrate] playAlertSoundWithSourcePath:@"hungUp.caf" isCyclic:NO];
        if (succeed) {
            [self revokeDeviceStatusTimer];
            [self clearAll];
//            NSLog(@"发送拒接成功");
//            [XDUtil showToast:@"发送拒接成功"];
        } else {
//            NSLog(@"发送拒接失败");
//            NSString *errStr = [NSString stringWithFormat:@"reject failed: error.code-%@ error.localizedDescription-%@", @(error.code), error.localizedDescription];
//            NSLog(@"%@", errStr);
//            [XDUtil showToast:errStr];
            [XDUtil showToast:error.localizedDescription];
        }
    }];
}

- (void)hangUp {
    [self stopAlertSound];
    [ZHYJSDK hangUp:self.callInfo completion:^(BOOL succeed, NSError *error) {
        [[XDSoundVibrate shareXDSoundVibrate] playAlertSoundWithSourcePath:@"hungUp.caf" isCyclic:NO];
        if (succeed) {
            [self revokeDeviceStatusTimer];
            [self UploadCallTime];
            [self clearAll];
//            NSLog(@"hang up succeed");
//            [XDUtil showToast:@"挂断成功"];
        } else {
//            NSString *errStr = [NSString stringWithFormat:@"hang up failed: error.code-%@ error.localizedDescription-%@", @(error.code), error.localizedDescription];
//            NSLog(@"%@", errStr);
//            [XDUtil showToast:errStr];
            [XDUtil showToast:error.localizedDescription];
        }
    }];
}

- (void)stopAlertSound {
    [[XDSoundVibrate shareXDSoundVibrate] stopAlertSound];
}

-(void)screenshot {
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
}

-(void)unlock {
    CTCCallOpenDoorType temp = CTCCallOpenDoorTypeRealPlay;
    if (self.status == CTCCallStatusInCome) {
        temp = CTCCallOpenDoorTypeVoiceTalk;
    } else {
        temp = CTCCallOpenDoorTypeRealPlay;
    }
    [ZHYJSDK sendDeviceUnlock:temp deviceSerial:self.callInfo.deviceSerial completion:^(BOOL succeed, NSError *error) {
        
    }];
}

-(void)setStatus:(CTCCallStatus)status {
    _status = status;
    if (self.delegate && [self.delegate respondsToSelector:@selector(callstatusUpdated:)]) {
        [self.delegate callstatusUpdated:status];
    }
}

#pragma mark - 铃声

/**
 * 播放拨打电话的嘟嘟嘟铃声
 */
- (void)playBellRing
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    // 扬声器模式播放来电铃声
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];

    // Create a system sound object representing the sound file.
    //    NSURL *ringSound = [[NSBundle mainBundle] URLForResource: @"ring" withExtension: @"caf"];
    NSURL *ringSound = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"ring" ofType:@"caf"]?:@""];
    g_audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:ringSound error:nil];
    g_audioPlayer.numberOfLoops = 2;
    if (![g_audioPlayer play])
    {
        NSLog(@"Something goes wrong when trying to play ring tone～");
    }
}

/**
 * 停止呼叫的声音
 */
- (void)stopCallingSound
{
    [g_audioPlayer stop];
    g_audioPlayer = nil;
}

#pragma mark - 计时器   >>>>>>>>>>>>>>>>>>>>>
- (void)initTimer
{
    double delayInSeconds = 1.0;
    g_timer = [NSTimer scheduledTimerWithTimeInterval:delayInSeconds target:self selector:@selector(updateValueOfTimerOnScreen) userInfo:nil repeats:YES];
}

//开启计时
- (void)startTiming
{
    if (!g_timer)
    {
        g_seconds = 0;
        [self initTimer];
    }
}
//
// 关闭计时器
- (void)revokeTimer
{
    if (g_timer)
    {
        g_seconds = 0;
        [g_timer invalidate];
        g_timer = nil;
    }
}

// 开始轮询获取设备状态
- (void)startGetDeviceStatus {
    if (!deviceStatusTimer) {
        deviceStatusTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(getDeviceStatus) userInfo:nil repeats:YES];
    }
}

// 结束轮询获取设备状态
- (void)endGetDeviceStatus {
    if (!deviceStatusTimer) {
        // 设备已经挂断或者拒接
        return;
    }
    if (deviceStatus == ZHYJDeviceCallStatusCalling) {
        [self reject];
    } else if (deviceStatus == ZHYJDeviceCallStatusAnswering) {
        [self hangUp];
    }
    [self revokeDeviceStatusTimer];
}

- (void)revokeDeviceStatusTimer {
    if (deviceStatusTimer) {
        [deviceStatusTimer invalidate];
        deviceStatusTimer = nil;
    }
}

- (void)getDeviceStatus {
    [ZHYJSDK listenDeviceStatus:self.callInfo answered:^(BOOL succeed, ZHYJDeviceCallStatus deviceCallStatus, NSError *error) {
        deviceStatus = deviceCallStatus;
        if (deviceStatus == ZHYJDeviceCallStatusNoCall) {
//            [XDUtil showToast:@"对方已挂断"];
            self.status = CTCCallStatusNone;
        }
    }];
}

// 更新时间值
- (void)updateValueOfTimerOnScreen
{
}
-(void)clearAll {
    [self revokeTimer];
    g_seconds = 0;
    self.status = CTCCallStatusNone;
}

-(void)UploadCallTime {
    if (self.callInfo == nil) {
        return;
    }
}
@end
