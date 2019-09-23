//
//  XDWarrantyHomeViewController.m
//  xd_proprietor
//
//  Created by mason on 2018/9/10.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDWarrantyHomeViewController.h"
#import "HZBaseListInfoTableViewCell.h"
#import "HZBaseAddImageTableViewCell.h"
#import "XDWarrantyOperationBtn.h"
#import "XDEvaluateTableViewCell.h"
#import "HWImagePickerSheet.h"
#import "WSDatePickerView.h"
#import "GSPopoverViewController.h"
#import "XDChooseContactController.h"
#import "XDAlertView.h"
#import "HZSingleChoiceListView.h"
#import "HZPopView.h"
#import "XDLoginUserRoomInfoModel.h"

@interface XDWarrantyHomeViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
HZBaseAddImageTableViewCellDelegate,
XDChooseContactControllerDelegate,
HWImagePickerSheetDelegate
>

/** <##> */
@property (strong, nonatomic) UITableView *tableView;
/** <##> */
@property (strong, nonatomic) NSMutableArray *itemArray;
/** <##> */
@property (strong, nonatomic) NSMutableArray *imageArray;
/** <##> */
@property (strong, nonatomic) NSMutableArray *originALAssetArray;
/** <##> */
@property (strong, nonatomic) HWImagePickerSheet *imagePickerSheet;
//弹出框
@property (strong ,nonatomic) GSPopoverViewController *popVC;
/** 当前服务器时间加一小时 */
@property (copy, nonatomic) NSString *currentServiceTimeAddHour;
/** 当前服务器时间加一小时 */
@property (copy, nonatomic) NSString *commitTime;
//address选择数据
@property(nonatomic ,strong) NSMutableArray * roomArray;
//维修类型Type数据
@property(nonatomic ,strong) NSMutableArray * repairTypeArray;
/** 紧急程度 */
@property (strong, nonatomic) NSMutableArray *complaintLevelArray;
/** 工单类别 */
@property (strong, nonatomic) NSMutableArray *workOrderTypeArray;

/** 需要提交的数据，保存在这里<##> */
@property (strong, nonatomic) NSMutableDictionary *parameter;

//选择数据
@property(nonatomic ,strong) NSMutableArray * roomChoiceArray;
//维修类型Type数据
@property(nonatomic ,strong) NSMutableArray * repairTypeChoiceArray;
/** 紧急程度 */
@property (strong, nonatomic) NSMutableArray *complaintLevelChoiceArray;
/** 工单类别 */
@property (strong, nonatomic) NSMutableArray *workOrderTypeChoiceArray;


@end

@implementation XDWarrantyHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    self.parameter[@"userId"] = loginModel.userInfo.userId;
    self.parameter[@"appTokenInfo"] = loginModel.token;
    self.parameter[@"appMobile"] = loginModel.userInfo.mobileNumber;
    if ([self.title containsString:@"报事报修"]) {
        self.warrantyHomeViewControllerType = XDWarrantyHomeViewControllerTypeWarranty;
        self.parameter[@"projectId"] = loginModel.userInfo.projectId;
        self.parameter[@"createusertype"] = @"0";
        
    } else if ([self.title containsString:@"投诉建议"]){
        self.warrantyHomeViewControllerType = XDWarrantyHomeViewControllerTypeComplaint;
        XDLoginUserRoomInfoModel *roomInfo = loginModel.roominfo.firstObject;
        self.parameter[@"ownerId"] = loginModel.userInfo.userId;
        self.parameter[@"roomid"] = roomInfo.roomId;
        
    } else if ([self.title containsString:@"筛选"]) {
        self.warrantyHomeViewControllerType = XDWarrantyHomeViewControllerTypeFiltrate;
    } else {
        self.warrantyHomeViewControllerType = XDWarrantyHomeViewControllerTypeEvaluate;
        if ([self.title containsString:@"工单评价"]) {
            self.parameter[@"workOrderId"] = self.ID;
        } else {
            self.parameter[@"complainid"] = self.ID;
        }
        self.parameter[@"taskId"] = self.taskId;
        self.parameter[@"outcome"] = @"评价";
        self.parameter[@"commentLevel"] = @"5";
    }
    
    [self setupView];
    [self configDataSource];
    [self loadDataSource];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardChange:(NSNotification *)note{
    //拿到键盘弹出的frame
//    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect rect = self.tableView.frame;
    CGFloat contentOffY = 0;
    if (self.warrantyHomeViewControllerType == XDWarrantyHomeViewControllerTypeWarranty) {
        contentOffY = - 40;
    } else if (self.warrantyHomeViewControllerType == XDWarrantyHomeViewControllerTypeComplaint) {
        contentOffY = -50;
    }
    //修改底部输入框的约束
    if (rect.origin.y == 0) {
        // 键盘被弹出
        rect.origin.y = contentOffY;
        self.tableView.frame = rect;
    } else {
        rect.origin.y = 0;
        self.tableView.frame = rect;
    }
    //键盘弹出所需时长
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //添加输入框弹出和收回动画
    [UIView animateWithDuration:duration animations:^{
        //立即刷新进行重新布局
        [self.view layoutIfNeeded];
    }];
}

