//
//  XDDeblockingController.m
//  XD业主
//
//  Created by zc on 2017/7/21.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDDeblockingController.h"
#import "XDDelockingHeadView.h"
#import "XDDelockingCarCell.h"
#import "XDDelockingCell.h"
#import "GSPopoverViewController.h"
#import "XDTypePopCell.h"

#import "XDResponseModel.h"
#import "XDVehicleInfoModel.h"
#import "XDVehiclePageInfoModel.h"
#import "XDVehicleAlarmModel.h"
#import "XDVehicleAlarmPageModel.h"
#import "XDVehicleRecordModel.h"
#import "XDVehicleRecordPageModel.h"

@interface XDDeblockingController ()<CustomAlertViewDelegate>

// 弹出框
@property (strong ,nonatomic) GSPopoverViewController *popView;
// pop的contentView
@property (strong , nonatomic)UITableView *popTableView;

//车辆的集合
@property (strong , nonatomic)NSMutableArray *carsArray;
//车辆出入记录
@property (strong , nonatomic)NSMutableArray *carsRecordArray;

//当前显示的车辆
@property (strong , nonatomic) XDVehicleInfoModel *carModel;

@end

@implementation XDDeblockingController

- (NSMutableArray *)carsArray {
    if (!_carsArray) {
        _carsArray = [[NSMutableArray alloc] init];
//        XDLoginUseModel *model = [XDReadLoginModelTool loginModel];
//        NSArray *array = [model.userInfo.vehicleCode componentsSeparatedByString:@","];
//        if (array.count > 0) {
//            for (NSString *code in array) {
//                XDVehicleInfoModel *model = [[XDVehicleInfoModel alloc] init];
//                model.plateNo = code;
//                [_carsArray addObject:model];
//            }
//        }
//        self.carModel = _carsArray.firstObject;
    }
    return _carsArray;
}

- (NSMutableArray *)carsRecordArray {
    if (!_carsRecordArray) {
        self.carsRecordArray = [NSMutableArray array];
    }
    return _carsRecordArray;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self = [super initWithStyle:UITableViewStyleGrouped];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"智能锁车";
    self.tableView.backgroundColor = litterBackColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    
    MJRefreshNormalHeader *Header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshCarRecord)];
    Header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = Header;
    [self.tableView.mj_header endRefreshing];

//    if (self.carsArray.count > 0) {
//        [MBProgressHUD showActivityMessageInWindow:nil];
//        [self getAlarmCars];
//    } else {
//        [XDUtil showToast:@"当前用户没有注册车辆！"];
//    }
    [self loadMyCarList];
}

#pragma mark -- data

- (void)refreshCarRecord {
    [MBProgressHUD showActivityMessageInWindow:nil];
    [self getCarRecord];
}

// 车辆取消布控
- (void)deleteAlarmCar {
    if (!self.carModel.alarmSyscode) {
        [XDUtil showToast:@"当前车辆没有被锁定！"];
        return;
    }
    [MBProgressHUD showActivityMessageInWindow:nil];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = @{
                          @"alarmSyscodes":self.carModel.alarmSyscode,
                          };
    [[XDAPIManager sharedManager] requestDeleteAlarmCarParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        [MBProgressHUD hideHUD];
        if (error) {
            [XDUtil showToast:@"网络异常，请稍后再试！"];
            return ;
        }
        XDResponseModel *response = [XDResponseModel mj_objectWithKeyValues:responseObject];
        if ([response.code isEqualToString:@"0"]) {
            weakSelf.carModel.state = @1;
            weakSelf.carModel.alarmSyscode = nil;
            [weakSelf.tableView reloadData];
        } else {
            NSLog(@"取消车辆布控失败--%@", response.msg);
            [XDUtil showToast:@"车辆解锁失败，请稍后再试！"];
        }
    }];
}

