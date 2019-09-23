//
//  XDActivityViewController.m
//  xd_proprietor
//
//  Created by mason on 2018/9/4.
//Copyright © 2018年 zc. All rights reserved.
//

#import "XDActivityViewController.h"
#import "XDActivityItemTableViewCell.h"

@interface XDActivityViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
/** <##> */
@property (strong, nonatomic) UITableView *tableView;


@end

@implementation XDActivityViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];

}

- (void)setupView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - NavHeight) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.backgroundColor = UIColorHex(f3f3f3);
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 229.f;
    tableView.tableFooterView = [UIView new];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XDActivityItemTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XDActivityItemTableViewCell class])];
    
//    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XDActivityItemTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XDActivityItemTableViewCell class])];
    
//    [tableView registerClass:[XDActivityItemTableViewCell class] forCellReuseIdentifier:NSStringFromClass([XDActivityItemTableViewCell class])];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    XDActivityItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XDActivityItemTableViewCell class])];
    if (!cell) {
        cell = [[XDActivityItemTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([XDActivityItemTableViewCell class])];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = UIColorHex(f3f3f3);
    return view;
}


@end
