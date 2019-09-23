//
//  XDHomePageViewController.m
//  首页
//
//  Created by mason on 2018/8/31.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDHomePageViewController.h"
#import "XDHomeAddressView.h"
#import "XDHomeEventCollectionViewCell.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "XDMarqueeCollectionViewCell.h"
#import "XDMenuItemCollectionViewCell.h"
#import "XDBannerCell.h"
#import "XDHomeMenuModel.h"
#import "XDHomeSectionHeaderCollectionReusableView.h"
#import <objc/message.h>
#import "XDWarrantyViewController.h"
#import "XDInfoNewModel.h"
#import "XDInfoNewDetailNetController.h"
#import "XDInformNewsListController.h"
#import "XDOpenClokController.h"
#import "XDDeblockingController.h"
#import "AFHTTPSessionManager.h"
#import "XDBannerDetailController.h"
#import "XDSecondaryTabBarController.h"
#import "XDPhoneBindController.h"
#import "XDThirdInfoModel.h"

#define KCycleScrollViewHeight 250.f * kScreenWidth / 414.f

static NSString * const kEventCell = @"kEventCell";
static NSString * const kMarqueeCell = @"kMarqueeCell";
static NSString * const kMyServiceCell = @"kMyServiceCell";
static NSString * const kBannerCell = @"kBannerCell";
static NSString * const kThemeFunctionCell = @"kThemeFunctionCell";

@interface XDHomePageViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UIGestureRecognizerDelegate,
SDCycleScrollViewDelegate
>

/** <##> */
@property (strong, nonatomic) UICollectionView *collectionView;
/** <##> */
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *queueArr; // 热点数据源
@property (strong, nonatomic) NSMutableArray *bannerArr; // 轮播图数据源
@end

@implementation XDHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getQueueData];
    
    [self setupNavigationBarView];
    [self setupCollectionView];
    
    // 检查更新业主信息缓存
    [self checkOwnerInfo];
    
//    [self appUpdate];
}

- (void)tipsWithBindPhone {
    // 根据uid查询是否绑定手机号，如果绑定了手机号，更新用户登录信息
    // 没有绑定，提示绑定
    UIViewController *rootVC = [[AppDelegate shareAppDelegate] topVC:[UIApplication sharedApplication].keyWindow.rootViewController];
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

- (void)checkOwnerInfo {
    __block XDLoginUseModel *loginAccout = [XDReadLoginModelTool loginModel];
    if (!loginAccout.userInfo.mobileNumber) {
        if (loginAccout.thirdInfo.count == 0 || !loginAccout.thirdInfo) {
            return;
        }
        XDThirdInfoModel *thirdInfo = loginAccout.thirdInfo.firstObject;
        if (thirdInfo.accountId && thirdInfo.type) {
            // 第三方登录
            NSDictionary *dic = @{
                                  @"type": thirdInfo.type,
                                  @"accountId": thirdInfo.accountId
                                  };
            WEAKSELF
            [[XDAPIManager sharedManager] requestCheckIsBindPhoneNoWithParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
                if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
                    loginAccout = [XDLoginUseModel mj_objectWithKeyValues:responseObject[@"data"]];
                    [XDReadLoginModelTool save:loginAccout];
                } else {
                    [weakSelf tipsWithBindPhone];
                }
            }];
        } else {
            [XDUtil showToast:@"登录异常，请退出重新登录！"];
        }
    } else {
        [self updateOwnerInfo];
    }
}

- (void)updateOwnerInfo {
    XDLoginUseModel *loginAccout = [XDReadLoginModelTool loginModel];
    if (!loginAccout.userInfo.mobileNumber) {
        [self tipsWithBindPhone];
        return;
    }
    NSDictionary *dic = @{
                          @"mobileNumber":loginAccout.userInfo.mobileNumber
                          };
    
    [[XDAPIManager sharedManager] updateOwnerInfoParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        if (error) {
            return;
        }
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            XDLoginUseModel *newLoginModel = [XDLoginUseModel mj_objectWithKeyValues:responseObject[@"data"]];
            newLoginModel.token = loginAccout.token;
            [XDReadLoginModelTool save:newLoginModel];
        } else {
        }
    }];
}

