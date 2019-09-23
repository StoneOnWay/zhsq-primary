//
//  XDGoodsListController.m
//  XD业主
//
//  Created by zc on 2018/3/7.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDGoodsListController.h"
#import "KYHoverFlowLayout.h"
#import "XDGoodsListCell.h"
#import "XDHomeDataModel.h"
#import "XDGoodsListModel.h"
#import "XDShopDetailController.h"

#define pageSizes 20
@interface XDGoodsListController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSInteger _currentPage;//当前页码
}

@property (nonatomic ,strong)MJRefreshAutoNormalFooter *Footer;
@property (nonatomic ,strong)NSMutableArray *infoArray;

/* scrollerVew */
@property (strong , nonatomic)UICollectionView *collectionView;

@end

static NSString *const XDGoodsListCellID = @"XDGoodsListCell";

@implementation XDGoodsListController

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
        _collectionView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - KYTopNavH);
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[XDGoodsListCell class] forCellWithReuseIdentifier:XDGoodsListCellID];//cell
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backColor;
    self.navigationItem.title = @"商品列表";
    self.collectionView.backgroundColor = self.view.backgroundColor;
    _currentPage = 1;
    //添加刷新
    [self prepareTableViewRefresh];
    //请求数据
    [self loadGoodsList];
    
}

- (void)loadGoodsList {
    
    [MBProgressHUD showActivityMessageInWindow:nil];
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    //请求数据
    NSDictionary *dic = @{
                          @"appTokenInfo":token,
                          @"appMobile":appMobile,
                          @"page":@(_currentPage),
                          @"pagesize":@pageSizes,
                          @"typeid":@(self.homeModel.ids),
                          };
    
    WEAKSELF
    [[XDAPIManager sharedManager] requestGoodsList:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        [MBProgressHUD hideHUD];
        weakSelf.Footer.hidden = NO;
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            NSArray *dicArray = responseObject[@"data"][@"list"];
            
            if (dicArray.count < pageSizes) {
                [weakSelf.Footer endRefreshingWithNoMoreData];
            }
            if (dicArray.count == 0) {
                [KYRefreshView showWithStatus:@"抱歉！暂无数据"];
                [KYRefreshView dismissDeleyWithDuration:1];
                return ;
            }
            for (int i = 0; i<dicArray.count; i++) {
                XDGoodsListModel *model = [XDGoodsListModel mj_objectWithKeyValues:dicArray[i]];
                [weakSelf.infoArray addObject:model];
            }
            [weakSelf.collectionView reloadData];
            
        } else {
            [weakSelf.Footer endRefreshingWithNoMoreData];
            weakSelf.Footer.stateLabel.text = @"数据加载失败";
        }
    }];
    
}


