//
//  XDPostMessageController.m
//  XD业主
//
//  Created by zc on 2017/8/11.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDPostMessageController.h"
#import "BRPlaceholderTextView.h"
#import "PYPhotosView.h"
#import "PYPhotosPreviewController.h"
#import "HWImagePickerSheet.h"
#import <JavaScriptCore/JavaScriptCore.h>

#define questionH 100
#define kMaxTextCount 200

@interface XDPostMessageController ()<UITextViewDelegate,UITextViewDelegate,PYPhotosViewDelegate,HWImagePickerSheetDelegate>

{
    //备注文本View高度
    float noteTextHeight;
    
    float allViewHeight;
    
}

//提交按钮
@property(nonatomic,strong) UIButton *submitBtn;

@property(nonatomic,strong) UIView *lineView;
// 输入框
@property (strong, nonatomic)  BRPlaceholderTextView *questionTextView;

@property (strong, nonatomic) UIScrollView *scrollView;

/** 即将发布的图片存储的photosView */
@property (nonatomic, weak) PYPhotosView *publishPhotosView;

//选择的图片数据
@property(nonatomic,strong) NSMutableArray *arrSelected;

//方形压缩图image 数组
@property(nonatomic,strong) NSMutableArray * imageArray;

//大图image 数组
@property(nonatomic,strong) NSMutableArray * bigImageArray;

//图片选择器
@property(nonatomic,weak) UIViewController *showActionSheetViewController;

//提出的提示框 选择照片还是相机
@property (nonatomic, strong) HWImagePickerSheet *imgPickerActionSheet;

//文字个数提示label
@property (nonatomic, strong) UILabel *textNumberLabel;

@end

@implementation XDPostMessageController

