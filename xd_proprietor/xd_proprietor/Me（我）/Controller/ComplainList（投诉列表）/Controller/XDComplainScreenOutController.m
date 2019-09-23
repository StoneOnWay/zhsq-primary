//
//  XDComplainScreenOutController.m
//  XD业主
//
//  Created by zc on 2017/6/22.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDComplainScreenOutController.h"
#import "WSDatePickerView.h"
#import "GSPopoverViewController.h"
#import "XDTypePopCell.h"


@interface XDComplainScreenOutController ()<UITableViewDelegate,UITableViewDataSource>
//开始时间的背景
@property (weak, nonatomic) IBOutlet UIView *startBackView;
//开始时间的label
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
//结束时间的背景
@property (weak, nonatomic) IBOutlet UIView *endBackView;
//结束时间的label
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
//类型的view
@property (weak, nonatomic) IBOutlet UIView *typeBackView;
//类型的label
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

//维修类型Type数据
@property(nonatomic,strong) NSMutableArray * typePopArray;

//pop的contentView
@property (strong , nonatomic)UITableView *tableView;
//弹出框
@property (strong ,nonatomic)GSPopoverViewController *popView;

//选择的工单类型id
@property (assign , nonatomic)NSInteger complainType;
@end

@implementation XDComplainScreenOutController

- (NSMutableArray *)typePopArray {
    if (!_typePopArray) {
        self.typePopArray = [NSMutableArray array];
    }
    return _typePopArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backColor;
    self.navigationItem.title = @"投诉刷选";
    //设置子控件的参数
    [self setSubviewsParam];
    
    //加载投诉类别
    [self loadComplainType];
    
}

//加载工单类别
- (void)loadComplainType {
    
    //我的报修工单列表
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showActivityMessageInWindow:nil];
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    
    NSDictionary *dic = @{@"appTokenInfo":token,
                          @"appMobile":appMobile,
                          };
    
    [[XDAPIManager sharedManager]requestWarrantyScreenTypeParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        if (error) {
            [MBProgressHUD hideHUD];
            return ;
        }
        if ([responseObject[@"resultCode"] isEqualToString:@"0"] ) {
            
            [weakSelf.typePopArray addObjectsFromArray:responseObject[@"data"]];
            if (weakSelf.typePopArray.count != 0) {
                weakSelf.typeLabel.text = weakSelf.typePopArray.firstObject[@"name"];
                weakSelf.complainType = [weakSelf.typePopArray.firstObject[@"id"] integerValue];
            }
            
            [weakSelf.tableView reloadData];
            [MBProgressHUD hideHUD];
            
        }else {
            
            [MBProgressHUD hideHUD];
        }
        
        
        
        
    }];
    
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
    
    self.typeBackView.layer.borderColor = [RGB(201, 170, 103) CGColor];
    self.typeBackView.layer.cornerRadius = 5;
    self.typeBackView.layer.borderWidth = 1.0;
    [self.typeBackView.layer setMasksToBounds:YES];
    
    
    
}

#pragma mark -- 按钮响应事件
//开始按钮
- (IBAction)startBtnClicked:(id)sender {
     __weak typeof(self) weakSelf = self;
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute CompleteBlock:^(NSDate *startDate) {
      
        weakSelf.startLabel.text = [startDate stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];;
        
    }];
    datepicker.doneButtonColor = BianKuang;//确定按钮的颜色
    [datepicker show];
    
}
//结束按钮响应
- (IBAction)endBtnClicked:(id)sender {
    __weak typeof(self) weakSelf = self;
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute CompleteBlock:^(NSDate *startDate) {
      
        weakSelf.endLabel.text = [startDate stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];;
        
    }];
    datepicker.doneButtonColor = BianKuang;//确定按钮的颜色
    [datepicker show];
    
}
- (IBAction)typeBtnClicked:(UIButton *)sender {
    
    [self setUpScreenPopView:sender];
    //一定要这个不要坐标不对
    
    CGRect rect = [self.typeBackView convertRect:sender.frame toView:self.view];
    rect.origin.y += 64;
    [self.popView showPopoverWithRect:rect animation:YES];
    
}


//筛选按钮
- (IBAction)screenOutBtn:(id)sender {
    
    if ([self.startLabel.text isEqualToString:@"开始时间"]||[self.endLabel.text isEqualToString:@"结束时间"]||self.typeLabel.text.length == 0) {
        [self clickToAlertViewTitle:@"信息不完整" withDetailTitle:@"请输入完整的信息"];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(XDComplainScreenOutControllerWithStartTime:endTime:complainType:)]) {
        [self.delegate XDComplainScreenOutControllerWithStartTime:self.startLabel.text endTime:self.endLabel.text complainType:self.complainType];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)clickToAlertViewTitle:(NSString *)title withDetailTitle:(NSString *)detailTitle
{
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    CustomAlertView *alertView = [[CustomAlertView alloc]initWithFrame:window.bounds WithTitle:title andDetail:detailTitle andBody:nil andCancelTitle:nil andOtherTitle:@"知道了" andIsOneBtn:YES];
    [window addSubview:alertView];
    
}

/**
 *  插入popView
 */
- (void)setUpScreenPopView:(UIButton *)sender {
    
    //    CGFloat typeBtnMinX = CGRectGetMinX(sender.frame);
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0 , 0,  sender.width, 120)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.rowHeight = 40;
    self.popView = [[GSPopoverViewController alloc]initWithShowView:self.tableView];
    self.popView.borderWidth = 1;
    self.popView.borderColor = BianKuang;
    
    
}

#pragma mark -- tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.typePopArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XDTypePopCell *cell = [XDTypePopCell cellWithTableView:tableView];
    cell.textLabels.text = _typePopArray[indexPath.row][@"name"];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.typeLabel.text = self.typePopArray[indexPath.row][@"name"];
    self.complainType = [self.typePopArray[indexPath.row][@"id"] integerValue];
    [self.popView dissPopoverViewWithAnimation:YES];
}



@end
