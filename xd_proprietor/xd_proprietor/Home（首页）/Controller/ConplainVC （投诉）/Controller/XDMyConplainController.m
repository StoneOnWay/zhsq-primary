//
//  XDMyConplainController.m
//  XD业主
//
//  Created by zc on 2017/6/21.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDMyConplainController.h"
#import "GSPopoverViewController.h"
#import "BRPlaceholderTextView.h"
#import "UIViewExt.h"
#import "HWCollectionViewCell.h"
#import "JJPhotoManeger.h"
#import "HWImagePickerSheet.h"
#import "XDTypePopCell.h"
#import "XDLoginUserRoomInfoModel.h"
#import "XDMyComplainListController.h"

//文本框最多输入多少个数
#define kMaxTextCount 3000


@interface XDMyConplainController ()<UITableViewDelegate,UITableViewDataSource,HWImagePickerSheetDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,JJPhotoDelegate,CustomAlertViewDelegate>
//按钮背景
@property (weak, nonatomic) IBOutlet UIView *levelBackView;
//显示紧急类型的label
@property (weak, nonatomic) IBOutlet UILabel *levelLab;
//上传图片文字label 需要他的坐标
@property (weak, nonatomic) IBOutlet UILabel *upDateLab;
//内容label 需要他的坐标
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
//弹出视图
@property (strong ,nonatomic)GSPopoverViewController *popView;
// 输入框
@property (strong, nonatomic)  BRPlaceholderTextView *questionTextView;
//添加照片view
@property (nonatomic, strong) UICollectionView *pickerCollectionView;
//方形压缩图image 数组
@property(nonatomic,strong) NSMutableArray * imageArray;
//选择的图片数据
@property(nonatomic,strong) NSMutableArray *arrSelected;
//大图image 数组
@property(nonatomic,strong) NSMutableArray * bigImageArray;
//大图image 二进制
@property(nonatomic,strong) NSMutableArray * bigImgDataArray;
//图片选择器
@property(nonatomic,weak) UIViewController *showActionSheetViewController;
//紧急类型的数据
@property(nonatomic,strong) NSMutableArray * levelPopArray;
//提出的提示框 选择照片还是相机
@property (nonatomic, strong) HWImagePickerSheet *imgPickerActionSheet;
//pop的contentView
@property (strong , nonatomic)UITableView *tableView;
@end

@implementation XDMyConplainController

/**
 *  懒加载
 */
- (NSMutableArray *)levelPopArray {
    if (!_levelPopArray) {
        self.levelPopArray = [[NSMutableArray alloc] initWithObjects:@"请选择紧急情况",@"高",@"一般",@"低", nil];
    }
    return _levelPopArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = backColor;
    //拍照用的同一个框架 有些地方是三个 有些地方是九个
    [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:@"kMaxImageCount"];
    
    //设置导航栏
    [self setLevelNavi];
    
    //设置提交问题输入框
    [self setUpLevelTextView];
    
    //设置添加照片
    [self setUpComplainPickerCollectionView];
    
    //添加提交按钮
    [self setUpCommitBtn];
    
    
}
/**
 *  设置导航栏
 */
-(void)setLevelNavi{
    
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem itemWithTitle:@"我的投诉" frame:CGRectMake(0, 10, 30, 30) target:self action:@selector(complainList)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font = CFont(19, 17);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"投诉";
    self.navigationItem.titleView = titleLabel;
}

- (void)complainList {
    
    XDMyComplainListController *list = [[XDMyComplainListController alloc] init];
    [self.navigationController pushViewController:list animated:YES];
    
}


#pragma mark -相册视图
/** 初始化collectionView */
-(void)setUpComplainPickerCollectionView
{
    _showActionSheetViewController = self;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsZero;
    
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = cellPhotosMargin;
    CGFloat MaxY = CGRectGetMaxY(_upDateLab.frame);
    self.pickerCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, MaxY+15, [UIScreen mainScreen].bounds.size.width-30, (((float)[UIScreen mainScreen].bounds.size.width-30.0) /4.0 )) collectionViewLayout:layout];
    [self.view addSubview:self.pickerCollectionView];
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

/**
 *  设置提交按钮
 */