- (void)setupView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = UIColorHex(f3f3f3);
    tableView.estimatedRowHeight = 40.f;
    tableView.rowHeight = UITableViewAutomaticDimension;
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HZBaseListInfoTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HZBaseListInfoTableViewCell class])];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HZBaseAddImageTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HZBaseAddImageTableViewCell class])];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XDEvaluateTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XDEvaluateTableViewCell class])];

    XDWarrantyOperationBtn *operationBtn = [XDWarrantyOperationBtn loadFromNib];
    operationBtn.frame = CGRectMake(0, 0, kScreenWidth, 102.f);
    [operationBtn setOperationBtnType:XDWarrantyOperationBtnTypeSingle];
    [operationBtn setSingleBtnTitle:@"提交"];
    operationBtn.backgroundColor = UIColorHex(f3f3f3);
    @weakify(self)
    [operationBtn setClickOperationBlock:^(XDClickType clickType) {
        @strongify(self)
        if (self.warrantyHomeViewControllerType == XDWarrantyHomeViewControllerTypeWarranty) {
            [self commitData];
        } else if (self.warrantyHomeViewControllerType == XDWarrantyHomeViewControllerTypeComplaint) {
            [self commitComplainData];
        } else if (self.warrantyHomeViewControllerType == XDWarrantyHomeViewControllerTypeFiltrate) {
            [self handleFilter];
        } else if (self.warrantyHomeViewControllerType == XDWarrantyHomeViewControllerTypeEvaluate) {
            [self commitBtnClicked];
        }
    }];
    tableView.tableFooterView = operationBtn;
}

- (void)configDataSource {
    [self.itemArray removeAllObjects];
    
    if (self.warrantyHomeViewControllerType == XDWarrantyHomeViewControllerTypeWarranty) {
        HZBaseModel *roomBaseModel = [HZBaseModel new];
        roomBaseModel.title = @"业主房屋：";
        NSDictionary *addressDic = self.roomArray.firstObject;
        roomBaseModel.value = addressDic[@"name"];
        roomBaseModel.baseType = HZBaseTypeTextWithArrow;
        [self configEditWithBaseModel:roomBaseModel code:addressDic[@"id"] value:nil];
        
        HZBaseModel *addressBaseModel = [HZBaseModel new];
        addressBaseModel.title = @"维修地点：";
        addressBaseModel.baseType = HZBaseTypeTextField;
        
        HZBaseModel *timeBaseModel = [HZBaseModel new];
        timeBaseModel.title = @"上门时间：";
        timeBaseModel.value = self.commitTime;
        timeBaseModel.baseType = HZBaseTypeTextWithArrow;
        [self configEditWithBaseModel:timeBaseModel code:self.commitTime value:nil];
        
        HZBaseModel *contactsBaseModel = [HZBaseModel new];
        contactsBaseModel.title = @"联系人员：";
        XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
        NSMutableString *namePhone;
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *nickName = [ud objectForKey:@"nickName"];
        if (nickName != nil) {
            namePhone = [[NSMutableString alloc] initWithString:nickName];
        }else {
            namePhone = [[NSMutableString alloc] initWithString:loginModel.userInfo.nickName];
        }
        [namePhone appendFormat:@"|%@", loginModel.userInfo.mobileNumber];
        contactsBaseModel.value = namePhone;
        contactsBaseModel.baseType = HZBaseTypeTextWithArrow;
        [self configEditWithBaseModel:contactsBaseModel code:namePhone value:nil];
        
        HZBaseModel *repairTypeBaseModel = [HZBaseModel new];
        repairTypeBaseModel.title = @"维修类别：";
        NSDictionary *repairTypeDic = self.repairTypeArray.lastObject;
        repairTypeBaseModel.value = repairTypeDic[@"name"];
        repairTypeBaseModel.baseType = HZBaseTypeTextWithArrow;
        [self configEditWithBaseModel:repairTypeBaseModel code:repairTypeDic[@"id"] value:nil];
        
        HZBaseModel *problemDescriptionBaseModel = [HZBaseModel new];
        problemDescriptionBaseModel.title = @"问题描述：";
        NSString *key = [self keyChange:problemDescriptionBaseModel.title];
        NSString *value = self.parameter[key];
        problemDescriptionBaseModel.value = [XDUtil stringIsEmpty:value]?@"请填写问题描述":value;
        problemDescriptionBaseModel.baseType = HZBaseTypeTextView;
        
        HZBaseModel *imageBaseModel = [[HZBaseModel alloc] init];
        imageBaseModel.title = @"上传图片：";
        imageBaseModel.value = [self.imageArray copy];
        imageBaseModel.baseType = HZBaseTypeAddImage;
        
        [self.itemArray addObject:@[roomBaseModel, addressBaseModel, timeBaseModel, contactsBaseModel, repairTypeBaseModel]];
        [self.itemArray addObject:@[problemDescriptionBaseModel, imageBaseModel]];
    } else if (self.warrantyHomeViewControllerType == XDWarrantyHomeViewControllerTypeComplaint) {
        HZBaseModel *repairTypeBaseModel = [HZBaseModel new];
        repairTypeBaseModel.title = @"紧急程度：";
        NSString *title = self.complaintLevelArray.lastObject;
        repairTypeBaseModel.value = title;
        repairTypeBaseModel.baseType = HZBaseTypeTextWithArrow;
        [self configEditWithBaseModel:repairTypeBaseModel code:title value:nil];
        
        HZBaseModel *problemDescriptionBaseModel = [HZBaseModel new];
        problemDescriptionBaseModel.title = @"投诉内容：";
        NSString *key = [self keyChange:problemDescriptionBaseModel.title];
        NSString *value = self.parameter[key];
        problemDescriptionBaseModel.value = [XDUtil stringIsEmpty:value]?@"请填写投诉内容":value;
        problemDescriptionBaseModel.baseType = HZBaseTypeTextView;
        
        HZBaseModel *imageBaseModel = [[HZBaseModel alloc] init];
        imageBaseModel.title = @"上传图片：";
        imageBaseModel.value = [self.imageArray copy];
        imageBaseModel.baseType = HZBaseTypeAddImage;
        
        [self.itemArray addObject:@[repairTypeBaseModel]];
        [self.itemArray addObject:@[problemDescriptionBaseModel, imageBaseModel]];
    } else if (self.warrantyHomeViewControllerType == XDWarrantyHomeViewControllerTypeFiltrate) {
        HZBaseModel *startTimeBaseModel = [HZBaseModel new];
        startTimeBaseModel.title = @"开始时间：";
        startTimeBaseModel.value = @"请选择时间点";
        startTimeBaseModel.baseType = HZBaseTypeTextWithArrow;
        
        HZBaseModel *endTimeBaseModel = [HZBaseModel new];
        endTimeBaseModel.title = @"结束时间：";
        endTimeBaseModel.value = @"请选择时间点";
        endTimeBaseModel.baseType = HZBaseTypeTextWithArrow;
        
        HZBaseModel *repairTypeBaseModel = [HZBaseModel new];
        repairTypeBaseModel.title = self.warrantyPageType == XDWarrantyPageTypeWorkOrder ? @"工单类别：" : @"投诉类别：";
        NSDictionary *repairTypeDic = self.workOrderTypeArray.lastObject;
        repairTypeBaseModel.value = repairTypeDic[@"name"];
        repairTypeBaseModel.baseType = HZBaseTypeTextWithArrow;
        [self configEditWithBaseModel:repairTypeBaseModel code:repairTypeDic[@"id"] value:nil];
        
        [self.itemArray addObject:@[startTimeBaseModel, endTimeBaseModel]];
        [self.itemArray addObject:@[repairTypeBaseModel]];
    } else if (self.warrantyHomeViewControllerType == XDWarrantyHomeViewControllerTypeEvaluate) {
        HZBaseModel *startTimeBaseModel = [HZBaseModel new];
        startTimeBaseModel.title = @"评分：";
        startTimeBaseModel.baseType = HZBaseTypeEvaluate;
        
        HZBaseModel *complainBaseModel = [HZBaseModel new];
        complainBaseModel.title = @"评价内容：";
        NSString *key = [self keyChange:complainBaseModel.title];
        NSString *value = self.parameter[key];
        complainBaseModel.value = [XDUtil stringIsEmpty:value]?@"请填写评价内容":value;
        complainBaseModel.baseType = HZBaseTypeTextView;
        [self.itemArray addObject:@[startTimeBaseModel, complainBaseModel]];
    }
    [self.tableView reloadData];
}

