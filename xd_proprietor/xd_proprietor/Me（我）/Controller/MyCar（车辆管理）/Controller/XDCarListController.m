//
//  XDCarListController.m
//  xd_proprietor
//
//  Created by stone on 22/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDCarListController.h"
#import "XDCarListCell.h"
#import "XDCarPropertyModel.h"
#import "XDCarManageController.h"
#import "XDCarEditController.h"

@interface XDCarListController () {
    UILabel *footerLabel;
}
@property (nonatomic, strong) NSMutableArray *itemArray;
@end

@implementation XDCarListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的车辆";
    
    [self setNavItem];
    [self configTableView];
    [self loadMyCarList];
    [self loadCarCharterInfo];
}

- (void)setNavItem {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"btn_jia" frame:CGRectMake(0, 0, 30, 30) target:self action:@selector(addMyCars)];
}

- (void)configTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"XDCarListCell" bundle:NSBundle.mainBundle] forCellReuseIdentifier:@"XDCarListCell"];
    self.tableView.backgroundColor = litterBackColor;
    footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    footerLabel.font = [UIFont systemFontOfSize:14];
    footerLabel.textColor = RGB(88, 88, 88);
    footerLabel.text = @"没有车辆，请点击右上角添加一台吧";
    footerLabel.textAlignment = NSTextAlignmentCenter;
    self.tableView.tableFooterView = footerLabel;
    footerLabel.hidden = YES;
    
    MJRefreshNormalHeader *Header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMyCarList)];
    Header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = Header;
    [self.tableView.mj_header endRefreshing];
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
    [[XDAPIManager sharedManager] requestMyVehicleListWithParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        if (error) {
            [XDUtil showToast:@"获取车辆列表失败！"];
            [MBProgressHUD hideHUD];
            return;
        }
        if ([responseObject[@"code"] intValue] == 200) {
            [self.itemArray removeAllObjects];
            NSArray *resultList = responseObject[@"resultList"];
            for (NSDictionary *dic in resultList) {
                XDCarPropertyModel *model = [self configModelWithDic:dic];
                [self.itemArray addObject:model];
                // 默认包期信息，防止接口异常无数据
                model.charterName = @"未包期";
            }
            if (self.itemArray.count > 0) {
                [self loadCarCharterInfo];
            } else {
                [MBProgressHUD hideHUD];
                [self.tableView reloadData];
            }
        } else {
            [MBProgressHUD hideHUD];
            NSString *msg = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
            [XDUtil showToast:msg];
        }
    }];
}

// 请求车辆包租信息
- (void)loadCarCharterInfo {
    NSDictionary *dic = @{
                          @"pageNo":@1,
                          @"pageSize":@100
                          };
    [[XDAPIManager sharedManager] requestGetCarCharterInfoWithParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        [MBProgressHUD hideHUD];
//        NSLog(@"loadCarCharterInfo---%@", [responseObject mj_JSONString]);
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            NSArray *list = responseObject[@"data"][@"list"];
            for (XDCarPropertyModel *model in self.itemArray) {
                for (NSDictionary *dic in list) {
                    if ([dic[@"plateNo"] isEqualToString:model.vehiclecode]) {
                        if ([dic[@"groupName"] isKindOfClass:NSNull.class]) {
                            if ([dic[@"validity"] isKindOfClass:NSNull.class]) {
                                model.charterName = @"未包期";
                            } else {
                                NSArray *valArray = dic[@"validity"];
                                NSDictionary *valDic = valArray.firstObject;
                                NSArray *funcTimeArray = valDic[@"functionTime"];
                                // 包租期时日期 startTime endTime
                                NSDictionary *funcTimeDic = funcTimeArray.firstObject;
                                if ([self checkCharterTimeIsValid:funcTimeDic]) {
                                    model.charterName = @"已包期";
                                    model.startTime = funcTimeDic[@"startTime"];
                                    model.endTime = funcTimeDic[@"endTime"];
                                } else {
                                    model.charterName = @"未包期";
                                }
                            }
                        } else {
                            model.charterName = dic[@"groupName"];
                        }
                    }
                }
            }
        }
        [self.tableView reloadData];
    }];
}