// 车辆布控
- (void)addAlarmCar {
    if (!self.carModel.plateNo) {
        [XDUtil showToast:@"请选择您要锁定的车辆！"];
        return;
    }
    [MBProgressHUD showActivityMessageInWindow:nil];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = @{
                          @"plateNo":self.carModel.plateNo,
                          };
    [[XDAPIManager sharedManager] requestAddAlarmCarParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        [MBProgressHUD hideHUD];
        if (error) {
            [XDUtil showToast:@"网络异常，请稍后再试！"];
            return ;
        }
        XDResponseModel *response = [XDResponseModel mj_objectWithKeyValues:responseObject];
        if ([response.code isEqualToString:@"0"]) {
            XDVehicleAlarmModel *alarmModel = [XDVehicleAlarmModel mj_objectWithKeyValues:response.data];
            weakSelf.carModel.state = @0;
            weakSelf.carModel.alarmSyscode = alarmModel.alarmSyscode;
            [weakSelf.tableView reloadData];
        } else {
            NSLog(@"车辆锁定失败--%@", response.msg);
            [XDUtil showToast:@"车辆锁定失败，请稍后再试！"];
        }
        
    }];
}

// 获取布控车辆
- (void)getAlarmCars {
    if (!self.carModel.plateNo) {
        [XDUtil showToast:@"请选择您的车辆！"];
        [MBProgressHUD hideHUD];
        return;
    }
    NSDictionary *dic = @{
                          @"searchKey":self.carModel.plateNo,
                          @"pageNo": @1,
                          @"pageSize": @1000,
                          };
    __weak typeof(self) weakSelf = self;
    [[XDAPIManager sharedManager] requestGetAlarmCarsListParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        if (error) {
            [XDUtil showToast:@"网络异常，请稍后再试！"];
//            [self getCarRecord];
            [MBProgressHUD hideHUD];
            return;
        }
        XDResponseModel *response = [XDResponseModel mj_objectWithKeyValues:responseObject];
        if ([response.code isEqualToString:@"0"]) {
            XDVehicleAlarmPageModel *page = [XDVehicleAlarmPageModel mj_objectWithKeyValues:response.data];
            if (page.list.count == 0) {
                self.carModel.state = @(1);
            } else {
                XDVehicleAlarmModel *alarmModel = page.list.firstObject;
                self.carModel.alarmSyscode = alarmModel.alarmSyscode;
                self.carModel.state = @(0);
            }
            [self.tableView reloadData];
            [weakSelf getCarRecord];
        } else {
            NSLog(@"获取布控车辆失败--%@", response.msg);
            [XDUtil showToast:response.msg];
//            [weakSelf getCarRecord];
            [MBProgressHUD hideHUD];
        }
    }];
}

- (void)loadMyCarList {
    [MBProgressHUD showActivityMessageInWindow:nil];
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSNumber *ownerId = loginModel.userInfo.userId;
    if (!ownerId) {
        [XDUtil showToast:@"登录失效！"];
        [MBProgressHUD hideHUD];
        return;
    }
    NSDictionary *dic = @{
                          @"ownerid":ownerId
                          };
    WEAKSELF
    [[XDAPIManager sharedManager] requestMyVehicleListWithParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        if (error) {
            [XDUtil showToast:@"获取车辆列表失败！"];
            [MBProgressHUD hideHUD];
            return;
        }
        if ([responseObject[@"code"] intValue] == 200) {
            [_carsArray removeAllObjects];
            NSArray *resultList = responseObject[@"resultList"];
            for (NSDictionary *dic in resultList) {
                if ([dic[@"vehiclestatus"] integerValue] == 0) {
                    XDVehicleInfoModel *model = [[XDVehicleInfoModel alloc] init];
                    model.plateNo = dic[@"vehiclecode"];
                    [_carsArray addObject:model];
                }
            }
            if (weakSelf.carsArray.count != 0) {
                weakSelf.carModel = weakSelf.carsArray[0];
                [weakSelf.tableView reloadData];
                [weakSelf getAlarmCars];
            } else {
                [weakSelf clickToAlertViewTitle:@"暂无车辆" withDetailTitle:@"请先至“我的-我的车辆”中添加车辆信息"];
                [MBProgressHUD hideHUD];
            }
        } else {
            [MBProgressHUD hideHUD];
            NSString *msg = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
            [XDUtil showToast:msg];
        }
    }];
}

