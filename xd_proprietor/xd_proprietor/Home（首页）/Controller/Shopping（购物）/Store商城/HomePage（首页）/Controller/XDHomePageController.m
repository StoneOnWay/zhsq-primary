//
//  XDHomePageController.m
//  XD业主
//
//  Created by zc on 2018/3/6.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDHomePageController.h"
#import "KYHoverFlowLayout.h"
#import "XDSwitchGridCell.h"
#import "XDGoodsListController.h"
#import "XDHomeDataModel.h"

@interface XDHomePageController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
/* scrollerVew */
@property (strong , nonatomic)UICollectionView *collectionView;
//数据
@property (nonatomic ,strong)NSMutableArray *infoArray;
@end

static NSString *const XDSwitchGridCellID = @"XDSwitchGridCell";

@implementation XDHomePageController

- (NSMutableArray *)infoArray {
    if (!_infoArray) {
        self.infoArray = [NSMutableArray array];
    }
    return _infoArray;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        KYHoverFlowLayout *layout = [KYHoverFlowLayout new];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - KYBottomTabH - KYTopNavH);
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[XDSwitchGridCell class] forCellWithReuseIdentifier:XDSwitchGridCellID];//cell
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = @"先导商城";
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backColor;
    self.collectionView.backgroundColor = self.view.backgroundColor;
    
    [self loadTypesList];
}

- (void)loadTypesList {
    
    [MBProgressHUD showActivityMessageInWindow:nil];
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    //请求数据
    NSDictionary *dic = @{
                          @"appTokenInfo":token,
                          @"appMobile":appMobile,
                          @"homeid" : @(self.shopModel.ids),
                          };
    
    WEAKSELF
    [[XDAPIManager sharedManager] requestTypeList:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        [MBProgressHUD hideHUD];
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
           
            NSArray *dicArray = responseObject[@"data"];
            if (dicArray.count == 0) {
                [KYRefreshView showWithStatus:@"抱歉！暂无数据"];
                [KYRefreshView dismissDeleyWithDuration:1];
                return ;
            }
            for (int i = 0; i<dicArray.count; i++) {
                XDHomeDataModel *model = [XDHomeDataModel mj_objectWithKeyValues:dicArray[i]];
                [weakSelf.infoArray addObject:model];
            }
            [weakSelf.collectionView reloadData];
        }
        
    }];
    
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _infoArray.count;
}

#pragma mark - <UICollectionViewDelegate>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XDSwitchGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:XDSwitchGridCellID forIndexPath:indexPath];
    cell.homeModel = _infoArray[indexPath.row];

    return cell;
}

#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenWidth - 4)/2, (kScreenWidth - 4)/2 + 30);//列表、网格Cell
}

#pragma mark - 边间距属性默认为0
#pragma mark - X间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 4;
    
}
#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 4;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    XDGoodsListController *dcVc = [[XDGoodsListController alloc] init];
    dcVc.homeModel = _infoArray[indexPath.row];
    [self.navigationController pushViewController:dcVc animated:YES];
    
}

@end