// 检查包租期是否有效
- (BOOL)checkCharterTimeIsValid:(NSDictionary *)dic {
    NSString *currentTimeStr = [XDUtil getNowTimeStrWithFormatter:@"yyyyMMdd"];
    NSString *startTimeStr = [dic[@"startTime"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *endTimeStr = [dic[@"endTime"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if (startTimeStr.integerValue <= currentTimeStr.integerValue && endTimeStr.integerValue >= currentTimeStr.integerValue) {
        return YES;
    }
    return NO;
}

- (XDCarPropertyModel *)configModelWithDic:(NSDictionary *)dic {
    XDCarPropertyModel *model = [[XDCarPropertyModel alloc] init];
    model.vehiclecode = dic[@"vehiclecode"];
    model.carPhoto = dic[@"carPhoto"];
    model.vehiclestatus = dic[@"vehiclestatus"];
    model.carId = dic[@"id"];
    if (dic[@"ownerid"]) {
        model.ownerid = [NSString stringWithFormat:@"%@", dic[@"ownerid"]];
    }
    
    if (dic[@"plateType"]) {
        switch ([dic[@"plateType"] integerValue]) {
            case KPlateTypeOri:
                model.plateType = @"标准民用车";
                break;
            case KPlateTypeTwo:
                model.plateType = @"02式民用车";
                break;
            case KPlateTypeArmedPolice:
                model.plateType = @"武警车";
                break;
            case KPlateTypePolice:
                model.plateType = @"警车";
                break;
            case KPlateTypeTwoLine:
                model.plateType = @"民用车双行尾牌";
                break;
            case KPlateTypeMission:
                model.plateType = @"使馆车";
                break;
            case KPlateTypeFarmer:
                model.plateType = @"农用车";
                break;
            case KPlateTypeMotor:
                model.plateType = @"摩托车";
                break;
            case KPlateTypeNewEnergy:
                model.plateType = @"新能源车";
                break;
            case KPlateTypeArmy:
                model.plateType = @"军车";
                break;
            default:
                NSLog(@"1222222");
                break;
        }
    }
    
    if (dic[@"plateColor"]) {
        switch ([dic[@"plateColor"] integerValue]) {
            case KPlateColorBlue:
                model.plateColor = @"蓝色";
                break;
            case KPlateColorYellow:
                model.plateColor = @"黄色";
                break;
            case KPlateColorWhite:
                model.plateColor = @"白色";
                break;
            case KPlateColorBlack:
                model.plateColor = @"黑色";
                break;
            case KPlateColorGreen:
                model.plateColor = @"绿色";
                break;
            case KPlateColorPlaneBlack:
                model.plateColor = @"民航黑色";
                break;
            case KPlateColorOther:
                model.plateColor = @"其他颜色";
                break;
            default:
                break;
        }
    }
    if (dic[@"carType"]) {
        switch ([dic[@"carType"] integerValue]) {
            case KCarTypeOther:
                model.carType = @"其他车";
                break;
            case KCarTypeSmall:
                model.carType = @"小型车";
                break;
            case KCarTypeLarge:
                model.carType = @"大型车";
                break;
            case KCarTypeMotor:
                model.carType = @"摩托车";
                break;
            default:
                break;
        }
    }
    
    if (dic[@"carColor"]) {
        switch ([dic[@"carColor"] integerValue]) {
            case KCarColorOther:
                model.carColor = @"其他颜色";
                break;
            case KCarColorWhite:
                model.carColor = @"白色";
                break;
            case KCarColorSilver:
                model.carColor = @"银色";
                break;
            case KCarColorGray:
                model.carColor = @"灰色";
                break;
            case KCarColorBlack:
                model.carColor = @"黑色";
                break;
            case KCarColorRed:
                model.carColor = @"红色";
                break;
            case KCarColorDarkBlue:
                model.carColor = @"深蓝色";
                break;
            case KCarColorBlue:
                model.carColor = @"蓝色";
                break;
            case KCarColorYellow:
                model.carColor = @"黄色";
                break;
            case KCarColorGreen:
                model.carColor = @"绿色";
                break;
            case KCarColorBrown:
                model.carColor = @"棕色";
                break;
            case KCarColorPink:
                model.carColor = @"粉色";
                break;
            case KCarColorPurple:
                model.carColor = @"紫色";
                break;
            default:
                break;
        }
    }
    return model;
}

- (void)addMyCars {
    XDCarManageController *carManVC = [[XDCarManageController alloc] init];
    carManVC.title = @"添加车辆";
    carManVC.addCarSuccess = ^{
        [self.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:carManVC animated:YES];
}

- (void)deleteMyCarAtIndexPath:(NSIndexPath *)indexPath {
    XDCarPropertyModel *model = self.itemArray[indexPath.row];
    if (!model.carId) {
        [XDUtil showToast:@"车辆不存在！"];
        return;
    }
    [MBProgressHUD showActivityMessageInWindow:nil];
    NSDictionary *dic = @{
                          @"id":model.carId
                          };
    [[XDAPIManager sharedManager] requesDeleteMyVehicleWithParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        [MBProgressHUD hideHUD];
        if (error) {
            [XDUtil showToast:@"删除车辆失败！"];
            return;
        }
        __weak typeof (self)weakSelf = self;
        if ([responseObject[@"resultCode"] integerValue] == 200) {
            [weakSelf.itemArray removeObjectAtIndex:indexPath.row];
            [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [weakSelf.tableView reloadData];
        } else {
            NSString *msg = [NSString stringWithFormat:@"%@", responseObject[@"msg"]];
            [XDUtil showToast:msg];
        }
    }];
}

#pragma mark - lazy load
- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.itemArray.count == 0) {
        footerLabel.hidden = NO;
    } else {
        footerLabel.hidden = YES;
    }
    return self.itemArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 155;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDCarPropertyModel *model = self.itemArray[indexPath.row];
    XDCarListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XDCarListCell" forIndexPath:indexPath];
    cell.carModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteMyCarAtIndexPath:indexPath];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XDCarPropertyModel *model = self.itemArray[indexPath.row];
    XDCarEditController *carEditVC = [[XDCarEditController alloc] init];
    carEditVC.title = model.vehiclecode;
    carEditVC.carModel = model;
    carEditVC.addCarSuccess = ^{
        [self.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:carEditVC animated:YES];
}

@end