// 获取车辆列表
- (void)getUserCarsList {
    [MBProgressHUD showActivityMessageInWindow:nil];
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *personName = loginModel.userInfo.personName;
    if (!personName) {
        [self clickToAlertViewTitle:@"登录异常" withDetailTitle:@"请检查登录状态后重新获取！"];
        [MBProgressHUD hideHUD];
        return;
    }
    NSDictionary *dic = @{
                          @"personName":personName,
                          @"isBandPerson":@1,
                          @"pageNo":@1,
                          @"pageSize":@1000,
                          };
    __weak typeof(self) weakSelf = self;
    [[XDAPIManager sharedManager] requestGetAllCarsListParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        if (error) {
            [XDUtil showToast:@"网络异常，请稍后再试！"];
            [MBProgressHUD hideHUD];
            return ;
        }
        // TODO:需要使用personId再次进行筛选
        XDResponseModel *list = [XDResponseModel mj_objectWithKeyValues:responseObject];
        if ([list.code isEqualToString:@"0"]) {
            XDVehiclePageInfoModel *pageInfo = [XDVehiclePageInfoModel mj_objectWithKeyValues:list.data];
            [weakSelf.carsArray removeAllObjects];
            [weakSelf.carsArray addObjectsFromArray:pageInfo.list];
            if (weakSelf.carsArray.count != 0) {
                weakSelf.carModel = weakSelf.carsArray[0];
                [weakSelf.tableView reloadData];
                [weakSelf getAlarmCars];
            } else {
                [weakSelf clickToAlertViewTitle:@"暂无车辆" withDetailTitle:@"请先至“我的-我的车辆”中添加车辆信息"];
                [MBProgressHUD hideHUD];
            }
        } else {
            NSLog(@"获取车辆列表失败--%@", list.msg);
            [XDUtil showToast:@"获取您的车辆列表失败，请稍后再试！"];
            [MBProgressHUD hideHUD];
        }
    }];
}

// 获取车辆出入记录
- (void)getCarRecord {
    NSDictionary *dic = @{
                          @"plateNo":self.carModel.plateNo,
                          @"pageNo": @1,
                          @"pageSize": @1000,
                          };
    __weak typeof(self) weakSelf = self;
    [[XDAPIManager sharedManager] requestCarOutRecordParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        [MBProgressHUD hideHUD];
        [self.tableView.mj_header endRefreshing];
        if (error) {
            [XDUtil showToast:@"网络异常，请稍后再试！"];
            return;
        }
        XDResponseModel *response = [XDResponseModel mj_objectWithKeyValues:responseObject];
        if ([response.code isEqualToString:@"0"]) {
            [weakSelf.carsRecordArray removeAllObjects];
            XDVehicleRecordPageModel *page = [XDVehicleRecordPageModel mj_objectWithKeyValues:response.data];
            for (XDVehicleRecordModel *record in page.list) {
                if (record.vehicleOut.intValue == 0) {
                    record.inTime = record.crossTime;
                } else {
                    record.outTime = record.crossTime;
                }
                [weakSelf.carsRecordArray addObject:record];
            }

//            if (weakSelf.carsRecordArray.count == 0) {
//                XDVehicleRecordModel *model = [[XDVehicleRecordModel alloc] init];
//                model.plateNo = weakSelf.carModel.plateNo;
//                model.inTime = @"2019-4-16";
//                model.outTime = @"2019-4-17";
//                [weakSelf.carsRecordArray addObject:model];
//                [weakSelf.carsRecordArray addObject:model];
//                [weakSelf.carsRecordArray addObject:model];
//            }
            [weakSelf.tableView reloadData];
        } else {
            NSLog(@"获取车辆出入记录失败--%@", response.msg);
            [XDUtil showToast:response.msg];
        }
    }];
}

