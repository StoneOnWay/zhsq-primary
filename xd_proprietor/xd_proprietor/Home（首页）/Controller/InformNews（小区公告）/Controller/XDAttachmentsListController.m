//
//  XDAttachmentsListController.m
//  XD业主
//
//  Created by zc on 2018/5/8.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDAttachmentsListController.h"
#import "XDAttachmentCell.h"
#import "XDAttachmentsDetailController.h"
#import "XDAttachmentModel.h"

@interface XDAttachmentsListController ()

//@property (nonatomic , strong)NSMutableArray *nameArray;

//@property (nonatomic , strong)NSMutableArray *pathArray;

@end

@implementation XDAttachmentsListController

//- (NSMutableArray *)nameArray {
//    if (!_nameArray) {
//        _nameArray = [NSMutableArray array];
//    }
//    return _nameArray;
//}
//- (NSMutableArray *)pathArray {
//    if (!_pathArray) {
//        _pathArray = [NSMutableArray array];
//    }
//    return _pathArray;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.separatorStyle = 0;
    self.tableView.rowHeight = 60;
    self.view.backgroundColor = backColor;
    self.title = @"附件列表";
    
//    [self initDatas];
    
}

//- (void)initDatas {
//
//    for (int i = 0; i < self.resourceArray.count ; i++) {
//        NSString *pathString = self.resourceArray[i];
//        NSArray *urlArray = [pathString componentsSeparatedByString:@"-"]; //从字符,中分隔成2个元素的数组
//        [self.pathArray addObject:urlArray.firstObject];
//        [self.nameArray addObject:urlArray.lastObject];
//    }
//
//    [self.tableView reloadData];
//
//}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDAttachmentModel *model = self.resourceArray[indexPath.row];
    XDAttachmentCell *cell = [XDAttachmentCell cellWithTableView:tableView];
    cell.selectionStyle = 0;
    cell.nameLabels.text = model.resourceRealName;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XDAttachmentModel *model = self.resourceArray[indexPath.row];
    XDAttachmentsDetailController *detail = [[XDAttachmentsDetailController alloc] init];
//    detail.urlString = [NSString stringWithFormat:@"%@%@", K_BASE_URL, model.url];
    detail.urlString = model.url;
    [self.navigationController pushViewController:detail animated:YES];
    
}

@end
