//
//  XDWarrantyDetailController.m
//  XD业主
//
//  Created by zc on 2017/6/21.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDWarrantyDetailController.h"
#import "XDWarrantyDetailCell.h"
#import "HBHomeSegmentNavigationBar.h"
#import "XDWarrantyDetailModelFrame.h"
#import "XDWarrantyDetailModel.h"
#import "XDWarrantyDetailFootView.h"
#import "XDMyWarratyHeaderView.h"
#import "XDProcessModel.h"
#import "XDWorkProgressSuperTableViewCell.h"
#import "XDWarrantyDetailPriceCell.h"
#import "XDEvaluateCommonCell.h"
#import "XDCommonEvaluteController.h"
#import "XDWarrantyDetailNetDataModel.h"
#import "XDWarrantyDetailPriceModel.h"
#import "XDWarrantyDetailEvaluateModel.h"
#import "XDWarrantyDetailProprietorInfoTableViewCell.h"
#import "XDWarrantyWorkProgressTableViewCell.h"
#import "XDContentEditTableViewCell.h"
#import "XDWarrantyOperationBtn.h"
#import "XDWorkProgressViewController.h"
#import "XDWarrantyEvaluateTableViewCell.h"
#import "XDComplainDetailNetModel.h"
#import "XDWarrantyHomeViewController.h"

#define KEY @"key"
#define VALUE @"value"
#define SUBKEY @"subKey"

static NSString * const kDetailProprietorInfoCell = @"kDetailProprietorInfoCell";
static NSString * const kWorkProgresCell = @"kWorkProgresCell";
static NSString * const kPriceCell = @"kPriceCell";
static NSString * const kTypeCell = @"kTypeCell";
static NSString * const kEvaluateCell = @"kEvaluateCell";

static NSString * const kCostOfLabor = @"kCostOfLabor";
static NSString * const kCostOfMaterials = @"kCostOfMaterials";
static NSString * const kCostOfTotal = @"kCostOfTotal";


@interface XDWarrantyDetailController ()
<
UITableViewDelegate,
UITableViewDataSource,
CustomAlertViewDelegate
>
{
    NSString      *_evaluteText; //评价的详细文字
}

//详情是否加载完毕
@property(nonatomic ,assign)BOOL isFinishDetail;
//进度是否加载完毕
@property(nonatomic ,assign)BOOL isFinishProcess;
//列表（详情）
@property (strong, nonatomic) UITableView *tableView;
//详情的头部
@property (strong , nonatomic)XDMyWarratyHeaderView *detailHead;
//数据模型
@property (nonatomic,strong) NSMutableArray *warrantyModelArray;
//用来判断warrantyModelArray这个数组中的模型的类型（添加模型的时候一定要同步按顺序添加）
@property (nonatomic,strong) NSMutableArray *modelTypeArray;
//尺寸数据模型
@property (nonatomic,strong) NSMutableArray *warrantyFrameArray;
//底部视图的类型（无，费用确认，评价）
@property (nonatomic,copy) NSString *footViewType;
//进度数据模型
@property (nonatomic,strong) NSMutableArray *processModelArray;
/** <##> */
@property (strong, nonatomic) XDWarrantyDetailNetDataModel *detailNetDataModel;


@end

@implementation XDWarrantyDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报单详情";
    self.view.backgroundColor = [UIColor whiteColor ];
    self.footViewType = self.jbpmOutcomes;
    @weakify(self)
    [self configNavigationRightItemWith:@"查看进度" andAction:^{
        @strongify(self)
        XDWorkProgressViewController *workProgressVC = [XDWorkProgressViewController new];
        workProgressVC.repairsId = self.repairsId;
        workProgressVC.warrantyPageType = self.warrantyPageType;
        [self.navigationController pushViewController:workProgressVC animated:YES];
    }];
//    //设置导航
    [self setupView];
//    //请求网络报修详情数据
    if (self.warrantyPageType == XDWarrantyPageTypeWorkOrder) {
        [self loadWarrantyListDetailNetData];
    } else {
        [self loadComplainListDetailNetData];
    }
}

- (void)setupView {
    //设置_tableView1的参数（详情）
    //设置UITableViewStyleGrouped这个样式footView就不会停留在底部
     UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight-NavHeight) style:UITableViewStylePlain];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.estimatedRowHeight = 80.f;
    tableView.tableFooterView = [UIView new];
    
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XDWarrantyDetailProprietorInfoTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XDWarrantyDetailProprietorInfoTableViewCell class])];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XDWarrantyWorkProgressTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XDWarrantyWorkProgressTableViewCell class])];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XDContentEditTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XDContentEditTableViewCell class])];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XDWarrantyEvaluateTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XDWarrantyEvaluateTableViewCell class])];

}

