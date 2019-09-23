//
//  XDPayforScreenController.m
//  XD业主
//
//  Created by zc on 2017/11/14.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDPayforScreenController.h"
#import "WSDatePickerView.h"

@interface XDPayforScreenController ()
//开始时间的背景
@property (weak, nonatomic) IBOutlet UIView *startBackView;
//结束时间的背景
@property (weak, nonatomic) IBOutlet UIView *endBackView;
@property (weak, nonatomic) IBOutlet UILabel *payTime;
@property (weak, nonatomic) IBOutlet UILabel *lastTime;

@end

@implementation XDPayforScreenController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = backColor;
    self.navigationItem.title = @"工单刷选";
    //设置子控件的参数
    [self setSubviewsParam];
}
//设置子控件的参数
- (void)setSubviewsParam {
    
    //设置轮廓颜色
    self.startBackView.layer.borderColor = [RGB(201, 170, 103) CGColor];
    self.startBackView.layer.cornerRadius = 5;
    self.startBackView.layer.borderWidth = 1.0;
    [self.startBackView.layer setMasksToBounds:YES];
    
    self.endBackView.layer.borderColor = [RGB(201, 170, 103) CGColor];
    self.endBackView.layer.cornerRadius = 5;
    self.endBackView.layer.borderWidth = 1.0;
    [self.endBackView.layer setMasksToBounds:YES];
   
}

- (IBAction)payTimeAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute CompleteBlock:^(NSDate *startDate) {
        
        weakSelf.payTime.text = [startDate stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];;
        
    }];
    
    datepicker.doneButtonColor = BianKuang;//确定按钮的颜色
    [datepicker show];
}

- (IBAction)lastTimeAction:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute CompleteBlock:^(NSDate *startDate) {
        
        weakSelf.lastTime.text = [startDate stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];;
        
    }];
    
    datepicker.doneButtonColor = BianKuang;//确定按钮的颜色
    [datepicker show];
}

- (IBAction)screenBtnAction:(UIButton *)sender {
    
    if ([self.payTime.text isEqualToString:@"支付时间"]||[self.lastTime.text isEqualToString:@"最后期限"]) {
        [self clickToAlertViewTitle:@"信息不完整" withDetailTitle:@"请输入完整的信息"];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(XDPayforScreenControllerWithStartTime:endTime:)]) {
        [self.delegate XDPayforScreenControllerWithStartTime:self.payTime.text endTime:self.lastTime.text];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)clickToAlertViewTitle:(NSString *)title withDetailTitle:(NSString *)detailTitle
{
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    CustomAlertView *alertView = [[CustomAlertView alloc]initWithFrame:window.bounds WithTitle:title andDetail:detailTitle andBody:nil andCancelTitle:nil andOtherTitle:@"知道了" andIsOneBtn:YES];
    [window addSubview:alertView];
    
}

@end
