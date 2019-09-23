//
//  XDFunAddViewController.m
//  xd_proprietor
//
//  Created by xielei on 2019/1/27.
//  Copyright © 2019年 zc. All rights reserved.
//

#import "XDFunAddViewController.h"
#import "HWCollectionViewCell.h"
#import "JJPhotoManeger.h"
#import "HWImagePickerSheet.h"


@interface XDFunAddViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,JJPhotoDelegate,HWImagePickerSheetDelegate,UIAlertViewDelegate,CustomAlertViewDelegate,UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

//图片选择器
@property(nonatomic,weak) UIViewController *showActionSheetViewController;

@property (weak, nonatomic) IBOutlet UILabel *placeLab;//默认文字

@property (weak, nonatomic) IBOutlet UITextView *contentTextView; // 内容

//选择的图片数据
@property(nonatomic,strong) NSMutableArray *arrSelected;

@property (nonatomic, strong) HWImagePickerSheet *imgPickerActionSheet;

@property (weak, nonatomic) IBOutlet UIView *imagesView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imagesViewHeightConstant;

//大图image 数组
@property(nonatomic,strong) NSMutableArray * bigImageArray;

//大图image 二进制
@property(nonatomic,strong) NSMutableArray * bigImgDataArray;

- (IBAction)publishClick:(UIButton *)sender;

//添加照片view
@property (nonatomic, strong) UICollectionView *pickerCollectionView;

//方形压缩图image 数组
@property(nonatomic,strong) NSMutableArray * imageArray;
@end

@implementation XDFunAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发布新鲜事";
    // 设置添加照片
    [self setUpPickerCollectionView];
    
    _arrSelected = [NSMutableArray array];
    _imageArray = [NSMutableArray array];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        if (!_showActionSheetViewController) {
            _showActionSheetViewController = self;
        }
    }
    return self;
}

#pragma mark -相册视图
/** 初始化collectionView */
- (void)setUpPickerCollectionView {
    _showActionSheetViewController = self;
    
    CGFloat width = ((float)[UIScreen mainScreen].bounds.size.width-30.0);
    if ([XDUtil isIPad]) {
        self.imagesViewHeightConstant.constant = (width/4.0) + 20;
    }
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsZero;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = cellPhotosMargin;
    self.pickerCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 15, width, (width/4.0)) collectionViewLayout:layout];
    [self.imagesView addSubview:self.pickerCollectionView];
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

- (void)textViewDidChange:(UITextView *)textView{
//    self.examineText =  textView.text;
    if (textView.text.length == 0) {
        self.placeLab.text = @"分享身边的奇闻异事...";
    } else {
        self.placeLab.text = @"";
    }
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
    cell.profilePhoto.userInteractionEnabled = YES;
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
//        [self addNewImg];
        [self takePhoto:self.pickerCollectionView];
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
    UIImage *img = [UIImage imageWithCGImage:set.defaultRepresentation.fullResolutionImage scale:set.defaultRepresentation.scale orientation:(UIImageOrientation)set.defaultRepresentation.orientation];
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

#pragma mark - UIAlert
- (void)takePhoto:(UIView *)view {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选取照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if ([XDUtil isIPad]) {
        UIPopoverPresentationController *popoverVC = [alert popoverPresentationController];
        popoverVC.sourceView = view;
        popoverVC.sourceRect = view.bounds;
    }
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
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];
    [_arrSelected addObject:image];
    image = [self thumbnailWithImage:image size:CGSizeMake(kScreenWidth, kScreenHeight)];
    [_imageArray addObject:image];
    [self.pickerCollectionView reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize {
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    } else {
        UIGraphicsBeginImageContext(asize);
        [image drawInRect:CGRectMake(0, 0, asize.width, asize.height)];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

#pragma mark - 删除照片
- (void)deletePhoto:(UIButton *)sender {
    [_imageArray removeObjectAtIndex:sender.tag];
    [_arrSelected removeObjectAtIndex:sender.tag];
    
    if (_imageArray.count == 2) {
        [self.pickerCollectionView reloadData];
    } else {
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
- (void)photoViwerWilldealloc:(NSInteger)selecedImageViewIndex
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

-(void)clickToAlertViewTitle:(NSString *)title withDetailTitle:(NSString *)detailTitle isDelegate:(BOOL)isDelegate
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    CustomAlertView *alertView = [[CustomAlertView alloc]initWithFrame:window.bounds WithTitle:title andDetail:detailTitle andBody:nil andCancelTitle:nil andOtherTitle:@"知道了" andIsOneBtn:YES];
    if (isDelegate) {
        alertView.delegate = self;
    }
    [window addSubview:alertView];
}

- (IBAction)publishClick:(UIButton *)sender {
    [self.view endEditing:YES];
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];

    NSString *content = self.contentTextView.text;
    
    if ([content isEqualToString:@""]) {
        [self clickToAlertViewTitle:@"提交失败" withDetailTitle:@"请将信息填写完整！" isDelegate:NO];
        return;
    }

    NSArray *imageDatas = [self getBigImageArray];
    
    [[XDAPIManager sharedManager] requestaddThemeWithParameters:@{@"ownerid":loginModel.userInfo.userId,@"content":content,@"appTokenInfo":loginModel.token} constructingBodyWithBlock:imageDatas CompletionHandle:^(id responseObject, NSError *error) {
        NSDictionary *resultDict = (NSDictionary*)responseObject;
        if ([resultDict[@"resultCode"] isEqualToString:@"0"]) {
//            [MBProgressHUD showSuccessMessage:@"发布成功!"];
            [MBProgressHUD showSuccessMessage:resultDict[@"msg"]];
            if (self.didPublishSuccess) {
                self.didPublishSuccess();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else if([resultDict[@"resultCode"] isEqualToString:@"-1"]){
              [MBProgressHUD showSuccessMessage:resultDict[@"msg"]];
        }
    }];
    
//    requestaddThemeWithParameters
}
@end
