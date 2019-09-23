//
//  XDCallCenterController.m
//  视频预览
//
//  Created by stone on 8/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDCallCenterController.h"
#import "CTCPlayerView.h"
#import "CTCCallCenterBusiness.h"
#import <AVFoundation/AVFoundation.h>
#import "XDSoundVibrate.h"
#import "ZHYJSDK.h"
#import "ZHYJCallInfo.h"

typedef NS_ENUM(NSInteger, CTCCallOpenDoorType) {
    CTCCallOpenDoorTypeRealPlay = 1,              //无通话或通话结束
    CTCCallOpenDoorTypeVoiceTalk = 2           //被叫响铃中
};

@interface XDCallCenterController () <CTCCallCenterBusinessDelegate> {
    CTCCallCenterBusiness *callCenterBusiness;
}
@property (weak, nonatomic) IBOutlet CTCPlayerView *playView;
@property (weak, nonatomic) IBOutlet UIView *answerView;
@property (weak, nonatomic) IBOutlet UIView *rejectView;
@property (weak, nonatomic) IBOutlet UIButton *hungUpBtn;
@property (weak, nonatomic) IBOutlet UILabel *hungUpLabel;

@end

@implementation XDCallCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 播放铃声
    [[XDSoundVibrate shareXDSoundVibrate] playAlertSoundWithSourcePath:@"sound_phone.caf" isCyclic:YES];
    
    // 获取权限
    [self getAudioPermission];
    
    callCenterBusiness = [CTCCallCenterBusiness sharedInstance];
    callCenterBusiness.delegate = self;
    
    // 开始预览
    [callCenterBusiness startVideoPlay:self.playView];
    [callCenterBusiness startGetDeviceStatus];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.playView startloading];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [callCenterBusiness endGetDeviceStatus];
    [callCenterBusiness stopAlertSound];
    [callCenterBusiness stopRealPlay];
    callCenterBusiness.delegate = nil;
}

- (IBAction)answerAction:(id)sender {
    [callCenterBusiness answer];
}

- (IBAction)rejectAction:(id)sender {
    [callCenterBusiness reject];
}

- (IBAction)hungUpAction:(id)sender {
    [callCenterBusiness hangUp];
}

- (IBAction)unlockAciton:(id)sender {
    [callCenterBusiness unlock];
}

#pragma mark - Private
- (void)getAudioPermission {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        AVAudioSessionRecordPermission permissionStatus = [[AVAudioSession sharedInstance] recordPermission];
        
        switch (permissionStatus) {
            case AVAudioSessionRecordPermissionUndetermined:{
                [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                    if (granted) {
                        // Microphone enabled code
                    }
                    else {
                        // Microphone disabled code
                    }
                }];
                break;
            }
            case AVAudioSessionRecordPermissionDenied:
                // direct to settings...
                NSLog(@"已经拒绝麦克风弹框");
                
                break;
            case AVAudioSessionRecordPermissionGranted:
                NSLog(@"已经允许麦克风弹框");
                break;
            default:
                
                break;
        }
        if(permissionStatus == AVAudioSessionRecordPermissionUndetermined) return;
    }
}

#pragma mark - CTCCallCenterBusinessDelegate
-(void)callstatusUpdated:(CTCCallStatus)callstatus {
    if (callstatus == CTCCallStatusNone) {
        self.answerView.hidden = YES;
        self.rejectView.hidden = YES;
        self.hungUpBtn.hidden = YES;
        self.hungUpLabel.hidden = YES;
        [self.navigationController popViewControllerAnimated:YES];
    } else if (callstatus == CTCCallStatusInCome) {
        self.answerView.hidden = YES;
        self.rejectView.hidden = YES;
        self.hungUpBtn.hidden = NO;
        self.hungUpLabel.hidden = NO;
    }
}

@end