- (void)loadWarrantyListDetailNetData {
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSNumber *userId = loginModel.userInfo.userId;
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    
    NSDictionary *dic = @{@"repairsId":_repairsId,
                          @"userId":userId,
                          @"appTokenInfo":token,
                          @"appMobile":appMobile,
                          };
    __weak typeof(self) weakSelf = self;
    [[XDAPIManager sharedManager] requestWorkOrderDetailListParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        if ([responseObject[@"resultCode"] isEqualToString:@"0"] ) {
            weakSelf.isFinishDetail = YES;
            XDWarrantyDetailNetDataModel *netModel = [XDWarrantyDetailNetDataModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.detailNetDataModel = netModel;
            [weakSelf reSetUpTableViewcell:netModel];
        }else {
            [MBProgressHUD hideHUD];
        }
    }];
}

- (void)loadComplainListDetailNetData {
    [MBProgressHUD showActivityMessageInWindow:nil];
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSNumber *userId = loginModel.userInfo.userId;
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSDictionary *dic = @{@"complainId":self.repairsId,
                          @"userId":userId,
                          @"appTokenInfo":token,
                          @"appMobile":appMobile,
                          };
    __weak typeof(self) weakSelf = self;
    [[XDAPIManager sharedManager] requestComplainOfDetailsWithParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        [MBProgressHUD hideHUD];
        if (error) {
            return ;
        }
        if ([responseObject[@"resultCode"] isEqualToString:@"0"] ) {
            weakSelf.isFinishDetail = YES;
            XDComplainDetailNetModel *netModel = [XDComplainDetailNetModel mj_objectWithKeyValues:responseObject[@"data"]];
            [weakSelf refreshTableViewcell:netModel];
        }else {
            [MBProgressHUD hideHUD];
        }
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.warrantyModelArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.warrantyModelArray[indexPath.section];
    if ([dic[KEY] isEqualToString:kDetailProprietorInfoCell]) {
        XDWarrantyDetailProprietorInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XDWarrantyDetailProprietorInfoTableViewCell class]) forIndexPath:indexPath];
        cell.userinfoNetModel = dic[VALUE];
        return cell;
    } else if ([dic[KEY] isEqualToString:kWorkProgresCell]) {
        XDWarrantyWorkProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XDWarrantyWorkProgressTableViewCell class]) forIndexPath:indexPath];
        cell.dictionary = dic[VALUE];
        return cell;
    } else if ([dic[KEY] isEqualToString:kPriceCell] || [dic[KEY] isEqualToString:kTypeCell]) {
        XDContentEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XDContentEditTableViewCell class]) forIndexPath:indexPath];
        cell.dictionary = dic;
        return cell;
    } else if ([dic[KEY] isEqualToString:kEvaluateCell]) {
        XDWarrantyEvaluateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XDWarrantyEvaluateTableViewCell class]) forIndexPath:indexPath];
        cell.warrantyDetailNetDataModel = dic[VALUE];
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSDictionary *dic = self.warrantyModelArray[section];
    if ([dic[KEY] isEqualToString:kWorkProgresCell] || [dic[KEY] isEqualToString:kTypeCell]) {
        return [UIView new];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    NSDictionary *dic = self.warrantyModelArray[section];
    if ([dic[KEY] isEqualToString:kWorkProgresCell]) {
        return 8.f;
    } else if ([dic[KEY] isEqualToString:kTypeCell]) {
        return 10.f;
    }
    return DBL_EPSILON;
}

#pragma  mark -- 提交是否接受价格
- (void)CommitWouldAcceptFee:(NSString *)accept {

    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showActivityMessageInWindow:nil];
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSNumber *userId = loginModel.userInfo.userId;
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    
    NSDictionary *dic = @{@"workOrderId":weakSelf.repairsId,
                          @"taskId":weakSelf.taskid,
                          @"outcome":@"是否接受价格",
                          @"accept":accept,
                          @"userId":userId,
                          @"appTokenInfo":token,
                          @"appMobile":appMobile,
                          };
    
    [[XDAPIManager sharedManager] requestWarrantyAcceptFee:dic CompletionHandle:^(id responseObject, NSError *error) {
        if (error) {
            [XDAlertView clickToAlertViewTitle:@"提交失败" withDetailTitle:@"请检查网络情况！" isDelegate:nil clickBlock:nil];
            [MBProgressHUD hideHUD];
            return ;
        }
        if ([responseObject[@"resultCode"] isEqualToString:@"0"] ) {
            [MBProgressHUD hideHUD];
            [XDAlertView clickToAlertViewTitle:@"提交成功" withDetailTitle:@"您的数据已提交成功！" isDelegate:self clickBlock:nil];
        }else {
            [MBProgressHUD hideHUD];
            [XDAlertView clickToAlertViewTitle:@"提交失败" withDetailTitle:@"请重新提交！" isDelegate:nil clickBlock:nil];
        }
    }];
}

