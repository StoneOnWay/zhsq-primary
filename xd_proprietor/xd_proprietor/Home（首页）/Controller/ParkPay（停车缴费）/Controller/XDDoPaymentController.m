//
//  XDDoPaymentController.m
//  xd_proprietor
//
//  Created by stone on 28/4/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDDoPaymentController.h"
#import "XDPayMethod.h"
#import "XDPayMethodCell.h"
#import "XDPaymentHeaderView.h"
#import "XDBillModel.h"
#import "XDCarCharterModel.h"

#define TABLEVIEW_TOP_INSET 15
#define PAY_BTN_HEIGHT 50

static int count = 0;

@interface XDDoPaymentController ()
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) XDPaymentHeaderView *header;
@property (nonatomic, assign) NSInteger selectRow;
@end

@implementation XDDoPaymentController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTableview];
    [self addPayBtn];
}

- (void)configTableview {
    [self.tableView registerNib:[UINib nibWithNibName:@"XDPayMethodCell" bundle:NSBundle.mainBundle] forCellReuseIdentifier:@"XDPayMethodCell"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
    self.tableView.sectionHeaderHeight = 40;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.header = [[XDPaymentHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 76)];
    
    if (self.bill) {
        self.header.detailLabel.text = self.bill.billSyscode;
        if (!self.bill.supposeCost) {
            self.bill.supposeCost = @"0";
        }
        self.header.billLabel.text = [NSString stringWithFormat:@"%@元", self.bill.supposeCost];
    } else if (self.charter) {
        self.header.detailLabel.text = @"车辆包期费用";
        self.header.billLabel.text = [NSString stringWithFormat:@"%@元", self.charter.fee];
    }
    
    self.tableView.tableHeaderView = self.header;
}

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
        XDPayMethod *weiXin = [[XDPayMethod alloc] init];
        weiXin.title = @"微信支付";
        weiXin.detailTitle = @"亿万用户的选择，更快更安全";
        weiXin.iconName = @"Wechat";
        weiXin.isRecommend = YES;
        [_dataSource addObject:weiXin];
        XDPayMethod *zhifubao = [[XDPayMethod alloc] init];
        zhifubao.title = @"支付宝";
        zhifubao.detailTitle = @"数亿用户都在用，安全可托付";
        zhifubao.iconName = @"Zhifubao";
        zhifubao.isRecommend = NO;
        [_dataSource addObject:zhifubao];
        XDPayMethod *yunshanfu = [[XDPayMethod alloc] init];
        yunshanfu.title = @"云闪付";
        yunshanfu.detailTitle = @"省钱省心的移动支付管家";
        yunshanfu.iconName = @"Yunshanfu";
        yunshanfu.isRecommend = NO;
        [_dataSource addObject:yunshanfu];
    }
    return _dataSource;
}