//准备刷新控件--tableView
- (void)prepareTableViewRefresh
{
    
    MJRefreshNormalHeader *Header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRefreshNoticeNewListData)];
    Header.lastUpdatedTimeLabel.hidden = YES;
    self.collectionView.mj_header = Header;
    [self.collectionView.mj_header endRefreshing];
    
    MJRefreshAutoNormalFooter *Footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreNoticeNewListData)];
    self.Footer = Footer;
    Footer.hidden = YES;
    self.collectionView.mj_footer = Footer;
    [self.collectionView.mj_footer endRefreshing];
    
}
#pragma mark -- 刷新数据 -- tablView
- (void)loadRefreshNoticeNewListData {
    
    _currentPage = 1;
    [self MJNewList:@"head"];
    
}
#pragma mark -- 加载更多 -- tablView
- (void)loadMoreNoticeNewListData {
    
    _currentPage += 1;
    [self MJNewList:@"foot"];
    
}
- (void)MJNewList:(NSString *)name {
    
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSDictionary *dic = @{
                          @"appTokenInfo":token,
                          @"appMobile":appMobile,
                          @"page":@(_currentPage),
                          @"pagesize":@pageSizes,
                          @"typeid":@(self.homeModel.ids),
                          };
    
    WEAKSELF
    //请求网络数据
    [[XDAPIManager sharedManager] requestGoodsList:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        //失败了
        if (error) {
            
            [weakSelf.collectionView.mj_header endRefreshing];
            [weakSelf.collectionView.mj_footer endRefreshing];
            if ([name isEqualToString:@"foot"]) {
                weakSelf.Footer.stateLabel.text = @"数据加载失败";
                _currentPage -= 1;
            }
            return ;
        }
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            
            NSArray *dicArray = responseObject[@"data"][@"list"];
            if ([name isEqualToString:@"foot"]) {
                [weakSelf.collectionView.mj_footer endRefreshing];
                if (dicArray.count < pageSizes) {
                    [weakSelf.Footer endRefreshingWithNoMoreData];
                }
            }
            if ([name isEqualToString:@"head"]) {
                [weakSelf.collectionView.mj_header endRefreshing];
                [weakSelf.infoArray removeAllObjects];
                [weakSelf.Footer resetNoMoreData];
                if (dicArray.count < pageSizes) {
                    [weakSelf.Footer endRefreshingWithNoMoreData];
                }
            }
            
            for (int i = 0; i<dicArray.count; i++) {
                XDGoodsListModel *model = [XDGoodsListModel mj_objectWithKeyValues:dicArray[i]];
                [weakSelf.infoArray addObject:model];
                
            }
            [weakSelf.collectionView reloadData];
            
        }else {
            [weakSelf.collectionView.mj_header endRefreshing];
            [weakSelf.collectionView.mj_footer endRefreshing];
            if ([name isEqualToString:@"foot"]) {
                weakSelf.Footer.stateLabel.text = @"数据加载失败";
                _currentPage -= 1;
            }
            
        }
    }];
    
}


#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.infoArray.count;
}

#pragma mark - <UICollectionViewDelegate>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XDGoodsListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:XDGoodsListCellID forIndexPath:indexPath];
    WEAKSELF
    cell.cartBtnBeClickedBlock = ^{
        
        [weakSelf addGoodsToshopCart:weakSelf.infoArray[indexPath.row]];
    };
    cell.listModel = _infoArray[indexPath.row];
    
    return cell;
}

//添加到购物车
- (void)addGoodsToshopCart:(XDGoodsListModel *)model {
    
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSNumber *ownerid = loginModel.userInfo.userId;
    NSInteger homeid = model.shopType.homeid;
    NSString *goodses = [NSString stringWithFormat:@"%ld=1",model.ids];
    NSDictionary *dic = @{
                          @"appTokenInfo":token,
                          @"appMobile":appMobile,
                          @"ownerid":ownerid,
                          @"goodses":goodses,
                          @"homeid":@(homeid),
                          };
    
    WEAKSELF
    //请求网络数据
    [[XDAPIManager sharedManager] requestAddGoods:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMyShopCaertList" object:nil];
            [weakSelf setUpWithAddIsSuccess:YES];
            
        }else if ([responseObject[@"resultCode"] isEqualToString:@"1"]) {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD dismissWithDelay:1.0];
            
        }else {
            [weakSelf setUpWithAddIsSuccess:NO];
        }
    }];
    
}
#pragma mark - 加入购物车成功
- (void)setUpWithAddIsSuccess:(BOOL)isSuccess{
    
    if (isSuccess) {
        [SVProgressHUD showSuccessWithStatus:@"加入购物车成功~"];
    }else {
        [SVProgressHUD showErrorWithStatus:@"加入购物车失败~"];
    }
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD dismissWithDelay:1.0];
}

#pragma mark - item宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenWidth - 4)/2, (kScreenWidth - 4)/2 + 60);//列表、网格Cell
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
    
    XDShopDetailController *shopDetail = [[XDShopDetailController alloc] init];
    shopDetail.shopModel = _infoArray[indexPath.row];
    [self.navigationController pushViewController:shopDetail animated:YES];

    
}


- (void)dealloc {
     NSLog(@"释放了");
}

@end
