//
//  XDChooseContactController.m
//  XD业主
//
//  Created by zc on 2017/6/20.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDChooseContactController.h"
#import "ContactCell.h"
#import "XDContactFootView.h"
#import "XDNewContactController.h"
#import "LJContactManager.h"
#import "XDWarrantyViewController.h"
#import "XDContactModel.h"
#import "MJExtension.h"
#import "XDMyInfoEditController.h"

@interface XDChooseContactController ()<XDNewContactControllerDelegate>

//当前选择的哪行
@property (nonatomic, assign)NSInteger selectedRow;

//联系人数组
@property (nonatomic ,strong)NSMutableArray *contactArray;


@end

@implementation XDChooseContactController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择联系人";
    
    _selectedRow = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self loadMoreContact];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

//获取更多的联系人
- (void)loadMoreContact {
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
    [[XDAPIManager sharedManager]requestLinkManParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        if (error) {
            [MBProgressHUD hideHUD];
            return ;
        }
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            NSArray *dicArray = responseObject[@"data"][@"linkmanEntityList"];
            for (int i = 0; i<dicArray.count; i++) {
                XDContactModel *model = [XDContactModel mj_objectWithKeyValues:dicArray[i]];
                [weakSelf.contactArray addObject:model];
            }
            [MBProgressHUD hideHUD];
            [weakSelf.tableView reloadData];
        }else {
            [MBProgressHUD hideHUD];
        }
    }];
}

- (instancetype)initWithStyle:(UITableViewStyle)style{
    self=[super initWithStyle:style];
    if (self) {
        self=[super initWithStyle:UITableViewStyleGrouped];
    }
    return self;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contactArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ContactCell *cell = [ContactCell cellWithTableView:tableView];
    XDContactModel *model = self.contactArray[indexPath.row];
    cell.nameLab.text = model.linkmanName;
    cell.phoneLab.text = model.linkmanMobileNo;
    if ([model.relationship isEqualToString:@"家属"]) {
        cell.iconImage.image = [UIImage imageNamed:@"xzlxr_iocn_jiashu"];
    }else {
        cell.iconImage.image = [UIImage imageNamed:@"xzlxr_icon_yezhu"];
    }
    if (self.selectedRow == indexPath.row) {
        [cell.chooseBtn setBackgroundImage:[UIImage imageNamed:@"xzlxr_btn_p"] forState:UIControlStateNormal];
    }else {
        [cell.chooseBtn setBackgroundImage:[UIImage imageNamed:@"xzlxr_btn_n"] forState:UIControlStateNormal];
    }
    if (indexPath.row == self.contactArray.count -1) {
        cell.lineView.hidden = YES;
    }else {
        cell.lineView.hidden = NO;
    }
    __weak typeof(self) weakSelf = self;
    cell.selectContactBtn = ^{
        weakSelf.selectedRow = indexPath.row;
        [weakSelf.tableView reloadData];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactCell *cell = (ContactCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([self.delegate respondsToSelector:@selector(XDChooseContactControllerWithName:andPhoneNumb:)]) {
        [self.delegate XDChooseContactControllerWithName:cell.nameLab.text andPhoneNumb:cell.phoneLab.text ];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    XDContactFootView * footerView=[XDContactFootView footerViewWithTableView:tableView];
    XDNewContactController *NewVC= [[XDNewContactController alloc] init];
    NewVC.delegate = self;
    __weak typeof(self) weakSelf = self;
    footerView.btnClicked = ^(NSInteger index){
        if (index == 1) {
            [weakSelf.navigationController pushViewController:NewVC animated:YES];
        }else if (index == 2) {
            BOOL isAllow = [[KyIsOpenPrivate sharedManager] isAllowPrivacyContact];
            if (!isAllow) {
                return;
            }
            [[LJContactManager sharedInstance] selectContactAtController:self complection:^(NSString *name, NSString *phone) {
                if ([weakSelf.delegate respondsToSelector:@selector(XDChooseContactControllerWithName:andPhoneNumb:)]) {
                    [weakSelf.delegate XDChooseContactControllerWithName:name andPhoneNumb:phone ];
                    [weakSelf popToWhichViewVC];
                }
            }];
        }else {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_selectedRow inSection:section];
            ContactCell *cell = (ContactCell *)[tableView cellForRowAtIndexPath:indexPath];
            if ([weakSelf.delegate respondsToSelector:@selector(XDChooseContactControllerWithName:andPhoneNumb:)]) {
                [weakSelf.delegate XDChooseContactControllerWithName:cell.nameLab.text andPhoneNumb:cell.phoneLab.text ];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }
    };
    return footerView;
}

- (void)popToWhichViewVC {
    NSArray *temArray = self.navigationController.viewControllers;
    for(UIViewController *temVC in temArray) {
        if ([temVC isKindOfClass:[XDWarrantyViewController class]] ||[temVC isKindOfClass:[XDMyInfoEditController class]]){
            [self.navigationController popToViewController:temVC animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 225;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return  nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

#pragma mark -- XDNewContactDelegate
- (void)XDNewContactControllerWithName:(NSString *)name andPhoneNumber:(NSString *)phone withRelationShip:(NSString *)relationShip {
    XDContactModel *model = [[XDContactModel alloc] init];
    model.linkmanName = name;
    model.linkmanMobileNo = phone;
    model.relationship = relationShip;
    [self.contactArray addObject:model];
    [self.tableView reloadData];
}

- (NSMutableArray *)contactArray {
    if (!_contactArray) {
        self.contactArray = [NSMutableArray array];
    }
    return _contactArray;
}


@end
