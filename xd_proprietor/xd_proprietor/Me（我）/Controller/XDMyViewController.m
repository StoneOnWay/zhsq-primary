//
//  XDMyViewController.m
//  我的
//
//  Created by mason on 2018/9/4.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDMyViewController.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "XDMenuItemCollectionViewCell.h"
#import "XDHeaderCollectionViewCell.h"
#import "XDWarrantyContainerViewController.h"
#import "XDExitLoginTableViewCell.h"
#import "XDLoginViewController.h"
#import "XDMyInfoEditController.h"
#import "XDPersonalInfoController.h"
#import "XDBannerDetailController.h"
#import "XDPhoneBindController.h"

static NSString * const kHeaderCell = @"kHeaderCell";
static NSString * const kFunctionCell = @"kFunctionCell";
static NSString * const kFooterCell = @"kFooterCell";

@interface XDMyViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UIAlertViewDelegate,
CustomAlertViewDelegate,
XDMyInfoEditControllerDelegate
>

@property (strong, nonatomic) UICollectionView *collectionView;
/** <##> */
@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) XDHeaderCollectionViewCell *headCell;

@end

@implementation XDMyViewController
   
-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    [self configDataSource];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)setupView {
    
    UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.view addSubview:collectionView];
    collectionView.backgroundColor = UIColorHex(f3f3f3);
    collectionView.delegate = self;
    collectionView.dataSource = self;
    self.collectionView = collectionView;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];

    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XDMenuItemCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XDMenuItemCollectionViewCell class])];
    
    // 头部
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XDHeaderCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XDHeaderCollectionViewCell class])];
    
    // 底部
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XDExitLoginTableViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XDExitLoginTableViewCell class])];

    [self.collectionView setContentInset:UIEdgeInsetsMake(-StatusBarHeight, 0, 0, 0)];

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource[section][@"value"] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        XDHeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XDHeaderCollectionViewCell class]) forIndexPath:indexPath];
        self.headCell = cell;
        [cell setContent];
        return cell;
    } else if(indexPath.section == 2 ){
        XDExitLoginTableViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XDExitLoginTableViewCell class]) forIndexPath:indexPath];
        [cell.exitLoginButton addTarget:self action:@selector(exitClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
    XDMenuItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XDMenuItemCollectionViewCell class]) forIndexPath:indexPath];
    NSArray *list = self.dataSource[indexPath.section][@"value"];
    cell.homeMenuModel = list[indexPath.row];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataSource[indexPath.section];
    XDHomeMenuModel * homeMenuModel = dic[@"value"][indexPath.row];
    
    // 游客权限控制
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    if (!loginModel.userInfo.userId) {
        NSString *title = homeMenuModel.title;
        if ([title isEqualToString:@"我的报修"] || [title isEqualToString:@"我的投诉"] || [title isEqualToString:@"车辆管理"] || [title isEqualToString:@"人脸采集"]) {
            [self tipsWithBindPhone];
        }
    }
    
    if (homeMenuModel.viewControllerStr.length > 0 && ![homeMenuModel.viewControllerStr isEqualToString:@""]) {
        UIViewController *vc = nil;
        if (homeMenuModel.vcType == XDVCTypeAlloc) {
            
            if ([homeMenuModel.viewControllerStr isEqualToString:@"XDBannerDetailController"]) {
                XDBannerDetailController *detail = [[XDBannerDetailController alloc] init];
                detail.title = @"包裹查询";
                detail.detailUrl = @"https://m.kuaidi100.com/app/?coname=hao123";
                [self.navigationController pushViewController:detail animated:YES];
            }else{
                vc = [NSClassFromString(homeMenuModel.viewControllerStr) new];
            }
            
        } else if (homeMenuModel.vcType == XDVCTypeStoryboard) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:homeMenuModel.viewControllerStr bundle:nil];
            vc= [storyboard instantiateViewControllerWithIdentifier:homeMenuModel.viewControllerStr];
        } else {
            vc = [UIViewController new];
        }
        if (![XDUtil stringIsEmpty:homeMenuModel.vcSubType]) {
            if ([vc isKindOfClass:[XDWarrantyContainerViewController class]]) {
                XDWarrantyContainerViewController *warrantyVC = (XDWarrantyContainerViewController *)vc;
                warrantyVC.warrantyPageType = homeMenuModel.vcSubType.integerValue;
                warrantyVC.title = homeMenuModel.title;
                [self.navigationController pushViewController:warrantyVC animated:YES];
                return;
            }
        }
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat margin = 0.5f;//1.f / [UIScreen mainScreen].scale;
    if (indexPath.section == 0) {
        return CGSizeMake(kScreenWidth, 127.f + StatusBarHeight);
    }else if (indexPath.section == 2){
        return CGSizeMake(kScreenWidth, 60.0f);
    }
    return CGSizeMake((kScreenWidth - 3 * margin)/ 4.f, (kScreenWidth - 3 * margin)/ 4.f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 1) {
        return 0.5f;
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 1) {
        return 0.5f;
    }
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return CGSizeMake(kScreenWidth, 15.f);
    }
    return CGSizeZero;
}

