//
//  XDSettingsController.m
//  xd_proprietor
//
//  Created by stone on 15/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDSettingsController.h"
#import "XDSettingsConfigModel.h"
#import "XDSettingCell.h"
#import "XDSettingExitCell.h"
#import "XDLoginViewController.h"
#import "XDBannerDetailController.h"
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>
#import "XDAboutController.h"

@interface XDSettingsController () <CustomAlertViewDelegate>
@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, copy) NSString *downUrl;
@end

@implementation XDSettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    [self configDataSource];
    [self configTableView];
}

- (void)configTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"XDSettingExitCell" bundle:NSBundle.mainBundle] forCellReuseIdentifier:@"XDSettingExitCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"XDSettingCell" bundle:NSBundle.mainBundle] forCellReuseIdentifier:@"XDSettingCell"];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
    self.tableView.backgroundColor = litterBackColor;
}

- (void)configDataSource {
    [self.itemArray removeAllObjects];
    XDSettingsConfigModel *messageModel = [[XDSettingsConfigModel alloc] init];
    messageModel.title = @"消息通知";
    messageModel.subTitle = @"";
    messageModel.hasArrow = YES;
    XDSettingsConfigModel *cacheModel = [[XDSettingsConfigModel alloc] init];
    cacheModel.title = @"清理缓存";
    float size = [XDUtil folderSizeAtPath:kLibraryPath];
    cacheModel.subTitle = [NSString stringWithFormat:@"%.fM", size];
    cacheModel.hasArrow = YES;
    XDSettingsConfigModel *aboutModel = [[XDSettingsConfigModel alloc] init];
    aboutModel.title = @"关于长房里";
    aboutModel.subTitle = @"";
    aboutModel.hasArrow = YES;
    XDSettingsConfigModel *versionModel = [[XDSettingsConfigModel alloc] init];
    versionModel.title = @"检查新版本";
    NSString *appVersion = [NSBundle.mainBundle.infoDictionary objectForKey:@"CFBundleShortVersionString"];
    versionModel.subTitle = appVersion;
    versionModel.hasArrow = YES;
    XDSettingsConfigModel *feedbackModel = [[XDSettingsConfigModel alloc] init];
    feedbackModel.title = @"意见反馈";
    feedbackModel.subTitle = @"";
    feedbackModel.hasArrow = YES;
    XDSettingsConfigModel *contactModel = [[XDSettingsConfigModel alloc] init];
    contactModel.title = @"联系我们";
    contactModel.subTitle = @"";
    contactModel.hasArrow = YES;
    XDSettingsConfigModel *exitModel = [[XDSettingsConfigModel alloc] init];
    exitModel.title = @"退出";
    exitModel.type = SettingTypeExit;
    [self.itemArray addObject:@[/*messageModel, */cacheModel]];
    [self.itemArray addObject:@[aboutModel, versionModel, feedbackModel, contactModel]];
    [self.itemArray addObject:@[exitModel]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.itemArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.itemArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDSettingsConfigModel *model = self.itemArray[indexPath.section][indexPath.row];
    if ([model.title isEqualToString:@"退出"]) {
        XDSettingExitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XDSettingExitCell" forIndexPath:indexPath];
        cell.titleLabel.text = model.title;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        XDSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XDSettingCell" forIndexPath:indexPath];
        cell.configModel = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
        if (!header) {
            header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"UITableViewHeaderFooterView"];
        }
        header.frame = CGRectMake(0, 0, kScreenWidth, 20);
        UIView *view = [[UIView alloc] initWithFrame:header.bounds];
        view.backgroundColor = litterBackColor;
        [header addSubview:view];
        return header;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        return 20;
    }
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XDSettingsConfigModel *model = self.itemArray[indexPath.section][indexPath.row];
    if (model.type == SettingTypeExit) {
        [self clickToAlertViewTitle:@"确定退出登录" withDetailTitle:@"退出登录后信息将会删除，是否确定退出？"];
    } else if ([model.title isEqualToString:@"关于长房里"]) {
        XDAboutController *aboutVC = [[XDAboutController alloc] init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    } else if ([model.title isEqualToString:@"检查新版本"]) {
        // 启动更新检查SDK
        [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:K_PGY_APP_KEY];
        [[PgyUpdateManager sharedPgyManager] checkUpdateWithDelegete:self selector:@selector(updateMethod:)];
    } else if ([model.title isEqualToString:@"意见反馈"]) {
        [[PgyManager sharedPgyManager] showFeedbackView];
    } else if ([model.title isEqualToString:@"联系我们"]) {
        NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@", @"18975879956"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    } else if ([model.title isEqualToString:@"清理缓存"]) {
        [self clearCache];
    }
}

#pragma mark - clear cache
- (void)clearCache {
    NSString *string = [NSString stringWithFormat:@"当前有%.fM的缓存，确定清理吗？", [XDUtil folderSizeAtPath:kLibraryPath]];
    UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"缓存" message:string preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [XDUtil clearCache:kLibraryPath];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self configDataSource];
            [self.tableView reloadRow:0 inSection:0 withRowAnimation:(UITableViewRowAnimationAutomatic)];
        });
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertvc addAction:sureAction];
    [alertvc addAction:cancelAction];
    [self presentViewController:alertvc animated:YES completion:nil ];
}

#pragma mark - update version
- (void)updateMethod:(NSDictionary *)dic {
    if (!dic) {
        [XDUtil showToast:@"当前无可更新版本"];
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
        [self presentViewController:alertvc animated:YES completion:nil];
    }
}


#pragma mark - login out

// 退出登录
-(void)clickToAlertViewTitle:(NSString *)title withDetailTitle:(NSString *)detailTitle {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    CustomAlertView *alertView = [[CustomAlertView alloc]initWithFrame:window.bounds WithTitle:title andDetail:detailTitle andBody:nil andCancelTitle:@"取消" andOtherTitle:@"确定" andIsOneBtn:NO];
    [alertView.otherButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    alertView.delegate = self;
    [window addSubview:alertView];
}

// CustomAlertViewDelegate
- (void)clickButtonWithTag:(UIButton *)button {
    if (button.tag == 309) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud removeObjectForKey:@"nickName"];
        [ud removeObjectForKey:@"commonAddress"];
        [ud removeObjectForKey:@"commonContact"];
        [ud removeObjectForKey:@"MyHeadImageData"];
        
        NSString *string = @"";
        [JPUSHService setTags:nil alias:string callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
        
        XDLoginUseModel *loginAccout = [XDReadLoginModelTool loginModel];
        loginAccout = nil;
        [XDReadLoginModelTool save:loginAccout];
        [MBProgressHUD showActivityMessageInWindow:nil];
        [KYRefreshView dismissDeleyWithDuration:2];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIWindow *window = [[UIApplication sharedApplication].delegate window];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            XDLoginViewController *logon = [storyboard instantiateViewControllerWithIdentifier:@"XDLoginViewController"];
            window.rootViewController = logon;
        });
    }
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

#pragma mark - lazy load
- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

@end