- (void)setupCollectionView {
    UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc] init];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - NavHeight - TabbarHeight) collectionViewLayout:layout];
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    collectionView.backgroundColor = RGB(243, 243, 243);
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XDHomeEventCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XDHomeEventCollectionViewCell class])];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XDMarqueeCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XDMarqueeCollectionViewCell class])];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XDMenuItemCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XDMenuItemCollectionViewCell class])];
    [collectionView registerClass:[XDBannerCell class] forCellWithReuseIdentifier:NSStringFromClass([XDBannerCell class])];
    [collectionView registerClass:[XDHomeSectionHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([XDHomeSectionHeaderCollectionReusableView class])];

    [self configDataSource];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSDictionary *dic = self.dataSource[section];
    if ([dic[@"type"] isEqualToString:kEventCell]) {
        return [dic[@"value"] count];
    } else if ([dic[@"type"] isEqualToString: kMarqueeCell]) {
        return 1;
    } else if ([dic[@"type"] isEqualToString: kMyServiceCell] || [dic[@"type"] isEqualToString: kThemeFunctionCell]) {
        return [dic[@"value"] count];
    } else if ([dic[@"type"] isEqualToString: kBannerCell]) {
        return 1;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataSource[indexPath.section];
    
    if ([dic[@"type"] isEqualToString:kEventCell]) {
        XDHomeEventCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XDHomeEventCollectionViewCell class]) forIndexPath:indexPath];
        cell.homeMenuModel = dic[@"value"][indexPath.row];
        return cell;
    } else if ([dic[@"type"] isEqualToString: kMarqueeCell]) {
        XDMarqueeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XDMarqueeCollectionViewCell class]) forIndexPath:indexPath];
        if (_queueArr.count>0) {
            [cell setAllDataWithArr: _queueArr];
        }
        return cell;
    } else if ([dic[@"type"] isEqualToString: kMyServiceCell] || [dic[@"type"] isEqualToString: kThemeFunctionCell]) {
        XDMenuItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XDMenuItemCollectionViewCell class]) forIndexPath:indexPath];
        cell.homeMenuModel = dic[@"value"][indexPath.row];
        return cell;
    } else if ([dic[@"type"] isEqualToString: kBannerCell]) {
        XDBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XDBannerCell class]) forIndexPath:indexPath];
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, KCycleScrollViewHeight) delegate:self placeholderImage:[UIImage imageNamed:@""]];
        cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
     
        NSMutableArray *imageUrlArray = [NSMutableArray array];
        for (XDInfoNewModel *model in self.bannerArr) {
            NSString *urlStr = [NSString stringWithFormat:@"%@/%@", K_BASE_URL, model.coverImgUrl];
            [imageUrlArray addObject:urlStr];
        }
        cycleScrollView.imageURLStringsGroup = imageUrlArray;
        [cell addSubview:cycleScrollView];
        return cell;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat margin = 0.5f;//1.f / [UIScreen mainScreen].scale;
    NSDictionary *dic = self.dataSource[indexPath.section];
    if ([dic[@"type"] isEqualToString:kEventCell]) {
        CGFloat width = kScreenWidth / 4.f;
        CGFloat height = 127.f * kScreenWidth / 375.f;
        if ([XDUtil isIPad]) {
            height = 85 * kScreenWidth / 375.f;
        }
        return CGSizeMake(width, height);
    } else if ([dic[@"type"] isEqualToString: kMarqueeCell]) {
        return CGSizeMake(kScreenWidth, 55.f);
    } else if ([dic[@"type"] isEqualToString: kMyServiceCell] || [dic[@"type"] isEqualToString: kThemeFunctionCell]) {
        return CGSizeMake((kScreenWidth - 3 * margin)/ 4.f, (kScreenWidth - 3 * margin)/ 4.f);
    } else if ([dic[@"type"] isEqualToString: kBannerCell]) {
        return CGSizeMake(kScreenWidth, KCycleScrollViewHeight);
    }
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    NSDictionary *dic = self.dataSource[section];
    if ([dic[@"type"] isEqualToString: kMyServiceCell] || [dic[@"type"] isEqualToString: kThemeFunctionCell]) {
        return 0.5f;
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    NSDictionary *dic = self.dataSource[section];
    if ([dic[@"type"] isEqualToString: kMyServiceCell] || [dic[@"type"] isEqualToString: kThemeFunctionCell]) {
        return 0.5f;
    }
    return 0;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.collectionView] == YES) {
          if ([self.collectionView indexPathForItemAtPoint:[touch locationInView:self.collectionView]]) {
                        return NO;}
    }
    return YES;
}