#pragma mark - 工单提交数据
- (void)commitData {
    if (![self.parameter containsObjectForKey:@"problemdesc"]) {
        [XDAlertView clickToAlertViewTitle:@"提交失败" withDetailTitle:@"请将信息填写完整！" isDelegate:nil clickBlock:nil];
        return;
    }
    
    BOOL isTure = [self setPlanTime:self.parameter[@"plandate"] systemTime:self.currentServiceTimeAddHour];
    if (!isTure) {
        NSString *detailString = [NSString stringWithFormat:@"上门时间不能小于系统默认时间:%@",self.currentServiceTimeAddHour];
        [XDAlertView clickToAlertViewTitle:@"信息错误" withDetailTitle:detailString isDelegate:nil clickBlock:nil];
        return;
    }
    [MBProgressHUD showActivityMessageInWindow:nil];
    NSArray *imageDatas = [self getBigImageArray];
    [[XDAPIManager sharedManager] requestCommitMyWarrantyParameters:self.parameter constructingBodyWithBlock:imageDatas CompletionHandle:^(id responseObject, NSError *error) {
        if (error) {
            [XDAlertView clickToAlertViewTitle:@"创建失败" withDetailTitle:@"请检查网络情况！" isDelegate:nil clickBlock:nil];
            [MBProgressHUD hideHUD];
            return ;
        }
        if ([responseObject[@"resultCode"] isEqualToString:@"0"] ) {
            [MBProgressHUD hideHUD];
            @weakify(self)
            [XDAlertView clickToAlertViewTitle:@"创建成功" withDetailTitle:@"您的工单已创建成功！" isDelegate:nil clickBlock:^(UIButton *btn) {
                @strongify(self)
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else {
            [MBProgressHUD hideHUD];
            [XDAlertView clickToAlertViewTitle:@"创建失败" withDetailTitle:@"请重新提交工单！" isDelegate:nil clickBlock:nil];
        }
    }];
}

#pragma mark - 投诉提交数据
- (void)commitComplainData {
    if (![self.parameter containsObjectForKey:@"content"]) {
        [XDAlertView clickToAlertViewTitle:@"提交失败" withDetailTitle:@"请将信息填写完整！" isDelegate:nil clickBlock:nil];
        return;
    }
    [MBProgressHUD showActivityMessageInWindow:nil];
    NSArray *imageDatas = [self getBigImageArray];
    __weak typeof(self) weakSelf = self;
    [[XDAPIManager sharedManager] requestCommitMyComplainParameters:self.parameter constructingBodyWithBlock:imageDatas CompletionHandle:^(id responseObject, NSError *error) {
        if (error) {
            [XDAlertView clickToAlertViewTitle:@"投诉失败" withDetailTitle:@"请检查网络情况！" isDelegate:nil clickBlock:nil];
            [MBProgressHUD hideHUD];
            return ;
        }
        if ([responseObject[@"resultCode"] isEqualToString:@"0"] ){
            [MBProgressHUD hideHUD];
            [XDAlertView clickToAlertViewTitle:@"投诉成功" withDetailTitle:@"您的投诉已提交成功！" isDelegate:self clickBlock:^(UIButton *btn) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        }else {
            [MBProgressHUD hideHUD];
            [XDAlertView clickToAlertViewTitle:@"投诉失败" withDetailTitle:@"请重新提交！" isDelegate:nil clickBlock:nil];
        }
    }];
}

- (void)commitBtnClicked {
    if (![self.parameter containsObjectForKey:@"commentContent"] && [XDUtil stringIsEmpty:self.parameter[@"commentContent"]]) {
        [XDAlertView clickToAlertViewTitle:@"提交失败" withDetailTitle:@"请将信息填写完整！" isDelegate:nil clickBlock:nil];
        return;
    }
    [MBProgressHUD showActivityMessageInWindow:nil];
    if ([self.title isEqualToString:@"工单评价"]) {
        __weak typeof(self) weakSelf = self;
        [[XDAPIManager sharedManager] requestWarrantyEvalute:self.parameter CompletionHandle:^(id responseObject, NSError *error) {
            [MBProgressHUD hideHUD];
            if (error) {
                [XDAlertView clickToAlertViewTitle:@"评论失败" withDetailTitle:@"请重新提交评论！" isDelegate:nil clickBlock:nil];
                return ;
            }
            if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
                [XDAlertView clickToAlertViewTitle:@"评论成功" withDetailTitle:@"恭喜评论成功！" isDelegate:nil clickBlock:^(UIButton *btn) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshList" object:nil];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            }else {
                [XDAlertView clickToAlertViewTitle:@"评论失败" withDetailTitle:@"请重新提交评论！" isDelegate:nil clickBlock:nil];
            }
        }];
    }else {
        __weak typeof(self) weakSelf = self;
        [[XDAPIManager sharedManager] requestComplainEvalute:self.parameter CompletionHandle:^(id responseObject, NSError *error) {
            [MBProgressHUD hideHUD];
            if (error) {
                [XDAlertView clickToAlertViewTitle:@"评论失败" withDetailTitle:@"请重新提交评论！" isDelegate:nil clickBlock:nil];
                return ;
            }
            if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
                [XDAlertView clickToAlertViewTitle:@"评论成功" withDetailTitle:@"恭喜评论成功！" isDelegate:nil clickBlock:^(UIButton *btn) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshList" object:nil];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            }else {
                [XDAlertView clickToAlertViewTitle:@"评论失败" withDetailTitle:@"请重新提交评论！" isDelegate:nil clickBlock:nil];
            }
        }];
    }
}

- (void)handleFilter {
    if (![self.parameter containsObjectForKey:@"startTime"] || ![self.parameter containsObjectForKey:@"endTime"]) {
        [XDAlertView clickToAlertViewTitle:@"信息不完整" withDetailTitle:@"请输入完整的信息！" isDelegate:nil clickBlock:nil];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    if ([self.delegate respondsToSelector:@selector(filterParameter:)]) {
        [self.delegate filterParameter:self.parameter];
    }
    NSLog(@"self.parameter : %@", self.parameter);
}

- (NSArray*)getBigImageArray{
    return [self getBigImageArrayWithALAssetArray:self.originALAssetArray];
}

/**
 *  用来判断期望上门的时间是否比服务器给的时间大 如果等于yes 就符合要求 可以提交
 */
- (BOOL)setPlanTime:(NSString *)planTime systemTime:(NSString *)systemTime{
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *planData = [[NSDate alloc] init];
    planData = [dateformater dateFromString:planTime];
    NSDate *systemData = [[NSDate alloc] init];
    systemData = [dateformater dateFromString:systemTime];
    NSComparisonResult result = [planData compare:systemData];
    if (result == NSOrderedDescending || result == NSOrderedSame)
    {
        //递减或者相等，说明上门时间 比系统给我的时间大
        return  YES;
    }else {
        //递增，说明上门时间 比系统给我的时间小
        return NO;
    }
}

- (void)loadDataSource {
    [MBProgressHUD showActivityMessageInWindow:nil];
    dispatch_group_t group = dispatch_group_create();
    if (self.warrantyHomeViewControllerType == XDWarrantyHomeViewControllerTypeWarranty) {
        [self loadCurrentTimeWithDispatchGroup:group];
        [self loadAddressWithDispatchGroup:group];
        [self loadRepairTypeWithDispatchGroup:group];
    } else if (self.warrantyHomeViewControllerType == XDWarrantyHomeViewControllerTypeComplaint) {
        [self loadCurrentTimeWithDispatchGroup:group];
    } else if (self.warrantyHomeViewControllerType == XDWarrantyHomeViewControllerTypeFiltrate) {
        [self loadCurrentTimeWithDispatchGroup:group];
        [self loadWorkOrderTypeWithDispatchGroup:group];
    } else if (self.warrantyHomeViewControllerType == XDWarrantyHomeViewControllerTypeEvaluate) {

    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
        [self configDataSource];
    });
}

- (void)loadCurrentTimeWithDispatchGroup:(dispatch_group_t)dispatchGroup {
    __weak typeof(self) weakSelf = self;
    //获取当前时间加一小时
    NSDictionary *dic1 = @{@"addHour":@"1"};
    dispatch_group_enter(dispatchGroup);
    [[XDAPIManager sharedManager] requestGetNowDateParameters:dic1 CompletionHandle:^(id responseObject, NSError *error) {
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            weakSelf.currentServiceTimeAddHour = responseObject[@"data"];
            weakSelf.commitTime = weakSelf.currentServiceTimeAddHour;
        }
        dispatch_group_leave(dispatchGroup);
    }];
}

- (void)loadAddressWithDispatchGroup:(dispatch_group_t)dispatchGroup {
    //获取房屋地址
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSNumber *userId = loginModel.userInfo.userId;
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSDictionary *dic = @{@"userId":userId,
                          @"appTokenInfo":token,
                          @"appMobile":appMobile
                          };
    __weak typeof(self) weakSelf = self;
    dispatch_group_enter(dispatchGroup);
    [[XDAPIManager sharedManager] requestHouseOfAddressWithParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        if ([responseObject[@"resultCode"] isEqualToString:@"0"] ) {
            NSArray *addressEntityList = responseObject[@"data"][@"addressEntityList"];
            [weakSelf.roomArray addObjectsFromArray:addressEntityList];
            for (NSInteger i = 0; i < addressEntityList.count; i++) {
                NSDictionary *dic = addressEntityList[i];
                HZSingleChoiceModel *singleChoiceModel = [HZSingleChoiceModel new];
                singleChoiceModel.title = dic[@"name"];
                singleChoiceModel.typeCode = dic[@"id"];
                singleChoiceModel.selectedStatus = (i == 0);
                [weakSelf.roomChoiceArray addObject:singleChoiceModel];
            }
        }
        dispatch_group_leave(dispatchGroup);
    }];
}

- (void)loadRepairTypeWithDispatchGroup:(dispatch_group_t)dispatchGroup {
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSNumber *userId = loginModel.userInfo.userId;
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSDictionary *dic = @{@"userId":userId,
                          @"appTokenInfo":token,
                          @"appMobile":appMobile
                          };
    __weak typeof(self) weakSelf = self;
    dispatch_group_enter(dispatchGroup);
    //获取维修类型List
    [[XDAPIManager sharedManager] requesWarrantyOfTypeWithParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        if ([responseObject[@"resultCode"] isEqualToString:@"0"] ) {
            NSArray *repairsTypeEntityList = responseObject[@"data"][@"repairsTypeEntityList"];
            [weakSelf.repairTypeArray addObjectsFromArray:repairsTypeEntityList];
            for (NSInteger i = 0; i < repairsTypeEntityList.count; i++) {
                NSDictionary *dic = repairsTypeEntityList[i];
                HZSingleChoiceModel *singleChoiceModel = [HZSingleChoiceModel new];
                singleChoiceModel.title = dic[@"name"];
                singleChoiceModel.typeCode = dic[@"id"];
                singleChoiceModel.selectedStatus = i == repairsTypeEntityList.count - 1;
                [weakSelf.repairTypeChoiceArray addObject:singleChoiceModel];
            }
        }
        dispatch_group_leave(dispatchGroup);
    }];
}

#pragma mark - 加载工单类别
- (void)loadWorkOrderTypeWithDispatchGroup:(dispatch_group_t)dispatchGroup {
    //我的报修工单列表
    __weak typeof(self) weakSelf = self;
//    [MBProgressHUD showActivityMessageInWindow:nil];
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSDictionary *dic = @{@"appTokenInfo":token,
                          @"appMobile":appMobile,
                          };
    dispatch_group_enter(dispatchGroup);
    [[XDAPIManager sharedManager] requestWarrantyScreenTypeParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        if (error) {
//            [MBProgressHUD hideHUD];
            dispatch_group_leave(dispatchGroup);
            return ;
        }
        if ([responseObject[@"resultCode"] isEqualToString:@"0"] ) {
            NSArray *list = responseObject[@"data"];
            [weakSelf.workOrderTypeArray addObjectsFromArray:list];
            for (NSInteger i = 0; i < list.count; i++) {
                NSDictionary *dic = list[i];
                HZSingleChoiceModel *singleChoiceModel = [HZSingleChoiceModel new];
                singleChoiceModel.title = dic[@"name"];
                singleChoiceModel.typeCode = dic[@"id"];
                singleChoiceModel.selectedStatus = i == list.count - 1;
                [weakSelf.workOrderTypeChoiceArray addObject:singleChoiceModel];
            }
        }
        dispatch_group_leave(dispatchGroup);
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.itemArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.itemArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HZBaseModel *baseModel = self.itemArray[indexPath.section][indexPath.row];
    if (baseModel.baseType == HZBaseTypeAddImage) {
        HZBaseAddImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HZBaseAddImageTableViewCell class]) forIndexPath:indexPath];
        cell.delegate = self;
        cell.itemArray = baseModel.value;
        return cell;
    } else if (baseModel.baseType == HZBaseTypeEvaluate) {
        XDEvaluateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XDEvaluateTableViewCell class]) forIndexPath:indexPath];
        __weak typeof(self) weakSelf = self;
        [cell setTextBlock:^(NSString *text) {
            [weakSelf configEditWithBaseModel:baseModel code:text value:nil];
        }];
        return cell;
    }
    HZBaseListInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HZBaseListInfoTableViewCell class]) forIndexPath:indexPath];
    cell.baseModel = baseModel;
    __weak typeof(self) weakSelf = self;
    [cell setInputContentChangeBlock:^(NSString *content) {
        baseModel.value = content;
        [weakSelf configEditWithBaseModel:baseModel code:content value:nil];
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HZBaseModel *baseModel = self.itemArray[indexPath.section][indexPath.row];
    if (baseModel.baseType == HZBaseTypeTextWithArrow) {
        if (self.warrantyHomeViewControllerType == XDWarrantyHomeViewControllerTypeWarranty) {
            if (indexPath.row == 0) {
                NSLog(@"维修地点");
                [self choiceItemWithBaseModel:baseModel itemArray:self.roomChoiceArray];
            } else if (indexPath.row == 2) {
                [self choiceTime:self.commitTime baseModel:baseModel];
            } else if (indexPath.row == 3) {
                NSLog(@"联系人员");
                [self choiceContacts];
            } else if (indexPath.row == 4) {
                NSLog(@"维修类别");
                [self choiceItemWithBaseModel:baseModel itemArray:self.repairTypeChoiceArray];
            }
        } else if (self.warrantyHomeViewControllerType == XDWarrantyHomeViewControllerTypeComplaint) {
            if (indexPath.row == 0) {
                NSLog(@"紧急程度");
                [self choiceItemWithBaseModel:baseModel itemArray:self.complaintLevelChoiceArray];
            }
        } else if (self.warrantyHomeViewControllerType == XDWarrantyHomeViewControllerTypeFiltrate) {
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    [self choiceTime:self.commitTime baseModel:baseModel];
                } else if (indexPath.row == 1) {
                    [self choiceTime:self.commitTime baseModel:baseModel];
                }
            } else if (indexPath.section == 1) {
               if (indexPath.row == 0) {
                   NSLog(@"维修类别");
                   [self choiceItemWithBaseModel:baseModel itemArray:self.workOrderTypeChoiceArray];
                }
            }
        }
    } 
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.tableView endEditing:YES];
}

