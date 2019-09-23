//
//  XDNewAddressController.m
//  XD业主
//
//  Created by zc on 2017/6/29.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDNewAddressController.h"
#import "GSPopoverViewController.h"
#import "XDTypePopCell.h"


@interface XDNewAddressController ()<UITableViewDelegate,UITableViewDataSource,CustomAlertViewDelegate>

{
    NSInteger _selectPop;//标记点击哪个按钮弹出pop
    
    //因为要根据楼盘的ID查出下一级的内容  以此类推
    NSString *_projectId;//楼盘id
    NSString *_buildingId;//楼栋id
    NSString *_cellId;//楼盘id
}

@property (weak, nonatomic) IBOutlet UIView *PanBackView;
@property (weak, nonatomic) IBOutlet UIView *DongBackView;
@property (weak, nonatomic) IBOutlet UIView *YuanBackView;
@property (weak, nonatomic) IBOutlet UIView *HaoBackView;
@property (weak, nonatomic) IBOutlet UITextField *PanTextField;
@property (weak, nonatomic) IBOutlet UITextField *DongTextField;
@property (weak, nonatomic) IBOutlet UITextField *YuanTextField;
@property (weak, nonatomic) IBOutlet UITextField *HaoTextField;


//楼盘的类型
@property(nonatomic,strong) NSMutableArray * panPopArray;
//楼栋的类型
@property(nonatomic,strong) NSMutableArray * dongPopArray;
//单元的类型
@property(nonatomic,strong) NSMutableArray * yuanPopArray;
//房号的类型
@property(nonatomic,strong) NSMutableArray * haoPopArray;

//pop的contentView
@property (strong , nonatomic)UITableView *tableView;
//弹出框
@property (strong ,nonatomic)GSPopoverViewController *popView;


@end

@implementation XDNewAddressController

- (NSMutableArray *)panPopArray {
    if (!_panPopArray) {
        self.panPopArray = [NSMutableArray array];
    }
    return _panPopArray;
}

- (NSMutableArray *)dongPopArray {
    if (!_dongPopArray) {
        self.dongPopArray = [NSMutableArray array];
    }
    return _dongPopArray;
}

- (NSMutableArray *)yuanPopArray {
    if (!_yuanPopArray) {
        self.yuanPopArray = [NSMutableArray array];
    }
    return _yuanPopArray;
}

- (NSMutableArray *)haoPopArray {
    if (!_haoPopArray) {
        self.haoPopArray = [NSMutableArray arrayWithObjects:@"1101",@"1102", nil];
    }
    return _haoPopArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = backColor;

    //设置圆角
    [self  setBackAddressViewLayer];
    
    //导航栏
    [self setNewAddressNavi];

}


/**
 *  设置导航栏
 */
-(void)setNewAddressNavi{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font = CFont(19, 17);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"新建常用地址";
    self.navigationItem.titleView = titleLabel;
}


- (void)setBackAddressViewLayer {
    
    self.PanBackView.layer.borderWidth = 1;
    self.PanBackView.layer.borderColor = BianKuang.CGColor;
    self.PanBackView.layer.cornerRadius = 5;
    [self.PanBackView.layer setMasksToBounds:YES];
    
    
    self.DongBackView.layer.borderWidth = 1;
    self.DongBackView.layer.borderColor = BianKuang.CGColor;
    self.DongBackView.layer.cornerRadius = 5;
    [self.DongBackView.layer setMasksToBounds:YES];
    
    
    self.YuanBackView.layer.borderWidth = 1;
    self.YuanBackView.layer.borderColor = BianKuang.CGColor;
    self.YuanBackView.layer.cornerRadius = 5;
    [self.YuanBackView.layer setMasksToBounds:YES];
    
    self.HaoBackView.layer.borderWidth = 1;
    self.HaoBackView.layer.borderColor = BianKuang.CGColor;
    self.HaoBackView.layer.cornerRadius = 5;
    [self.HaoBackView.layer setMasksToBounds:YES];
    
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self.view endEditing:YES];

}
- (IBAction)panBtnClicked:(UIButton *)sender {
    
//    //将判断依据置空 为了就是防止选择完成之后继续更改上面的信息 这样是为了有序的进行选择
//    _projectId = nil;
//    _buildingId = nil;
//    _cellId = nil;
//    self.DongTextField.text = @"";
//    self.YuanTextField.text = @"";
//    self.HaoTextField.text = @"";
//    [self.panPopArray removeAllObjects];
    
    _selectPop = 0;
    [self setUpAddressPopView:sender];
    //一定要这个不要坐标不对
    CGRect rect = [self.PanBackView convertRect:sender.frame toView:self.view];
    rect.origin.y += 64;
    
    //获取楼盘
    [self getUserLouPanInfo:rect];
    
}

