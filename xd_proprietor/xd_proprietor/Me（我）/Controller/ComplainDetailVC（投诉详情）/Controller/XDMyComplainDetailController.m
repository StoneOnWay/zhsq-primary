//
//  XDMyComplainDetailController.m
//  XD业主
//
//  Created by zc on 2017/6/21.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDMyComplainDetailController.h"
#import "XDMyComplainHeaderView.h"
#import "HBHomeSegmentNavigationBar.h"
#import "XDComplainDetailCell.h"
#import "XDComplainDetailModelFrame.h"
#import "XDComplainDetailModel.h"
#import "XDDisposeMenCell.h"
#import "XDComplainDetailFootView.h"
#import "XDWorkProgressSuperTableViewCell.h"
#import "XDProcessModel.h"
#import "XDEvaluateCommonCell.h"
#import "XDComplainDetailNetModel.h"
#import "XDUserinfoNetModel.h"
#import "XDComplainDetailDisposeModel.h"
#import "XDComplainDetailEvaluteModel.h"
#import "XDCommonEvaluteController.h"

@interface XDMyComplainDetailController ()
<
UITableViewDelegate,
UITableViewDataSource,
UIScrollViewDelegate,
HBHomeSegmentNavigationBarDelegate,
CustomAlertViewDelegate
>
{
    UIScrollView *_scrollView;//滑动视图
    NSString      *_evaluteText; //评价的详细文字
    
}
//详情是否加载完毕
@property(nonatomic ,assign)BOOL isFinishDetail;
//进度是否加载完毕
@property(nonatomic ,assign)BOOL isFinishProcess;

//进度／详情
@property (strong , nonatomic)HBHomeSegmentNavigationBar * segment;

//列表（详情）
@property (strong , nonatomic)UITableView   *tableView1;

//列表（进度）
@property (strong , nonatomic)UITableView   *tableView2;

//数据模型
@property (nonatomic,strong) NSMutableArray *complainModelArray;

//用来判断complainModelArray这个数组中的模型是那种模型的
@property (nonatomic,strong) NSMutableArray *complainModelType;
//详情的头部
@property (strong , nonatomic)XDMyComplainHeaderView *detailHead;

//底部视图的类型（无，方案，评价，整改，满意）
@property (nonatomic,copy) NSString *footViewType;

//进度数据模型
@property (nonatomic,strong) NSMutableArray *processModelArray; //ViewModel(包含cell子控件的Frame)


@end

@implementation XDMyComplainDetailController

- (NSMutableArray *)processModelArray {
    if (!_processModelArray) {
        self.processModelArray = [NSMutableArray array];
      
    }
    return _processModelArray;
}

- (NSMutableArray *)complainModelArray{
    if (!_complainModelArray) {
        self.complainModelArray = [NSMutableArray array];
     
    }
    return _complainModelArray;
}