- (void)choiceItemWithBaseModel:(HZBaseModel *)baseModel itemArray:(NSArray *)itemArray{
    __block HZPopView *popView = [HZPopView new];
    CGFloat width = 300.f * kScreenWidth / 375.f;
    
    HZSingleChoiceListView *singleChoiceView = [HZSingleChoiceListView new];
    singleChoiceView.itemArray = [itemArray copy];
    @weakify(self)
     [singleChoiceView setChoiceResultBlock:^(id result) {
         @strongify(self)
         HZSingleChoiceModel *singleChioceModel = result;
         baseModel.value =singleChioceModel.title;
         [self.tableView reloadData];
         [popView diss];
         popView = nil;
         
         [self configEditWithBaseModel:baseModel code:singleChioceModel.typeCode value:singleChioceModel.title];
     }];
    
    [singleChoiceView setChoiceDismissBlock:^{
        @strongify(self)
        [popView diss];
        popView = nil;
    }];
    [popView popViewWithContenView:singleChoiceView inRect:CGRectMake(0, 0, width, width * 5.f / 6) inContainer:nil];
}

#pragma mark - 选择联系人
- (void)choiceContacts {
    XDChooseContactController *choose = [[XDChooseContactController alloc] init];
    choose.delegate = self;
    [self.navigationController pushViewController:choose animated:YES];
}

