//
//  XDWarrantyViewController.m
//  XＤ
//
//  Created by zc on 17/3/31.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDWarrantyViewController.h"
#import "UIViewExt.h"
#import "XDAPIManager.h"
#import "AFNetworking.h"
#import "WSDatePickerView.h"
#import "BRPlaceholderTextView.h"
#import "scanningCardViewController.h"
#import "GSPopoverViewController.h"
#import "XDTypePopCell.h"
#import "XDChooseContactController.h"
#import "XDWarrantyListController.h"

//文本框最多输入多少个数
#define kMaxTextCount 3000


#define KWIDTH [UIScreen mainScreen].bounds.size.width
#define RGBColorMake(_R_,_G_,_B_,_alpha_) [UIColor colorWithRed:_R_/255.0 green:_G_/255.0 blue:_B_/255.0 alpha:_alpha_]

#define SCREEN_HEIGHT [ UIScreen mainScreen ].bounds.size.height
#define SCREEN_WIDTH [ UIScreen mainScreen ].bounds.size.width

@interface XDWarrantyViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,JJPhotoDelegate,HWImagePickerSheetDelegate,UITableViewDelegate,UITableViewDataSource,XDChooseContactControllerDelegate,CustomAlertViewDelegate>


{
    NSInteger _isInterger;
}
//scrollView
@property(nonatomic, strong) UIScrollView *backScrollView;
//所有控件都添加到这个view上
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UIView *defaultBackView;

@property (weak, nonatomic) IBOutlet UILabel *defaultLabel;

//地址按钮
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
//名字输入
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
//电话输入
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
//地址输入框的背景view
@property (weak, nonatomic) IBOutlet UIView *addressBackView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *typeBackView;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

//报修的类型
@property (weak, nonatomic) IBOutlet UIButton *WarrantyTypeBtn;
//为了定位选择照片的y
@property (weak, nonatomic) IBOutlet UILabel *UpdataLabel;
@property (weak, nonatomic) IBOutlet UIButton *UpdataBtn;
//维修地点显示label
@property (weak, nonatomic) IBOutlet UITextField *addressText;
//维修类型label
@property (weak, nonatomic) IBOutlet UITextField *typeText;
//时间label
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIView *timeBackView;

//上门时间的约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabConstraint;

// 输入框
@property (strong, nonatomic)  BRPlaceholderTextView *questionTextView;
//添加照片view
@property (nonatomic, strong) UICollectionView *pickerCollectionView;
//选择的图片数据
@property(nonatomic,strong) NSMutableArray *arrSelected;

//方形压缩图image 数组
@property(nonatomic,strong) NSMutableArray * imageArray;

//大图image 数组
@property(nonatomic,strong) NSMutableArray * bigImageArray;

//大图image 二进制
@property(nonatomic,strong) NSMutableArray * bigImgDataArray;

//图片选择器
@property(nonatomic,weak) UIViewController *showActionSheetViewController;
//提出的提示框 选择照片还是相机
@property (nonatomic, strong) HWImagePickerSheet *imgPickerActionSheet;

//弹出框
@property (strong ,nonatomic)GSPopoverViewController *popView;

//address选择数据
@property(nonatomic,strong) NSMutableArray * addressPopArray;

//维修类型Type数据
@property(nonatomic,strong) NSMutableArray * typePopArray;

//pop的contentView
@property (strong , nonatomic)UITableView *tableView;
//提交时候选择的时间
@property(nonatomic,copy)NSString *commitDate;

//地址所属id
@property(nonatomic,copy)NSString *AddressID;
//类型所属id
@property(nonatomic,copy)NSString *WarrantyTypeID;

//当前服务器时间  加一小时
@property(nonatomic,copy)NSString *addHour;

@end

@implementation XDWarrantyViewController

/**
 *  懒加载
 */
