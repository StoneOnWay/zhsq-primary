//
//  XDRealPlayerController.m
//  可视对讲
//
//  Created by stone on 24/4/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDRealPlayerController.h"
#import "XDRealPlayCell.h"
#import "CTCPlayerView.h"
#import "CTCCallCenterBusiness.h"
#import "ZHYJCallInfo.h"
#import "XDDeviceInfoModel.h"
#import "ZHYJSDK.h"

#define CELL_IDENTIFY @"XDRealPlayCell"

@interface XDRealPlayerController () <CTCCallCenterBusinessDelegate, UITableViewDelegate, UITableViewDataSource> {
    CTCCallCenterBusiness *callCenterBusiness;
}
@property (nonatomic, strong) CTCPlayerView *playView;    /**< 显示预览视频View*/
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *deviceArray;
@end

@implementation XDRealPlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    callCenterBusiness = [CTCCallCenterBusiness sharedInstance];
    callCenterBusiness.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [callCenterBusiness stopRealPlay];
}

- (NSArray *)deviceArray {
    if (!_deviceArray) {
        XDLoginUseModel *model = [XDReadLoginModelTool loginModel];
        _deviceArray = model.deviceInfo;
    }
    return _deviceArray;
}

- (void)setUI {
    self.playView = [[CTCPlayerView alloc] init];
    [self.view addSubview:self.playView];
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.top.equalTo(self.view);
        make.height.mas_equalTo(0);
    }];
    
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.playView.mas_bottom);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = litterBackColor;
    [self.tableView registerNib:[UINib nibWithNibName:CELL_IDENTIFY bundle:NSBundle.mainBundle] forCellReuseIdentifier:CELL_IDENTIFY];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.deviceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDRealPlayCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFY forIndexPath:indexPath];
    XDDeviceInfoModel *model = self.deviceArray[indexPath.row];
    cell.nameLabel.text = model.location;
    NSString *imageName = [NSString stringWithFormat:@"video_play%ld", (long)(indexPath.row % 6)];
    cell.staticImageView.image = [UIImage imageNamed:imageName];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.playView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(280 * kScreenWidth / 414.f);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view updateConstraintsIfNeeded];
        [self.view layoutIfNeeded];
    }];
    
    XDDeviceInfoModel *model = self.deviceArray[indexPath.row];
    ZHYJCallInfo *callInfo = [[ZHYJCallInfo alloc] init];
    callInfo.deviceSerial = model.deviceSerial;
    callCenterBusiness.callInfo = callInfo;
    [callCenterBusiness startVideoPlay:self.playView];
}

@end