- (void)setUpCommitBtn {
    
    CGFloat MaxY = CGRectGetMaxY(self.pickerCollectionView.frame);
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, MaxY+25, kScreenWidth-40, 36)];
    [btn setBackgroundImage:[UIImage imageNamed:@"baoxiu_btn_tijiao"] forState:UIControlStateNormal];
    btn.titleLabel.font = SFont(16);
    [btn addTarget:self action:@selector(commitComplainData) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [self.view addSubview:btn];

}

/**
 *  提交数据
 */
- (void)commitComplainData {
    
    if ([self.levelLab.text isEqualToString:@"请选择紧急情况"] || [self.questionTextView.text isEqualToString:@""]) {
        [self clickToAlertViewTitle:@"提交失败" withDetailTitle:@"请将信息填写完整！" isDelegate:NO];
        return;
    }

    [MBProgressHUD showActivityMessageInWindow:nil];
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSNumber *userId = loginModel.userInfo.userId;
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    XDLoginUserRoomInfoModel *roomInfo = loginModel.roominfo.firstObject;
    NSNumber *roomId = roomInfo.roomId;
    
    NSDictionary *dic = @{@"ownerId":userId,
                          @"appTokenInfo":token,
                          @"appMobile":appMobile,
                          @"content":_questionTextView.text,
                          @"roomid":roomId
                          };
    
    NSArray *imageDatas = [self getBigImageArray];
    __weak typeof(self) weakSelf = self;
    [[XDAPIManager sharedManager] requestCommitMyComplainParameters:dic constructingBodyWithBlock:imageDatas CompletionHandle:^(id responseObject, NSError *error) {
        
        if (error) {
            [weakSelf clickToAlertViewTitle:@"投诉失败" withDetailTitle:@"请检查网络情况！" isDelegate:NO];
            [MBProgressHUD hideHUD];
            return ;
        }
        if ([responseObject[@"resultCode"] isEqualToString:@"0"] ){
            
            [MBProgressHUD hideHUD];
            [weakSelf clickToAlertViewTitle:@"投诉成功" withDetailTitle:@"您的投诉已提交成功！" isDelegate:YES];
            
        }else {
            [MBProgressHUD hideHUD];
            [weakSelf clickToAlertViewTitle:@"投诉失败" withDetailTitle:@"请重新提交！" isDelegate:NO];
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

/**
 *  插入popView
 */
- (void)setUpComplainPopView:(UIButton *)sender {
    
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
- (void)setUpLevelTextView {
        
    CGFloat MaxY = CGRectGetMaxY(self.contentLab.frame);
    _questionTextView = [[BRPlaceholderTextView alloc]initWithFrame:CGRectMake(20, MaxY+10, kScreenWidth-40, 100)];
    _questionTextView.placeholder= @"请输入您当前需要投诉的具体信息";
    [_questionTextView setPlaceholderColor:[UIColor lightGrayColor]];
    [_questionTextView setFont:[UIFont systemFontOfSize:14.0]];
    [_questionTextView setTextColor:[UIColor blackColor]];
    _questionTextView.maxTextLength = kMaxTextCount;
    _questionTextView.delegate = self;
    _questionTextView.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    _questionTextView.layer.borderColor = [BianKuang CGColor];
    _questionTextView.layer.cornerRadius = 5;
    _questionTextView.layer.borderWidth = 1.0;
    [_questionTextView.layer setMasksToBounds:YES];
    [self.view addSubview:_questionTextView];
    
    self.levelBackView.layer.borderColor = [BianKuang CGColor];
    self.levelBackView.layer.cornerRadius = 5;
    self.levelBackView.layer.borderWidth = 1.0;

    
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
    [_bigImgDataArray addObject:imageData];
    
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
    return self.levelPopArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XDTypePopCell *cell = [XDTypePopCell cellWithTableView:tableView];
    
    cell.textLabels.text = self.levelPopArray[indexPath.row];
    return cell;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.levelLab.text = self.levelPopArray[indexPath.row];
    
    [self.popView dissPopoverViewWithAnimation:YES];
}

//紧急情况按钮
- (IBAction)levelBtn:(UIButton *)sender {
    
    [self setUpComplainPopView:sender];
    
    //一定要这个不要坐标不对
    CGRect rect = [self.levelBackView convertRect:sender.frame toView:self.view];
    rect.origin.y += 64;
    [self.popView showPopoverWithRect:rect animation:YES];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self.view endEditing:YES];
}

- (void)dealloc {


}
















@end
