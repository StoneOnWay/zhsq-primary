//
//  XDShopDetailController.m
//  XD业主
//
//  Created by zc on 2018/3/14.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDShopDetailController.h"
#import <WebKit/WebKit.h>
#import "XDDetailShufflingHeadView.h" //头部轮播
#import "XDShopDetailSectionHead.h"
#import "XDShopDetailCell.h"
#import "XDShopDetailSizeCell.h"
// Views
#import "DCLIRLButton.h"
#import "DCDetailOverFooterView.h"
#import "XDShoppingCartController.h"
#import "XDCreateOrderController.h"
#import "XDOrderCommentCell.h"
#import "XDOrderCommentController.h"
#import "XDOrderCommentModel.h"

@interface XDShopDetailController ()<UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate>

@property (strong, nonatomic) UIScrollView *scrollerView;
@property (strong, nonatomic) UITableView *showTableView;
@property (strong, nonatomic) WKWebView *webView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation XDShopDetailController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
#pragma mark - LazyLoad
- (UIScrollView *)scrollerView
{
    if (!_scrollerView) {
        _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollerView.frame = self.view.bounds;
        _scrollerView.contentSize = CGSizeMake(kScreenWidth, (kScreenHeight - 50) * 2);
        _scrollerView.pagingEnabled = YES;
        _scrollerView.scrollEnabled = NO;
        [self.view addSubview:_scrollerView];
    }
    return _scrollerView;
}

- (UITableView *)showTableView {
    if (!_showTableView) {
        _showTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _showTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _showTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - KYTopNavH-50);
        [_showTableView registerClass:[XDShopDetailSectionHead class] forHeaderFooterViewReuseIdentifier:@"XDShopDetailSectionHead"];
        _showTableView.delegate = self;
        _showTableView.dataSource = self;
        [self.scrollerView addSubview:_showTableView];
    }
    return _showTableView;
}
- (WKWebView *)webView
{
    if (!_webView) {

        _webView = [[WKWebView alloc] initWithFrame:CGRectZero];
        _webView.frame = CGRectMake(0,kScreenHeight - KYTopNavH , kScreenWidth, kScreenHeight - KYTopNavH-50);
        _webView.scrollView.scrollIndicatorInsets = _webView.scrollView.contentInset;
        [_webView setBackgroundColor:[UIColor clearColor]];
        [_webView setOpaque:NO];
        [self.scrollerView addSubview:_webView];
    }
    return _webView;
}



- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpInit];
    
    [self setUpViewScroller];
    
    [self setUpGoodsWKWebView];
    
    [self setUpJoinCartButton];
    
    [self getCommentData];
    
//    [self setUpBottomButton]; 这个暂时不做
    
    
}
- (void)getCommentData {
    
    [MBProgressHUD showActivityMessageInWindow:nil];
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    //请求数据
    NSDictionary *dic = @{
                          @"appTokenInfo":token,
                          @"appMobile":appMobile,
                          @"goodsId" : @(self.shopModel.ids),
                          @"page":@"1",
                          @"pagesize":@PageSiz
                          };
    
    WEAKSELF
    [[XDAPIManager sharedManager] requestGetCommentData:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        [MBProgressHUD hideHUD];
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            
            NSArray *dicArray = responseObject[@"data"][@"comments"];
            if (dicArray.count == 0) {
                return ;
            }
            for (int i = 0; i<dicArray.count; i++) {
                XDOrderCommentModel *model = [XDOrderCommentModel mj_objectWithKeyValues:dicArray[i]];
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf.showTableView reloadData];
        }
        
    }];
    
    
}
#pragma mark - initialize
- (void)setUpInit
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = RGB(242, 243, 244);;
    self.navigationItem.title = @"商品详情";
    self.scrollerView.backgroundColor = self.view.backgroundColor;

    XDDetailShufflingHeadView *headView = [[XDDetailShufflingHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight*0.55)];
    headView.shufflingArray = self.shopModel.resourceList;
    self.showTableView.tableHeaderView = headView;
    self.showTableView.backgroundColor = self.view.backgroundColor;

}
#pragma mark - 底部按钮(收藏 购物车 加入购物车 立即购买)
- (void)setUpBottomButton
{
    [self setUpLeftTwoButton];//收藏 购物车
    
    [self setUpRightTwoButton];//加入购物车 立即购买
}