- (NSMutableArray *)complainModelType {
    if (!_complainModelType) {
        
        self.complainModelType = [NSMutableArray array];

    }
    return _complainModelType;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backColor;
    
    //底部视图的类型（ @""，方案，评价，整改，满意）
    _footViewType = @"";
    
    //设置导航栏
    [self setComplainDetailNavi];
    
    //加载子控制器
    [self setUpComplainDetailSubViews];
 
    //请求网络报修详情数据
    [self loadComplainListDetailNetData];
    
    //请求网络报修进度数据
    [self loadComplainListProcessNetData];
}
- (void)loadComplainListProcessNetData {
    
    [MBProgressHUD showActivityMessageInWindow:nil];
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    //    NSNumber *userId = loginModel.userInfo.userId;
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    
    NSDictionary *dic = @{@"complainId":_complainId,
                          @"appTokenInfo":token,
                          @"appMobile":appMobile,
                          };
    [[XDAPIManager sharedManager] requestComplainProcessWithParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        if (error) {
            [MBProgressHUD hideHUD];
        }
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"] ) {
            
            _isFinishProcess = YES;
            NSArray *arrayDic = responseObject[@"data"];
            __weak typeof(self) weakSelf = self;
            for (int i=0 ; i<arrayDic.count; i++) {
                
                XDProcessModel *processModel = [XDProcessModel mj_objectWithKeyValues:arrayDic[i]];
                [weakSelf.processModelArray addObject:processModel];
            }
            if (weakSelf.isFinishDetail) {
                [MBProgressHUD hideHUD];
            }
            [weakSelf.tableView2 reloadData];
            //添加tableView2头部视图
            UIView *head2 = [[NSBundle mainBundle] loadNibNamed:@"XDHeaderProcessView" owner:nil options:nil ].lastObject;
            _tableView2.tableHeaderView = head2;
        
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
    
    NSDictionary *dic = @{@"complainId":_complainId,
                          @"userId":userId,
                          @"appTokenInfo":token,
                          @"appMobile":appMobile,
                          };
    
    __weak typeof(self) weakSelf = self;
    [[XDAPIManager sharedManager] requestComplainOfDetailsWithParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        if (error) {
            [MBProgressHUD hideHUD];
            return ;
        }

        if ([responseObject[@"resultCode"] isEqualToString:@"0"] ) {
        
            weakSelf.isFinishDetail = YES;
            XDComplainDetailNetModel *netModel = [XDComplainDetailNetModel mj_objectWithKeyValues:responseObject[@"data"]];
            
            [weakSelf reSetUpComplainTableViewcell:netModel];
        }else {
        
            [MBProgressHUD hideHUD];
        }

        
    }];


}
/**
 *  重新设置cell的显示
 */
- (void)reSetUpComplainTableViewcell:(XDComplainDetailNetModel *)model {
    __weak typeof(self) weakSelf = self;
    
    /**
     // 0--自适应(XDComplainDetailModel)、 1--处理人那种、 2--评价 这三种模型
    */
    //业主自己的投诉
    XDComplainDetailModel *model0 = [[XDComplainDetailModel alloc] init];
    model0.title = model.complainType;
    model0.time = model.complainDateTime;
    model0.text = model.complainDes;
    model0.photos = model.complainImageUrlList;
    model0.finishText = model.complainStatus;
    XDComplainDetailModelFrame *modelFrame = [[XDComplainDetailModelFrame alloc] init];
    modelFrame.complainModel = model0;
    [weakSelf.complainModelArray addObject:modelFrame];
    [weakSelf.complainModelType addObject:@"0"];

    //判断显示现场情况
    if (![model.checkContent isEqualToString:@""]) {
        
        XDComplainDetailModel *model1 = [[XDComplainDetailModel alloc] init];
        model1.title = @"现场情况";
        model1.time = model.complainDateTime;
        model1.text = model.checkContent;
        model1.photos = model.managercheckpic;
        XDComplainDetailModelFrame *modelFrame = [[XDComplainDetailModelFrame alloc] init];
        modelFrame.complainModel = model1;
        [weakSelf.complainModelArray addObject:modelFrame];
        [weakSelf.complainModelType addObject:@"0"];
        
        
    }
    //判断解决方案
    if (![model.solutionContent isEqualToString:@""]) {
        XDComplainDetailModel *model2 = [[XDComplainDetailModel alloc] init];
        model2.title = @"解决方案";
        model2.time = model.solutionDate;
        model2.text = model.solutionContent;
        XDComplainDetailModelFrame *modelFrame = [[XDComplainDetailModelFrame alloc] init];
        modelFrame.complainModel = model2;
        [weakSelf.complainModelArray addObject:modelFrame];
        [weakSelf.complainModelType addObject:@"0"];
    }
    
    
    if (![model.empHandler isEqualToString:@""]) {
        XDComplainDetailDisposeModel *disposeModel = [[XDComplainDetailDisposeModel alloc] init];
        disposeModel.disposeName = model.empHandler;
        [weakSelf.complainModelArray addObject:disposeModel];
        [weakSelf.complainModelType addObject:@"1"];
        
    }
    
    if (![model.empSolutionContent isEqualToString:@""]) {
        XDComplainDetailModel *resultModel = [[XDComplainDetailModel alloc] init];
        resultModel.title = @"处理结果";
        resultModel.time = model.empSolutionDate;
        resultModel.text = model.empSolutionContent;
        resultModel.photos = model.empSolutionPic;
        XDComplainDetailModelFrame *modelFrame = [[XDComplainDetailModelFrame alloc] init];
        modelFrame.complainModel = resultModel;
        [weakSelf.complainModelArray addObject:modelFrame];
        [weakSelf.complainModelType addObject:@"0"];
        
    }
    if (![model.measureContent isEqualToString:@""]) {
        XDComplainDetailModel *model2 = [[XDComplainDetailModel alloc] init];
        model2.title = @"整改措施";
        model2.time = model.measureDate;
        model2.text = model.measureContent;
        XDComplainDetailModelFrame *modelFrame = [[XDComplainDetailModelFrame alloc] init];
        modelFrame.complainModel = model2;
        [weakSelf.complainModelArray addObject:modelFrame];
        [weakSelf.complainModelType addObject:@"0"];
        
    }
    
    if (![model.commentContent isEqualToString:@""]) {
        XDComplainDetailEvaluteModel *model4 = [[XDComplainDetailEvaluteModel alloc] init];
        model4.commentLevel = model.commentLevel;
        model4.commentContent = model.commentContent;
        [weakSelf.complainModelArray addObject:model4];
        [weakSelf.complainModelType addObject:@"2"];
    }

    
    [weakSelf reSetUpTableViewHead:model.UserInfo];
    weakSelf.footViewType = weakSelf.jbpmOutcomes;
    [weakSelf.tableView1 reloadData];
    if (weakSelf.isFinishProcess) {
        [MBProgressHUD hideHUD];
    }
    
    
}