#pragma mark -- Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableView) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.carsArray.count == 0) {
        return 0;
    }
    if (tableView == self.tableView) {
        if (section == 1) {
            return self.carsRecordArray.count;
        }
        return 1;
    } else {
        return self.carsArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            XDDelockingCarCell __block *cell = [XDDelockingCarCell cellWithTableView:tableView];
            if ([self.carModel.state isEqual: @(1)]) {
                cell.switchBtn.selected = YES;
                cell.isLock.text = @"解锁";
                cell.lockImage.image = [UIImage imageNamed:@"suo_kai"];
            } else {
                cell.switchBtn.selected = NO;
                cell.isLock.text = @"锁车";
                cell.lockImage.image = [UIImage imageNamed:@"suo_guan"];
            }
            __weak typeof(self)weakSelf = self;
            cell.switchBtnBlock = ^(UIButton *button) {
                if ([weakSelf.carModel.state isEqual:@1] && !weakSelf.carModel.alarmSyscode) {
                    [weakSelf addAlarmCar];
                } else if ([weakSelf.carModel.state isEqual:@0] && weakSelf.carModel.alarmSyscode) {
                    // 取消布控
                    [weakSelf deleteAlarmCar];
                } else {
                    [XDUtil showToast:@"服务器异常，请稍后再试"];
                }
            };
            cell.selectionStyle = 0;
            return cell;
        } else {
            XDDelockingCell *cell = [XDDelockingCell cellWithTableView:tableView];
            cell.selectionStyle = 0;
            XDVehicleRecordModel *model = self.carsRecordArray[indexPath.row];
            cell.recordModel = model;
            return cell;
        }
    } else {
        XDTypePopCell *cell = [XDTypePopCell cellWithTableView:tableView];
        XDVehicleInfoModel *carModel = self.carsArray[indexPath.row];
        cell.textLabels.text = [NSString stringWithFormat:@"%@", carModel.plateNo];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.carsArray.count == 0) {
        return nil;
    }
    NSString *typeString;
    if (tableView == self.tableView) {
        if (section == 0) {
            typeString = @"choiceCar";
        }
        XDDelockingHeadView *head = [XDDelockingHeadView headerViewWithTableView:tableView withType:typeString];
        head.carNumLabel.text = self.carModel.plateNo;
        [head.popBtn addTarget:self action:@selector(headBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        return head;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.popTableView) {
        XDVehicleInfoModel *carModel = self.carsArray[indexPath.row];
        if (self.carModel.plateNo == carModel.plateNo) {
            [self.popView dissPopoverViewWithAnimation:YES];
            return;
        }
        self.carModel = self.carsArray[indexPath.row];
        [self getAlarmCars];
        [self.popView dissPopoverViewWithAnimation:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            return 67;
        }
        return 108;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.carsArray.count == 0) {
        return 0.001;
    }
    if (tableView == self.tableView) {
        if (section == 0) {
            return 38;
        } else {
            return 33;
        }
    }
    return 0.001;
    
}

/**
 *  按钮点击事件
 */
#pragma mark -- action
- (void)headBtnClicked:(UIButton *)sender {
    
    XDDelockingHeadView *cell = (XDDelockingHeadView *)[self.tableView headerViewForSection:0];
    CGRect rect = [cell.backViews convertRect:sender.frame toView:self.view];
    rect.origin.y += 64;
    [self setUpPopView:sender];
    [self.popView showPopoverWithRect:rect animation:YES];
}

/**
 *  插入popView
 */
- (void)setUpPopView:(UIButton *)sender {
    
    _popTableView = [[UITableView alloc]initWithFrame:CGRectMake(0 , 0,  sender.width, 79)];
    _popTableView.delegate = self;
    _popTableView.dataSource = self;
    _popTableView.tag = 3;
    _popTableView.rowHeight = 40;
    _popTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _popTableView.backgroundColor = [UIColor whiteColor];
    
    self.popView = [[GSPopoverViewController alloc]initWithShowView:self.popTableView];
    self.popView.borderWidth = 1;
    self.popView.borderColor = BianKuang;
}

- (void)clickToAlertViewTitle:(NSString *)title withDetailTitle:(NSString *)detailTitle {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    CustomAlertView *alertView = [[CustomAlertView alloc]initWithFrame:window.bounds WithTitle:title andDetail:detailTitle andBody:nil andCancelTitle:nil andOtherTitle:@"知道了" andIsOneBtn:YES];
    alertView.delegate = self;
    [window addSubview:alertView];
    
}

- (void)clickButtonWithTag:(UIButton *)button {

    [self.navigationController popViewControllerAnimated:YES];

}

@end