-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    XDHomeSectionHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([XDHomeSectionHeaderCollectionReusableView class]) forIndexPath:indexPath];
    NSDictionary *dic = self.dataSource[indexPath.section];
    if ([dic[@"type"] isEqualToString: kMyServiceCell]) {
        headerView.titleLabel.text = @"我的服务";;
    } else if ([dic[@"type"] isEqualToString: kThemeFunctionCell]) {
        headerView.titleLabel.text = @"主题功能";;
    } else {
        headerView.titleLabel.text = @"";;
    }
    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataSource[indexPath.section];
    XDMarqueeCollectionViewCell *cell = (XDMarqueeCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    XDHomeMenuModel *homeMenuModel = dic[@"value"][indexPath.row];
    
    // 游客权限控制
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    if (!loginModel.userInfo.userId) {
        NSString *title = homeMenuModel.title;
        if ([title isEqualToString:@"门禁开锁"] || [title isEqualToString:@"访客邀约"] || [title isEqualToString:@"可视对讲"] || [title isEqualToString:@"智能锁车"] || [title isEqualToString:@"投诉建议"] || [title isEqualToString:@"报事报修"]) {
            [self tipsWithBindPhone];
        }
    }
    
    if (indexPath.section == 1) {
//        XDInformNewsListController *vc = [XDInformNewsListController new];
//        [self.navigationController pushViewController:vc animated:YES];
        if (_queueArr.count > 0) {
            XDInfoNewModel *model = [_queueArr objectAtIndex:cell.marquee.currentIndex];
            XDInfoNewDetailNetController *info = [[XDInfoNewDetailNetController alloc] init];
            info.infoModel = model;
            info.readCountDidUpdate = ^{
                [self getQueueData];
            };
            [self.navigationController pushViewController:info animated:YES];
        }
    } else {
        if ([homeMenuModel.viewControllerStr isEqualToString:@"XDSecondaryTabBarController"]) {
            XDSecondaryTabBarController *secTab = [[XDSecondaryTabBarController alloc] init];
            [AppDelegate shareAppDelegate].window.rootViewController = secTab;
            return;
        }
        if (homeMenuModel.viewControllerStr.length > 0 && ![homeMenuModel.viewControllerStr isEqualToString:@""]) {
            UIViewController *vc = nil;
            if (homeMenuModel.vcType == XDVCTypeAlloc) {
                
                if ([homeMenuModel.viewControllerStr isEqualToString:@"XDNeighborController"]) {
                    self.tabBarController.selectedIndex = 1;
                    return;
                } else {
                    vc = [[NSClassFromString(homeMenuModel.viewControllerStr) alloc] init];
                }
            } else if (homeMenuModel.vcType == XDVCTypeStoryboard) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                vc= [storyboard instantiateViewControllerWithIdentifier:homeMenuModel.viewControllerStr];
            } else {
                vc = [UIViewController new];
            }
            vc.title = homeMenuModel.title;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    NSDictionary *dic = self.dataSource[section];
    if ([dic[@"type"] isEqualToString: kMyServiceCell] || [dic[@"type"] isEqualToString: kThemeFunctionCell]) {
        return CGSizeMake(kScreenWidth, 34.f);
    } else if ([dic[@"type"] isEqualToString: kBannerCell]) {
        return CGSizeMake(kScreenWidth, 0.f);
    }
    return CGSizeZero;
}

#pragma mark - cycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    XDInfoNewModel *model = self.bannerArr[index];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", K_BASE_URL, model.detailUrl];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    XDBannerDetailController *bannerVC = [[XDBannerDetailController alloc] init];
    bannerVC.detailUrl = urlStr;
    [self.navigationController pushViewController:bannerVC animated:YES];
}