/**
 *  重新设置详情头部的信息
 */
- (void)reSetUpTableViewHead:(XDUserinfoNetModel *)model {
    __weak typeof(self) weakSelf = self;
    //添加tableView1的头部视图
    XDMyComplainHeaderView *head1 = [[NSBundle mainBundle] loadNibNamed:@"XDMyComplainHeaderView" owner:nil options:nil ].lastObject;
    weakSelf.detailHead = head1;
    
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSString *nickName = [ud objectForKey:@"nickName"];
//    if (nickName != nil) {
//        head1.nameText = nickName;
//    }else {
//        head1.nameText = model.userName;
//    }
    head1.nameText = model.userName;
    head1.addressText = model.userRoomAddress;
    head1.roomAddress = model.atProperty;
    head1.phoneNumber = model.userMobileNo;
    head1.iconUrl = model.userHearImageUrl;
    
    weakSelf.tableView1.tableHeaderView = head1;
    
    
}


/**
 *  设置导航栏
 */
-(void)setComplainDetailNavi{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font = CFont(19, 17);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"投诉详情";
    self.navigationItem.titleView = titleLabel;
    
    
}
#pragma mark -- 加载子控制器
- (void)setUpComplainDetailSubViews {
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0 + self.segment.frame.size.height,kScreenWidth,kScreenHeight)];
    _scrollView.contentSize = CGSizeMake(kScreenWidth * 2, 0);
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.tag = 1000;
    [self.view addSubview:_scrollView];
    
    
    //设置_tableView1的参数（详情）
    _tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight-64-_segment.bounds.size.height) style:UITableViewStyleGrouped];
    _tableView1.tag = 1;
    _tableView1.delegate = self;
    _tableView1.dataSource = self;
    _tableView1.backgroundColor = backColor;
    _tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:_tableView1];

    
    //设置_tableView2的参数（进度）
    _tableView2 = [[UITableView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight-64-_segment.bounds.size.height)];
    _tableView2.tag = 2;
    _tableView2.delegate = self;
    _tableView2.dataSource = self;
    _tableView2.backgroundColor = backColor;
    _tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_scrollView addSubview:_tableView2];
    
    
    
    
}


- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    CGRect segmentRect = self.segment.frame;
    segmentRect.size.width = kScreenWidth;
    self.segment.frame = segmentRect;
    
}
#pragma mark -- 顶部菜单
- (HBHomeSegmentNavigationBar *)segment{
    if (!_segment) {
        _segment = [[HBHomeSegmentNavigationBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35) items:@[@"详情",@"进度"] withDelegate:self];
        _segment.backgroundColor = backColor;
        _segment.deSelectColor = BianKuang;//选中时的颜色
        _segment.defualtCololr =[UIColor grayColor];//不选择颜色
        _segment.currentIndex = 0;//默认定位在
        [self.view addSubview:_segment];
    }
    return _segment;
}

#pragma mark - UIScrollViewDelegate
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.tag == 1000) {
        CGPoint point = self.segment.lineView.frame.origin;
        
        if (scrollView.contentSize.width !=0) {
            point.x = self.segment.bounds.size.width* (scrollView.contentOffset.x/scrollView.contentSize.width);
            if (point.x >=0 &&point.x <= kScreenWidth/2) {
                self.segment.pointX = point.x;
            }
            
        }
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.tag == 1000) {
        CGPoint point = self.segment.lineView.frame.origin;
        
        self.segment.currentIndex = (long)point.x/(long)self.segment.lineView.bounds.size.width;
    }
    
}

#pragma mark - HBHomeSegmentNavigationBarDelegate
- (void)deSelectIndex:(NSInteger)index withSegmentBar:(HBHomeSegmentNavigationBar *)segmentBar{
    
    [_scrollView setContentOffset:CGPointMake(kScreenWidth*index, 0) animated:YES];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_tableView1 == tableView) {
        return self.complainModelArray.count ;
    }else {
    
        return self.processModelArray.count ;
   
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _tableView1) {
        
        NSString *typeString = self.complainModelType[indexPath.row];
        if ([typeString isEqualToString:@"0"]) {
            //这个是显示图片种类的cell
            XDComplainDetailCell *cell = [XDComplainDetailCell cellWithTableView:tableView];
            XDComplainDetailModelFrame *complainFrame = self.complainModelArray[indexPath.row];
            cell.complainFrames = complainFrame;
            
            
            return cell;
            
            
        }else if ([typeString isEqualToString:@"1"]) {
            //这个是那个处理人张三那一行
            XDDisposeMenCell *cell = [XDDisposeMenCell cellWithTableView:tableView];
            XDComplainDetailDisposeModel *disModel = self.complainModelArray[indexPath.row];
            cell.disposeName.text = disModel.disposeName;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }else {
            //评价的
            //这个是评价
            XDEvaluateCommonCell *cell = [XDEvaluateCommonCell cellWithTableView:tableView];
            XDComplainDetailEvaluteModel *model = self.complainModelArray[indexPath.row];
            cell.evaluteString = model.commentContent;
            _evaluteText = model.commentContent;
            cell.currentScore = [model.commentLevel floatValue];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }

        
    }else {
    
        XDProcessModel *model = self.processModelArray[indexPath.row];
        
        NSString  * identifier;
        if ([model.handlertype isEqualToString:@"0"]) {//右边
            
            identifier = @"XDWorkProgressRightTableViewCell";
            
        }else{//左边
            identifier = @"XDWorkProgressLeftTableViewCell";
            
        }
        XDWorkProgressSuperTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil].lastObject;
        }
        cell.selectionStyle = 0;
        cell.timeLabel.text = model.planDateTime;
        cell.statusLabel.text = model.planName;
        cell.pointImage.image = model.notAcceptable ==1 ? [UIImage imageNamed:@"tsxq_dian"]:[UIImage imageNamed:@"tsxq_dian_hui"];
        
        return cell;
    
    
    }
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _tableView1) {
        
        NSString *typeString = self.complainModelType[indexPath.row];
        if ([typeString isEqualToString:@"0"]) {
            //这个是显示图片种类的cell
            XDComplainDetailModelFrame *modelFrame = self.complainModelArray[indexPath.row];
            
            return modelFrame.cellHeight;
            
        }else if ([typeString isEqualToString:@"1"]) {
            //这个是那个处理人张三那一行
            return 40;
        }else {
        //评价的
            return [self evaluteCompCellHeight:_evaluteText];
        }
       
        
    }else {
    
        return 65;
    }
    
    
}

