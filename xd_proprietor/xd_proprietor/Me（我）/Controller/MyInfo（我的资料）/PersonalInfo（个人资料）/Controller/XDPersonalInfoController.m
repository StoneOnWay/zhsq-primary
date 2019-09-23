//
//  XDPersonalInfoController.m
//  个人资料
//
//  Created by stone on 14/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDPersonalInfoController.h"
#import "XDPersonalConfigModel.h"
#import "XDPersonInfoCell.h"
#import "XDPersonalInfo.h"
#import "XDLoginUserRoomInfoModel.h"
#import "XDNameEditController.h"
#import "WSDatePickerView.h"
#import "XDPhoneBindController.h"
#import "XDThirdBindController.h"
#import "XDThirdInfoModel.h"

@interface XDPersonalInfoController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) XDPersonalInfo *myInfo;

@end

@implementation XDPersonalInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    
    [self configDataSource];
    [self configTableView];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nameChanged:) name:@"nickNameChangedNoti" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"nickNameChangedNoti" object:nil];
}

- (void)nameChanged:(NSNotification *)noti {
    self.myInfo.nickname = [noti object];
    [self configDataSource];
    [self.tableView reloadRow:1 inSection:0 withRowAnimation:(UITableViewRowAnimationAutomatic)];
}

- (void)loadData {
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    [MBProgressHUD showActivityMessageInWindow:nil];
    if (!loginModel.userInfo.userId) {
        [MBProgressHUD hideHUD];
        return;
    }
    
    NSString *userId = [NSString stringWithFormat:@"%@", loginModel.userInfo.userId];
    NSDictionary *dic = @{@"userId":userId};
    [[XDAPIManager sharedManager] requestOwnerInfoParameters:dic CompletionHandle:^(NSDictionary *responseObject, NSError *error) {
        [MBProgressHUD hideHUD];
        if (error) {
            [XDUtil showToast:@"获取业主信息失败！"];
            return;
        }
        if ([responseObject[@"resultCode"] intValue] == 0) {
            self.myInfo = [XDPersonalInfo mj_objectWithKeyValues:responseObject[@"data"]];
            self.myInfo.face = [NSString stringWithFormat:@"%@/%@", K_BASE_URL, self.myInfo.face];
            if (loginModel.roominfo.count > 0) {
                XDLoginUserRoomInfoModel *model = loginModel.roominfo.firstObject;
                self.myInfo.roomInfo = model.address;
            }
            [self configDataSource];
            [self.tableView reloadData];
        } else {
            NSString *msg = [NSString stringWithFormat:@"%@", responseObject[@"msg"]];
            [XDUtil showToast:msg];
        }
    }];
}

- (void)configTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"XDPersonInfoCell" bundle:NSBundle.mainBundle] forCellReuseIdentifier:@"XDPersonInfoCell"];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
    self.tableView.backgroundColor = litterBackColor;
}