- (void) setupNavigationBarView {
//    UIView *rightBarView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - 55.f, 0, 55.f, NavHeight-StatusBarHeight)];
//    CGFloat top = (NavHeight-StatusBarHeight - 20.f) / 2;
//    UIButton *phonebutton = [UIButton buttonWithType:UIButtonTypeCustom];
//    phonebutton.frame=CGRectMake(0, top, 20.f, 20.f);
//    [phonebutton setImage:[UIImage imageNamed:@"btn_home_scan"]forState:UIControlStateNormal];
//    [phonebutton addTarget:self action:@selector(scanClick)forControlEvents:UIControlEventTouchUpInside];
//    [rightBarView addSubview:phonebutton];
//
//    UIButton *mapbutton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [mapbutton setFrame:CGRectMake(35.f, top, 20.f, 20.f)];
//    [mapbutton setImage:[UIImage imageNamed:@"btn_home_add"]forState:UIControlStateNormal];
//    [mapbutton addTarget:self action:@selector(addClick)forControlEvents:UIControlEventTouchUpInside];
//    [rightBarView addSubview:phonebutton];
//
//    [rightBarView addSubview:mapbutton];
//    rightBarView.backgroundColor=[UIColor clearColor];
//
//    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBarView];
//    self.navigationItem.rightBarButtonItem = rightBtn;
    
    XDHomeAddressView *homeAddressView = [XDHomeAddressView loadFromNib];
    if ([[XDAPIManager sharedManager].myBaseUrl containsString:@"smartxd"]) {
        homeAddressView.imageView.image = [UIImage imageNamed:@"xf_logo"];
    } else if ([[XDAPIManager sharedManager].myBaseUrl containsString:@"smartjy"]) {
        homeAddressView.imageView.image = [UIImage imageNamed:@"jy_logo"];
    } else if ([[XDAPIManager sharedManager].myBaseUrl containsString:@"smartwl"]) {
        homeAddressView.imageView.image = [UIImage imageNamed:@"wl_logo"];
    }
    homeAddressView.frame = CGRectMake(0, 0, kScreenWidth - 100.f, NavHeight-StatusBarHeight);
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:homeAddressView];
    self.navigationItem.leftBarButtonItem = leftBtn;
}

- (void)scanClick {
    
}

- (void)addClick {
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    XDWarrantyViewController *VC= [storyboard instantiateViewControllerWithIdentifier:@"XDWarrantyViewController"];
//    [self.navigationController pushViewController:VC animated:YES];
}

