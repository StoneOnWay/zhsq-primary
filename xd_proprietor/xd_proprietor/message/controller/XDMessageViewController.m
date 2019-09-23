//
//  XDMessageViewController.m
//  xd_proprietor
//
//  Created by mason on 2018/8/31.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDMessageViewController.h"
#import "XDMessageItemTableViewCell.h"

@interface XDMessageCellModel : NSObject

/** <##> */
@property (strong, nonatomic) NSString *icon;
/** <##> */
@property (strong, nonatomic) NSString *title;
/** <##> */
@property (strong, nonatomic) NSString *subTitle;
/** <##> */
@property (strong, nonatomic) NSString *time;

@end

@implementation XDMessageCellModel


@end


@interface XDMessageViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
/** <##> */
@property (strong, nonatomic) UITableView *tableView;
/** <##> */
@property (strong, nonatomic) NSMutableArray *itemArray;



@end

@implementation XDMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    [self setupView];
}

- (void)setupView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = 65.f;
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XDMessageItemTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XDMessageItemTableViewCell class])];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDMessageItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XDMessageItemTableViewCell class]) forIndexPath:indexPath];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}


- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

@end




























