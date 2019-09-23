//
//  XDShoppingCartController.m
//  XD业主
//
//  Created by zc on 2018/3/6.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDShoppingCartController.h"

#import "KYShopcartTableViewProxy.h"
#import "KYShopcartBottomView.h"
#import "KYShopcartCell.h"
#import "KYShopcartHeaderView.h"
#import "KYShopcartFormat.h"
#import "Masonry.h"
#import "KYEmptyCartView.h"
#import "XDCreateOrderController.h"
#import "KYShopcartBrandModel.h"

@interface XDShoppingCartController ()<KYShopcartFormatDelegate>

@property (nonatomic ,strong)NSMutableArray *infoArray;

@property (nonatomic, strong) UITableView *shopcartTableView;   /**< 购物车列表 */
@property (nonatomic, strong) KYShopcartBottomView *shopcartBottomView;    /**< 购物车底部视图 */
@property (nonatomic, strong) KYShopcartTableViewProxy *shopcartTableViewProxy;    /**< tableView代理 */
@property (nonatomic, strong) KYShopcartFormat *shopcartFormat;    /**< 负责购物车逻辑处理 */
@property (nonatomic, strong) UIButton *editButton;    /**< 编辑按钮 */

@property (nonatomic, strong) KYEmptyCartView *emptyCartView;

@end

@implementation XDShoppingCartController

#pragma mark getters

- (NSMutableArray *)infoArray {
    if (!_infoArray) {
        self.infoArray = [NSMutableArray array];
    }
    return _infoArray;
}

- (UITableView *)shopcartTableView {
    if (_shopcartTableView == nil){
        _shopcartTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _shopcartTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_shopcartTableView registerClass:[KYShopcartCell class] forCellReuseIdentifier:@"KYShopcartCell"];
        [_shopcartTableView registerClass:[KYShopcartHeaderView class] forHeaderFooterViewReuseIdentifier:@"KYShopcartHeaderView"];
        _shopcartTableView.backgroundColor = backColor;
        _shopcartTableView.showsVerticalScrollIndicator = NO;
        _shopcartTableView.delegate = self.shopcartTableViewProxy;
        _shopcartTableView.dataSource = self.shopcartTableViewProxy;
        _shopcartTableView.rowHeight = 100;
        _shopcartTableView.sectionFooterHeight = 10;
        _shopcartTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _shopcartTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    }
    return _shopcartTableView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = @"购物车";
    UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.editButton];
    self.tabBarController.navigationItem.rightBarButtonItem = editBarButtonItem;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = backColor;
    [self addSubview];
    [self layoutSubview];
    //添加刷新
    [self prepareTableViewRefresh];
    
    [self requestShopcartListData];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestShopcartListData) name:@"refreshMyShopCaertList" object:nil];
    
}

//请求购物车数据
- (void)requestShopcartListData {
    [self.shopcartFormat requestShopcartProductList:YES];
}

//准备刷新控件--tableView
- (void)prepareTableViewRefresh
{
    
    MJRefreshNormalHeader *Header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshShopcartListData)];
    Header.lastUpdatedTimeLabel.hidden = YES;
    self.shopcartTableView.mj_header = Header;
    [self.shopcartTableView.mj_header endRefreshing];
}

#pragma mark -- 刷新数据 -- tablView
//请求购物车数据
- (void)refreshShopcartListData {
    [self.shopcartFormat requestShopcartProductList:NO];
}

#pragma mark KYShopcartFormatDelegate
//数据请求成功回调
- (void)shopcartFormatRequestProductListDidSuccessWithArray:(NSMutableArray *)dataArray {
    
    KYShopcartBrandModel *brandModel = dataArray.firstObject;
    if (brandModel.data.count == 0) {
        self.shopcartTableView.backgroundView = self.emptyCartView;
    }else {
        self.shopcartTableView.backgroundView = nil;
    }
    [self.shopcartTableView.mj_header endRefreshing];
    self.shopcartTableViewProxy.dataArray = dataArray;
    
    [self.shopcartBottomView configureShopcartBottomViewWithTotalPrice:0 totalCount:0 isAllselected:NO];
    [self.shopcartTableView reloadData];
}

//购物车视图需要更新时的统一回调
- (void)shopcartFormatAccountForTotalPrice:(float)totalPrice totalCount:(NSInteger)totalCount isAllSelected:(BOOL)isAllSelected {
    [self.shopcartBottomView configureShopcartBottomViewWithTotalPrice:totalPrice totalCount:totalCount isAllselected:isAllSelected];
    [self.shopcartTableView reloadData];
}

//点击结算按钮后的回调
- (void)shopcartFormatSettleForSelectedProducts:(NSArray *)selectedProducts {
    XDCreateOrderController *orderVC = [[XDCreateOrderController alloc] init];
    WEAKSELF
    orderVC.refreshCart = ^{
        [weakSelf requestShopcartListData];
    };
    KYShopcartBrandModel *brandModel = selectedProducts.firstObject;
    orderVC.cartModelArray = brandModel.selectedArray;
    orderVC.totalString = self.shopcartBottomView.totalPrice;
    [self.navigationController pushViewController:orderVC animated:YES];
    
}