#pragma  mark -- 提交是否满意
- (void)CommitWouldManYi:(NSString *)isLike {
    [MBProgressHUD showActivityMessageInWindow:nil];
    __weak typeof(self) weakSelf = self;
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSNumber *userId = loginModel.userInfo.userId;
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSDictionary *dic = @{@"complainid":weakSelf.repairsId,
//                          @"piid":weakSelf.piid,
                          @"taskId":weakSelf.taskid,
                          @"outcome":@"是否满意",
                          @"satisfaction":isLike,
                          @"ownerId":userId,
                          @"appTokenInfo":token,
                          @"appMobile":appMobile,
                          };
    [[XDAPIManager sharedManager] requestIsManYiEvalute:dic CompletionHandle:^(id responseObject, NSError *error) {
        [MBProgressHUD hideHUD];
        if (error) {
            [XDAlertView clickToAlertViewTitle:@"提交失败" withDetailTitle:@"请检查网络情况！" isDelegate:nil clickBlock:nil];
            return ;
        }
        if ([responseObject[@"resultCode"] isEqualToString:@"0"] ) {
            weakSelf.taskid = responseObject[@"data"][@"taskId"];
            if ([isLike isEqualToString:@"1"]) {
                [weakSelf toEvaluteVC];
            } else {
                [XDAlertView clickToAlertViewTitle:@"提交成功" withDetailTitle:@"您的数据已提交成功！" isDelegate:self clickBlock:nil];
            }
        } else {
            [XDAlertView clickToAlertViewTitle:@"提交失败" withDetailTitle:@"请重新提交！" isDelegate:nil clickBlock:nil];
        }
    }];
}

#pragma  mark -- 提交是否接受接受整改
- (void)CommitWouldMeaSure:(NSString *)isLike {
    [MBProgressHUD showActivityMessageInWindow:nil];
    __weak typeof(self) weakSelf = self;
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSNumber *userId = loginModel.userInfo.userId;
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSDictionary *dic = @{@"complainid":weakSelf.repairsId,
                          @"taskId":weakSelf.taskid,
                          @"outcome":@"业主是否接受整改",
                          @"accept":isLike,
                          @"ownerId":userId,
                          @"appTokenInfo":token,
                          @"appMobile":appMobile,
                          };
    
    [[XDAPIManager sharedManager] requestIsMeaSure:dic CompletionHandle:^(id responseObject, NSError *error) {
        [MBProgressHUD hideHUD];
        if (error) {
            [XDAlertView clickToAlertViewTitle:@"提交失败" withDetailTitle:@"请检查网络情况！" isDelegate:nil clickBlock:nil];
            return ;
        }
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]){
            [XDAlertView clickToAlertViewTitle:@"提交成功" withDetailTitle:@"您的数据已提交成功！" isDelegate:self clickBlock:nil];
        }else {
            [XDAlertView clickToAlertViewTitle:@"提交失败" withDetailTitle:@"请重新提交！" isDelegate:nil clickBlock:nil];
        }
    }];
}

