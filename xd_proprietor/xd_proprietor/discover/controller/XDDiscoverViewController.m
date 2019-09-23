//
//  XDDiscoverViewController.m
//  xd_proprietor
//
//  Created by mason on 2018/8/31.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDDiscoverViewController.h"
#import "SYStickHeaderWaterFallLayout.h"
#import "XDFunActivityItemCollectionViewCell.h"
#import "XDCommentListModel.h"
#import "XDFunDetailViewController.h"
#import "XDBindTipsView.h"
#import "XDPhoneBindController.h"

@interface XDDiscoverViewController ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
SYStickHeaderWaterFallDelegate,
ISLikeDelegate
>
{
    XDBindTipsView *tipsView;
}
/** <##> */
@property (strong, nonatomic) NSMutableArray *itemArray;

@end

@implementation XDDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setuiView];
    self.view.backgroundColor = UIColorHex(f3f3f3);
    [self loadDiscoverData];
}

- (void)loadDiscoverData{
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    if (!loginModel.userInfo.userId) {
//        [XDUtil showToast:@"用户信息不存在！"];
        tipsView.hidden = NO;
        return;
    } else {
        tipsView.hidden = YES;
        [self.itemArray removeAllObjects];// 清空数据
        
        if (self.flag == 1) {
            // 全部
            [[XDAPIManager sharedManager] requestgetAllThemeWithParameters:@{@"page":@"1",@"appTokenInfo":loginModel.token} CompletionHandle:^(id responseObject, NSError *error) {
                [self.collectionView.mj_header endRefreshing];
                NSDictionary *resultDict = (NSDictionary*)responseObject;
                if ([resultDict[@"resultCode"] isEqualToString:@"0"]) {
                    NSArray *items = [NSArray modelArrayWithClass:[XDCommentListModel class] json:responseObject[@"data"]];
                    [self.itemArray addObjectsFromArray:items];
                    [self.collectionView reloadData];
                }
            }];
        } else if (self.flag == 2) {
            // 我关注的
            [[XDAPIManager sharedManager] requestGetFollowThemesByOwneridWithParameters:@{@"ownersid":loginModel.userInfo.userId,@"page":@"1", @"appTokenInfo":loginModel.token} CompletionHandle:^(id responseObject, NSError *error) {
                [self.collectionView.mj_header endRefreshing];
                NSDictionary *resultDict = (NSDictionary*)responseObject;
                if ([resultDict[@"resultCode"] isEqualToString:@"0"]) {
                    NSArray *items = [NSArray modelArrayWithClass:[XDCommentListModel class] json:responseObject[@"data"]];
                    [self.itemArray addObjectsFromArray:items];
                    
                    [self.collectionView reloadData];
                }
            }];
        } else if (self.flag == 3) {
            // 我发布的
            [[XDAPIManager sharedManager] requestgetAllThemmByOwneridWithParameters:@{@"ownersid":loginModel.userInfo.userId,@"page":@"1",@"appTokenInfo":loginModel.token} CompletionHandle:^(id responseObject, NSError *error) {
                [self.collectionView.mj_header endRefreshing];
                NSDictionary *resultDict = (NSDictionary*)responseObject;
                if ([resultDict[@"resultCode"] isEqualToString:@"0"]) {
                    NSArray *items = [NSArray modelArrayWithClass:[XDCommentListModel class] json:responseObject[@"data"]];
                    [self.itemArray addObjectsFromArray:items];
                    [self.collectionView reloadData];
                }
            }];
        }
    }
    
}

- (void)setuiView {
    
    SYStickHeaderWaterFallLayout *layout = [[SYStickHeaderWaterFallLayout alloc] init];
    layout.delegate = self;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - TabbarHeight - NavHeight) collectionViewLayout:layout];
    self.collectionView = collectionView;
    collectionView.delegate =self;
    collectionView.dataSource =self;
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XDFunActivityItemCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XDFunActivityItemCollectionViewCell class])];
    collectionView.backgroundColor = UIColorHex(f3f3f3);
    
    self.collectionView.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        [self loadDiscoverData];
    }];
    
    [self.view addSubview:collectionView];
    
    tipsView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XDBindTipsView class]) owner:self options:nil].firstObject;
    tipsView.frame = self.collectionView.bounds;
    WEAKSELF
    tipsView.bindBtnClick = ^{
        XDPhoneBindController *bindVC = [[XDPhoneBindController alloc] init];
        [weakSelf.navigationController pushViewController:bindVC animated:YES];
    };
    [self.collectionView addSubview:tipsView];
    tipsView.hidden = YES;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XDFunActivityItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XDFunActivityItemCollectionViewCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    [cell setCellDataWithModel:self.itemArray[indexPath.row]];
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5.f;
}

//代理方法
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(SYStickHeaderWaterFallLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([XDUtil isIPad]) {
        return 400.f;
    }
    return 260.0f;
//    return [self.itemArray[indexPath.row] floatValue];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    XDCommentListModel *listModel = self.itemArray[indexPath.row];
    XDFunDetailViewController *mvc = [[UIStoryboard storyboardWithName:@"XDDiscoverHomeViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"XDFunDetailViewController"];
    mvc.listModel = listModel;
    mvc.shouldUpdateFunAllDataBlock = ^{
        for (XDDiscoverViewController *discoverVC in self.relationVcArray) {
            [discoverVC.collectionView.mj_header beginRefreshing];
//            if (discoverVC.flag != 2) {
//                // 关注的不需要刷新
//            }
        }
    };
    [self.navigationController pushViewController:mvc animated:YES];
}

- (void)islikeWithModel:(XDCommentListModel *)model{
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];

    [[XDAPIManager sharedManager] requestupThemeWithParameters:@{@"themeid":model.mid,@"ownersid":loginModel.userInfo.userId,@"appTokenInfo":loginModel.token} CompletionHandle:^(id responseObject, NSError *error) {
        
    }];
}

- (CGFloat)collectionView:(nonnull UICollectionView *)collectionView
                   layout:(nonnull SYStickHeaderWaterFallLayout *)collectionViewLayout
    widthForItemInSection:( NSInteger )section
{
    return (kScreenWidth - 15.f) / 2.f;
}

- (NSMutableArray *)itemArray {
    if (!_itemArray) {
//        NSInteger count = arc4random() % 30 + 20;
        _itemArray = [NSMutableArray array];
//        for (NSInteger i = 0; i < count; i++) {
//            [_itemArray addObject:@(arc4random() % 100 + 50.f)];
//        }
    }
    return _itemArray;
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView
//                   layout:(SYStickHeaderWaterFallLayout *)collectionViewLayout
//heightForHeaderAtIndexPath:(NSIndexPath *)indexPath {
//    return 38.0f;
//}
//

//
//- (CGFloat) collectionView:(nonnull UICollectionView *)collectionView
//                    layout:(nonnull SYStickHeaderWaterFallLayout *)collectionViewLayout
//              topInSection:(NSInteger )section
//{
//    return 10;
//}
//
//- (CGFloat) collectionView:(nonnull UICollectionView *)collectionView
//                    layout:(nonnull SYStickHeaderWaterFallLayout *)collectionViewLayout
//           bottomInSection:( NSInteger)section
//{
//    return 5;
//}


@end