- (void)configDataSource {
    [self.itemArray removeAllObjects];
    NSMutableArray *section1Array = [[NSMutableArray alloc] init];
    NSMutableArray *section2Array = [[NSMutableArray alloc] init];
    XDPersonalConfigModel *headModel = [[XDPersonalConfigModel alloc] init];
    headModel.title = @"头像";
    headModel.subTitle = @"";
    headModel.isImage = YES;
    headModel.hasArrow = YES;
    headModel.headUrl = self.myInfo.face;
//    headModel.headImage = self.myInfo.headImage;
    [section1Array addObject:headModel];
    
    XDPersonalConfigModel *nickModel = [[XDPersonalConfigModel alloc] init];
    nickModel.title = @"昵称";
    nickModel.subTitle = self.myInfo.nickname;
    nickModel.isImage = NO;
    nickModel.hasArrow = YES;
    [section1Array addObject:nickModel];
    
    XDPersonalConfigModel *phoneModel = [[XDPersonalConfigModel alloc] init];
    phoneModel.title = @"电话";
    phoneModel.subTitle = self.myInfo.mobile;
    phoneModel.isImage = NO;
    phoneModel.hasArrow = NO;
//    [section1Array addObject:phoneModel];
    
    XDPersonalConfigModel *genderModel = [[XDPersonalConfigModel alloc] init];
    genderModel.title = @"性别";
    NSString *gender = nil;
    if (self.myInfo.gender == 1) {
        gender = @"男";
    } else if (self.myInfo.gender == 2) {
        gender = @"女";
    } else {
        gender = @"未知";
    }
    genderModel.subTitle = gender;
    genderModel.isImage = NO;
    genderModel.hasArrow = YES;
    [section1Array addObject:genderModel];
    
    XDPersonalConfigModel *birthModel = [[XDPersonalConfigModel alloc] init];
    birthModel.title = @"生日";
    birthModel.subTitle = self.myInfo.birthday;
    birthModel.isImage = NO;
    birthModel.hasArrow = YES;
//    [section1Array addObject:birthModel];
    
    XDPersonalConfigModel *roomModel = [[XDPersonalConfigModel alloc] init];
    roomModel.title = @"房屋信息";
    roomModel.subTitle = self.myInfo.roomInfo;
    roomModel.isImage = NO;
    roomModel.hasArrow = NO;
    //    [section2Array addObject:roomModel];
    
    XDPersonalConfigModel *dateModel = [[XDPersonalConfigModel alloc] init];
    dateModel.title = @"入住日期";
    dateModel.subTitle = self.myInfo.checkindate;
    dateModel.isImage = NO;
    dateModel.hasArrow = NO;
    //    [section2Array addObject:dateModel];
    
    XDPersonalConfigModel *methodModel = [[XDPersonalConfigModel alloc] init];
    methodModel.title = @"居住方式";
    NSString *livemode = nil;
    if ([self.myInfo.livemode isEqualToString:@"1"]) {
        livemode = @"单身居住";
    } else if ([self.myInfo.livemode isEqualToString:@"2"]) {
        livemode = @"合伙居住";
    } else if ([self.myInfo.livemode isEqualToString:@"3"]) {
        livemode = @"家庭居住";
    } else if ([self.myInfo.livemode isEqualToString:@"4"]) {
        livemode = @"集体居住";
    } else {
        livemode = @"其它";
    }
    methodModel.subTitle = livemode;
    methodModel.isImage = NO;
    methodModel.hasArrow = NO;
    //    [section2Array addObject:methodModel];
    
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    if (!loginModel.userInfo.userId) {
        // 非手机号登录
        if (loginModel.thirdInfo) {
            XDThirdInfoModel *thirdInfo = loginModel.thirdInfo.firstObject;
            if (thirdInfo.accountId) {
                // QQ微信登录，并且还没有绑定业主
                self.myInfo.face = thirdInfo.faceImg;
                headModel.headUrl = self.myInfo.face;
                headModel.hasArrow = NO;
                self.myInfo.nickname = thirdInfo.nickname;
                nickModel.subTitle = self.myInfo.nickname;
                nickModel.hasArrow = NO;
                self.myInfo.gender = [thirdInfo.sex integerValue];
                if ([thirdInfo.sex isEqualToString:@"男"]) {
                    self.myInfo.gender = 1;
                } else if ([thirdInfo.sex isEqualToString:@"女"]) {
                    self.myInfo.gender = 2;
                }
                genderModel.subTitle = thirdInfo.sex;
                genderModel.hasArrow = NO;
                XDPersonalConfigModel *bindModel = [[XDPersonalConfigModel alloc] init];
                bindModel.title = @"绑定业主";
                bindModel.subTitle = @"绑定业主，获取所有功能";
                bindModel.isImage = NO;
                bindModel.hasArrow = YES;
                [section1Array addObject:bindModel];
        }
        } else {
            // 已经绑定了业主，不需要绑定这一行
        }
    } else {
        [section1Array insertObject:phoneModel atIndex:2];
        [section1Array insertObject:birthModel atIndex:4];
        // 手机号登录
        XDPersonalConfigModel *bindModel = [[XDPersonalConfigModel alloc] init];
        bindModel.title = @"绑定";
        bindModel.subTitle = @"绑定QQ、微信";
        bindModel.isImage = NO;
        bindModel.hasArrow = YES;
        [section1Array addObject:bindModel];
        
        [section2Array addObject:roomModel];
        [section2Array addObject:dateModel];
        [section2Array addObject:methodModel];
    }
    
    [self.itemArray addObject:section1Array];
    [self.itemArray addObject:section2Array];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.itemArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.itemArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDPersonalConfigModel *model = self.itemArray[indexPath.section][indexPath.row];
    if (model.isImage) {
        return 100;
    } else {
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDPersonInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XDPersonInfoCell" forIndexPath:indexPath];
    XDPersonalConfigModel *model = self.itemArray[indexPath.section][indexPath.row];
    cell.personInfo = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XDPersonInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    XDPersonalConfigModel *model = self.itemArray[indexPath.section][indexPath.row];
    if ([model.title isEqualToString:@"头像"]) {
        if (model.hasArrow) {
            [self takePhoto:cell];
        }
    } else if ([model.title isEqualToString:@"昵称"]) {
        if (model.hasArrow) {
            XDNameEditController *nameVC = [[XDNameEditController alloc] init];
            nameVC.nickName = self.myInfo.nickname;
            [self.navigationController pushViewController:nameVC animated:YES];
        }
    } else if ([model.title isEqualToString:@"生日"]) {
        WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSDate *startDate) {
            NSString *timeStr = [startDate stringWithFormat:@"yyyy-MM-dd"];
            [self commitBirthday:timeStr];
        }];
        datepicker.doneButtonColor = BianKuang; // 确定按钮的颜色
        [datepicker show];
    } else if ([model.title isEqualToString:@"性别"]) {
        if (model.hasArrow) {
            [self alterSexPortrait];
        }
    } else if ([model.title isEqualToString:@"绑定业主"]) {
        XDPhoneBindController *bindVC = [[XDPhoneBindController alloc] init];
        bindVC.bindSuccessBlock = ^{
            [self loadData];
        };
        [self.navigationController pushViewController:bindVC animated:YES];
    } else if ([model.title isEqualToString:@"绑定"]) {
        XDThirdBindController *thirdVC = [[XDThirdBindController alloc] init];
        self.definesPresentationContext = YES;
        thirdVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:thirdVC animated:NO completion:nil];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
        if (!header) {
            header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"UITableViewHeaderFooterView"];
        }
        header.frame = CGRectMake(0, 0, kScreenWidth, 20);
        UIView *view = [[UIView alloc] initWithFrame:header.bounds];
        view.backgroundColor = litterBackColor;
        [header addSubview:view];
        return header;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 20;
    }
    return 0.01;
}

