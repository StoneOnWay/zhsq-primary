//
//  AppDelegate.m
//  XD业主
//
//  Created by zc on 2017/6/16.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "AppDelegate.h"
#import "XDLoginViewController.h"
#import "XDWarrantyDetailController.h"
#import "XDMyComplainDetailController.h"
#import "XDInfoNewDetailNetController.h"
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>
#import "WXApi.h"
#import "SDPaymentTool.h"
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>
#import "ZHYJSDK.h"
#import "CTCCallCenterBusiness.h"
#import "ZHYJCallInfo.h"
#import <AudioToolbox/AudioToolbox.h>
#import "XDCallCenterController.h"
#import "XDSecondaryTabBarController.h"
#import <JMessage/JMessage.h>
#import "XDHTTPManager.h"

#define JPUSH_APPKEY @"9d5199c1d83613fa2ccaffb8"
#define CHANNEL @"Develop channel"

@interface AppDelegate ()<JPUSHRegisterDelegate,CustomAlertViewDelegate,JMessageDelegate>

@property(nonatomic ,copy)NSString *downUrl;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    //拍照用的同一个框架 有些地方是三个 有些地方是九个
    [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:@"kMaxImageCount"];
    
    //获取账号信息
    XDLoginUseModel *loginAccout = [XDReadLoginModelTool loginModel];
    if (loginAccout) {
        
        self.tabBarViewController = [[BaseTabBarViewController alloc]init];
        self.window.rootViewController = self.tabBarViewController;
        
    }else {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        XDLoginViewController *logon = [storyboard instantiateViewControllerWithIdentifier:@"XDLoginViewController"];
        self.window.rootViewController = logon;
    }

    [self.window makeKeyAndVisible];
    #pragma mark 微信
    //向微信注册wxd930ea5d5a258f4f
    [WXApi registerApp:@"wx4b10935662bcf67c" withDescription:@"xiandao"];
    
    #pragma mark 极光推送
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:JPUSH_APPKEY channel:@"App Store" apsForProduction:YES];
    
    /*
     // Required - 启动 JMessage SDK
     [JMessage addDelegate:self withConversation:nil];
     [JMessage setupJMessage:launchOptions appKey:JPUSH_APPKEY channel:CHANNEL apsForProduction:NO category:nil messageRoaming:YES];
     // Required - 注册 APNs 通知
     [JMessage registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert) categories:nil];
     */
    
    // 请将 PGY_APP_ID 换成应用的 App ID
    //公司的 4ed628a8af1607e0686469e685bdb4ec
//    我自己的 8f78468c52da3d9267f6570e56ced58b
    
#pragma mark AppStore版本更新
    [self updateWithAppStoreVersion];
#pragma mark 蒲公英
    // 关闭用户反馈
    [[PgyManager sharedPgyManager] setEnableFeedback:NO];
    // 启动基本SDK
    [[PgyManager sharedPgyManager] startManagerWithAppId:K_PGY_APP_KEY];
    // 启动更新检查SDK
//    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:K_PGY_APP_KEY];
//    [[PgyUpdateManager sharedPgyManager] checkUpdateWithDelegete:self selector:@selector(updateMethod:)];
    
    // U-Share 平台设置
    [self configUSharePlatforms];
    [self confitUShareSettings];
    
    // 可视对讲
    BOOL zhyjSDKInit = [ZHYJSDK initZHYJLibWithClientId:@"2c7b337fc9684cc58308f0df762c4e94" clientSecret:@"b29de58956404938bec6c8b9f4c1f731" completion:^{
    }];
    if (!zhyjSDKInit) {
        [XDUtil showToast:@"可视对讲初始化失败！"];
    } else {
//        [XDUtil showToast:@"可视对讲初始化成功！"];
    }
    
    return YES;
}

#pragma mark - update version
- (void)updateMethod:(NSDictionary *)dic {
    if (!dic) {
//        [XDUtil showToast:@"当前无可更新版本"];
        return;
    }
    // 获得当前打开软件的版本号
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
    NSString *version = dic[@"versionName"];
    if ([version isEqualToString:currentVersion]) {
        return;
    }
    NSString *string = dic[@"releaseNote"];
    if (string.length == 0) {
        string = [NSString stringWithFormat:@"发现新版本%@，是否更新", version];
    }
    if (dic[@"downloadURL"]) {
        self.downUrl = dic[@"downloadURL"];
        UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"更新" message:string preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.downUrl]];
            [[PgyUpdateManager sharedPgyManager] updateLocalBuildNumber];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertvc addAction:sureAction];
        [alertvc addAction:cancelAction];
        
        UIViewController *rootVC = [self topVC:[UIApplication sharedApplication].keyWindow.rootViewController];
        [rootVC.navigationController presentViewController:alertvc animated:YES completion:nil ];
    }
}