- (NSMutableArray *)addressPopArray {
    if (!_addressPopArray) {
        self.addressPopArray = [NSMutableArray array];
    }
    return _addressPopArray;
}
- (NSMutableArray *)typePopArray {
    if (!_typePopArray) {
        self.typePopArray = [NSMutableArray array];
    }
    return _typePopArray;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        if (!_showActionSheetViewController) {
            _showActionSheetViewController = self;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //拍照用的同一个框架 有些地方是三个 有些地方是九个
    [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:@"kMaxImageCount"];
    
    self.view.backgroundColor = [UIColor whiteColor]; //backColor;
    self.addressText.borderStyle = UITextBorderStyleNone;
    self.typeText.borderStyle = UITextBorderStyleNone;
    self.addressText.textAlignment = NSTextAlignmentLeft;
    self.addressText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
     self.addressText.adjustsFontSizeToFitWidth = YES;
    
    //获取地址和维修类型
    [self getWarrantyAddressAndTypeList];
    
    //设置导航栏
    [self setWarrantyNavi];
    
    //设置背景scrollView
    [self setBackScrollView];
    
    //设置提交问题输入框
    [self setUpTextView];
    
    //设置添加照片
    [self setUpPickerCollectionView];

    
    //通知和手势
    [self notificationAddTap];
    
   
    if (kScreenWidth == 375) {
        self.timeLabConstraint.constant = 130;
    }else if (kScreenWidth > 375){
        self.timeLabConstraint.constant = 140;
    }
}
/**
 *  通知和手势
 */
- (void)notificationAddTap {

    //通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHideShow:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(popViewDisAppear) name:GSPopoverViewControllerWillDisappearNotification object:nil];
    
    //添加图片cell点击事件
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEndView)];
    singleTap.numberOfTapsRequired = 1;
    [self.backView addGestureRecognizer:singleTap];

}

- (void)getWarrantyAddressAndTypeList {
    
    __weak typeof(self) weakSelf = self;
    
    //获取当前时间加一小时
    NSDictionary *dic1 = @{@"addHour":@"1",
                           };
    [[XDAPIManager sharedManager] requestGetNowDateParameters:dic1 CompletionHandle:^(id responseObject, NSError *error) {
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            weakSelf.addHour = responseObject[@"data"];
            weakSelf.timeLab.text = weakSelf.addHour;
            weakSelf.commitDate = weakSelf.addHour;
        }
        
    }];
    
    //获取房屋地址
    [MBProgressHUD showActivityMessageInWindow:nil];
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSNumber *userId = loginModel.userInfo.userId;
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *nickName = [ud objectForKey:@"nickName"];
    if (nickName != nil) {
        self.nameTF.text = nickName;
    }else {
        
        self.nameTF.text = loginModel.userInfo.nickName;
    }
    
    self.phoneTF.text = loginModel.userInfo.mobileNumber;
    
    NSDictionary *dic = @{@"userId":userId,
                          @"appTokenInfo":token,
                          @"appMobile":appMobile
                          };
    [[XDAPIManager sharedManager] requestHouseOfAddressWithParameters:dic CompletionHandle:^(id responseObject, NSError *error) {
        

        if ([responseObject[@"resultCode"] isEqualToString:@"0"] ) {
        
            NSArray *addressEntityList = responseObject[@"data"][@"addressEntityList"];
            for (int i = 0; i<addressEntityList.count; i++) {
                
                NSDictionary *subDic = addressEntityList[i];
                NSString *addressID = subDic[@"id"];
                NSString *name = subDic[@"name"];
                NSDictionary *dic = @{@"addressID":addressID,@"name":name};
                weakSelf.defaultLabel.text = name;
                weakSelf.AddressID = addressID;
                [weakSelf.addressPopArray addObject:dic];
                
            }
            [MBProgressHUD hideHUD];
        }else {
            [MBProgressHUD hideHUD];
        
        }
        
    }];

    
    //获取维修类型List
    [[XDAPIManager sharedManager] requesWarrantyOfTypeWithParameters:dic CompletionHandle:^(id responseObject, NSError *error) {

        if ([responseObject[@"resultCode"] isEqualToString:@"0"] ) {
            NSArray *repairsTypeEntityList = responseObject[@"data"][@"repairsTypeEntityList"];
            for (int i = 0; i<repairsTypeEntityList.count; i++) {
                
                NSDictionary *subDic = repairsTypeEntityList[i];
                NSString *warrantyID = subDic[@"id"];
                NSString *name = subDic[@"name"];
                weakSelf.typeText.text = name;
                weakSelf.WarrantyTypeID = warrantyID;
                NSDictionary *dic = @{@"warrantyID":warrantyID,@"name":name};
                [weakSelf.typePopArray addObject:dic];
                
            }
            [MBProgressHUD hideHUD];
        
        }else {
            [MBProgressHUD hideHUD];
        }
    }];
}

/**
 *  插入popView
 */
