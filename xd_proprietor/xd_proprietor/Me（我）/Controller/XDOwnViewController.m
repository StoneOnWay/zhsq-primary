//
//  XDOwnViewController.m
//  XD业主
//
//  Created by zc on 2017/6/16.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDOwnViewController.h"
#import "XDOwnHeadView.h"
#import "XDOwnTableViewCell.h"
#import "XDOwnTableFootCell.h"
#import "XDWarrantyListController.h"
#import "XDMyComplainListController.h"
#import "XDMyInfoEditController.h"
#import "XDMyInfoEditController.h"
#import "XDLoginUseModel.h"
#import "XDReadLoginModelTool.h"
#import "XDLoginViewController.h"
#import "XDInformNewsListController.h"
#import "XDLoginUserRoomInfoModel.h"
#import "XDMyOderFatherController.h"
#import "XDMyOrderAddressController.h"


@interface XDOwnViewController ()<XDMyInfoEditControllerDelegate,CustomAlertViewDelegate>

// 显示的文字
@property (nonatomic , strong) NSArray *nameArray;

//显示的图标
@property (nonatomic , strong) NSArray *iconArray;

//头部控件
@property (nonatomic , strong) XDOwnHeadView *headView;

@end

@implementation XDOwnViewController


- (instancetype)initWithStyle:(UITableViewStyle)style{
    self=[super initWithStyle:style];
    if (self) {
        self=[super initWithStyle:UITableViewStyleGrouped];
    }
    return self;
}

-(BOOL)prefersStatusBarHidden
{
    return NO;// 返回YES表示隐藏，返回NO表示显示
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setOwnNavi];
    
    //设置初始化数据
    [self setupInitData];
    
    //加载头部
    [self setupOwnHeaderView];
}
/**
 *  设置导航栏
 */
-(void)setOwnNavi{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font = CFont(19, 17);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"我";
    self.navigationItem.titleView = titleLabel;
}
//设置初始化数据
- (void)setupInitData {

    self.tableView.backgroundColor = backColor;
    
    //隐藏系统分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //初始值方便更改
    self.nameArray = [NSArray arrayWithObjects:@[@"我的工单",@"我的投诉"],@[@"我的账单",@"公告与通知"],@[@"我的钱包"],@[@"我的订单",@"收货地址"] ,nil];
    self.iconArray = [NSArray arrayWithObjects:@[@"工单-icon",@"投诉-icon"],@[@"账单-icon",@"公告-icon",@"账单-icon",@"公告-icon"],@[@"钱包-icon"],@[@"账单-icon",@"公告-icon"] ,nil];

}
//加载头部
- (void)setupOwnHeaderView {
    
    UIView *baseHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth , 190)];
    XDOwnHeadView *head = [[NSBundle mainBundle] loadNibNamed:@"XDOwnHeadView" owner:nil options:nil ].lastObject;
    self.headView = head;
  
    head.frame = CGRectMake(0, 0, kScreenWidth, 190);
    [baseHeaderView addSubview:head];
    
    __weak typeof(self) weakSelf = self;
    head.headImageClick = ^{
        XDMyInfoEditController *info = [[XDMyInfoEditController alloc] init];
        info.headImage = weakSelf.headView.headImage.image;
        info.textName = weakSelf.headView.nameLabel.text;
        info.delegate = weakSelf;
        [weakSelf.navigationController pushViewController:info animated:YES];
    };
    self.tableView.tableHeaderView = baseHeaderView;
    
}

#pragma mark -- tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2 ||section == 4) {
        return 1;
    }else {
        return [self.nameArray[section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    //退出登录
    if (indexPath.section == 4) {
        
        XDOwnTableFootCell *cell = [XDOwnTableFootCell cellWithTableView:tableView];
  
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else {
        
        XDOwnTableViewCell *cell = [XDOwnTableViewCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == [self.nameArray[indexPath.section] count]-1) {
            cell.downImageLine.hidden = YES;
        }
        cell.iconImage.image = [UIImage imageNamed:self.iconArray[indexPath.section][indexPath.row]];
        cell.nameLabel.text = self.nameArray[indexPath.section][indexPath.row];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XDWarrantyListController *wWarrantyVC = [[XDWarrantyListController alloc] init];
    XDMyComplainListController *complainVC = [[XDMyComplainListController alloc] init];
    XDNotOpenController *onOpen = [[XDNotOpenController alloc] init];

    
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                
                [self.navigationController pushViewController:wWarrantyVC animated:YES];
                
            }else if (indexPath.row == 1){
            
                [self.navigationController pushViewController:complainVC animated:YES];
            }else {
            
            
            }
            break;
        case 1:
            if (indexPath.row == 0) {//我的账单
                
                [self.navigationController pushViewController:onOpen animated:YES];
                
            }else if (indexPath.row == 1){//公告通知
                
                XDInformNewsListController *informVC = [[XDInformNewsListController alloc] init];
                [self.navigationController pushViewController:informVC animated:YES];
            }
            break;
        case 2:
            
            [self.navigationController pushViewController:onOpen animated:YES];
            
            break;
        case 3:
            
            if (indexPath.row == 0){//我的订单
                
                XDMyOderFatherController *orderVC = [[XDMyOderFatherController alloc] init];
                [self.navigationController pushViewController:orderVC animated:YES];
                
            }else {//收货地址
                XDMyOrderAddressController *address = [[XDMyOrderAddressController alloc] init];
                [self.navigationController pushViewController:address animated:YES];
            }
            
            break;
        case 4:
            
            [self clickToAlertViewTitle:@"确定退出登录" withDetailTitle:@"退出登录后信息将会删除，是否确定退出？"];
            
            break;
        default:
            break;
    }
}

#pragma mark -- infoDelegate
- (void)XDMyInfoEditControllerWithUsualName:(NSString *)usualName withUsualAddress:(NSString *)usualAddress withUsualContact:(NSString *)usualContact withMyHeadImage:(UIImage *)headImage {
    // 项目 楼栋 单元 房屋
    self.headView.headImage.image = headImage;
    self.headView.nameLabel.text = usualName;
}

//退出登录
-(void)clickToAlertViewTitle:(NSString *)title withDetailTitle:(NSString *)detailTitle {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    CustomAlertView *alertView = [[CustomAlertView alloc]initWithFrame:window.bounds WithTitle:title andDetail:detailTitle andBody:nil andCancelTitle:@"取消" andOtherTitle:@"确定" andIsOneBtn:NO];
    [alertView.otherButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    alertView.delegate = self;
    [window addSubview:alertView];
}

//CustomAlertViewDelegate
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

@end