- (void)clickButtonWithTag:(UIButton *)button {
    __weak typeof(self) weakSelf = self;
    if (weakSelf.backToRefresh) {
        weakSelf.backToRefresh();
    }
    [weakSelf.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)evaluteCellHeight:(NSString *)evaluteString {
    CGFloat Width = kScreenWidth - WMargin * 2;
    CGSize evaluteLabelSize = [evaluteString boundingRectWithSize:CGSizeMake(Width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttributes context:nil].size;
    CGFloat evaluteLabelSizeH = evaluteLabelSize.height;
    return evaluteLabelSizeH + HMargin*2 +28;
}

- (void)refreshTableViewcell:(XDComplainDetailNetModel *)model {
    // 0--业主、 1--报修问题 2--员工检视（现场情况）、 3--确定费用 4--处理后显示 5--评价
    //业主的报事报修
    [self.warrantyModelArray addObject:@{KEY : kDetailProprietorInfoCell, VALUE : model.UserInfo}];
    NSDictionary *repairBaseInfo = @{
                                     @"title" : model.complainType,
                                     @"status" : model.complainStatus,
                                     @"content" : model.complainDes,
                                     @"time" : model.complainDateTime,
                                     @"images" : model.complainImageUrlList
                                     };
    [self.warrantyModelArray addObject:@{KEY : kWorkProgresCell, VALUE : repairBaseInfo}];
    //如果现场的描述不是空的 就添加
    if (![XDUtil stringIsEmpty:model.checkContent]) {
        NSDictionary *repairBaseInfo = @{
                                         @"title" : @"现场情况",
                                         @"status" : [NSString stringWithFormat:@"处理人：%@", model.deparmentLeader],
                                         @"content" : model.checkContent,
                                         @"time" : model.solutionDate,
                                         @"images" : model.managercheckpic
                                         };
        [self.warrantyModelArray addObject:@{KEY : kWorkProgresCell, VALUE : repairBaseInfo}];
    }
    //判断处理结果
    if (![XDUtil stringIsEmpty:model.solutionContent]) {
        NSDictionary *repairBaseInfo = @{
                                         @"title" : @"解决方案",
                                         @"status" : @"",
                                         @"content" : model.solutionContent,
                                         @"time" : model.empSolutionDate,
                                         @"images" : model.empSolutionPic
                                         };
        [self.warrantyModelArray addObject:@{KEY : kWorkProgresCell, VALUE : repairBaseInfo}];

    }
    
    [self configFootView];
    [self.tableView reloadData];
}
/**
 *  重新设置cell的显示
 */
- (void)reSetUpTableViewcell:(XDWarrantyDetailNetDataModel *)model {
    // 0--业主、 1--报修问题 2--员工检视（现场情况）、 3--确定费用 4--处理后显示 5--评价
    //业主的报事报修
    [self.warrantyModelArray addObject:@{KEY : kDetailProprietorInfoCell, VALUE : model.UserInfo}];
    NSDictionary *repairBaseInfo = @{
                          @"title" : model.repairsType,
                          @"status" : model.repairsStatus,
                          @"content" : model.title,
                          @"time" : model.plandate,
                          @"images" : model.piclist
                          };
    [self.warrantyModelArray addObject:@{KEY : kWorkProgresCell, VALUE : repairBaseInfo}];
    
    //如果现场的描述不是空的 就添加
    if (model.workOrderStatus >= XDWorkOrderStatusOnSiteChecking && (model.workOrderStatus != XDWorkOrderStatusRegulatorUnTakeOrder && model.workOrderStatus != XDWorkOrderStatusBranchLeaderTakeOrder)) {
        NSDictionary *repairBaseInfo = @{
                                         @"title" : @"现场情况",
                                         @"status" : [NSString stringWithFormat:@"处理人：%@", model.disposePerson],
                                         @"content" : model.liveContentDesc,
                                         @"time" : model.livedate,
                                         @"images" : model.newpiclist
                                         };
        [self.warrantyModelArray addObject:@{KEY : kWorkProgresCell, VALUE : repairBaseInfo}];
    }
    //询价
    if (model.workOrderStatus == XDWorkOrderStatusEnquiry && (model.workOrderStatus != XDWorkOrderStatusRegulatorUnTakeOrder && model.workOrderStatus != XDWorkOrderStatusBranchLeaderTakeOrder)) {
        [self.warrantyModelArray addObject:@{KEY : kPriceCell, VALUE : @{@"title" : @"人工费用", @"content" : [NSString stringWithFormat:@"%ld", model.manualCost]}, SUBKEY : @(XDContentEditTypeInput)}];
        
        [self.warrantyModelArray addObject:@{KEY : kPriceCell, VALUE : @{@"title" : @"材料费用", @"content" : [NSString stringWithFormat:@"%ld", model.materialCost]}, SUBKEY : @(XDContentEditTypeInput)}];

        [self.warrantyModelArray addObject:@{KEY : kPriceCell, VALUE : @{@"title" : @"共计费用", @"content" : [NSString stringWithFormat:@"%ld", model.totalCost]}, SUBKEY : @(XDContentEditTypeInput)}];
    }
    
    //判断处理结果
    if (model.workOrderStatus >= XDWorkOrderStatusCompleted  && (model.workOrderStatus != XDWorkOrderStatusRegulatorUnTakeOrder && model.workOrderStatus != XDWorkOrderStatusBranchLeaderTakeOrder)) {
        NSDictionary *repairBaseInfo = @{
                                         @"title" : @"处理结果",
                                         @"status" : @"",
                                         @"content" : model.disposeDes,
                                         @"time" : model.completeTime,
                                         @"images" : model.handerpiclist
                                         };
        [self.warrantyModelArray addObject:@{KEY : kWorkProgresCell, VALUE : repairBaseInfo}];
    }
    //判断有没有评论
    if (model.workOrderStatus >= XDWorkOrderStatusEvaluate && (model.workOrderStatus != XDWorkOrderStatusRegulatorUnTakeOrder && model.workOrderStatus != XDWorkOrderStatusBranchLeaderTakeOrder)) {
        XDWarrantyDetailEvaluateModel *model4 = [[XDWarrantyDetailEvaluateModel alloc] init];
        model4.commentLevel = model.commentLevel;
        model4.commentContent = model.commentContent;
        [self.warrantyModelArray addObject:@{KEY : kEvaluateCell, VALUE : model}];
    }
    [self configFootView];
    [self.tableView reloadData];
}

- (void)configFootView {
    if ([XDUtil stringIsEmpty:self.footViewType]) {
        return;
    }
    XDWarrantyOperationBtn *operationBtn = [XDWarrantyOperationBtn loadFromNib];
    operationBtn.frame = CGRectMake(0, 0, kScreenWidth, 102.f);
    __weak typeof(self) weakSelf = self;
    [operationBtn setClickOperationBlock:^(XDClickType clickType) {
        [weakSelf clickOperationClickType:clickType];
    }];
    if ([self.footViewType isEqualToString:@"是否满意"]) {
        //是否满意
        operationBtn.operationBtnType = XDWarrantyOperationBtnTypeDouble;
        operationBtn.leftBtnTitle = @"不满意";
        operationBtn.rightBtnTitle = @"满意";
    }else if ([self.footViewType isEqualToString:@"评价"]) {
        //评价
        operationBtn.operationBtnType = XDWarrantyOperationBtnTypeSingle;
        operationBtn.singleBtnTitle = @"评价";
    }else if ([self.footViewType isEqualToString:@"业主是否接受整改"]) {
        //是否整改
        operationBtn.operationBtnType = XDWarrantyOperationBtnTypeDouble;
        operationBtn.leftBtnTitle = @"不接受";
        operationBtn.rightBtnTitle = @"接受";
    }else {
        //拒绝方案--是否接受
        operationBtn.operationBtnType = XDWarrantyOperationBtnTypeDouble;
        operationBtn.leftBtnTitle = @"不接受";
        operationBtn.rightBtnTitle = @"接受";
    }
    self.tableView.tableFooterView = operationBtn;
}

- (void)clickOperationClickType:(XDClickType)clickType {
    if (clickType == XDClickTypeCenter) {
        [self toEvaluteVC];
    } else {
        if ([self.footViewType isEqualToString:@"是否接受"]) {
            [self CommitWouldAcceptFee:[NSString stringWithFormat:@"%ld", clickType - 1]];
        }
        if ([self.footViewType isEqualToString:@"是否满意"]) {
            [self CommitWouldManYi:[NSString stringWithFormat:@"%ld", clickType - 1]];
        }
        if ([self.footViewType isEqualToString:@"业主是否接受整改"]) {
            [self CommitWouldMeaSure:[NSString stringWithFormat:@"%ld", clickType - 1]];
        }
    }
}

- (void)toEvaluteVC {
    XDWarrantyHomeViewController *evalute = [[XDWarrantyHomeViewController alloc] init];
    evalute.ID = [NSString stringWithFormat:@"%@", self.repairsId];
    evalute.warrantyHomeViewControllerType = XDWarrantyHomeViewControllerTypeEvaluate;
    evalute.taskId = self.taskid;
    evalute.title = self.warrantyPageType == XDWarrantyPageTypeWorkOrder ? @"工单评价" : @"投诉评价";
    [self.navigationController pushViewController:evalute animated:YES];
}

- (NSMutableArray *)modelTypeArray {
    if (!_modelTypeArray) {
        self.modelTypeArray = [NSMutableArray array];
    }
    return _modelTypeArray;
}

- (NSMutableArray *)processModelArray {
    if (!_processModelArray) {
        self.processModelArray = [NSMutableArray array];
    }
    return _processModelArray;
}

- (NSMutableArray *)warrantyModelArray{
    if (!_warrantyModelArray) {
        self.warrantyModelArray = [NSMutableArray array];
    }
    return _warrantyModelArray;
}

- (NSMutableArray *)warrantyFrameArray {
    if (!_warrantyFrameArray) {
        self.warrantyFrameArray = [NSMutableArray array];
    }
    return _warrantyFrameArray;
}


- (void)dealloc {

}
@end