- (void)setUpPopView:(UIButton *)sender {
    
//    CGFloat typeBtnMinX = CGRectGetMinX(sender.frame);
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0 , 0,  sender.width, 120)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.rowHeight = 40;
    self.popView = [[GSPopoverViewController alloc]initWithShowView:self.tableView];
    self.popView.borderWidth = 1;
    self.popView.borderColor = BianKuang;
}
/**
 *  输入框
 */
- (void)setUpTextView {
    
    CGFloat addressMaxY = CGRectGetMaxY(self.desLabel.frame);
    _questionTextView = [[BRPlaceholderTextView alloc]initWithFrame:CGRectMake(20, addressMaxY +10, kScreenWidth-40, 100)];
    _questionTextView.placeholder= @"请输入你当前需要报修的信息";
    [_questionTextView setPlaceholderColor:[UIColor lightGrayColor]];
    [_questionTextView setFont:[UIFont systemFontOfSize:14.0]];
    [_questionTextView setTextColor:[UIColor blackColor]];
    _questionTextView.maxTextLength = kMaxTextCount;
    _questionTextView.delegate = self;
    _questionTextView.layer.backgroundColor = [litterBackColor CGColor];
    _questionTextView.layer.borderColor = [BianKuang CGColor];
    _questionTextView.layer.cornerRadius = 5;
    _questionTextView.layer.borderWidth = 1.0;
    [_questionTextView.layer setMasksToBounds:YES];
    [self.backView addSubview:_questionTextView];

    //设置轮廓颜色
    self.defaultBackView.layer.borderColor = [BianKuang CGColor];
    self.defaultBackView.layer.cornerRadius = 5;
    self.defaultBackView.layer.borderWidth = 1.0;
    [self.defaultBackView.layer setMasksToBounds:YES];
    
    self.nameTF.layer.borderColor = [BianKuang CGColor];
    self.nameTF.layer.cornerRadius = 5;
    self.nameTF.layer.borderWidth = 1.0;
    [self.nameTF.layer setMasksToBounds:YES];
    self.phoneTF.layer.borderColor = [BianKuang CGColor];
    self.phoneTF.layer.cornerRadius = 5;
    self.phoneTF.layer.borderWidth = 1.0;
    [self.phoneTF.layer setMasksToBounds:YES];
    self.addressBackView.layer.borderColor = [BianKuang CGColor];
    self.addressBackView.layer.cornerRadius = 5;
    self.addressBackView.layer.borderWidth = 1.0;
    [self.addressBackView.layer setMasksToBounds:YES];
    
    self.timeBackView.layer.borderColor = [BianKuang CGColor];
    self.timeBackView.layer.cornerRadius = 5;
    self.timeBackView.layer.borderWidth = 1.0;
    [self.timeBackView.layer setMasksToBounds:YES];
    
    self.lineView.layer.borderColor = [BianKuang CGColor];
    self.lineView.layer.cornerRadius = 5;
    self.lineView.layer.borderWidth = 1.0;
    [self.lineView.layer setMasksToBounds:YES];
    
    self.typeBackView.layer.borderColor = [BianKuang CGColor];
    self.typeBackView.layer.cornerRadius = 5;
    self.typeBackView.layer.borderWidth = 1.0;
    [self.typeBackView.layer setMasksToBounds:YES];

}
/**
 *  因为这个需要用到scrollView 但是scrollView在xib中比较
    特殊 所以用这个方法 多添加了一个backView
 */
- (void)setBackScrollView {
    
    //适配的问题
    self.backView.frame = self.view.bounds;

    //创建scrollView
    self.backScrollView = [[UIScrollView alloc]init];
    self.backScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.backScrollView addSubview:self.backView];
    //设置scrollView的contentSize
    CGFloat maxY = CGRectGetMaxY(self.UpdataBtn.frame);
    self.backScrollView.contentSize = CGSizeMake(kScreenWidth,maxY+20+64);
    
    [self.view addSubview: self.backScrollView];
}

/**
 *  设置导航栏
 */
