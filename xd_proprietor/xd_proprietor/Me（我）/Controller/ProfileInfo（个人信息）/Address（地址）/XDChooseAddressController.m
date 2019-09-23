//
//  XDChooseAddressController.m
//  XD业主
//
//  Created by zc on 2017/6/29.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDChooseAddressController.h"
#import "XDAddressFootView.h"
#import "AddressCell.h"
#import "XDNewAddressController.h"
#import "XDAddressModel.h"


@interface XDChooseAddressController ()<XDNewAddressControllerDelegate>

//联系人数组
@property (nonatomic ,strong)NSMutableArray *addressArray;

//当前选择的哪行
@property (nonatomic, assign)NSInteger selectedRow;

@end


@implementation XDChooseAddressController


- (NSMutableArray *)addressArray {
    
    if (!_addressArray) {
        self.addressArray = [NSMutableArray array];
    }
    return _addressArray;
    
}

- (instancetype)initWithStyle:(UITableViewStyle)style{
    self=[super initWithStyle:style];
    if (self) {
        self=[super initWithStyle:UITableViewStyleGrouped];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //设置导航栏
    [self setChooseAddressNavi];
    
    //获取更多地址
    [self loadMoreAddress];
}

//获取更多地址
- (void)loadMoreAddress {
    
    //获取房屋地址
    [MBProgressHUD showActivityMessageInWindow:nil];
    
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSNumber *userId = loginModel.userInfo.userId;
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    
    NSDictionary *dic = @{@"userId":userId,
                          @"appTokenInfo":token,
                          @"appMobile":appMobile
                          };
    
    
    __weak typeof(self) weakSelf = self;
    [[XDAPIManager sharedManager] requestHouseOfAddressWithParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        if (error) {
            [MBProgressHUD hideHUD];
            return ;
        }
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"] ) {
            
            NSArray *addressEntityList = responseObject[@"data"][@"addressEntityList"];
            for (int i = 0; i<addressEntityList.count; i++) {
     
                XDAddressModel *model = [XDAddressModel mj_objectWithKeyValues:addressEntityList[i]];
                [weakSelf.addressArray addObject:model];
                
            }
            [weakSelf.tableView reloadData];
            [MBProgressHUD hideHUD];
        }else {
            [MBProgressHUD hideHUD];
            
        }
        
        
        
    }];
    
}



/**
 *  设置导航栏
 */
-(void)setChooseAddressNavi{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font = CFont(19, 17);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"选择常用地址";
    self.navigationItem.titleView = titleLabel;
    
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.addressArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddressCell *cell = [AddressCell cellWithTableView:tableView];
    XDAddressModel *model = self.addressArray[indexPath.row];
    cell.AddressLab.text = model.name;
    
    if (indexPath.row == self.addressArray.count -1) {
        cell.lineView.hidden = YES;
    }else {
        cell.lineView.hidden = NO;
        
    }
    if (self.selectedRow == indexPath.row) {
        [cell.choiceBtn setBackgroundImage:[UIImage imageNamed:@"tsxq_dian"] forState:UIControlStateNormal];
        
    }else {
        [cell.choiceBtn setBackgroundImage:[UIImage imageNamed:@"tsxq_dian_hui"] forState:UIControlStateNormal];
        
    }
    
    __weak typeof(self) weakSelf = self;
    cell.selectAddressBtn = ^{
        
        weakSelf.selectedRow = indexPath.row;
        [weakSelf.tableView reloadData];
        
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddressCell *cell = (AddressCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(XDChooseAddressControllerWithName:)]) {
        [self.delegate XDChooseAddressControllerWithName:cell.AddressLab.text ];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    
    XDAddressFootView * footerView=[XDAddressFootView footerViewWithTableView:tableView];
    
    XDNewAddressController *NewVC= [[XDNewAddressController alloc] init];
    NewVC.delegate = self;
    __weak typeof(self) weakSelf = self;
    footerView.btnClicked = ^(NSInteger index){
        
        if (index == 101) {
            
            [weakSelf.navigationController pushViewController:NewVC animated:YES];
            
        }else {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_selectedRow inSection:section];
            AddressCell *cell = (AddressCell *)[tableView cellForRowAtIndexPath:indexPath];
            if ([weakSelf.delegate respondsToSelector:@selector(XDChooseAddressControllerWithName:)]) {
                
                [weakSelf.delegate XDChooseAddressControllerWithName:cell.AddressLab.text ];
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }
        
        
    };
    
    return footerView;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    return 165;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.001;
}

//XDNewAddressControllerDelegate
- (void)XDNewAddressControllerWithLouPan:(NSString *)louPan withLouDong:(NSString *)louDong withDanYuan:(NSString *)danYuan withFangHao:(NSString *)fangHao {
    
    NSLog(@"---------> %@%@%@%@",louPan,louDong,danYuan,fangHao);

    XDAddressModel *model = [[XDAddressModel alloc] init];
    model.name = [NSString stringWithFormat:@"%@%@%@%@",louPan,louDong,danYuan,fangHao];
    [self.addressArray addObject:model];
    [self.tableView reloadData];
}

@end