#pragma mark - 时间选择
- (void)choiceTime:(NSString *)time baseModel:(HZBaseModel *)baseModel {
    [self.view endEditing:YES];
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *nowData = [dateformater dateFromString:time];
    @weakify(self)
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute withUnitData:nowData CompleteBlock:^(NSDate *startDate) {
        @strongify(self)
        baseModel.value = [startDate stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
        [self configEditWithBaseModel:baseModel code:baseModel.value value:nil];
        [self.tableView reloadData];
    }];
    datepicker.doneButtonColor = UIColorHex(007cc2);//确定按钮的颜色
    [datepicker show];
}

#pragma mark - 相册视图
#pragma mark - 照片选择
-(void)pickerPhoto:(UIView *)view {
    if (self.originALAssetArray.count) {
        self.imagePickerSheet.arrSelected = [self.originALAssetArray mutableCopy];
    }
    [self.imagePickerSheet showImgPickerActionSheetInView:self popoverView:view];
}

- (void)deleteItemWithImageModel:(HZBaseImageModel *)imageModel indexPath:(NSIndexPath *)indexPath {
    [self.imageArray removeObject:imageModel];
    [self.originALAssetArray removeObjectAtIndex:indexPath.row];
    if (self.imageArray.count < 3) {
        HZBaseImageModel *baseImageModel = self.imageArray.lastObject;
        if (baseImageModel.source != nil) {
            HZBaseImageModel *imageModel = [HZBaseImageModel new];
            imageModel.source = nil;
            imageModel.baseSourceType = HZBaseSourceTypeNone;
            [self.imageArray addObject:imageModel];
        }
    }
    [self configDataSource];
}