-(void)setWarrantyNavi{

    self.navigationItem.rightBarButtonItem=[UIBarButtonItem itemWithTitle:@"我的工单" frame:CGRectMake(0, 0, 22, 22) target:self action:@selector(warrantyList)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font = CFont(19, 17);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"报事报修";
    self.navigationItem.titleView = titleLabel;
}

- (void)warrantyList {

    XDWarrantyListController *list = [[XDWarrantyListController alloc] init];
    [self.navigationController pushViewController:list animated:YES];
    
}
- (void)tapEndView {
    
    [self.view endEditing:YES];

}
#pragma mark -- 更多联系人
- (IBAction)moreContact:(id)sender {
    XDChooseContactController *choose = [[XDChooseContactController alloc] init];
    choose.delegate = self;
    [self.navigationController pushViewController:choose animated:YES];
}

#pragma mark -- 添加地址
- (IBAction)addAddress:(UIButton *)sender {

    [self.view endEditing:YES];
    
    _isInterger = 1;
    [self setUpPopView:sender];
 
    //一定要这个不要坐标不对
    CGRect rect = [self.defaultBackView convertRect:sender.frame toView:self.view];
    rect.origin.y += 64;
    [self.popView showPopoverWithRect:rect animation:YES];
}

#pragma mark -- 扫二维码
- (IBAction)code:(id)sender {
    
    [self.view endEditing:YES];
    scanningCardViewController *scanningCard = [[scanningCardViewController alloc]init];
    [scanningCard returnInform:^(NSString *watchInform){
        
        //获取当前时间加一小时
        NSDictionary *dic1 = @{@"code":watchInform,
                               };
        [[XDAPIManager sharedManager] requestScanWithParameters:dic1 CompletionHandle:^(id responseObject, NSError *error) {
            
            if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
               
                self.addressText.text = responseObject[@"data"][@"name"];
            }
        }];
        
    }];
    
    [self.navigationController pushViewController:scanningCard animated:YES];
}


#pragma mark -- 时间选择器
- (IBAction)timeButton:(UIButton *)sender {
    
    [self.view endEditing:YES];
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *nowData = [dateformater dateFromString:self.timeLab.text];
    
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDayHourMinute withUnitData:nowData CompleteBlock:^(NSDate *startDate) {
      
        _commitDate = [startDate stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
        self.timeLab.text = _commitDate;
        
    }];

    datepicker.doneButtonColor = BianKuang;//确定按钮的颜色
    [datepicker show];

}