- (CGFloat)evaluteCompCellHeight:(NSString *)evaluteString {
    
    CGFloat Width = kScreenWidth - WMargin * 2;
    CGSize evaluteLabelSize = [evaluteString boundingRectWithSize:CGSizeMake(Width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:textAttributes context:nil].size;
    CGFloat evaluteLabelSizeH = evaluteLabelSize.height;
    
    return evaluteLabelSizeH + HMargin*2 +28;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    if (tableView == _tableView1) {
        
        if ([_footViewType isEqualToString:@""]) {
            return nil;
        }
        XDComplainDetailFootView *foot  = [XDComplainDetailFootView footerViewWithTableView:tableView withType:_footViewType];
        
        __weak typeof(self) weakSelf = self;
        foot.compDetailBtnClicked = ^(NSInteger index) {
            if (index == 0) {
                
                XDCommonEvaluteController *evalute = [[XDCommonEvaluteController alloc] init];
                evalute.ComplainId = weakSelf.complainId;
                evalute.navTitle = @"投诉评价";
                evalute.taskId = weakSelf.taskid;
                [weakSelf.navigationController pushViewController:evalute animated:YES];
                
            }else if (index == 1){
                
                if ([weakSelf.footViewType isEqualToString:@"是否接受"]) {
                    [weakSelf CommitWouldAcceptFee:@"0"];
                }
                if ([weakSelf.footViewType isEqualToString:@"是否满意"]) {
                    
                    [weakSelf CommitWouldManYi:@"0"];
                }
                if ([weakSelf.footViewType isEqualToString:@"业主是否接受整改"]) {
                    
                    [weakSelf CommitWouldMeaSure:@"0"];
                }
                
            }else {
                
                if ([weakSelf.footViewType isEqualToString:@"是否接受"]) {
                    [weakSelf CommitWouldAcceptFee:@"1"];
                }
                if ([weakSelf.footViewType isEqualToString:@"是否满意"]) {
                    
                    [weakSelf CommitWouldManYi:@"1"];
                    
                }
                if ([weakSelf.footViewType isEqualToString:@"业主是否接受整改"]) {
                    
                    [weakSelf CommitWouldMeaSure:@"1"];
                }
            }
            
            
        };
        return foot;
        
    }else {
    
        return nil;
        
    }
    

}
#pragma  mark -- 提交是否接受接受整改
- (void)CommitWouldMeaSure:(NSString *)isLike {
    
    [MBProgressHUD showActivityMessageInWindow:nil];
    
    __weak typeof(self) weakSelf = self;
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSNumber *userId = loginModel.userInfo.userId;
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    
    NSDictionary *dic = @{@"complainid":weakSelf.complainId,
                          @"taskId":weakSelf.taskid,
                          @"outcome":@"业主是否接受整改",
                          @"accept":isLike,
                          @"ownerId":userId,
                          @"appTokenInfo":token,
                          @"appMobile":appMobile,
                          };
    
    [[XDAPIManager sharedManager] requestIsMeaSure:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        if (error) {
            [weakSelf clickToAlertViewTitle:@"提交失败" withDetailTitle:@"请检查网络情况！" isDelegate:NO];
            [MBProgressHUD hideHUD];
            return ;
        }
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]){
            
            [MBProgressHUD hideHUD];
            [weakSelf clickToAlertViewTitle:@"提交成功" withDetailTitle:@"您的数据已提交成功！" isDelegate:YES];
            
        }else {
            [weakSelf clickToAlertViewTitle:@"提交失败" withDetailTitle:@"请重新提交！" isDelegate:NO];
            [MBProgressHUD hideHUD];
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
    
    NSDictionary *dic = @{@"complainid":weakSelf.complainId,
                          @"piid":weakSelf.piid,
                          @"taskId":weakSelf.taskid,
                          @"outcome":@"是否满意",
                          @"satisfaction":isLike,
                          @"ownerId":userId,
                          @"appTokenInfo":token,
                          @"appMobile":appMobile,
                          };
    
    [[XDAPIManager sharedManager] requestIsManYiEvalute:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        if (error) {
            [weakSelf clickToAlertViewTitle:@"提交失败" withDetailTitle:@"请检查网络情况！" isDelegate:NO];
            [MBProgressHUD hideHUD];
            return ;
        }
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"] ) {
            
            weakSelf.taskid = responseObject[@"data"][@"taskId"];
            if ([isLike isEqualToString:@"1"]) {
                
                [MBProgressHUD hideHUD];
                XDCommonEvaluteController *evalute = [[XDCommonEvaluteController alloc] init];
                evalute.ComplainId = weakSelf.complainId;
                evalute.navTitle = @"投诉评价";
                evalute.taskId = weakSelf.taskid;
                [weakSelf.navigationController pushViewController:evalute animated:YES];
            }else {
            
                [MBProgressHUD hideHUD];
                [weakSelf clickToAlertViewTitle:@"提交成功" withDetailTitle:@"您的数据已提交成功！" isDelegate:YES];
                
            }
        }else {
            [weakSelf clickToAlertViewTitle:@"提交失败" withDetailTitle:@"请重新提交！" isDelegate:NO];
            [MBProgressHUD hideHUD];
        }
        
        
        
    }];
    
    
    
}