-(void)getSelectImageWithALAssetArray:(NSArray *)ALAssetArray thumbnailImageArray:(NSArray *)thumbnailImgArray {
    [self.originALAssetArray removeAllObjects];
    [self.originALAssetArray addObjectsFromArray:[NSMutableArray arrayWithArray:ALAssetArray]];
    NSArray *imageDataArray = [[self getBigImageArrayWithALAssetArray:ALAssetArray] copy];
    
    NSMutableArray *imageArray = [NSMutableArray array];
    for (NSInteger i = 0; i < imageDataArray.count; i++) {
        HZBaseImageModel *imageModel = [HZBaseImageModel new];
        imageModel.baseSourceType = HZBaseSourceTypeImageData;
        imageModel.source = imageDataArray[i];
        [imageArray addObject:imageModel];
    }
    [self.imageArray removeAllObjects];
    [self.imageArray addObjectsFromArray:imageArray];
    if (self.imageArray.count < 3) {
        HZBaseImageModel *baseImageModel = self.imageArray.lastObject;
        if (baseImageModel.source != nil) {
            HZBaseImageModel *imageModel = [HZBaseImageModel new];
            imageModel.source = nil;
            imageModel.baseSourceType = HZBaseSourceTypeNone;
            [self.imageArray addObject:imageModel];
        }
    }
    [self configDataSource];
}