#pragma mark -- 维修类型
- (IBAction)warrantyType:(UIButton *)sender {
    
    _isInterger = 2;
    [self.view endEditing:YES];
    
    [self setUpPopView:sender];
    //一定要这个不要坐标不对
    CGRect rect = [self.typeBackView convertRect:sender.frame toView:self.view];
    rect.origin.y += 64;
    self.popView.showAnimation = GSPopoverViewShowAnimationBottomTop;
    [self.popView showPopoverWithRect:rect animation:YES];
}
- (void)scrollsToBottomAnimated
{
    if (kScreenWidth == 320) {
        
        CGFloat maxY = CGRectGetMaxY(self.UpdataBtn.frame);
        self.backScrollView.contentSize = CGSizeMake(kScreenWidth,maxY+90+64);
        
        CGFloat offset = self.backScrollView.contentSize.height - self.backScrollView.bounds.size.height;
        if (offset > 0)
        {
            [self.backScrollView setContentOffset:CGPointMake(0, offset)];
        }
        
    }
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

#pragma mark -- 提交按钮
- (IBAction)sumbit:(id)sender {
    
    if ([_questionTextView.text isEqualToString:@""] || _WarrantyTypeID == nil ||_AddressID == nil || _commitDate == nil || [_phoneTF.text isEqualToString:@""]) {
        
        [self clickToAlertViewTitle:@"提交失败" withDetailTitle:@"请将信息填写完整！" isDelegate:NO];
        return;
    }
    
    BOOL isTure = [self setPlanTime:self.timeLab.text systemTime:self.addHour];
    if (!isTure) {
        NSString *detailString = [NSString stringWithFormat:@"上门时间不能小于系统默认时间:%@",self.addHour];
        [self clickToAlertViewTitle:@"信息错误" withDetailTitle:detailString isDelegate:NO];
        return;
    }
    
    [MBProgressHUD showActivityMessageInWindow:nil];
    
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSNumber *userId = loginModel.userInfo.userId;
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSString *projectId = loginModel.userInfo.projectId;
    NSMutableDictionary *dic = @{
                                 @"userId":userId,
                                 @"appTokenInfo":token,
                                 @"appMobile":appMobile,
                                 @"projectId":projectId,
                                 @"createusertype":@"0",
                                 @"problemdesc":_questionTextView.text,
                                 @"jobtypeid":_WarrantyTypeID,
                                 @"roomid":_AddressID,
                                 @"linkman":_nameTF.text,
                                 @"plandate":_commitDate,
                                 @"mobile":_phoneTF.text,
                                 }.mutableCopy;
    
    if (self.addressText.text.length != 0) {
        dic[@"address"] = self.addressText.text;
    }
    
    NSArray *imageDatas = [self getBigImageArray];
    
    __weak typeof(self) weakSelf = self;
    [[XDAPIManager sharedManager] requestCommitMyWarrantyParameters:dic constructingBodyWithBlock:imageDatas CompletionHandle:^(id responseObject, NSError *error) {
        
        if (error) {
            [weakSelf clickToAlertViewTitle:@"创建失败" withDetailTitle:@"请检查网络情况！" isDelegate:NO];
            [MBProgressHUD hideHUD];
            return ;
        }
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"] ) {
            [MBProgressHUD hideHUD];
            [weakSelf clickToAlertViewTitle:@"创建成功" withDetailTitle:@"您的工单已创建成功！" isDelegate:YES];
            
        }else {
            
            [MBProgressHUD hideHUD];
            [weakSelf clickToAlertViewTitle:@"创建失败" withDetailTitle:@"请重新提交工单！" isDelegate:NO];
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
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -相册视图
/** 初始化collectionView */
-(void)setUpPickerCollectionView
{
    _showActionSheetViewController = self;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsZero;
    
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = cellPhotosMargin;
    CGFloat MaxY = CGRectGetMaxY(_UpdataLabel.frame);
    self.pickerCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, MaxY+15, [UIScreen mainScreen].bounds.size.width-30, (((float)[UIScreen mainScreen].bounds.size.width-30.0) /4.0 )) collectionViewLayout:layout];
    [self.backView addSubview:self.pickerCollectionView];
    self.pickerCollectionView.delegate=self;
    self.pickerCollectionView.dataSource=self;
    self.pickerCollectionView.backgroundColor = [UIColor clearColor];
    
    if(_imageArray.count == 0)
    {
        _imageArray = [NSMutableArray array];
    }
    if(_bigImageArray.count == 0)
    {
        _bigImageArray = [NSMutableArray array];
    }

    _pickerCollectionView.scrollEnabled = NO;
}

#pragma mark -相册CollectionView代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return  _imageArray.count == 3? _imageArray.count : _imageArray.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //加载已有的cell
    UINib *nib = [UINib nibWithNibName:@"HWCollectionViewCell" bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"HWCollectionViewCell"];
    
    HWCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"HWCollectionViewCell" forIndexPath:indexPath];
    
    cell.plusImage.hidden = YES;
    
    //显示+这个cell
    if (indexPath.row == _imageArray.count) {
        cell.plusImage.hidden = NO;
        [cell.profilePhoto setImage:[[UIImage alloc] init]];
        [cell.plusImage setImage:[UIImage imageNamed:@"tousu_btn_zj"]];
        cell.closeButton.hidden = YES;
        
    }//其他cell
    else{
        [cell.profilePhoto setImage:_imageArray[indexPath.item]];
        cell.closeButton.hidden = NO;
    }
    
    [cell setBigImageViewWithImage:nil];
    cell.profilePhoto.tag = [indexPath item];
    
    //添加图片cell点击事件
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProfileImage:)];
    singleTap.numberOfTapsRequired = 1;
    cell.profilePhoto .userInteractionEnabled = YES;
    [cell.profilePhoto  addGestureRecognizer:singleTap];
    cell.closeButton.tag = [indexPath item];
    [cell.closeButton addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(cellPhotosW,cellPhotosH);
}