#pragma mark - 进入购物车和加入购物车
- (void)setUpJoinCartButton
{

    CGFloat buttonW = kScreenWidth * 0.2;
    CGFloat buttonH = 50;
    CGFloat buttonY = kScreenHeight - buttonH -KYTopNavH;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"tabr_08gouwuche"] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    [button setImage:[UIImage imageNamed:@"tabr_08gouwuche"] forState:UIControlStateSelected];
    button.tag = 1;
    [button addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, buttonY, buttonW, buttonH);
    [self.view addSubview:button];
    
    CGFloat buttonW1 = kScreenWidth*0.8;
    CGFloat buttonH1 = 50;
    CGFloat buttonY1 = kScreenHeight - buttonH -KYTopNavH;
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.titleLabel.font = SFont(16);
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button1.tag = 2;
    [button1 setTitle:@"加入购物车" forState:UIControlStateNormal];
    button1.backgroundColor = RGB(208, 175, 107);
    [button1 addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    button1.frame = CGRectMake(buttonW, buttonY1, buttonW1, buttonH1);
    [self.view addSubview:button1];
    
}

#pragma mark - 收藏 购物车
- (void)setUpLeftTwoButton
{
    NSArray *imagesNor = @[@"tabr_07shoucang_up",@"tabr_08gouwuche"];
    NSArray *imagesSel = @[@"tabr_07shoucang_down",@"tabr_08gouwuche"];
    CGFloat buttonW = kScreenWidth * 0.2;
    CGFloat buttonH = 50;
    CGFloat buttonY = kScreenHeight - buttonH -KYTopNavH;
    
    for (NSInteger i = 0; i < imagesNor.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:imagesNor[i]] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        [button setImage:[UIImage imageNamed:imagesSel[i]] forState:UIControlStateSelected];
        button.tag = i;
        [button addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat buttonX = (buttonW * i);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        [self.view addSubview:button];
    }
}
#pragma mark - 加入购物车 立即购买
- (void)setUpRightTwoButton
{
    NSArray *titles = @[@"加入购物车",@"立即购买"];
    CGFloat buttonW = kScreenWidth * 0.6 * 0.5;
    CGFloat buttonH = 50;
    CGFloat buttonY = kScreenHeight - buttonH -KYTopNavH;
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = SFont(16);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.tag = i + 2;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        button.backgroundColor = (i == 0) ? [UIColor redColor] : RGB(249, 125, 10);
        [button addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat buttonX = kScreenWidth * 0.4 + (buttonW * i);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        [self.view addSubview:button];
    }
}