#pragma mark - UIAlert
- (void)takePhoto:(XDPersonInfoCell *)cell {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选取照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet ];
    //拍照
    UIAlertAction *Action = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self photoWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }];
    //相机胶卷
    UIAlertAction *Action1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self photoWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    //取消style:UIAlertActionStyleDefault
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:Action];
    [alert addAction:Action1];
    [alert addAction:cancelAction];
    if ([XDUtil isIPad]) {
        UIPopoverPresentationController *popoverVC = [alert popoverPresentationController];
        popoverVC.sourceView = cell;
        popoverVC.sourceRect = cell.bounds;
    }
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)photoWithSourceType:(UIImagePickerControllerSourceType)type{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    NSDictionary *textAt = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    [imagePicker.navigationBar setTitleTextAttributes:textAt];
    imagePicker.navigationBar.tintColor = [UIColor blackColor];
    imagePicker.delegate = self;
    imagePicker.sourceType = type;
    imagePicker.allowsEditing = YES;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self commitHeadImage:info[@"UIImagePickerControllerEditedImage"]];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark----- 选择性别弹出框
-(void)alterSexPortrait {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self commitGender:1];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        [self commitGender:2];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - commit edit data
- (void)commitHeadImage:(UIImage *)image {
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSData *imageData = UIImagePNGRepresentation(image);
    NSArray *imageArray = [NSArray arrayWithObject:imageData];
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSNumber *userId = loginModel.userInfo.userId;
    NSString *token = loginModel.token;
    if (!appMobile || !userId || !token) {
        [XDUtil showToast:@"绑定业主后，才有权限修改个人头像！"];
        return;
    }
    NSDictionary *dic = @{
                          @"appMobile" : appMobile,
                          @"appTokenInfo":token,
                          @"ownerid":userId,
                          };
    [MBProgressHUD showActivityMessageInWindow:nil];
    __weak typeof(self) weakSelf = self;
    [[XDAPIManager sharedManager] requestEditPersonalInformationParameters:dic constructingBodyWithBlock:imageArray CompletionHandle:^(id responseObject, NSError *error) {
        [MBProgressHUD hideHUD];
        if (error) {
            [XDUtil showToast:@"修改头像失败！"];
            return ;
        }
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"MyHeadImageData"];
//            weakSelf.myInfo.headImage = image;
            [weakSelf configDataSource];
            [weakSelf.tableView reloadRow:0 inSection:0 withRowAnimation:(UITableViewRowAnimationAutomatic)];

            [XDUtil showToast:@"修改头像成功！"];
        } else {
            NSString *msg = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
            [XDUtil showToast:msg];
        }
    }];
}

