//
//  XDCommonEvaluteController.m
//  XD业主
//
//  Created by zc on 2017/6/23.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDCommonEvaluteController.h"
#import "BRPlaceholderTextView.h"
#import "XDEvaluateStarView.h"
#import "XDMyComplainListController.h"
#import "XDWarrantyListController.h"

//文本框最多输入多少个数
#define kMaxTextCount 3000


@interface XDCommonEvaluteController ()<UITextViewDelegate,UITextViewDelegate,XDEvaluateStarViewDelegate,CustomAlertViewDelegate>

// 输入框
@property (strong, nonatomic)  BRPlaceholderTextView *questionTextView;

@property (nonatomic, strong) XDEvaluateStarView *starView;

@property (nonatomic, strong)UILabel *scoreLabel;

@property (nonatomic, assign)NSInteger currentScore;

@end

@implementation XDCommonEvaluteController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backColor;
    _currentScore = 5;
    //导航栏
    [self setEvaluteDetailNavi];
    
    [self setEvaluteSubviewsView];
}

/**
 *  设置导航栏
 */
- (void)setEvaluteDetailNavi{
    
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem leftItemWithImageName:@"nav_btn_back" frame:CGRectMake(0, 0, 40, 40) target:self action:@selector(backListOrHome)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font = CFont(19, 17);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = _navTitle;
    self.navigationItem.titleView = titleLabel;
}
- (void)backListOrHome {
    [self popToWhichViewVC];
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
    label1.text = @"满意";
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
    CGFloat textMaxY = CGRectGetMaxY(_questionTextView.frame);
    UIButton *commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, textMaxY +20, kScreenWidth -40, 36)];
    [commitBtn setBackgroundImage:[UIImage imageNamed:@"baoxiu_btn_tijiao"] forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(commitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitBtn.titleLabel.font = titleFont;
    [self.view addSubview:commitBtn];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:NO];

}

- (void)commitBtnClicked {
    if ([self.questionTextView.text isEqualToString:@""]) {
        [self clickToAlertViewTitle:@"提交失败" withDetailTitle:@"请将信息填写完整！" isDelegate:NO];
        return;
    }
    [MBProgressHUD showActivityMessageInWindow:nil];
    if ([_navTitle isEqualToString:@"工单评价"]) {
        XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
        NSNumber *userId = loginModel.userInfo.userId;
        NSString *token = loginModel.token;
        NSString *appMobile = loginModel.userInfo.mobileNumber;
        NSDictionary *dic = @{@"workOrderId":_repairsId,
                              @"taskId":_taskId,
                              @"outcome":@"评价",
                              @"commentContent":_questionTextView.text,
                              @"userId":userId,
                              @"commentLevel":[NSString stringWithFormat:@"%ld",(long)_currentScore],
                              @"appTokenInfo":token,
                              @"appMobile":appMobile,
                              };
            __weak typeof(self) weakSelf = self;
        [[XDAPIManager sharedManager] requestWarrantyEvalute:dic CompletionHandle:^(id responseObject, NSError *error) {
            if (error) {
                [weakSelf clickToAlertViewTitle:@"评论失败" withDetailTitle:@"请重新提交评论！" isDelegate:YES];
                [MBProgressHUD hideHUD];
                return ;
            }
            if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
                [weakSelf clickToAlertViewTitle:@"评论成功" withDetailTitle:@"恭喜评论成功！" isDelegate:YES];
            }else {
                [weakSelf clickToAlertViewTitle:@"评论失败" withDetailTitle:@"请重新提交评论！" isDelegate:YES];
            }
            [MBProgressHUD hideHUD];
        }];
    }else {
        XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
        NSNumber *userId = loginModel.userInfo.userId;
        NSString *token = loginModel.token;
        NSString *appMobile = loginModel.userInfo.mobileNumber;
        NSDictionary *dic = @{@"complainid":_ComplainId,
                              @"taskId":_taskId,
                              @"outcome":@"评价",
                              @"commentContent":_questionTextView.text,
                              @"ownerId":userId,
                              @"commentLevel":[NSString stringWithFormat:@"%ld",(long)_currentScore],
                              @"appTokenInfo":token,
                              @"appMobile":appMobile,
                              };
        
            __weak typeof(self) weakSelf = self;
        [[XDAPIManager sharedManager] requestComplainEvalute:dic CompletionHandle:^(id responseObject, NSError *error) {
            if (error) {
                [weakSelf clickToAlertViewTitle:@"评论失败" withDetailTitle:@"请重新提交评论！" isDelegate:NO];
                [MBProgressHUD hideHUD];
                return ;
            }
            if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
                [weakSelf clickToAlertViewTitle:@"评论成功" withDetailTitle:@"恭喜评论成功！" isDelegate:YES];
            }else {
                [weakSelf clickToAlertViewTitle:@"评论失败" withDetailTitle:@"请重新提交评论！" isDelegate:NO];
            }
            [MBProgressHUD hideHUD];
        }];
    }
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

    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshList" object:nil];
    [self popToWhichViewVC];

}
- (void)popToWhichViewVC {
    NSArray *temArray = self.navigationController.viewControllers;
    for (int i = 0; i<temArray.count; i++) {
        UIViewController *temVC = temArray[i];
        if ([temVC isKindOfClass:[XDWarrantyListController class]] ||[temVC isKindOfClass:[XDMyComplainListController class]])
        {
            [self.navigationController popToViewController:temVC animated:YES];
        }else {
            if (i == temArray.count-1) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        }
        
    }
}

#pragma mark - FMLStarViewDelegate

- (void)fml_didClickStarViewByScore:(CGFloat)score atIndex:(NSInteger)index {
    NSLog(@"score: %f  index：%zd", score, index);
    _currentScore = score;
    if (score == 1) {
        self.scoreLabel.text = @"差";
    }else if(score == 2) {
        self.scoreLabel.text = @"一般";
    }else if(score == 3) {
        self.scoreLabel.text = @"好";
    }else if(score == 4) {
        self.scoreLabel.text = @"很好";
    }else {
        self.scoreLabel.text = @"满意";
    }
}


@end
