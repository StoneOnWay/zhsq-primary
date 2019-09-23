//
//  XDFunDetailViewController.m
//  发现
//
//  Created by xielei on 2019/1/27.
//  Copyright © 2019年 zc. All rights reserved.
//

#import "XDFunDetailViewController.h"
#import "XDFunDetailell.h"
#import "XDFunDetailHeaderView.h"
#import "XDFunImageDetailController.h"
#import "MenuAlertViewController.h"
#import "CenterView.h"

@interface XDFunDetailViewController ()
{
    NSInteger picCount;
}


@property (weak, nonatomic) IBOutlet UIScrollView *mscrollview;

@property (weak, nonatomic) IBOutlet UILabel *fromLab;

@property (weak, nonatomic) IBOutlet UILabel *dateLab;

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollview_W;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;

@property (weak, nonatomic) IBOutlet UIButton *zanButton;
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;
@property (nonatomic, strong) NSMutableArray *imageArray;

- (IBAction)zanClick:(UIButton *)sender;

- (IBAction)attentionClick:(UIButton *)sender;

@end

@implementation XDFunDetailViewController


- (void)updateViewConstraints{
    
    [super updateViewConstraints];
    
    self.scrollview_W.constant  = kScreenWidth;
    
    self.mscrollview.contentSize = CGSizeMake(kScreenWidth, kScreenHeight - 44.0f);
    
    if (picCount > 0) {
        self.imageHeight.constant = 200.0f;
    } else {
        self.imageHeight.constant = 0.0;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新鲜事";
    [self configTableView];
    [self loadThemeDetail];
    [self configRightNavItem];
}

- (void)configRightNavItem {
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    if (loginModel.userInfo.userId.intValue == self.listModel.ownerid.intValue) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:(UIBarButtonItemStylePlain) target:self action:@selector(deleteTheme)];
    } else {
        // 举报
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"举报" style:(UIBarButtonItemStylePlain) target:self action:@selector(reportTheme)];
    }
}

- (void)reportTheme {
    NSArray *items = @[@"垃圾广告", @"色情信息", @"赌博相关", @"其他"];
    MenuAlertViewController *vc = [[MenuAlertViewController alloc]initWithTitleItems:items detailsItems:nil selectImage:@"select_normal" normalImage:@"select_not"];
    vc.leftBtnTitle = @"取消";
    vc.titles = @"举报";
    vc.btnFont = 17;
    vc.confirmSelectRowBlock = ^(NSInteger index) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [XDUtil showToast:@"感谢您的反馈，我们会在24小时内处理"];
        });
    };
    [self presentViewController:vc animated:false completion:nil];
}

- (void)deleteTheme {
    [MBProgressHUD showActivityMessageInWindow:nil];
    NSDictionary *dic = @{
                          @"id":self.listModel.mid,
                          };
    [[XDAPIManager sharedManager] requestDeleteThemeWithParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        [MBProgressHUD hideHUD];
        NSDictionary *resultDict = (NSDictionary*)responseObject;
        if ([resultDict[@"resultCode"] isEqualToString:@"0"]) {
            [MBProgressHUD showSuccessMessage:@"删除成功！"];
            if (self.shouldUpdateFunAllDataBlock) {
                self.shouldUpdateFunAllDataBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showSuccessMessage:@"删除失败！"];
        }
    }];
}

- (void)configTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"XDFunDetailell" bundle:NSBundle.mainBundle] forCellReuseIdentifier:@"XDFunDetailell"];
    
    UIView *footView = [[UIView alloc] init];
    UILabel *label = [[UILabel alloc] init];
    [footView addSubview:label];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:15];
    label.text = self.listModel.content;
    label.textColor = [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1.0];
    CGSize maximumLabelSize = CGSizeMake(kScreenWidth - 40, 9999);
    CGSize fitSize = [label sizeThatFits:maximumLabelSize];
    footView.frame = CGRectMake(0, 0, kScreenWidth, fitSize.height + 10);
    label.frame = CGRectMake(20, 10, fitSize.width, fitSize.height);
    self.tableView.tableFooterView = footView;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"XDFunDetailHeaderView" bundle:NSBundle.mainBundle] forHeaderFooterViewReuseIdentifier:@"XDFunDetailHeaderView"];
    self.tableView.sectionHeaderHeight = 40;
}