-(CGFloat )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 1;
}
#pragma mark - 图片cell点击事件
//点击图片看大图
- (void) tapProfileImage:(UITapGestureRecognizer *)gestureRecognizer{
    [self.view endEditing:YES];
    
    UIImageView *tableGridImage = (UIImageView*)gestureRecognizer.view;
    NSInteger index = tableGridImage.tag;
    
    if (index == (_imageArray.count)) {
        [self.view endEditing:YES];
    
        //添加新图片
        [self addNewImg];
    }
    else{
        //点击放大查看
        HWCollectionViewCell *cell = (HWCollectionViewCell*)[_pickerCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        if (!cell.BigImageView || !cell.BigImageView.image) {
            
            if ([_arrSelected[index] isKindOfClass:[UIImage class]]) {
                [cell setBigImageViewWithImage:[self getBigIamgeWithImage:_arrSelected[index] index:index]];
            }else {
                [cell setBigImageViewWithImage:[self getBigIamgeWithALAsset:_arrSelected[index]]];
            }
//            [cell setBigImageViewWithImage:[self getBigIamgeWithALAsset:_arrSelected[index]]];
        }
        
        JJPhotoManeger *mg = [JJPhotoManeger maneger];
        mg.delegate = self;
        [mg showLocalPhotoViewer:@[cell.BigImageView] selecImageindex:0];
    }
}
- (UIImage*)getBigIamgeWithImage:(UIImage*)set index:(NSInteger)index{
    //压缩
    // 需传入方向和缩放比例，否则方向和尺寸都不对
    UIImage *img = set;
    NSData *imageData = UIImageJPEGRepresentation(img, 0.5);
    [_bigImgDataArray addObject:imageData];
    
    return [UIImage imageWithData:imageData];
}

- (UIImage*)getBigIamgeWithALAsset:(ALAsset*)set{
    //压缩
    // 需传入方向和缩放比例，否则方向和尺寸都不对
    UIImage *img = [UIImage imageWithCGImage:set.defaultRepresentation.fullResolutionImage
                                       scale:set.defaultRepresentation.scale
                                 orientation:(UIImageOrientation)set.defaultRepresentation.orientation];
    NSData *imageData = UIImageJPEGRepresentation(img, 0.5);
//    [_bigImgDataArray addObject:imageData];
    
    return [UIImage imageWithData:imageData];
}
#pragma mark - 选择图片
- (void)addNewImg{
    if (!_imgPickerActionSheet) {
        _imgPickerActionSheet = [[HWImagePickerSheet alloc] init];
        _imgPickerActionSheet.delegate = self;
    }
    if (_arrSelected) {
        _imgPickerActionSheet.arrSelected = _arrSelected;
    }
//    _imgPickerActionSheet.maxCount = _maxCount;
//    [_imgPickerActionSheet showImgPickerActionSheetInView:_showActionSheetViewController];
}

#pragma mark - 删除照片
- (void)deletePhoto:(UIButton *)sender{
    
    
    [_imageArray removeObjectAtIndex:sender.tag];
    [_arrSelected removeObjectAtIndex:sender.tag];
    
    if (_imageArray.count == 2) {
        
        [self.pickerCollectionView reloadData];
    }else {
        [self.pickerCollectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:sender.tag inSection:0]]];
        
        for (NSInteger item = sender.tag; item <= _imageArray.count; item++) {
            HWCollectionViewCell *cell = (HWCollectionViewCell*)[self.pickerCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0]];
            cell.closeButton.tag--;
            cell.profilePhoto.tag--;
        }
        
        
    }

}


/**
 *  相册完成选择得到图片
 */
-(void)getSelectImageWithALAssetArray:(NSArray *)ALAssetArray thumbnailImageArray:(NSArray *)thumbnailImgArray{
    //（ALAsset）类型 Array
    _arrSelected = [NSMutableArray arrayWithArray:ALAssetArray];
    //正方形缩略图 Array
    _imageArray = [NSMutableArray arrayWithArray:thumbnailImgArray] ;
    
    [self.pickerCollectionView reloadData];
}



#pragma mark - 防止奔溃处理
-(void)photoViwerWilldealloc:(NSInteger)selecedImageViewIndex
{
    NSLog(@"最后一张观看的图片的index是:%zd",selecedImageViewIndex);
}

