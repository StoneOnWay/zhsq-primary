//
//  XDNewVisitController.m
//  XD业主
//
//  Created by zc on 2017/8/10.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDNewVisitController.h"
#import "XDVisitDetailController.h"
#import "WSDatePickerView.h"
#import "XDVisitModel.h"
#import "GSPopoverViewController.h"
#import "XDTypePopCell.h"

#import "XDResponseModel.h"
#import "XDPersonInfoModel.h"
#import "XDCardPageModel.h"
#import "XDCardInfoModel.h"

@interface XDNewVisitController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *nameTexts;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *effectTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *expireTimeLabel;

@property (strong, nonatomic) NSString *numberTimes;
//弹出框
@property (strong ,nonatomic)GSPopoverViewController *popView;
//pop的contentView
@property (strong , nonatomic)UITableView *tableView;

@end

@implementation XDNewVisitController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"新邀请";
    self.view.backgroundColor = litterBackColor;
    self.numberTimes = @"2";
    self.numberLabel.text = self.numberTimes;
    self.effectTimeLabel.text = [XDUtil getNowTimeStrWithFormatter:VISIT_DATE_FORMATTER];
    self.expireTimeLabel.text = [XDUtil getDateStrWithFormatter:VISIT_DATE_FORMATTER sinceNow:5*60];
}

- (NSString *)convertStr:(NSString *)str {
    return [[[[str stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@":" withString:@""] substringFromIndex:2];
}

- (void)creatNewVisit {
    if (self.nameTexts.text.length == 0) {
        [XDUtil showToast:@"被邀请人名不能为空！"];
        return;
    }
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    if (!loginModel.userInfo.cardNo || !loginModel.userInfo.userId) {
        [XDUtil showToast:@"用户卡片不存在！"];
        return;
    }
    NSDate *effectDate = [NSDate date:self.effectTimeLabel.text WithFormat:VISIT_DATE_FORMATTER];
    NSDate *expireDate = [NSDate date:self.expireTimeLabel.text WithFormat:VISIT_DATE_FORMATTER];
    NSTimeInterval effectInterval = [effectDate timeIntervalSince1970];
    NSTimeInterval expireInterval = [expireDate timeIntervalSince1970];
    if (expireInterval < effectInterval) {
        [XDUtil showToast:@"失效日期不能小于生效日期！"];
        return;
    }
    if (expireInterval - effectInterval > 48 * 60 * 60) {
        [XDUtil showToast:@"失效日期和生效日期间隔不能超过48小时！"];
        return;
    }
    [MBProgressHUD showActivityMessageInWindow:nil];
    
    // 获取被邀请人员唯一标识
    NSDictionary *dic = @{
                          @"cardNo":loginModel.userInfo.cardNo,
                          @"effectTime":[self convertStr:self.effectTimeLabel.text],
                          @"expireTime":[self convertStr:self.expireTimeLabel.text],
                          @"openTimes":self.numberLabel.text.numberValue,
                          @"visitorName":self.nameTexts.text,
                          @"userId":loginModel.userInfo.userId,
                          };
    __weak typeof(self) weakSelf = self;
    [[XDAPIManager sharedManager] requestVisitorQrCodeParameters:dic CompletionHandle:^(NSDictionary *responseObject, NSError *error) {
        if (error) {
            [MBProgressHUD hideHUD];
            [weakSelf clickToAlertViewTitle:@"创建失败" withDetailTitle:@"连接超时，请重试！"];
            return ;
        }
        if ([[responseObject objectForKey:@"code"] longLongValue] == 200) {
            [MBProgressHUD hideHUD];
            NSDictionary *data = responseObject[@"data"];
            NSString *codeUrl = data[@"qrCodeUrl"];
            XDVisitModel *model = [[XDVisitModel alloc] init];
            model.visitorName = self.nameTexts.text;
            model.expireTime = self.expireTimeLabel.text;
            model.effectTime = self.effectTimeLabel.text;
            model.effectNum = self.numberLabel.text.intValue;
            model.codeUrlStr = codeUrl;
            XDVisitDetailController *detail = [[XDVisitDetailController alloc] init];
            detail.visitModel = model;
            detail.isAddNew = YES;
            [weakSelf.navigationController pushViewController:detail animated:YES];
        } else {
            [XDUtil showToast:@"获取开锁二维码失败！"];
            [MBProgressHUD hideHUD];
        }
    }];
}

- (IBAction)newCodeBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];

    [self creatNewVisit];
}

- (IBAction)chooseTimeBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];

    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute CompleteBlock:^(NSDate *startDate) {
        NSString *timeStr = [startDate stringWithFormat:VISIT_DATE_FORMATTER];
        if (sender.tag == 100) {
            self.effectTimeLabel.text = timeStr;
        } else {
            self.expireTimeLabel.text = timeStr;
        }
    }];
    datepicker.doneButtonColor = BianKuang; // 确定按钮的颜色
    [datepicker show];
}