- (void)commitBirthday:(NSString *)birthday {
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSNumber *userId = loginModel.userInfo.userId;
    NSString *token = loginModel.token;
    if (!appMobile || !userId || !token) {
        [XDUtil showToast:@"登录失效！"];
        return;
    }
    NSDictionary *dic = @{
                          @"appMobile" : appMobile,
                          @"appTokenInfo":token,
                          @"ownerid":userId,
                          @"birthday":birthday
                          };
    [MBProgressHUD showActivityMessageInWindow:nil];
    __weak typeof(self) weakSelf = self;
    [[XDAPIManager sharedManager] requestEditPersonalInformationParameters:dic constructingBodyWithBlock:nil CompletionHandle:^(id responseObject, NSError *error) {
        [MBProgressHUD hideHUD];
        if (error) {
            [XDUtil showToast:@"修改生日失败！"];
            return ;
        }
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            [XDUtil showToast:@"修改生日成功！"];
            weakSelf.myInfo.birthday = birthday;
            [weakSelf configDataSource];
            [weakSelf.tableView reloadRow:4 inSection:0 withRowAnimation:(UITableViewRowAnimationAutomatic)];
        } else {
            NSString *msg = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
            [XDUtil showToast:msg];
        }
    }];
}

- (void)commitGender:(NSInteger)gender {
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSNumber *userId = loginModel.userInfo.userId;
    NSString *token = loginModel.token;
    if (!appMobile || !userId || !token) {
        [XDUtil showToast:@"绑定业主后，才有权限修改性别！"];
        return;
    }
    NSDictionary *dic = @{
                          @"appMobile" : appMobile,
                          @"appTokenInfo":token,
                          @"ownerid":userId,
                          @"gender":@(gender)
                          };
    [MBProgressHUD showActivityMessageInWindow:nil];
    __weak typeof(self) weakSelf = self;
    [[XDAPIManager sharedManager] requestEditPersonalInformationParameters:dic constructingBodyWithBlock:nil CompletionHandle:^(id responseObject, NSError *error) {
        [MBProgressHUD hideHUD];
        if (error) {
            [XDUtil showToast:@"修改性别失败！"];
            return ;
        }
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            [XDUtil showToast:@"修改性别成功！"];
            weakSelf.myInfo.gender = gender;
            [weakSelf configDataSource];
            [weakSelf.tableView reloadRow:3 inSection:0 withRowAnimation:(UITableViewRowAnimationAutomatic)];
        } else {
            NSString *msg = [NSString stringWithFormat:@"%@", responseObject[@"message"]];
            [XDUtil showToast:msg];
        }
    }];
}

#pragma mark - lazy load
- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

- (XDPersonalInfo *)myInfo {
    if (!_myInfo) {
        _myInfo = [[XDPersonalInfo alloc] init];
    }
    return _myInfo;
}

@end