#pragma  mark -- 提交是否接受方案
- (void)CommitWouldAcceptFee:(NSString *)accept {
    [MBProgressHUD showActivityMessageInWindow:nil];
    
    __weak typeof(self) weakSelf = self;
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSNumber *userId = loginModel.userInfo.userId;
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    
    NSDictionary *dic = @{@"complainid":weakSelf.complainId,
                          @"taskId":weakSelf.taskid,
                          @"outcome":@"是否接受",
                          @"accept":accept,
                          @"ownerId":userId,
                          @"appTokenInfo":token,
                          @"appMobile":appMobile,
                          };
    
    
    [[XDAPIManager sharedManager] requestWouldAcceptProjectWithParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        if (error) {
            [weakSelf clickToAlertViewTitle:@"提交失败" withDetailTitle:@"请检查网络情况！" isDelegate:NO];
            [MBProgressHUD hideHUD];
        }
        if ([responseObject[@"resultCode"] isEqualToString:@"0"] ){
        
            [MBProgressHUD hideHUD];
            [weakSelf clickToAlertViewTitle:@"提交成功" withDetailTitle:@"您的数据已提交成功！" isDelegate:YES];
            
        }else {
            [weakSelf clickToAlertViewTitle:@"提交失败" withDetailTitle:@"请重新提交！" isDelegate:NO];
            [MBProgressHUD hideHUD];
        }
        
        
    }];
    
    
    
}


-(void)clickToAlertViewTitle:(NSString *)title withDetailTitle:(NSString *)detailTitle isDelegate:(BOOL)isDelegate
{
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    CustomAlertView *alertView = [[CustomAlertView alloc]initWithFrame:window.bounds WithTitle:title andDetail:detailTitle andBody:nil andCancelTitle:nil andOtherTitle:@"知道了" andIsOneBtn:YES];
    if (isDelegate) {
        alertView.delegate = self;
    }
    [window addSubview:alertView];
    
}

- (void)clickButtonWithTag:(UIButton *)button {
    
    __weak typeof(self) weakSelf = self;
    if (weakSelf.backToRefresh) {
        weakSelf.backToRefresh();
    }
    [weakSelf.navigationController popViewControllerAnimated:YES];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    if (tableView == _tableView1) {
        
        if ([_footViewType isEqualToString:@""]) {
            return 0.001;
        }
        return 50;
        
    }else {
        
        return 0.001;
    }
    
    

}

- (void)dealloc {


}

@end