-(instancetype)init{
    self = [super init];
    if (self) {
        if (!_showActionSheetViewController) {
            _showActionSheetViewController = self;
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    //拍照用的同一个框架 有些地方是三个 有些地方是九个
    [[NSUserDefaults standardUserDefaults] setObject:@"9" forKey:@"kMaxImageCount"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"发帖";
    self.view.backgroundColor = backColor;
  
    //收起键盘
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
 
    [self initViews];
    
}

- (void)viewTapped{
    [self.view endEditing:YES];
}

- (void)initViews {
    
    if(!_bigImageArray.count)
    {
        _bigImageArray = [NSMutableArray array];
    }
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:self.scrollView];
    
    _questionTextView = [[BRPlaceholderTextView alloc]init];
    _questionTextView.backgroundColor = backColor;
    _questionTextView.placeholder= @"说点什么吧。。。";
    [_questionTextView setPlaceholderColor:[UIColor lightGrayColor]];
    [_questionTextView setFont:[UIFont systemFontOfSize:14.0]];
    [_questionTextView setTextColor:[UIColor blackColor]];
    _questionTextView.maxTextLength = kMaxTextCount;
    _questionTextView.delegate = self;
    
    _textNumberLabel = [[UILabel alloc]init];
    _textNumberLabel.textAlignment = NSTextAlignmentRight;
    _textNumberLabel.font = [UIFont boldSystemFontOfSize:12];
    _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    _textNumberLabel.text = [NSString stringWithFormat:@"0/%d    ",kMaxTextCount];
    
    // 1. 常见一个发布图片时的photosView
    PYPhotosView *publishPhotosView = [PYPhotosView photosView];
    self.publishPhotosView = publishPhotosView;
    publishPhotosView.photoWidth = (self.view.frame.size.width-30-15)/4;
    publishPhotosView.photoHeight = (self.view.frame.size.width-30-15)/4;
    publishPhotosView.photosMaxCol = 4;
    publishPhotosView.py_x = 15;
    publishPhotosView.py_y = _questionTextView.py_y+10;
    // 3. 设置代理
    publishPhotosView.delegate = self;
    
    
    UIView *lineView = [[UIView alloc] init];
    self.lineView = lineView;
    lineView.backgroundColor = RGB(230, 230, 230);
    
    _submitBtn = [[UIButton alloc]init];
    [_submitBtn setTitle:@"发表" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitBtn setBackgroundImage:[UIImage imageNamed:@"baoxiu_btn_tijiao"] forState:UIControlStateNormal];
    [_submitBtn addTarget:self action:@selector(submitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    // 4. 添加view
    [_scrollView addSubview:_questionTextView];
    [_scrollView addSubview:_textNumberLabel];
    [_scrollView addSubview:publishPhotosView];
    [_scrollView addSubview:lineView];
    [_scrollView addSubview:_submitBtn];
    
    [self updateViewsFrame];
}

- (void)submitBtnClicked{
    
    if (self.questionTextView.text.length == 0) {
        return;
    }
    
    [MBProgressHUD showActivityMessageInWindow:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self afterCommitData];
    });
    
    
}

- (void)afterCommitData {
    
    
    XDLoginUseModel *loginAccout = [XDReadLoginModelTool loginModel];
    NSString *ownerid = [NSString stringWithFormat:@"%@",loginAccout.userInfo.userId];
    //获取当前时间加一小时
    NSDictionary *dic = @{
                          @"publishId":ownerid,
                          @"body":self.questionTextView.text,
                          
                          };
    NSArray *picArray = [self getBigImageArray];
    
    [[XDAPIManager sharedManager] requestPostMessageParameters:dic constructingBodyWithBlock:picArray CompletionHandle:^(id responseObject, NSError *error) {
        
        if (error) {
            [self clickToAlertViewTitle:@"发帖失败" withDetailTitle:@"数据请求超时，请重试！"];
            [MBProgressHUD hideHUD];
            return ;
        }
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            
            [MBProgressHUD hideHUD];
            
            [self sucessedAfter];
            
        }else {
            
            [self clickToAlertViewTitle:@"登录失败" withDetailTitle:@"数据请求超时，请重试！"];
            [MBProgressHUD hideHUD];
            return ;
            
        }
        
    }];

}
- (void)sucessedAfter {
    
    [self.navigationController popViewControllerAnimated:YES];
    
    if (self.refreshWebview) {
        self.refreshWebview();
    }

}

-(void)clickToAlertViewTitle:(NSString *)title withDetailTitle:(NSString *)detailTitle
{
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    CustomAlertView *alertView = [[CustomAlertView alloc]initWithFrame:window.bounds WithTitle:title andDetail:detailTitle andBody:nil andCancelTitle:nil andOtherTitle:@"知道了" andIsOneBtn:YES];
    [window addSubview:alertView];
    
}

- (void)updateViewsFrame{
    
    if (!allViewHeight) {
        allViewHeight = 0;
    }
    if (!noteTextHeight) {
        noteTextHeight = questionH;
    }

    //文本编辑框
    _questionTextView.frame = CGRectMake(15, 10, kScreenWidth - 30, noteTextHeight);
    
    CGFloat textMaxY = CGRectGetMaxY(_questionTextView.frame);
    
    //文字个数提示Label
    _textNumberLabel.frame = CGRectMake(15, textMaxY, kScreenWidth - 30, 20);
    
    _publishPhotosView.py_y = textMaxY +10 + 25;
    
    //提交按钮
    CGFloat photosMaxY = CGRectGetMaxY(_publishPhotosView.frame);
    _lineView.frame = CGRectMake(15, photosMaxY+20, kScreenWidth, 1);
    
    _submitBtn.frame = CGRectMake(15, photosMaxY+40, kScreenWidth -30, 36);
    
    CGFloat submitMaxY = CGRectGetMaxY(_publishPhotosView.frame);
    allViewHeight = submitMaxY + 30;
    
    _scrollView.contentSize = self.scrollView.contentSize = CGSizeMake(0,allViewHeight);
    
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //当前输入字数
    _textNumberLabel.text = [NSString stringWithFormat:@"%lu/%d    ",(unsigned long)_questionTextView.text.length,kMaxTextCount];
    
    if (_questionTextView.text.length > kMaxTextCount) {
        _textNumberLabel.textColor = [UIColor redColor];
    }else{
        _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    }
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    [self questTextDidChange];
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    
    _textNumberLabel.text = [NSString stringWithFormat:@"%lu/%d    ",(unsigned long)_questionTextView.text.length,kMaxTextCount];
    if (_questionTextView.text.length > kMaxTextCount) {
        _textNumberLabel.textColor = [UIColor redColor];
    }
    else{
        _textNumberLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    }
    
    [self questTextDidChange];
}

-(void)questTextDidChange{
    
    CGRect orgRect = self.questionTextView.frame;//获取原始UITextView的frame
    
    CGSize size = [self.questionTextView sizeThatFits:CGSizeMake(self.questionTextView.frame.size.width, MAXFLOAT)];
    
    orgRect.size.height=size.height+10;//获取自适应文本内容高度
    
    if (orgRect.size.height > questionH) {
        noteTextHeight = orgRect.size.height;
    }else {
        noteTextHeight = questionH;
    }
    
    [self updateViewsFrame];

}

#pragma mark - PYPhotosViewDelegate
- (void)photosView:(PYPhotosView *)photosView didAddImageClickedWithImages:(NSMutableArray *)images
{
    [self addNewImg];
}

- (void)addNewImg{
    if (!_imgPickerActionSheet) {
        _imgPickerActionSheet = [[HWImagePickerSheet alloc] init];
        _imgPickerActionSheet.delegate = self;
    }
    if (_arrSelected) {
        _imgPickerActionSheet.arrSelected = _arrSelected;
    }
//    [_imgPickerActionSheet showImgPickerActionSheetInView:_showActionSheetViewController];
}
/**
 *  相册完成选择得到图片
 */
-(void)getSelectImageWithALAssetArray:(NSArray *)ALAssetArray thumbnailImageArray:(NSArray *)thumbnailImgArray{
    //（ALAsset）类型 Array
    _arrSelected = [NSMutableArray arrayWithArray:ALAssetArray];
    //正方形缩略图 Array
    _imageArray = [NSMutableArray arrayWithArray:thumbnailImgArray] ;
    
    [self.publishPhotosView reloadDataWithImages:_imageArray];
    
    [self updateViewsFrame];
}
- (NSArray*)getBigImageArray{
    
    return [self getBigImageArrayWithALAssetArray:_arrSelected];
}
//获得大图
- (NSArray*)getBigImageArrayWithALAssetArray:(NSArray*)ALAssetArray{
    NSMutableArray *bigImgArr = [NSMutableArray array];
//    for (ALAsset *set in ALAssetArray) {
//        [bigImgArr addObject:[self getBigIamgeDataWithALAsset:set]];
//    }

    for (int i = 0; i<ALAssetArray.count; i++) {
        if ([ALAssetArray[i] isKindOfClass:[UIImage class]]) {
            UIImage *img = ALAssetArray[i];
            NSData *imageData = UIImageJPEGRepresentation(img, 0.5);
            imageData = [KYCompressImage compressImage:imageData toByte:30*1024];
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

// 进入预览图片时调用, 可以在此获得预览控制器，实现对导航栏的自定义
- (void)photosView:(PYPhotosView *)photosView didPreviewImagesWithPreviewControlelr:(PYPhotosPreviewController *)previewControlelr
{
    NSLog(@"进入预览图片");
}

@end
