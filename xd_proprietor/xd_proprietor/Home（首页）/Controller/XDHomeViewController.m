//
//  XDHomeViewController.m
//  XD业主
//
//  Created by zc on 2017/6/16.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDHomeViewController.h"
#import "CFLBannerView.h"
#import "XDCollectView.h"
#import "XDHomeTableViewCell.h"
#import "XDInfoNewDetailNetController.h"

@interface XDHomeViewController ()<CFLBannerViewDelegate>

@property (nonatomic,strong) XDInfoNewModel *model;

@property (nonatomic,strong) CFLBannerView *lcoalBannerView;
//数据模型
@property (nonatomic,strong) NSMutableArray *modelArray;



@end

@implementation XDHomeViewController

- (NSMutableArray *)modelArray {
    if (!_modelArray) {
        self.modelArray = [NSMutableArray array];
    }
    return _modelArray;
}
-(BOOL)prefersStatusBarHidden
{
    return NO;// 返回YES表示隐藏，返回NO表示显示
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setHomeNavi];
    
    self.view.backgroundColor = backColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self loadTableViewHead];
    

}


/**
 *  设置导航栏
 */
- (void)setHomeNavi{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font = CFont(19, 17);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"先导物业";
    self.navigationItem.titleView = titleLabel;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    NSArray *arr = @[@"home_1",@"home_2",@"home_3"];
    
    self.lcoalBannerView.images = [arr mutableCopy];
    
    [self loadNoticeNewList];
    
}

- (void )loadTableViewHead
{
    
    //tableView的头部view
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 190+kScreenWidth/2)];
    
    
    // Collectionview
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"XDCollectView" owner:self options:nil];
    UIView *localView = [nib lastObject];
    localView.frame = CGRectMake(0, kScreenWidth/2+5, kScreenWidth, 180);
    [headView addSubview:localView];
    
    //轮播图View
    _lcoalBannerView = [CFLBannerView bannerView];
    _lcoalBannerView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth/2);
    _lcoalBannerView.delegate = self;
    _lcoalBannerView.interval = 5;
    [_lcoalBannerView creatTimer];
    [headView addSubview:_lcoalBannerView];
    
    self.tableView.tableHeaderView = headView;
    
}


/**
 *  懒加载轮播图
 */


#pragma mark --tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.modelArray.count != 0) {
        return self.modelArray.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDHomeTableViewCell *cell = [XDHomeTableViewCell cellWithTableView:tableView];
 
    XDInfoNewModel *model = self.modelArray[indexPath.row];
    cell.iconImage.image = [UIImage imageNamed:@"home_pic_little"];
    cell.titleLablels.text = model.title;
    cell.detailLabels.text = model.remark;
        
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 180;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
        
    XDInfoNewDetailNetController *info = [[XDInfoNewDetailNetController alloc] init];
    info.infoModel = self.model;
    [self.navigationController pushViewController:info animated:YES];

    
}

- (void)loadNoticeNewList {
    
    [MBProgressHUD showActivityMessageInWindow:nil];
    [self.modelArray removeAllObjects];
    [self.tableView reloadData];
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSString *projectId = loginModel.userInfo.projectId;
    NSDictionary *dic = @{
                          @"appTokenInfo":token,
                          @"appMobile":appMobile,
                          @"currentPage":@"1",
                          @"pageSize":@PageSiz,
                          @"receive":@"1",
                          @"projectid":projectId
                          };
    //第一条通知
    __weak typeof(self) weakSelf = self;
    [[XDAPIManager sharedManager] requestFindnotice:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        [MBProgressHUD hideHUD];
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            
            NSArray *dicArray = responseObject[@"data"][@"noticeList"];
             [MBProgressHUD hideHUD];
            if (dicArray.count != 0) {
                XDInfoNewModel *model = [XDInfoNewModel mj_objectWithKeyValues:dicArray[0]];
                weakSelf.model = model;
                [weakSelf.modelArray addObject:model];
                [weakSelf.tableView reloadData];
            }
            
        }
    }];
    
}

#pragma mark - delegate
- (void)bannerView:(CFLBannerView *)view didSelectImageView:(UIImageView *)imageView{
    
    NSLog(@"点击：%ld",(long)imageView.tag);
    
}

@end