- (void)updateWithAppStoreVersion {
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
    [[XDHTTPManager sharedManager] POST:@"https://itunes.apple.com/lookup?id=1470360494" parameters:nil completionHandle:^(id responseObject, NSError *error) {
        if (responseObject) {
            NSArray *array = responseObject[@"results"];
            NSString *nowVersion = nil;
            for (NSDictionary *dic in array) {
                if ([dic.allKeys containsObject:@"version"]) {
                    nowVersion = dic[@"version"];
                }
            }
            if (nowVersion && ![currentVersion isEqualToString:nowVersion]) {
                NSString *msg = [NSString stringWithFormat:@"有新版本%@，是否更新？", nowVersion];
                UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"更新" message:msg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSURL *url = [NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/id1470360494"];
                    [[UIApplication sharedApplication] openURL:url];
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alertvc addAction:sureAction];
                [alertvc addAction:cancelAction];
                UIViewController *rootVC = [self topVC:[UIApplication sharedApplication].keyWindow.rootViewController];
                [rootVC.navigationController presentViewController:alertvc animated:YES completion:nil ];
            }
        }
    }];
}

- (void)confitUShareSettings {
    /* 设置友盟appkey */
    [UMConfigure initWithAppkey:@"5cc6b9754ca3577ea20001c2" channel:@"App Store"];
    // 打开图片水印
    [UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
}

- (void)configUSharePlatforms {
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx9e26096ae63f011d" appSecret:@"22ba1246fa64314bb6cc97a7c10ac25c" redirectURL:nil];
    
    // 移除相应平台的分享，如微信收藏
//    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"101574816"/*设置QQ平台的appID*/  appSecret:@"651f1b7501cf1d51f5253b5ecd23e76a" redirectURL:nil];
}

// ios 10 support 处于前台时接收到通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler
{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        // 添加各种需求。。。。。
        if (userInfo) {
            if([[userInfo allKeys] containsObject:@"key"]) {
                [self goToJPushControllerWithDic:userInfo];
            }
            // 添加各种需求。。。。。
            [JPUSHService handleRemoteNotification:userInfo];
            completionHandler(UIBackgroundFetchResultNewData);
        }
    }
//    completionHandler(UNNotificationPresentationOptionAlert);
    // 处于前台时，添加需求，一般是弹出alert跟用户进行交互，这时候completionHandler(UNNotificationPresentationOptionAlert)这句话就可以注释掉了，这句话是系统的alert，显示在app的顶部，
}

// iOS 10 Support  点击处理事件
/**
 *  极光通知被点击
 */
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        /*
         "{\"buildingNumber\":3,\"cmdType\":\"\U5f00\U95e8\",\"dateTime\":\"2019-04-17 10:07:30\",\"devIndex\":2,\"deviceSerial\":\"14634534\",\"periodNumber\":867676,\"roomNumber\":8,\"unitNumber\":2,\"unitType\":\"outdoor\"}";
         */
        //推送打开
        if (userInfo) {
            if([[userInfo allKeys] containsObject:@"key"]) {
                [self goToJPushControllerWithDic:userInfo];
            }
            // 添加各种需求。。。。。
            [JPUSHService handleRemoteNotification:userInfo];
            completionHandler(UIBackgroundFetchResultNewData);
        }
        completionHandler(UNNotificationPresentationOptionBadge);  // 系统要求执行这个方法
    }
}