/**
 *  //获取楼盘
 */
- (void)getUserLouPanInfo:(CGRect)rect {
    
    [MBProgressHUD showActivityMessageInWindow:nil];
    
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSNumber *userId = loginModel.userInfo.userId;
    NSString *token = loginModel.token;
    
    NSDictionary *dic = @{
                          @"appMobile" : appMobile,
                          @"appTokenInfo":token,
                          @"ownerId":userId,
                          
                          };
    
    __weak typeof(self) weakSelf = self;
    [[XDAPIManager sharedManager]requestQueryProjectsParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        if (error) {
            [MBProgressHUD hideHUD];
            return ;
        }
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"] ) {
            //获取数据 懒得建模
            NSArray *dicArray = responseObject[@"data"];
            weakSelf.panPopArray = [NSMutableArray arrayWithArray:dicArray];
            
            [weakSelf.tableView reloadData];
            [weakSelf.popView showPopoverWithRect:rect animation:YES];
            [MBProgressHUD hideHUD];
            
        }else {
            [MBProgressHUD hideHUD];
        }
        
    }];
    
}


- (IBAction)dongBtnClicked:(UIButton *)sender {
    
//    //将判断依据置空 为了就是防止选择完成之后继续更改上面的信息 这样是为了有序的进行选择
//    _buildingId = nil;
//    _cellId = nil;
//    self.YuanTextField.text = @"";
//    self.HaoTextField.text = @"";
//    [self.dongPopArray removeAllObjects];
    
    //当还没有楼盘ID时是不能选择下面的信息的
    if (_projectId == nil) {
        return;
    }
    
    _selectPop = 1;
    [self setUpAddressPopView:sender];
    //一定要这个不要坐标不对
    CGRect rect = [self.DongBackView convertRect:sender.frame toView:self.view];
    rect.origin.y += 64;
    
    //获取楼栋
    [self getUserLouDongInfo:rect];
    
}

/**
 *  //获取楼栋
 */
- (void)getUserLouDongInfo:(CGRect)rect {
    
    [MBProgressHUD showActivityMessageInWindow:nil];
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSNumber *userId = loginModel.userInfo.userId;
    NSString *token = loginModel.token;
    
    NSDictionary *dic = @{
                          @"appMobile" : appMobile,
                          @"appTokenInfo":token,
                          @"ownerId":userId,
                          @"projectId":_projectId
                          };
    
        __weak typeof(self) weakSelf = self;
    [[XDAPIManager sharedManager]requestQueryBuildingsParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        if (error) {
            [MBProgressHUD hideHUD];
            return ;
        }
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"] ) {
            //获取数据 懒得建模
            NSArray *dicArray = responseObject[@"data"];
            weakSelf.dongPopArray = [NSMutableArray arrayWithArray:dicArray];
            
            [weakSelf.tableView reloadData];
            [weakSelf.popView showPopoverWithRect:rect animation:YES];
            [MBProgressHUD hideHUD];
            
        }else {
            [MBProgressHUD hideHUD];
        }
        
    }];
    
}