// 退出登录
- (void)exitClick:(UIButton*)btn{
    [self clickToAlertViewTitle:@"确定退出登录" withDetailTitle:@"退出登录后信息将会删除，是否确定退出？"];
}

//退出登录
-(void)clickToAlertViewTitle:(NSString *)title withDetailTitle:(NSString *)detailTitle
{
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    CustomAlertView *alertView = [[CustomAlertView alloc]initWithFrame:window.bounds WithTitle:title andDetail:detailTitle andBody:nil andCancelTitle:@"取消" andOtherTitle:@"确定" andIsOneBtn:NO];
    [alertView.otherButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    alertView.delegate = self;
    [window addSubview:alertView];
}

//CustomAlertViewDelegate
-(void)clickButtonWithTag:(UIButton *)button
{
    if (button.tag == 309)
    {
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

- (void) configDataSource {
    
    XDHomeMenuModel *deblockModel = [XDHomeMenuModel new];
    deblockModel.viewControllerStr = @"XDPersonalInfoController";
    [self.dataSource addObject:@{@"type" : kHeaderCell, @"value": @[deblockModel]}];
    
    XDHomeMenuModel *myWorkModel = [XDHomeMenuModel new];
    myWorkModel.title = @"我的报修";
    myWorkModel.icon = @"btn_my_work";
    myWorkModel.vcType = XDVCTypeStoryboard;
    myWorkModel.viewControllerStr = @"XDWarrantyContainerViewController";
    myWorkModel.vcSubType = [NSString stringWithFormat:@"%ld", (long)XDWarrantyPageTypeWorkOrder];
    
    XDHomeMenuModel *complainModel = [XDHomeMenuModel new];
    complainModel.title = @"我的投诉";
    complainModel.icon = @"btn_my_complain";
    complainModel.vcType = XDVCTypeStoryboard;
    complainModel.viewControllerStr = @"XDWarrantyContainerViewController";
    complainModel.vcSubType = [NSString stringWithFormat:@"%ld", (long)XDWarrantyPageTypeComplaint];

    XDHomeMenuModel *carManageModel = [XDHomeMenuModel new];
    carManageModel.title = @"车辆管理";
    carManageModel.icon = @"btn_my_car";
    carManageModel.viewControllerStr = @"XDCarListController";
    
    XDHomeMenuModel *faceDiscernModel = [XDHomeMenuModel new];
    faceDiscernModel.title = @"人脸采集";
    faceDiscernModel.icon = @"btn_my_face";
    faceDiscernModel.viewControllerStr = @"XDFaceListController";
    
    XDHomeMenuModel *communityAnnouncementModel = [XDHomeMenuModel new];
    communityAnnouncementModel.title = @"包裹查询";
    communityAnnouncementModel.icon = @"btn_home_notice";
    communityAnnouncementModel.viewControllerStr = @"XDBannerDetailController";
    
    XDHomeMenuModel *walletModel = [XDHomeMenuModel new];
    walletModel.title = @"评价";
    walletModel.icon = @"btn_my_wallet";
    walletModel.viewControllerStr = @"XDEvaluateBaseController";
    
    XDHomeMenuModel *personalModel = [XDHomeMenuModel new];
    personalModel.title = @"个人资料";
    personalModel.icon = @"btn_my_datum";
    personalModel.viewControllerStr = @"XDPersonalInfoController";
    
    XDHomeMenuModel *settingModel = [XDHomeMenuModel new];
    settingModel.title = @"设置";
    settingModel.icon = @"btn_my_intercalate";
    settingModel.viewControllerStr = @"XDSettingsController";
    
//    XDHomeMenuModel *emptyModel = [XDHomeMenuModel new];
    
    NSArray *menuArray = @[myWorkModel, complainModel, carManageModel, faceDiscernModel, communityAnnouncementModel, walletModel, personalModel, settingModel/*, emptyModel*/];
    [self.dataSource addObject:@{@"type" : kFunctionCell, @"value" : menuArray}];

//    XDHomeMenuModel *footblockModel = [XDHomeMenuModel new];
//    [self.dataSource addObject:@{@"type" : kFooterCell, @"value": @[footblockModel]}];
    
    [self.collectionView reloadData];
}


- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)tipsWithBindPhone {
    UIViewController *rootVC = [[AppDelegate shareAppDelegate] topVC:[UIApplication sharedApplication].keyWindow.rootViewController];
    // 根据uid查询是否绑定手机号，如果绑定了手机号，更新用户登录信息
    
    // 没有绑定，提示绑定
    NSString *string = [NSString stringWithFormat:@"未绑定业主，App部分功能受限！"];
    UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"提示" message:string preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"前往绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        XDPhoneBindController *bindVC = [[XDPhoneBindController alloc] init];
        [rootVC.navigationController pushViewController:bindVC animated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"稍后绑定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertvc addAction:sureAction];
    [alertvc addAction:cancelAction];
    
    [rootVC presentViewController:alertvc animated:YES completion:nil];
}

@end




