- (void)bottomButtonClick:(UIButton *)button
{
    
    if (button.tag == 0) {//收藏
        NSLog(@"收藏");
        button.selected = !button.selected;
    }else if(button.tag == 1){//购物车

        XDShoppingCartController *shopCarVc = [[XDShoppingCartController alloc] init];
        shopCarVc.navigationItem.title = @"购物车";
        [self.navigationController pushViewController:shopCarVc animated:YES];
        
    }else  if (button.tag == 2) { //加入购物车
        
        [self addGoodsToshopCart:self.shopModel];
        
    }else { //button.tag == 3 立即购买
        
        XDCreateOrderController *orderVc = [[XDCreateOrderController alloc] init];
        orderVc.shopModelArray = @[self.shopModel];
        [self.navigationController pushViewController:orderVc animated:YES];
        

    }
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


#pragma mark - 记载图文详情
- (void)setUpGoodsWKWebView {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",K_BASE_URL,self.shopModel.detail];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [self.webView loadRequest:request];
    
    //下拉返回商品详情View
    UIView *topHitView = [[UIView alloc] init];
    topHitView.frame = CGRectMake(0, -35, kScreenWidth, 35);
    DCLIRLButton *topHitButton = [DCLIRLButton buttonWithType:UIButtonTypeCustom];
    topHitButton.imageView.transform = CGAffineTransformRotate(topHitButton.imageView.transform, M_PI); //旋转
    [topHitButton setImage:[UIImage imageNamed:@"Details_Btn_Up"] forState:UIControlStateNormal];
    [topHitButton setTitle:@"下拉返回商品详情" forState:UIControlStateNormal];
    topHitButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [topHitButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [topHitView addSubview:topHitButton];
    topHitButton.frame = topHitView.bounds;
    
    [self.webView.scrollView addSubview:topHitView];
}

#pragma mark - 视图滚动
- (void)setUpViewScroller{
    WEAKSELF
    self.showTableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            weakSelf.scrollerView.contentOffset = CGPointMake(0, kScreenHeight-64);
        } completion:^(BOOL finished) {
            [weakSelf.showTableView.mj_footer endRefreshing];
        }];
    }];
    
    self.webView.scrollView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [UIView animateWithDuration:0.8 animations:^{
            weakSelf.scrollerView.contentOffset = CGPointMake(0, 0);
        } completion:^(BOOL finished) {
            [weakSelf.webView.scrollView.mj_header endRefreshing];
        }];
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count? 3:2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        XDShopDetailCell *cell = [XDShopDetailCell cellWithTableView:tableView];
        cell.selectionStyle = 0;
        cell.nameLabel.text = self.shopModel.name;
        cell.discountLabel.text = [NSString stringWithFormat:@"¥ %@",self.shopModel.discountprice];
        cell.priceLabel.text = [NSString stringWithFormat:@"¥ %@",self.shopModel.price];
        return cell;
    }else if (indexPath.section == 1) {
        XDShopDetailSizeCell *cell = [XDShopDetailSizeCell cellWithTableView:tableView];
        cell.selectionStyle = 0;
        [cell.sizeBtn setTitle:self.shopModel.size forState:UIControlStateNormal];
        
        return cell;
    }
    XDOrderCommentCell *cell = [XDOrderCommentCell cellWithTableView1:tableView];
    cell.selectionStyle = 0;
    cell.commentModel = self.dataArray.firstObject;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        XDOrderCommentController *comment = [[XDOrderCommentController alloc] init];
        comment.dataArray = self.dataArray;
        comment.shopModel = self.shopModel;
        [self.navigationController pushViewController:comment animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        
        XDOrderCommentModel *model = self.dataArray.firstObject;
        return [self evaluteCellHeight:model.content];
    }
    return 70;
}

- (CGFloat)evaluteCellHeight:(NSString *)evaluteString {
    
    CGFloat Width = kScreenWidth - WMargin * 2;
    CGSize evaluteLabelSize = [evaluteString boundingRectWithSize:CGSizeMake(Width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttributes context:nil].size;
    CGFloat evaluteLabelSizeH = evaluteLabelSize.height;
    
    return evaluteLabelSizeH + 110;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    XDShopDetailSectionHead *shopHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"XDShopDetailSectionHead"];
    if (section == 0) {
        shopHeaderView.titleString = self.shopModel.shopType.name;;
    }else if (section == 1) {
        shopHeaderView.titleString = @"规格选择:";
    }else{
        shopHeaderView.titleString = @"评论:";
    }
    
    return shopHeaderView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 30;
    }
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
        DCDetailOverFooterView *shopFootView = [[DCDetailOverFooterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
        return shopFootView;
    }
    return nil;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 40;
    }
    return 0.001;
}


@end