- (void)goToJPushControllerWithDic:(NSDictionary *)userInfo {
    //拿到当前页面的VC
    UIViewController *rootVC = [self topVC:[UIApplication sharedApplication].keyWindow.rootViewController];
    NSDictionary *msgDic = [self parseJSONStringToNSDictionary:userInfo[@"key"]];

    if ([msgDic[@"type"] isEqualToString:@"notice"]) {
        // 公告
        XDInfoNewDetailNetController *info = [[XDInfoNewDetailNetController alloc] init];
        XDInfoNewModel *model = [[XDInfoNewModel alloc] init];
        model.noticeId = msgDic[@"noticeId"];
        model.publishTime = msgDic[@"publishTime"];
        model.detailUrl = msgDic[@"detailUrl"];
        model.title = msgDic[@"noticeTitle"];
        model.praises = [msgDic[@"praises"] integerValue];
        model.reads = [msgDic[@"reads"] integerValue];
        model.publisherName = msgDic[@"publisherName"];
        info.infoModel = model;
        [rootVC.navigationController pushViewController:info animated:YES];
    } else if ([msgDic[@"type"] isEqualToString:@"workOrder"]) {
        //============工单
        XDWarrantyDetailController *warrany = [[XDWarrantyDetailController alloc] init];
        warrany.repairsId = msgDic[@"workOrderId"];
        warrany.taskid = msgDic[@"taskId"];
        NSArray *outcome = msgDic[@"jbpmOutcomes"];
        NSString *string = [outcome componentsJoinedByString:@""];
        warrany.jbpmOutcomes = string;
        [rootVC.navigationController pushViewController:warrany animated:YES];//跳转想去的VC
        
        //    value	__NSCFString *	@"{\"piid\":\"gongdan_newAdd.660098\",\"jbpmOutcomes\":[],\"workOrderId\":250,\"type\":\"workOrder\",\"taskId\":\"\"}"	0x00000001704fc680
        
    }else if ([msgDic[@"type"] isEqualToString:@"complains"]) {
        
        //============投诉
        XDMyComplainDetailController *complain = [[XDMyComplainDetailController alloc] init];
        complain.complainId = msgDic[@"complainid"];
        complain.taskid = msgDic[@"taskId"];
        NSArray *outcome = msgDic[@"jbpmOutcomes"];
        NSString *string = [outcome componentsJoinedByString:@""];
        complain.jbpmOutcomes = string;
        complain.piid = msgDic[@"piid"];
        [rootVC.navigationController pushViewController:complain animated:YES];//跳转想去的VC
        
//        value	__NSCFString *	@"{\"piid\":\"Complaints.670100\",\"complainid\":144,\"jbpmOutcomes\":[\"是否接受\"],\"type\":\"complains\",\"taskId\":\"670138\"}"	0x00000001701dde20
//        value	__NSCFString *	@"{\"piid\":\"Complaints.670100\",\"complainid\":144,\"jbpmOutcomes\":[\"是否满意\"],\"type\":\"complains\",\"taskId\":\"670151\"}"	0x00000001701de2d0
        
    } else if ([msgDic[@"cmdType"] isEqualToString:@"request"]) {
        // 呼叫
        CTCCallCenterBusiness *business = [CTCCallCenterBusiness sharedInstance];
        business.callInfo.deviceSerial = msgDic[@"deviceSerial"];
        NSString *room = nil;
        if ([msgDic[@"roomNumber"] intValue] < 10) {
            room = [NSString stringWithFormat:@"%@0%@", msgDic[@"floorNumber"], msgDic[@"roomNumber"]];
        } else {
            room = [NSString stringWithFormat:@"%@%@", msgDic[@"floorNumber"], msgDic[@"roomNumber"]];
        }
        business.callInfo.room = room;
        business.callInfo.callId = @"";
        business.callInfo.periodNumber = [NSString stringWithFormat:@"%@", msgDic[@"periodNumber"]];
        business.callInfo.buildingNumber = [NSString stringWithFormat:@"%@", msgDic[@"buildingNumber"]];
        business.callInfo.unitNumber = [NSString stringWithFormat:@"%@", msgDic[@"unitNumber"]];
        business.callInfo.floorNumber = [NSString stringWithFormat:@"%@", msgDic[@"devIndex"]];
        business.callInfo.devIndex = [NSString stringWithFormat:@"%@", msgDic[@"floorNumber"]];
        business.callInfo.unitType = msgDic[@"unitType"];
        XDCallCenterController *callVC = [[XDCallCenterController alloc] init];
        [ZHYJSDK initZHYJLibWithClientId:@"2c7b337fc9684cc58308f0df762c4e94" clientSecret:@"b29de58956404938bec6c8b9f4c1f731" completion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [rootVC.navigationController pushViewController:callVC animated:YES];
            });
        }];
    }
}

- (NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}

/**
 *  获取当前窗口的跟控制器
 */
- (UIViewController *)topVC:(UIViewController *)rootViewController {
    if ([rootViewController isKindOfClass:[BaseTabBarViewController class]]) {
        BaseTabBarViewController *tab = (BaseTabBarViewController *)rootViewController;
        return [self topVC:tab.selectedViewController];
    } else if ([rootViewController isKindOfClass:[XDSecondaryTabBarController class]]){
        XDSecondaryTabBarController *secTab = (XDSecondaryTabBarController *)rootViewController;
        return [self topVC:secTab.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]){
        BaseNavigationController *navc = (BaseNavigationController *)rootViewController;
        return [self topVC:navc.visibleViewController];
    }else if (rootViewController.presentedViewController){
        UIViewController *pre = (UIViewController *)rootViewController.presentedViewController;
        return [self topVC:pre];
    }else{
        return rootViewController;
    }
}

/**
 *  Required - 注册 DeviceToken
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
    [JMessage registerDeviceToken:deviceToken];
}

//处理推送过来的消息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"推送的消息呢===%@",userInfo);
//    AudioServicesPlaySystemSound(1000);
}


- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

// 点击之后badge清零
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [JPUSHService setBadge:0];
        [[UIApplication alloc] setApplicationIconBadgeNumber:0];
    });
}

// 点击之后badge清零
- (void)applicationWillEnterForeground:(UIApplication *)application {
    dispatch_async(dispatch_get_main_queue(), ^{
        [JPUSHService setBadge:0];
        [[UIApplication alloc] setApplicationIconBadgeNumber:0];
    });
    [[UNUserNotificationCenter alloc] removeAllPendingNotificationRequests];
}

//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    return  [WXApi handleOpenURL:url delegate:[SDPaymentTool sharedSDPaymentTool]];
//}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    // 6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
        return [WXApi handleOpenURL:url delegate:[SDPaymentTool sharedSDPaymentTool]];
    }
    return result;
}

- (void)onDBMigrateStart {
    NSLog(@"onDBmigrateStart in appdelegate");
}

/**
 *  获取delegate
 */
+ (AppDelegate* )shareAppDelegate {
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}


@end