//获得大图
- (NSArray*)getBigImageArrayWithALAssetArray:(NSArray*)ALAssetArray{
    NSMutableArray *bigImgDataArray = [NSMutableArray array];
    for (int i = 0; i<ALAssetArray.count; i++) {
        if ([ALAssetArray[i] isKindOfClass:[UIImage class]]) {
            UIImage *img = ALAssetArray[i];
            NSData *imageData = UIImageJPEGRepresentation(img, 0.5);
            imageData = [KYCompressImage compressImage:imageData toByte:60*1024];
            [bigImgDataArray addObject:imageData];
        }else {
            ALAsset *set = ALAssetArray[i];
            [bigImgDataArray addObject:[self getBigIamgeDataWithALAsset:set]];
        }
    }
    return bigImgDataArray;
}

- (NSData *)getBigIamgeDataWithALAsset:(ALAsset*)set{
    // 需传入方向和缩放比例，否则方向和尺寸都不对
    UIImage *img = [UIImage imageWithCGImage:set.defaultRepresentation.fullResolutionImage
                                       scale:set.defaultRepresentation.scale
                                 orientation:(UIImageOrientation)set.defaultRepresentation.orientation];
    NSData *imageData = UIImageJPEGRepresentation(img, 0.5);
    imageData = [KYCompressImage compressImage:imageData toByte:60*1024];
    return imageData;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HZBaseModel *baseModel = self.itemArray[indexPath.section][indexPath.row];
    if (baseModel.baseType == HZBaseTypeTextView) {
        return 127.f;
    } else if (baseModel.baseType == HZBaseTypeAddImage) {
        if ([XDUtil isIPad]) {
            return 200.f;
        }
        return 130.f;
    }
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return DBL_EPSILON;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 8.f;
    }
    return DBL_EPSILON;
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

#pragma mark - 接收选择或输入数据
- (void)configEditWithBaseModel:(HZBaseModel *)baseModel code:(NSString *)code value:(NSString *)value{
    NSString *key = [self keyChange:baseModel.title];
    if ([key containsString:@"|"] && [code containsString:@"|"]) {
        NSArray *keyArray = [key componentsSeparatedByString:@"|"];
        NSArray *codeArray = [code componentsSeparatedByString:@"|"];
        [self configParameterWithKey:keyArray.firstObject value:codeArray.firstObject];
        [self configParameterWithKey:keyArray.lastObject value:codeArray.lastObject];
    } else {
        [self configParameterWithKey:key value:code];
    }
}