- (void)clickToAlertViewTitle:(NSString *)title withDetailTitle:(NSString *)detailTitle {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    CustomAlertView *alertView = [[CustomAlertView alloc]initWithFrame:window.bounds WithTitle:title andDetail:detailTitle andBody:nil andCancelTitle:nil andOtherTitle:@"知道了" andIsOneBtn:YES];
    [window addSubview:alertView];
}

- (IBAction)effectiveNumber:(UIButton *)sender forEvent:(UIEvent *)event {
    [self setUpPopView:sender];
    //一定要这个不要坐标不对
    CGRect rect = [self.backView convertRect:sender.frame toView:self.view];
    rect.origin.y += 64;
    self.popView.showAnimation = GSPopoverViewShowAnimationBottomTop;
    [self.popView showPopoverWithRect:rect animation:YES];
}

/**
 *  插入popView
 */
- (void)setUpPopView:(UIButton *)sender {
    
    //    CGFloat typeBtnMinX = CGRectGetMinX(sender.frame);
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0 , 0,  sender.width, 120)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 40;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    
    self.popView = [[GSPopoverViewController alloc]initWithShowView:self.tableView];
    self.popView.borderWidth = 1;
    self.popView.borderColor = BianKuang;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDTypePopCell *cell = [XDTypePopCell cellWithTableView:tableView];
    cell.textLabels.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.numberTimes = [NSString stringWithFormat:@"%d",indexPath.row+1];
    self.numberLabel.text = self.numberTimes;
    [self.popView dissPopoverViewWithAnimation:YES];
}

/**
 *  设置tableView每个section的head和foot
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return  nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

#pragma mark - isc
- (void)creatNewVisitIsc {
    if (self.nameTexts.text.length == 0) {
        return;
    }
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    if (!loginModel.userInfo.phoneNo) {
        return;
    }
    [MBProgressHUD showActivityMessageInWindow:nil];
    // 获取被邀请人员唯一标识
    NSDictionary *dic = @{
                          @"certificateType":@990,
                          @"certificateNo":loginModel.userInfo.phoneNo
                          };
    __weak typeof(self) weakSelf = self;
    [[XDAPIManager sharedManager] requestPersonInfoWithCertificateParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        if (error) {
            [MBProgressHUD hideHUD];
            [weakSelf clickToAlertViewTitle:@"创建失败" withDetailTitle:@"连接超时，请重试！"];
            return ;
        }
        XDResponseModel *response = [XDResponseModel mj_objectWithKeyValues:responseObject];
        if ([response.code isEqualToString:@"0"]) {
            XDPersonInfoModel *personInfo = [XDPersonInfoModel mj_objectWithKeyValues:response.data];
            if (personInfo.personId) {
                [weakSelf queryCardNoWithPersonId:personInfo.personId];
            } else {
                [MBProgressHUD hideHUD];
                [weakSelf clickToAlertViewTitle:@"创建失败" withDetailTitle:@"创建二维码失败，请重试！"];
            }
        } else {
            [MBProgressHUD hideHUD];
            [weakSelf clickToAlertViewTitle:@"创建失败" withDetailTitle:@"创建二维码失败，请重试！"];
        }
    }];
}

- (void)queryCardNoWithPersonId:(NSString *)personId {
    NSDictionary *dic = @{
                          @"personIds":personId,
                          @"pageNo":@1,
                          @"pageSize":@1000,
                          };
    __weak typeof(self) weakSelf = self;
    [[XDAPIManager sharedManager] requestCardListParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        if (error) {
            [weakSelf clickToAlertViewTitle:@"获取失败" withDetailTitle:@"获取失败，请检查网络设置！"];
            [MBProgressHUD hideHUD];
            return ;
        }
        XDResponseModel *response = [XDResponseModel mj_objectWithKeyValues:responseObject];
        if ([response.code isEqualToString:@"0"]) {
            [MBProgressHUD hideHUD];
            XDCardPageModel *page = [XDCardPageModel mj_objectWithKeyValues:response.data];
            XDCardInfoModel *cardInfo = page.list[0];
            NSString *cardNo = cardInfo.cardNo;
            XDVisitModel *model = [[XDVisitModel alloc] init];
            model.visitorname = self.nameTexts.text;
            model.deadline = self.expireTimeLabel.text;
            model.openid = cardNo;
            XDVisitDetailController *detail = [[XDVisitDetailController alloc] init];
            detail.visitModel = model;
            detail.isAddNew = YES;
            [weakSelf.navigationController pushViewController:detail animated:YES];
        } else {
            NSLog(@"获取卡片ID失败! msg--%@", response.msg);
            [MBProgressHUD hideHUD];
        }
    }];
}

@end
