//
//  XDNewContactController.m
//  XD业主
//
//  Created by zc on 2017/6/29.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDNewContactController.h"
#import "GSPopoverViewController.h"
#import "XDTypePopCell.h"

@interface XDNewContactController ()<UITableViewDelegate,UITableViewDataSource,CustomAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *nameBackView;
@property (weak, nonatomic) IBOutlet UIView *phoneBackView;
@property (weak, nonatomic) IBOutlet UIView *relateBackView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *relateTextField;


//关系的类型
@property(nonatomic,strong) NSMutableArray * relationPopArray;

//pop的contentView
@property (strong , nonatomic)UITableView *tableView;
//弹出框
@property (strong ,nonatomic)GSPopoverViewController *popView;

@end


@implementation XDNewContactController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新建联系人";
    
    //设置边框
    [self  setBackNewViewLayer];
    
}

- (void)setBackNewViewLayer {
    
    self.nameBackView.layer.borderWidth = 1;
    self.nameBackView.layer.borderColor = BianKuang.CGColor;
    self.nameBackView.layer.cornerRadius = 5;
    [self.nameBackView.layer setMasksToBounds:YES];
    
    
    self.phoneBackView.layer.borderWidth = 1;
    self.phoneBackView.layer.borderColor = BianKuang.CGColor;
    self.phoneBackView.layer.cornerRadius = 5;
    [self.phoneBackView.layer setMasksToBounds:YES];
    
    
    self.relateBackView.layer.borderWidth = 1;
    self.relateBackView.layer.borderColor = BianKuang.CGColor;
    self.relateBackView.layer.cornerRadius = 5;
    [self.relateBackView.layer setMasksToBounds:YES];
    
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    
}


- (IBAction)chooseRelateBtnClicked:(UIButton *)sender {
    
    [self setUpContactPopView:sender];
    
    //一定要这个不要坐标不对
    CGRect rect = [self.relateBackView convertRect:sender.frame toView:self.view];
    rect.origin.y += 64;
    
    [self.popView showPopoverWithRect:rect animation:YES];
    
}

//提交按钮
- (IBAction)newContactCommitBtn:(UIButton *)sender {
    [self.view endEditing:YES];
    //新建联系人
    [self creatNewContact];
    
}

//新建常用联系人
- (void)creatNewContact {
    
    if ([self.relateTextField.text isEqualToString:@""]||[self.phoneTextField.text isEqualToString:@""]||[self.nameTextField.text isEqualToString:@""] ||self.phoneTextField.text.length >11) {
        [self clickToAlertViewTitle:@"提交失败" withDetailTitle:@"请将信息填写完整！" isDelegate:NO];
        return;
    }
    
    [MBProgressHUD showActivityMessageInWindow:nil];
    
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSNumber *userId = loginModel.userInfo.userId;
    NSString *token = loginModel.token;
    
    NSDictionary *dic = @{
                          @"appMobile" : appMobile,
                          @"appTokenInfo":token,
                          @"userId":userId,
                          @"relaionShip":self.relateTextField.text,
                          @"phone":self.phoneTextField.text,
                          @"name" : self.nameTextField.text
                          
                          };
    
    __weak typeof(self) weakSelf = self;
    [[XDAPIManager sharedManager]requestCreateNewLinkManParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        if (error) {
            [weakSelf clickToAlertViewTitle:@"新建失败" withDetailTitle:@"请检查网络情况！" isDelegate:NO];
            [MBProgressHUD hideHUD];
            return ;
        }
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            
            [MBProgressHUD hideHUD];
            [weakSelf clickToAlertViewTitle:@"新建成功" withDetailTitle:@"您的数据已提交成功！" isDelegate:YES];
            
        }else {
            
            [MBProgressHUD hideHUD];
            [weakSelf clickToAlertViewTitle:@"新建失败" withDetailTitle:@"请重新提交！" isDelegate:NO];
        }
    }];
    
    
}

-(void)clickToAlertViewTitle:(NSString *)title withDetailTitle:(NSString *)detailTitle isDelegate:(BOOL)isDelegate
{
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    CustomAlertView *alertView = [[CustomAlertView alloc]initWithFrame:window.bounds WithTitle:title andDetail:detailTitle andBody:nil andCancelTitle:nil andOtherTitle:@"知道了" andIsOneBtn:YES];
    if (isDelegate) {
        alertView.delegate = self;
    }
    [window addSubview:alertView];
    
}
- (void)clickButtonWithTag:(UIButton *)button {
    __weak typeof(self) weakSelf = self;
    if ([weakSelf.delegate respondsToSelector:@selector(XDNewContactControllerWithName:andPhoneNumber:withRelationShip:)]) {
        
        [weakSelf.delegate XDNewContactControllerWithName:weakSelf.nameTextField.text andPhoneNumber:weakSelf.phoneTextField.text withRelationShip:weakSelf.relateTextField.text];
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }
    
}

/**
 *  插入popView
 */
- (void)setUpContactPopView:(UIButton *)sender {
    
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
    return self.relationPopArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XDTypePopCell *cell = [XDTypePopCell cellWithTableView:tableView];
    cell.textLabels.text = self.relationPopArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.relateTextField.text = self.relationPopArray[indexPath.row];
    
    [self.popView dissPopoverViewWithAnimation:YES];
}

- (NSMutableArray *)relationPopArray {
    if (!_relationPopArray) {
        self.relationPopArray = [NSMutableArray arrayWithObjects:@"家属",@"业主", nil];
    }
    return _relationPopArray;
}

@end