- (void)loadThemeDetail {
    [MBProgressHUD showActivityMessageInWindow:nil];
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSDictionary *dic = @{@"id":self.listModel.mid,
                          @"ownerid":loginModel.userInfo.userId,
                          @"appTokenInfo":loginModel.token
                          };
    [[XDAPIManager sharedManager] requestgetByThemeIWithParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        [MBProgressHUD hideHUD];
        NSDictionary *resultDict = (NSDictionary*)responseObject;
        if ([resultDict[@"resultCode"] isEqualToString:@"0"]) {
            self.zanButton.selected = ([resultDict[@"data"][@"ifUp"] isEqual:@(0)])? NO : YES;
            self.attentionButton.selected = ([resultDict[@"data"][@"ifFollow"] isEqual:@(0)])? NO : YES;
        }
    }];
}

// 点赞
- (IBAction)zanClick:(UIButton *)sender {
    
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    
    if ( self.zanButton.selected == YES) {
        [MBProgressHUD showSuccessMessage:@"您已经点赞了"];
        return;
    }
    
    [[XDAPIManager sharedManager] requestupThemeWithParameters:@{@"themeid":self.listModel.mid,@"ownersid":loginModel.userInfo.userId,@"appTokenInfo":loginModel.token} CompletionHandle:^(id responseObject, NSError *error) {
        NSDictionary *resultDict = (NSDictionary*)responseObject;
        if ([resultDict[@"resultCode"] isEqualToString:@"0"]) {
            [MBProgressHUD showSuccessMessage:@"点赞成功！"];
            self.zanButton.selected = YES;
            if (self.shouldUpdateFunAllDataBlock) {
                self.shouldUpdateFunAllDataBlock();
            }
        } else {
            [MBProgressHUD showSuccessMessage:@"点赞失败！"];
            
        }
    }];
}

// 关注
- (IBAction)attentionClick:(UIButton *)sender {
    
    if (self.attentionButton.selected == YES) {
        XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
        
        NSDictionary *dic = @{@"ownersid":loginModel.userInfo.userId,
                              @"themeid":self.listModel.mid,
                              @"appTokenInfo":loginModel.token
                              };
        [[XDAPIManager sharedManager] requestcancelFollowWithParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
            NSDictionary *resultDict = (NSDictionary*)responseObject;
            if ([resultDict[@"resultCode"] isEqualToString:@"0"]) {
                [MBProgressHUD showSuccessMessage:@"取消关注！"];
                self.attentionButton.selected = NO;
                if (self.shouldUpdateFunAllDataBlock) {
                    self.shouldUpdateFunAllDataBlock();
                }
            }else{
                [MBProgressHUD showSuccessMessage:@"取消失败！"];
            }
        }];
    } else {
        XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
        NSDictionary *dic = @{@"ownersid":loginModel.userInfo.userId,
                              @"themeid":self.listModel.mid,
                              @"appTokenInfo":loginModel.token
                              };
        [[XDAPIManager sharedManager]requestFollowWithParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
            
            NSDictionary *resultDict = (NSDictionary*)responseObject;
            if ([resultDict[@"resultCode"] isEqualToString:@"0"]) {
                [MBProgressHUD showSuccessMessage:@"关注成功！"];
                self.attentionButton.selected = YES;
                if (self.shouldUpdateFunAllDataBlock) {
                    self.shouldUpdateFunAllDataBlock();
                }
            }else{
                [MBProgressHUD showSuccessMessage:@"关注失败！"];
            }
        }];
    }
}

#pragma mark - table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listModel.picList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([XDUtil isIPad]) {
        return 350;
    }
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@", K_BASE_URL, self.listModel.picList[indexPath.row][@"url"]];
    XDFunDetailell *cell = [tableView dequeueReusableCellWithIdentifier:@"XDFunDetailell"];
    [cell.picImagView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"pic_find_2"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (self.imageArray.count < 3) {
            [self.imageArray addObject:image];
        }
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    XDFunDetailHeaderView *header = [[XDFunDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    header.fromLabel.text = [NSString stringWithFormat:@"来源：%@", self.listModel.ownerName];
    header.dateLabel.text = self.listModel.time;
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XDFunImageDetailController *imageDetailVC = [[XDFunImageDetailController alloc] init];
    imageDetailVC.imageArray = self.imageArray;
    imageDetailVC.currentIndex = indexPath.row;
    [self presentViewController:imageDetailVC animated:NO completion:nil];
}

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

@end