- (UIImage *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize {
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
}

#pragma mark - 获得选中图片各个尺寸
- (NSArray*)getALAssetArray{
    return _arrSelected;
}

- (NSArray*)getBigImageArray{
    
    return [self getBigImageArrayWithALAssetArray:_arrSelected];
}
//获得大图
- (NSArray*)getBigImageArrayWithALAssetArray:(NSArray*)ALAssetArray{
    _bigImgDataArray = [NSMutableArray array];
    NSMutableArray *bigImgArr = [NSMutableArray array];
//    for (ALAsset *set in ALAssetArray) {
//        [bigImgArr addObject:[self getBigIamgeDataWithALAsset:set]];
//    }

    for (int i = 0; i<ALAssetArray.count; i++) {
        if ([ALAssetArray[i] isKindOfClass:[UIImage class]]) {
            UIImage *img = ALAssetArray[i];
            NSData *imageData = UIImageJPEGRepresentation(img, 0.5);
            imageData = [KYCompressImage compressImage:imageData toByte:60*1024];
            [bigImgArr addObject:imageData];
            
        }else {
            ALAsset *set = ALAssetArray[i];
            [bigImgArr addObject:[self getBigIamgeDataWithALAsset:set]];
        }
        
    }
    
    _bigImageArray = bigImgArr;
    return _bigImageArray;
}
- (NSData *)getBigIamgeDataWithALAsset:(ALAsset*)set{
    //压缩
    // 需传入方向和缩放比例，否则方向和尺寸都不对
    UIImage *img = [UIImage imageWithCGImage:set.defaultRepresentation.fullResolutionImage
                                       scale:set.defaultRepresentation.scale
                                 orientation:(UIImageOrientation)set.defaultRepresentation.orientation];
    NSData *imageData = UIImageJPEGRepresentation(img, 0.5);
    imageData = [KYCompressImage compressImage:imageData toByte:60*1024];

    return imageData;
}

- (NSArray*)getSmallImageArray{
    return _imageArray;
}


#pragma mark -- tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isInterger == 1)
    {
        return self.addressPopArray.count;
    }else
    {
        return self.typePopArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XDTypePopCell *cell = [XDTypePopCell cellWithTableView:tableView];
    
    if (_isInterger == 1)
    {
      
        cell.textLabels.text = _addressPopArray[indexPath.row][@"name"];
        return cell;
        
    }else
    {

        cell.textLabels.text = _typePopArray[indexPath.row][@"name"];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isInterger == 1)
    {
        self.defaultLabel.text = self.addressPopArray[indexPath.row][@"name"];
        _AddressID = self.addressPopArray[indexPath.row][@"addressID"];
      
        
    }else{
         self.typeText.text = self.typePopArray[indexPath.row][@"name"];
        _WarrantyTypeID = self.typePopArray[indexPath.row][@"warrantyID"];
    }
    
    [self.popView dissPopoverViewWithAnimation:YES];
}

#pragma mark --chooseDelegate选择联系人代理
- (void)XDChooseContactControllerWithName:(NSString *)name andPhoneNumb:(NSString *)phone {

    self.nameTF.text = name;
    self.phoneTF.text = phone;

}
#pragma mark -- 键盘上下移动
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    // get keyboard rect in windwo coordinate
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // convert keyboard rect from window coordinate to scroll view coordinate
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    // get keybord anmation duration
    NSTimeInterval animationDuration =[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];;
    
    // get first responder textfield
    UIView *currentResponder = [self findFirstResponderBeneathView:self.view];
    if (currentResponder != nil) {
        CGPoint point = [currentResponder convertPoint:CGPointMake(0, currentResponder.frame.size.height) toView:self.backScrollView];
        
        // 计算textfield左下角和键盘上面20像素 之间是不是差值
        float scrollY = point.y - (keyboardRect.origin.y - 5);
        if (scrollY > 0) {
            [UIView animateWithDuration:animationDuration animations:^{
                //移动textfield到键盘上面20个像素
                self.backScrollView.contentSize = CGSizeMake(kScreenWidth,(kScreenHeight + scrollY+50));
                self.backScrollView.contentOffset = CGPointMake(self.backScrollView.contentOffset.x, (self.backScrollView.contentOffset.y + scrollY+50));
                
            }];
        }
        
        
    }
    self.backScrollView.scrollEnabled = YES;
}

- (UIView*)findFirstResponderBeneathView:(UIView*)view {
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] ) return childView;
        UIView *result = [self findFirstResponderBeneathView:childView];
        if ( result )
            return result;
    }
    return nil;
}

- (void)keyboardHideShow:(NSNotification *)notification {
    CGFloat maxY = CGRectGetMaxY(self.UpdataBtn.frame);
    self.backScrollView.contentSize = CGSizeMake(kScreenWidth,maxY+20+64);
    
}

- (void)popViewDisAppear {
    if (kScreenWidth == 320) {
        
        [UIView animateWithDuration:0.3 animations:^{
            CGFloat maxY = CGRectGetMaxY(self.UpdataBtn.frame);
            self.backScrollView.contentSize = CGSizeMake(kScreenWidth,maxY+20+64);
        }];
        
    }

}


- (void)dealloc {


}

@end