- (void)configParameterWithKey:(NSString *)key value:(NSString *)value {
    if ([key isEqualToString:@""] || key.length <= 0) {
        return;
    }
    if ([self.parameter.allKeys containsObject:key]) {
        [self.parameter setObject:value forKey:key];
    } else {
        self.parameter[key] = value;
    }
}

- (NSString *)keyChange:(NSString *)key {
    if (self.warrantyHomeViewControllerType == XDWarrantyHomeViewControllerTypeWarranty) {
        NSDictionary *dic = @{
                              @"业主房屋" : @"roomid",
                              @"维修地点：" : @"address",
                              @"上门时间：" : @"plandate",
                              @"联系人员：" : @"linkman|mobile",
                              @"维修类别：" : @"jobtypeid",
                              @"问题描述：" : @"problemdesc",
                              };
        return dic[key];
    } else if (self.warrantyHomeViewControllerType == XDWarrantyHomeViewControllerTypeComplaint) {
        NSDictionary *dic = @{
                              @"紧急程度：" : @"emerg",
                              @"投诉内容：" : @"content"
                              };
        return dic[key];
    } else if (self.warrantyHomeViewControllerType == XDWarrantyHomeViewControllerTypeFiltrate) {
        NSDictionary *dic = @{
                              @"开始时间：" : @"startTime",
                              @"结束时间：" : @"endTime",
                              @"工单类别：" : @"workOrderType",
                              @"投诉类别：" : @"complainTypeId",
                              };
        return dic[key];
    } else if (self.warrantyHomeViewControllerType == XDWarrantyHomeViewControllerTypeEvaluate) {
        NSDictionary *dic = @{
                              @"评分：" : @"commentLevel",
                              @"评价内容：" : @"commentContent",
                              };
        return dic[key];
    }
    return @"";
}

//移除通知
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 懒加载
- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
        
        HZBaseImageModel *baseImageModel = [[HZBaseImageModel alloc] init];
        baseImageModel.source = @"";
        baseImageModel.baseSourceType = HZBaseSourceTypeNone;
        
        [_imageArray addObjectsFromArray:@[baseImageModel]];
    }
    return _imageArray;
}

- (NSMutableArray *)originALAssetArray {
    if (!_originALAssetArray) {
        _originALAssetArray = [NSMutableArray array];
    }
    return _originALAssetArray;
}

- (HWImagePickerSheet *)imagePickerSheet {
    if (!_imagePickerSheet) {
        _imagePickerSheet = [HWImagePickerSheet new];
        _imagePickerSheet.delegate = self;
    }
    return _imagePickerSheet;
}

- (NSMutableArray *)roomArray {
    if (!_roomArray) {
        _roomArray = [NSMutableArray array];
    }
    return _roomArray;
}

- (NSMutableArray *)repairTypeArray {
    if (!_repairTypeArray) {
        _repairTypeArray = [NSMutableArray array];
    }
    return _repairTypeArray;
}

- (NSMutableArray *)roomChoiceArray {
    if (!_roomChoiceArray) {
        _roomChoiceArray = [NSMutableArray array];
    }
    return _roomChoiceArray;
}

- (NSMutableArray *)repairTypeChoiceArray {
    if (!_repairTypeChoiceArray) {
        _repairTypeChoiceArray = [NSMutableArray array];
    }
    return _repairTypeChoiceArray;
}

- (NSMutableDictionary *)parameter {
    if (!_parameter) {
        _parameter = [NSMutableDictionary dictionary];
    }
    return _parameter;
}

- (NSMutableArray *)complaintLevelArray {
    if (!_complaintLevelArray) {
        _complaintLevelArray = [[NSMutableArray alloc] initWithObjects:@"高",@"一般",@"低", nil];
    }
    return _complaintLevelArray;
}

- (NSMutableArray *)complaintLevelChoiceArray {
    if (!_complaintLevelChoiceArray) {
        _complaintLevelChoiceArray = [NSMutableArray array];
        for (NSInteger i = 0; i < self.complaintLevelArray.count; i++) {
            NSString *title = self.complaintLevelArray[i];
            HZSingleChoiceModel *singleChoiceModel = [HZSingleChoiceModel new];
            singleChoiceModel.title = title;
            singleChoiceModel.typeCode = title;
            singleChoiceModel.selectedStatus = i == self.complaintLevelArray.count - 1;
            [_complaintLevelChoiceArray addObject:singleChoiceModel];
        }
    }
    return _complaintLevelChoiceArray;
}

- (NSMutableArray *)workOrderTypeArray {
    if (!_workOrderTypeArray) {
        _workOrderTypeArray = [NSMutableArray array];
    }
    return _workOrderTypeArray;
}

- (NSMutableArray *)workOrderTypeChoiceArray {
    if (!_workOrderTypeChoiceArray) {
        _workOrderTypeChoiceArray = [NSMutableArray array];
    }
    return _workOrderTypeChoiceArray;
}

@end