- (void)addPayBtn {
    CGFloat width = kScreenWidth - 2 * 15;
    CGFloat originY = kScreenHeight - PAY_BTN_HEIGHT- 5 - 64 - TabbarSafeBottomMargin;
    if ([XDUtil isIPad]) {
        CGFloat navHeight = self.navigationController.navigationBar.frame.size.height;
        originY = kScreenHeight - PAY_BTN_HEIGHT- 5 - 20 - navHeight - TabbarSafeBottomMargin;
    }
    UIButton *payBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    payBtn.frame = CGRectMake(15, originY, width, PAY_BTN_HEIGHT);
    payBtn.backgroundColor = buttonColor;
    [payBtn setTitle:@"立即支付" forState:(UIControlStateNormal)];
    payBtn.layer.cornerRadius = 8;
    payBtn.layer.masksToBounds = YES;
    [payBtn addTarget:self action:@selector(payAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.tableView addSubview:payBtn];
}

- (void)payAction {
    // TODO:第三方支付
    if (self.bill) {
        [self parkPay];
    } else if (self.charter) {
        [self carCharter];
    }
}

// 停车缴费
- (void)parkPay {
    if (!self.bill.billSyscode || !self.bill.supposeCost) {
        [XDUtil showToast:@"账单不存在！"];
        return;
    }
    NSDictionary *dic = @{
                          @"billSyscode":self.bill.billSyscode,
                          @"actualCost":[NSString stringWithFormat:@"%@", self.bill.supposeCost]
                          };
    [MBProgressHUD showActivityMessageInWindow:nil];
    [[XDAPIManager sharedManager] requestPayReceiptParameters:dic CompletionHandle:^(NSDictionary *responseObject, NSError *error) {
        [MBProgressHUD hideHUD];
        if (error) {
            [XDUtil showToast:@"支付失败！"];
        } else {
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                [XDUtil showToast:@"支付成功！"];
                if (self.hasPaidBlock) {
                    self.hasPaidBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [XDUtil showToast:@"支付失败！"];
            }
        }
    }];
}

// 车辆包期
- (void)carCharter {
    [MBProgressHUD showActivityMessageInWindow:nil];
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    if (!loginModel.userInfo.parkSyscode) {
        // 获取停车库唯一标识
        [[XDAPIManager sharedManager] requestGetParkListWithParameters:nil CompletionHandle:^(id responseObject, NSError *error) {
            if (error) {
                [MBProgressHUD hideHUD];
                [XDUtil showToast:@"车辆充值失败-停车库信息异常！"];
                return;
            }
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                NSArray *dataArr = responseObject[@"data"];
                NSDictionary *parkInfo = dataArr.firstObject;
                loginModel.userInfo.parkSyscode = parkInfo[@"parkIndexCode"];
                [XDReadLoginModelTool save:loginModel];
                [self carCharterPay];
            } else {
                [MBProgressHUD hideHUD];
                [XDUtil showToast:@"车辆充值失败-停车库信息异常！"];
                return;
            }
        }];
    } else {
        [self carCharterPay];
    }
}

- (void)carCharterPay {
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    if (!loginModel.userInfo.parkSyscode) {
        [MBProgressHUD hideHUD];
        [XDUtil showToast:@"车辆充值失败-停车库信息异常！"];
        return;
    }
    NSDictionary *dic = @{
                          @"parkSyscode":loginModel.userInfo.parkSyscode,
                          @"plateNo":self.charter.plateNo,
                          @"startTime":self.charter.startTime,
                          @"endTime":self.charter.endTime,
                          @"fee":self.charter.fee
                          };
    [[XDAPIManager sharedManager] requestCarCharterWithParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        [MBProgressHUD hideHUD];
        if (error) {
            [XDUtil showToast:@"车辆充值失败！"];
        } else {
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                [XDUtil showToast:@"车辆充值成功！"];
                if (self.hasPaidBlock) {
                    self.hasPaidBlock();
                }
                [self.navigationController popViewControllerAnimated:YES];
            } else if ([responseObject[@"code"] isEqualToString:@"0x00072202"]) {
                // 停车库标识错误
                if (count > 3) {
                    [XDUtil showToast:responseObject[@"msg"]];
                    return;
                }
                loginModel.userInfo.parkSyscode = nil;
                [XDReadLoginModelTool save:loginModel];
                count++;
                [self carCharter];
            } else {
                [XDUtil showToast:responseObject[@"msg"]];
            }
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDPayMethodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XDPayMethodCell" forIndexPath:indexPath];
    [cell setContentWithPayModel:self.dataSource[indexPath.row]];
    if (indexPath.row == self.selectRow) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    if (!header) {
        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"UITableViewHeaderFooterView"];
    }
    header.frame = CGRectMake(0, 0, kScreenWidth, 40);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth, 40)];
    label.text = @"选择支付方式";
    label.font = [UIFont boldSystemFontOfSize:15];
    [header addSubview:label];
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectRow = indexPath.row;
    [tableView reloadData];
}

@end