- (IBAction)yuanBtnClicked:(UIButton *)sender {
    
//    //将判断依据置空 为了就是防止选择完成之后继续更改上面的信息 这样是为了有序的进行选择
//    _cellId = nil;
//    self.HaoTextField.text = @"";
//    [self.yuanPopArray removeAllObjects];
    
    //当还没有楼栋ID时是不能选择下面的信息的
    if (_buildingId == nil) {
        return;
    }
    
    _selectPop = 2;
    [self setUpAddressPopView:sender];
    //一定要这个不要坐标不对
    CGRect rect = [self.YuanBackView convertRect:sender.frame toView:self.view];
    rect.origin.y += 64;
    
    //获取单元
    [self getUserDanYuanInfo:rect];
}

/**
 *  //获取单元
 */
- (void)getUserDanYuanInfo:(CGRect)rect {
    
    [MBProgressHUD showActivityMessageInWindow:nil];
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSNumber *userId = loginModel.userInfo.userId;
    NSString *token = loginModel.token;
    
    NSDictionary *dic = @{
                          @"appMobile" : appMobile,
                          @"appTokenInfo":token,
                          @"ownerId":userId,
                          @"buildingId" :_buildingId
                          };
    
        __weak typeof(self) weakSelf = self;
    [[XDAPIManager sharedManager]requesQueryCellsParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        if (error) {
            [MBProgressHUD hideHUD];
            return ;
        }
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"] ) {
            
            //获取数据 懒得建模
            NSArray *dicArray = responseObject[@"data"];
            weakSelf.yuanPopArray = [NSMutableArray arrayWithArray:dicArray];
            
            [weakSelf.tableView reloadData];
            [weakSelf.popView showPopoverWithRect:rect animation:YES];
            [MBProgressHUD hideHUD];
            
        }else {
            [MBProgressHUD hideHUD];
        }
        
    }];
    
}


- (IBAction)haoBtnClicked:(UIButton *)sender {
    
//    [self.haoPopArray removeAllObjects];
    
    //当还没有单元ID时是不能选择下面的信息的
    if (_cellId == nil) {
        return;
    }
    _selectPop = 3;
    [self setUpAddressPopView:sender];
    //一定要这个不要坐标不对
    CGRect rect = [self.HaoBackView convertRect:sender.frame toView:self.view];
    rect.origin.y += 64;
    
    
    //获取房屋号
    [self getUserFangWuHaoInfo:rect];
}

/**
 *  //获取房屋号
 */
- (void)getUserFangWuHaoInfo:(CGRect)rect {
    
    [MBProgressHUD showActivityMessageInWindow:nil];
    
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSNumber *userId = loginModel.userInfo.userId;
    NSString *token = loginModel.token;
    
    NSDictionary *dic = @{
                          @"appMobile" : appMobile,
                          @"appTokenInfo":token,
                          @"ownerId":userId,
                          @"cellId" : _cellId
                          };
    
        __weak typeof(self) weakSelf = self;
    [[XDAPIManager sharedManager]requestQueryRoomsParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        if (error) {
            [MBProgressHUD hideHUD];
            return ;
        }
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"] ) {
            
            //获取数据 懒得建模
            NSArray *dicArray = responseObject[@"data"];
            weakSelf.haoPopArray = [NSMutableArray arrayWithArray:dicArray];

            [weakSelf.tableView reloadData];
            [weakSelf.popView showPopoverWithRect:rect animation:YES];
            [MBProgressHUD hideHUD];
        }else {
            [MBProgressHUD hideHUD];
        }
        
    }];
    
}

