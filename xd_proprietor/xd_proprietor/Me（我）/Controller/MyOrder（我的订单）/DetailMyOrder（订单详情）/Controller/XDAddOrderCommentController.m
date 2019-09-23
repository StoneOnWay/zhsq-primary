//
//  XDAddOrderCommentController.m
//  XD业主
//
//  Created by zc on 2018/3/22.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDAddOrderCommentController.h"
#import "BRPlaceholderTextView.h"
#import "XDEvaluateStarView.h"
#import "XDMyComplainListController.h"
#import "XDWarrantyListController.h"
#import "XDMyOrderShopModel.h"

#define kMaxTextCount 150

@interface XDAddOrderCommentController ()<UITextViewDelegate,UITextViewDelegate,XDEvaluateStarViewDelegate,CustomAlertViewDelegate>
// 输入框
@property (strong, nonatomic)  BRPlaceholderTextView *questionTextView;

@property (nonatomic, strong) XDEvaluateStarView *starView;

@property (nonatomic, strong)UILabel *scoreLabel;

@property (nonatomic, assign)NSInteger currentScore;

@property (nonatomic, assign)NSInteger gradeScore;

@end

@implementation XDAddOrderCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backColor;
    _currentScore = 5;
    _gradeScore = 2;
    //导航栏
    [self setEvaluteDetailNavi];
    
    [self setEvaluteSubviewsView];
}

/**
 *  设置导航栏
 */
- (void)setEvaluteDetailNavi{
    
    self.navigationItem.title = @"评价";
}

#define EHMargin 30

#pragma mark -- 设置星星
- (void)setEvaluteSubviewsView{
    
    
    
    UILabel *label = [[UILabel alloc] init];
    label.x = 27;
    label.y = EHMargin;
    label.text = @"总分";
    [label sizeToFit];
    label.textColor = RGB(74, 74, 74);
    label.font = titleFont;
    [self.view addSubview:label];
    
    //星星
    CGFloat W ;
    CGFloat H ;
    if (kScreenWidth == 320 ) {
        W = 160;
        H = 25;
    }else {
        W = 190;
        H = 30;
    }
    CGFloat labelMaxX = CGRectGetMaxX(label.frame) + 28;
    _starView = [[XDEvaluateStarView alloc] initWithFrame:CGRectMake(labelMaxX, 0, W, H) numberOfStars:5 isTouchable:YES index:100];
    _starView.centerY = label.centerY;
    _starView.currentScore = 5;
    _starView.totalScore = 5;
    _starView.isFullStarLimited = YES;
    _starView.delegate = self;
    [self.view addSubview:_starView];
    
    CGFloat StarMaxX = CGRectGetMaxX(_starView.frame);
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(StarMaxX+20, 50, 50, 20)];
    self.scoreLabel = label1;
    label1.text = @"好评";
    label1.centerY = label.centerY;
    label1.textColor = RGB(74, 74, 74);
    label1.font = titleFont;
    [self.view addSubview:label1];
    
    //那条横线
    CGFloat labelMaxY = CGRectGetMaxY(label.frame);
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, labelMaxY +EHMargin, kScreenWidth, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.alpha = 0.4;
    [self.view addSubview:lineView];
    
    CGFloat lineMaxY = CGRectGetMaxY(lineView.frame);
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(20, lineMaxY + 23, 50, 20)];
    label2.text = @"评价:";
    label2.font = [UIFont systemFontOfSize:15];
    label2.textColor = RGB(74, 74, 74);
    [self.view addSubview:label2];
    
    //输入框
    CGFloat label2MaxY = CGRectGetMaxY(label2.frame);
    _questionTextView = [[BRPlaceholderTextView alloc]initWithFrame:CGRectMake(20, label2MaxY +10, kScreenWidth-40, 100)];
    _questionTextView.placeholder= @"请说说您的想法吧！";
    [_questionTextView setPlaceholderColor:RGB(155, 155, 155)];
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
    
    //提交按钮
    CGFloat buttonW = kScreenWidth;
    CGFloat buttonH = 50;
    CGFloat buttonY = kScreenHeight - buttonH -KYTopNavH;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = SFont(16);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"确认评价" forState:UIControlStateNormal];
    button.backgroundColor = RGB(208, 175, 107);
    [button addTarget:self action:@selector(commitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, buttonY, buttonW, buttonH);
    [self.view addSubview:button];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:NO];
    
}
- (void)commitBtnClicked:(UIButton *)sender {
    
    if ([self.questionTextView.text isEqualToString:@""]) {
        
        [KYRefreshView showWithStatus:@"请将信息填写完整！"];
        [KYRefreshView dismissDeleyWithDuration:1];
        
        return;
    }
    
    [MBProgressHUD showActivityMessageInWindow:nil];
    
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSNumber *userId = loginModel.userInfo.userId;
    NSString *token = loginModel.token;
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSDictionary *dic = @{
                          @"appTokenInfo":token,
                          @"appMobile":appMobile,
                          @"content":_questionTextView.text,
                          @"goodsid":self.shopModel.goodsid,
                          @"orderid":@(self.detailModel.ids),
                          @"ownerid":userId,
                          @"stargrade":@(_currentScore),
                          @"commentgrade":@(_gradeScore),
                          };
    
    WEAKSELF
    [[XDAPIManager sharedManager] requestAddCommentData:dic CompletionHandle:^(id responseObject, NSError *error) {
        
        [MBProgressHUD hideHUD];
        
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            
            if (weakSelf.refreshFinish) {
                weakSelf.refreshFinish();
            }
            sender.userInteractionEnabled = NO;
            sender.backgroundColor = [UIColor lightGrayColor];
            [weakSelf setUpWithAddIsSuccess:YES];
        }else if ([responseObject[@"resultCode"] isEqualToString:@"1"]) {
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
            [SVProgressHUD dismissWithDelay:1.0];
            
        }else {
            [weakSelf setUpWithAddIsSuccess:NO];
        }
    }];
    
}

#pragma mark - 加入评论成功
- (void)setUpWithAddIsSuccess:(BOOL)isSuccess{
    
    if (isSuccess) {
        [SVProgressHUD showSuccessWithStatus:@"评价成功~"];
    }else {
        [SVProgressHUD showErrorWithStatus:@"评价失败,请重新提交~"];
    }
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD dismissWithDelay:1.0];
}

#pragma mark - FMLStarViewDelegate
//懒得改 就这样
- (void)fml_didClickStarViewByScore:(CGFloat)score atIndex:(NSInteger)index {
    
    _currentScore = score;
    if (score == 1) {
        self.scoreLabel.text = @"差评";
        _gradeScore = 0;
    }else if(score == 2) {
        self.scoreLabel.text = @"差评";
        _gradeScore = 0;
    }else if(score == 3) {
        self.scoreLabel.text = @"中评";
        _gradeScore = 1;
    }else if(score == 4) {
        self.scoreLabel.text = @"好评";
        _gradeScore = 2;
    }else {
        self.scoreLabel.text = @"好评";
        _gradeScore = 2;
    }
}

@end
