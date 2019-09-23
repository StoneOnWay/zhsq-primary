//
//  XDFaceListController.m
//  xd_proprietor
//
//  Created by cfsc on 2019/6/13.
//  Copyright © 2019年 zc. All rights reserved.
//

#import "XDFaceListController.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "XDFaceCell.h"
#import "XDFaceManageController.h"

#define kMargin 0.5

@interface XDFaceListController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation XDFaceListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"人脸采集";
    [self loadFamilyInfos];
    [self configCollectionView];
}

- (void)configCollectionView {
    UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - NavHeight) collectionViewLayout:layout];
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    collectionView.backgroundColor = litterBackColor;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerNib:[UINib nibWithNibName:@"XDFaceCell" bundle:NSBundle.mainBundle] forCellWithReuseIdentifier:@"XDFaceCell"];
}

- (void)loadFamilyInfos {
    [MBProgressHUD showActivityMessageInWindow:nil];
    XDLoginUseModel *model = [XDReadLoginModelTool loginModel];
    if (!model.userInfo.userId) {
        [XDUtil showToast:@"登录失效！"];
        [MBProgressHUD hideHUD];
        return;
    }
    NSDictionary *dic = @{
                          @"userId":model.userInfo.userId,
                          };
    [[XDAPIManager sharedManager] requestGetOwnerFamilyInfosWithParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        [MBProgressHUD hideHUD];
        if (error) {
            [XDUtil showToast:@"服务器异常！"];
            return;
        }
        if ([responseObject[@"resultCode"] integerValue] == 0) {
            self.itemArray = [XDloginUserInfoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            [self.collectionView reloadData];
        } else {
            [XDUtil showToast:responseObject[@"msg"]];
        }
    }];
}

#pragma mark - uicollection view data source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([XDUtil isIPad]) {
        return CGSizeMake((kScreenWidth - 3 * kMargin)/ 3.f, 150);
    }
    return CGSizeMake((kScreenWidth - 3 * kMargin)/ 3.f, ((kScreenWidth - 3 * kMargin)/ 3.f) + 30);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kMargin;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kMargin;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XDloginUserInfoModel *model = self.itemArray[indexPath.row];
    XDFaceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XDFaceCell" forIndexPath:indexPath];
    cell.userModel = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XDloginUserInfoModel *model = self.itemArray[indexPath.row];
    XDFaceManageController *managerVC = [[XDFaceManageController alloc] init];
    managerVC.userModel = model;
    managerVC.faceDidUpdateSuccess = ^(UIImage * _Nonnull faceImage) {
        [self loadFamilyInfos];
    };
    [self.navigationController pushViewController:managerVC animated:YES];
}

#pragma mark - lazy load
- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

@end