#pragma mark -- tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (_selectPop) {
        case 0:
            return self.panPopArray.count;
            break;
        case 1:
            return self.dongPopArray.count;
            break;
        case 2:
            return self.yuanPopArray.count;
            break;
        default:
            return self.haoPopArray.count;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    XDTypePopCell *cell = [XDTypePopCell cellWithTableView:tableView];
    switch (_selectPop) {
        case 0:
            cell.textLabels.text = self.panPopArray[indexPath.row][@"name"];
            break;
        case 1:
            cell.textLabels.text = self.dongPopArray[indexPath.row][@"name"];
            break;
        case 2:
            cell.textLabels.text = self.yuanPopArray[indexPath.row][@"name"];
            break;
        default:
            cell.textLabels.text = self.haoPopArray[indexPath.row][@"name"];
            break;
    }
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_selectPop) {
        case 0:
            if (![self.PanTextField.text isEqualToString:self.panPopArray[indexPath.row][@"name"] ]) {
                //将判断依据置空 为了就是防止选择完成之后继续更改上面的信息 这样是为了有序的进行选择
                _projectId = nil;
                _buildingId = nil;
                _cellId = nil;
                self.DongTextField.text = @"";
                self.YuanTextField.text = @"";
                self.HaoTextField.text = @"";
                
                self.PanTextField.text = self.panPopArray[indexPath.row][@"name"];
                _projectId = self.panPopArray[indexPath.row][@"id"];
            }
            
            break;
        case 1:
            if (![self.DongTextField.text isEqualToString:self.dongPopArray[indexPath.row][@"name"] ]) {
                //将判断依据置空 为了就是防止选择完成之后继续更改上面的信息 这样是为了有序的进行选择
                _buildingId = nil;
                _cellId = nil;
                self.YuanTextField.text = @"";
                self.HaoTextField.text = @"";
                
                self.DongTextField.text = self.dongPopArray[indexPath.row][@"name"];
                _buildingId = self.dongPopArray[indexPath.row][@"id"];
            }
            
            break;
        case 2:
            
            if (![self.YuanTextField.text isEqualToString:self.yuanPopArray[indexPath.row][@"name"] ]) {
                //将判断依据置空 为了就是防止选择完成之后继续更改上面的信息 这样是为了有序的进行选择
                _cellId = nil;
                self.HaoTextField.text = @"";
                
                self.YuanTextField.text = self.yuanPopArray[indexPath.row][@"name"];
                _cellId = self.yuanPopArray[indexPath.row][@"id"];
            }
            
            break;
        default:
            self.HaoTextField.text = self.haoPopArray[indexPath.row][@"name"];
            break;
    }
    
    [self.popView dissPopoverViewWithAnimation:YES];
}



/**
 *  插入popView
 */
- (void)setUpAddressPopView:(UIButton *)sender {
    
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


//确定按钮
- (IBAction)ensureBtnClicked:(UIButton *)sender {
    //新建常用地址
    
    [self creatNewAddress];

    
}

//新建常用地址
- (void)creatNewAddress{
    
    if ([self.PanTextField.text isEqualToString:@""]||[self.DongTextField.text isEqualToString:@""]||[self.YuanTextField.text isEqualToString:@""]||[self.HaoTextField.text isEqualToString:@""]) {
        
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
                          @"ownerId":userId,
                          @"houses":self.PanTextField.text,
                          @"building":self.DongTextField.text,
                          @"cells" : self.YuanTextField.text,
                          @"roomNumber" : self.HaoTextField.text
                          
                          };
    
    __weak typeof(self) weakSelf = self;
    [[XDAPIManager sharedManager]requestCreateCommonAddressParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        
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
    if ([weakSelf.delegate respondsToSelector:@selector(XDNewAddressControllerWithLouPan:withLouDong:withDanYuan:withFangHao:)]) {
        [weakSelf.delegate XDNewAddressControllerWithLouPan:weakSelf.PanTextField.text withLouDong:weakSelf.DongTextField.text withDanYuan:weakSelf.YuanTextField.text withFangHao:weakSelf.HaoTextField.text];
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }
    
}

@end
