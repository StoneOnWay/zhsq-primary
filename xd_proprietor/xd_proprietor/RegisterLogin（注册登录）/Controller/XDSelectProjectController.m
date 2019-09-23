//
//  XDSelectProjectController.m
//  xd_proprietor
//
//  Created by cfsc on 2019/7/30.
//  Copyright © 2019年 zc. All rights reserved.
//

#import "XDSelectProjectController.h"
#import "XDProjectSelCell.h"
#import "XDAddProjectController.h"

@interface XDSelectProjectController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) NSMutableArray<XDProjectModel*> *projectArray;
@end

@implementation XDSelectProjectController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTableView];
    [self loadData];
}

- (void)configTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"XDProjectSelCell" bundle:NSBundle.mainBundle] forCellReuseIdentifier:@"XDProjectSelCell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)loadData {
    NSArray *array = [XDReadLoginModelTool projectArray];
    if (array) {
        [self.projectArray addObjectsFromArray:array];
    }
    XDProjectModel *xfModel = [[XDProjectModel alloc] init];
    xfModel.name = @"云西府";
    xfModel.address = @"长沙市望青路东100米";
    xfModel.tag = @"YXF";
    xfModel.ip = @"http://dev.chanfine.com:9082/smartxd";
    [self.itemArray addObject:xfModel];
    XDProjectModel *jyModel = [[XDProjectModel alloc] init];
    jyModel.name = @"金阳府";
    jyModel.address = @"长沙市浏阳市健寿大道与康万路交叉口西南角";
    jyModel.tag = @"JYF";
    jyModel.ip = @"http://dev.chanfine.com:9082/smartjy";
    [self.itemArray addObject:jyModel];
    XDProjectModel *wlModel = [[XDProjectModel alloc] init];
    wlModel.name = @"万楼公馆";
    wlModel.address = @"湘潭市雨湖区潭州大道与万楼路交汇处";

    wlModel.tag = @"WLGG";
    wlModel.ip = @"http://dev.chanfine.com:9082/smartwl";
    [self.itemArray addObject:wlModel];
    [self.itemArray addObjectsFromArray:self.projectArray];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDProjectModel *model = self.itemArray[indexPath.row];
    XDProjectSelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XDProjectSelCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLabel.text = model.name;
    cell.addressLabel.text = model.address;
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200 * kScreenWidth / 414;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XDProjectModel *model = self.itemArray[indexPath.row];
    [JPUSHService addTags:[NSSet setWithObject:model.tag] completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
        NSLog(@"add tags - %ld", (long)iResCode);
    } seq:0];
    if (self.didSelectedProject) {
        self.didSelectedProject(model);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // (self.itemArray.count - self.projectArray.count)为服务器上项目的个数
    if (indexPath.row >= (self.itemArray.count - self.projectArray.count)) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger index = indexPath.row - (self.itemArray.count - self.projectArray.count);
        [self.projectArray removeObjectAtIndex:index];
        [XDReadLoginModelTool saveProjectArray:self.projectArray];
        [self.itemArray removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
}

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addProject:(id)sender {
    XDAddProjectController *addVC = [[XDAddProjectController alloc] init];
    WEAKSELF
    addVC.didAddProject = ^(XDProjectModel * _Nonnull model) {
        [weakSelf.itemArray addObject:model];
        [weakSelf.tableView reloadData];
        [self.projectArray addObject:model];
        [XDReadLoginModelTool saveProjectArray:self.projectArray];
    };
    [self presentViewController:addVC animated:YES completion:nil];
}

- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _itemArray;
}

- (NSMutableArray<XDProjectModel *> *)projectArray {
    if (!_projectArray) {
        _projectArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _projectArray;
}

@end