//批量删除回调
- (void)shopcartFormatWillDeleteSelectedProducts:(NSArray *)selectedProducts {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"确认要删除这%ld个宝贝吗？", selectedProducts.count] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.shopcartFormat deleteSelectedProducts:selectedProducts];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

//全部删除回调 所有数据都没有了的时候调用
- (void)shopcartFormatHasDeleteAllProducts {
    
    self.shopcartTableView.backgroundView = self.emptyCartView;
    
}

- (KYEmptyCartView *)emptyCartView {
    
    if (_emptyCartView == nil) {
        _emptyCartView = [[KYEmptyCartView alloc] init];
        _emptyCartView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth);
        WEAKSELF
        _emptyCartView.buyingClickBlock = ^{
            NSLog(@"点击了立即抢购");
            weakSelf.tabBarController.selectedViewController = [weakSelf.tabBarController.viewControllers objectAtIndex:0];
        };
    }
    return _emptyCartView;
}

- (KYShopcartTableViewProxy *)shopcartTableViewProxy {
    if (_shopcartTableViewProxy == nil){
        _shopcartTableViewProxy = [[KYShopcartTableViewProxy alloc] init];
        
        __weak __typeof(self) weakSelf = self;
        //cell的单选
        _shopcartTableViewProxy.shopcartProxyProductSelectBlock = ^(BOOL isSelected, NSIndexPath *indexPath){
            [weakSelf.shopcartFormat selectProductAtIndexPath:indexPath isSelected:isSelected];
        };
        //section的全选
        _shopcartTableViewProxy.shopcartProxyBrandSelectBlock = ^(BOOL isSelected, NSInteger section){
            [weakSelf.shopcartFormat selectBrandAtSection:section isSelected:isSelected];
        };
        //改变个数
        _shopcartTableViewProxy.shopcartProxyChangeCountBlock = ^(NSInteger count, NSIndexPath *indexPath){
            [weakSelf.shopcartFormat changeCountAtIndexPath:indexPath count:count];
        };
        //左滑cell删除
        _shopcartTableViewProxy.shopcartProxyDeleteBlock = ^(NSIndexPath *indexPath){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确认要删除这个宝贝吗？" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf.shopcartFormat deleteProductAtIndexPath:indexPath];
            }]];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        };
        
        //收藏
        _shopcartTableViewProxy.shopcartProxyStarBlock = ^(NSIndexPath *indexPath){
            [weakSelf.shopcartFormat starProductAtIndexPath:indexPath];
        };
    }
    return _shopcartTableViewProxy;
}

/**
 *  初始化底部工具条
 */
- (KYShopcartBottomView *)shopcartBottomView {
    if (_shopcartBottomView == nil){
        _shopcartBottomView = [[KYShopcartBottomView alloc] init];
        
        __weak __typeof(self) weakSelf = self;
        
        //全选按钮
        _shopcartBottomView.shopcartBotttomViewAllSelectBlock = ^(BOOL isSelected){
            [weakSelf.shopcartFormat selectAllProductWithStatus:isSelected];
        };
        //点击结算按钮
        _shopcartBottomView.shopcartBotttomViewSettleBlock = ^(){
            [weakSelf.shopcartFormat settleSelectedProducts];
        };
        //点击收藏按钮
        _shopcartBottomView.shopcartBotttomViewStarBlock = ^(){
            [weakSelf.shopcartFormat starSelectedProducts];
        };
        //批量删除
        _shopcartBottomView.shopcartBotttomViewDeleteBlock = ^(){
            [weakSelf.shopcartFormat beginToDeleteSelectedProducts];
        };
    }
    return _shopcartBottomView;
}

- (KYShopcartFormat *)shopcartFormat {
    if (_shopcartFormat == nil){
        _shopcartFormat = [[KYShopcartFormat alloc] init];
        _shopcartFormat.delegate = self;
    }
    return _shopcartFormat;
}

- (UIButton *)editButton {
    if (_editButton == nil){
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _editButton.frame = CGRectMake(0, 0, 40, 40);
        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_editButton setTitle:@"完成" forState:UIControlStateSelected];
        [_editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _editButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_editButton addTarget:self action:@selector(editButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editButton;
}

- (void)editButtonAction {
    self.editButton.selected = !self.editButton.isSelected;
    [self.shopcartBottomView changeShopcartBottomViewWithStatus:self.editButton.isSelected];
    self.shopcartTableViewProxy.isEdit = self.editButton.selected;
    [self.shopcartTableView reloadData];
}

- (void)addSubview {
    
    [self.view addSubview:self.shopcartTableView];
    [self.view addSubview:self.shopcartBottomView];
}

- (void)layoutSubview {
    [self.shopcartTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.shopcartBottomView.mas_top);
    }];
    
    [self.shopcartBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@50);
    }];
}


@end
