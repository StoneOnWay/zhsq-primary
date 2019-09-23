//
//  XDWorkProgressViewController.m
//  xd_proprietor
//
//  Created by mason on 2018/9/7.
//Copyright © 2018年 zc. All rights reserved.
//

#import "XDWorkProgressViewController.h"
#import "XDWorkProgressTableViewCell.h"
#import "XDProcessModel.h"

@interface XDWorkProgressViewController ()

/** <##> */
@property (strong, nonatomic) NSMutableArray *itemArray;

@end

@implementation XDWorkProgressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"投诉进度";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XDWorkProgressTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XDWorkProgressTableViewCell class])];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 49.f;
    
    [MBProgressHUD showActivityMessageInWindow:nil];
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSString *key = self.warrantyPageType == XDWarrantyPageTypeWorkOrder ? @"repairsId" : @"complainId";
    NSDictionary *parameter = @{
                          key : self.repairsId,
                          @"appTokenInfo":token,
                          @"appMobile":appMobile,
                          };
    if (self.warrantyPageType == XDWarrantyPageTypeWorkOrder) {
        [self loadWarrantyListProcessNetDataWithParameter:parameter];
    } else {
        [self loadComplainListProcessNetDataWithParameter:parameter];
    }
}

- (void)loadWarrantyListProcessNetDataWithParameter:(NSDictionary *)parameter {
    [[XDAPIManager sharedManager] requestMyWarrantyOfProgressParameters:parameter CompletionHandle:^(id responseObject, NSError *error) {
        __weak typeof(self) weakSelf = self;
        [weakSelf handleResultWithResponseObject:responseObject error:error];
    }];
}

- (void)loadComplainListProcessNetDataWithParameter:(NSDictionary *)parameter {
    [[XDAPIManager sharedManager] requestComplainProcessWithParameters:parameter CompletionHandle:^(id responseObject, NSError *error) {
        __weak typeof(self) weakSelf = self;
        [weakSelf handleResultWithResponseObject:responseObject error:error];
    }];
}

- (void) handleResultWithResponseObject:(id)responseObject error:(NSError *)error {
    if ([responseObject[@"resultCode"] isEqualToString:@"0"] ) {
        [self.itemArray removeAllObjects];
        NSArray *processArray = [NSArray modelArrayWithClass:[XDProcessModel class] json:responseObject[@"data"]];
        [self.itemArray addObjectsFromArray:processArray];
        [self.tableView reloadData];
    }
    [MBProgressHUD hideHUD];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    XDWorkProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XDWorkProgressTableViewCell class]) forIndexPath:indexPath];
    cell.processModel = self.itemArray[indexPath.row];
    cell.aboveLine.hidden = indexPath.row == 0;
    cell.belowLine.hidden = indexPath.row == self.itemArray.count - 1;
    return cell;
}

- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}


@end