- (void) configDataSource {
    
#pragma mark 门禁开锁 报事报修 投诉建议 锁车解锁
    XDHomeMenuModel *lockModel = [XDHomeMenuModel new];
    lockModel.title = @"门禁开锁";
    lockModel.icon = @"btn_home_lock";
    lockModel.viewControllerStr = @"XDOpenClokController";
    
    XDHomeMenuModel *visitModel = [XDHomeMenuModel new];
    visitModel.title = @"访客邀约";
    visitModel.icon = @"btn_home_visit";
    visitModel.viewControllerStr = @"XDVisitorListController";
    
    XDHomeMenuModel *visualModel = [XDHomeMenuModel new];
    visualModel.title = @"可视对讲";
    visualModel.icon = @"btn_home_visual";
    visualModel.viewControllerStr = @"XDRealPlayerController";
    
    XDHomeMenuModel *deblockModel = [XDHomeMenuModel new];
    deblockModel.title = @"智能锁车";
    deblockModel.icon = @"btn_home_lock_car";
    deblockModel.viewControllerStr = @"XDDeblockingController";
    
    [self.dataSource addObject:@{@"type" : kEventCell, @"value" : @[lockModel, visitModel, visualModel, deblockModel]}];
    
    
#pragma mark 热点关注
    [self.dataSource addObject:@{@"type" : kMarqueeCell}];
    
    [self.dataSource addObject:@{@"type" : kBannerCell}];
    
#pragma mark 邻里圈
    
    XDHomeMenuModel *workProgressModel = [XDHomeMenuModel new];
    workProgressModel.title = @"工程进度";
    workProgressModel.icon = @"work_progress";
    workProgressModel.viewControllerStr = @"XDInformNewsListController";
    
    XDHomeMenuModel *cardQueryModel = [XDHomeMenuModel new];
    cardQueryModel.title = @"产证查询";
    cardQueryModel.icon = @"card_query";
    cardQueryModel.viewControllerStr = @"XDHomeNearController";
    
    XDHomeMenuModel *complainModel = [XDHomeMenuModel new];
    complainModel.title = @"投诉建议";
    complainModel.icon = @"complain";
    complainModel.viewControllerStr = @"XDWarrantyHomeViewController";
    
    XDHomeMenuModel *repairModel = [XDHomeMenuModel new];
    repairModel.title = @"报事报修";
    repairModel.icon = @"repair";
    repairModel.viewControllerStr = @"XDWarrantyHomeViewController";
    
//    XDHomeMenuModel *lifeServiceModel = [XDHomeMenuModel new];
//    lifeServiceModel.title = @"生活服务";
//    lifeServiceModel.icon = @"btn_home_service";
//    lifeServiceModel.viewControllerStr = @"XDServeceController";

    XDHomeMenuModel *notificationModel = [XDHomeMenuModel new];
    notificationModel.title = @"通知公告";
    notificationModel.icon = @"btn_home_inform";
    notificationModel.viewControllerStr = @"XDInformNewsListController";
    
    XDHomeMenuModel *livingPaymentModel = [XDHomeMenuModel new];
    livingPaymentModel.title = @"生活缴费";
    livingPaymentModel.icon = @"btn_home_payment";
    livingPaymentModel.viewControllerStr = @"XDLiveChargeController";
    
    XDHomeMenuModel *shoppingMallModel = [XDHomeMenuModel new];
    shoppingMallModel.title = @"二手市场";
    shoppingMallModel.icon = @"btn_home_shopping";
    shoppingMallModel.viewControllerStr = @"XDSecondaryTabBarController";
    
    XDHomeMenuModel *rimServiceModel = [XDHomeMenuModel new];
    rimServiceModel.title = @"周边服务";
    rimServiceModel.icon = @"btn_home_ambitus";
    rimServiceModel.viewControllerStr = @"XDHomeNearController";
    
    XDHomeMenuModel *jsonModel = [XDHomeMenuModel new];
    jsonModel.title = @"入伙";
    jsonModel.icon = @"btn_home_more";
    jsonModel.viewControllerStr = @"XDInformNewsListController";
    
    NSArray *menuArray = @[workProgressModel, cardQueryModel, jsonModel, notificationModel, livingPaymentModel, complainModel, repairModel, rimServiceModel];
    
    [self.dataSource addObject:@{@"type" : kMyServiceCell, @"value" : menuArray}];

//    [self.dataSource addObject:@{@"type" : kThemeFunctionCell, @"value" : menuArray}];
    
    [self.collectionView reloadData];
}


- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


- (NSMutableArray *)queueArr {
    if (!_queueArr) {
        _queueArr = [NSMutableArray array];
    }
    return _queueArr;
}

- (NSMutableArray *)bannerArr {
    if (!_bannerArr) {
        _bannerArr = [NSMutableArray array];
    }
    return _bannerArr;
}

- (void)getQueueData{
    [self.queueArr removeAllObjects];
    [self.bannerArr removeAllObjects];
    NSInteger _receive = 1;
    
    NSDictionary *dic = @{
                          @"receive":@(_receive),
                          };
    [[XDAPIManager sharedManager] requestFindHotAndBanner:dic CompletionHandle:^(id responseObject, NSError *error) {
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            NSArray *dicArray = responseObject[@"data"][@"noticeList"];
            for (int i = 0; i< dicArray.count; i++) {
                XDInfoNewModel *model = [XDInfoNewModel mj_objectWithKeyValues:dicArray[i]];
                if (model.noticeType.intValue == 2) {
                    [self.queueArr addObject:model];
                } else if (model.noticeType.intValue == 3) {
                    [self.bannerArr addObject:model];
                }
            }
            [self.collectionView reloadData];
        }
    }];
}

@end
















