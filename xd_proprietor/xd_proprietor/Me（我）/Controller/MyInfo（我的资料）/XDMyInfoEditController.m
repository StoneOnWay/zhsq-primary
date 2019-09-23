//
//  XDMyInfoEditController.m
//  XD业主
//
//  Created by zc on 2017/6/28.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDMyInfoEditController.h"
#import "XDChooseContactController.h"
#import "XDChooseAddressController.h"

@interface XDMyInfoEditController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,XDChooseContactControllerDelegate,XDChooseAddressControllerDelegate,CustomAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *nameBackView;
@property (weak, nonatomic) IBOutlet UIView *addressBackView;

@property (weak, nonatomic) IBOutlet UIView *contactBackView;


@end

@implementation XDMyInfoEditController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setBackViewLayer];
    
    [self setInfoNavi];
    
    self.headImageView.image = self.headImage;
    self.nameText.text = self.textName;
}

/**
 *  设置导航栏
 */
-(void)setInfoNavi{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font = CFont(19, 17);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"编辑我的资料";
    self.navigationItem.titleView = titleLabel;
    self.view.backgroundColor = [UIColor whiteColor];//backColor;
    
}

- (void)setBackViewLayer {
    
    self.headImageView.layer.cornerRadius = self.headImageView.width/2;
    [self.headImageView.layer setMasksToBounds:YES];
    
    self.nameBackView.layer.borderWidth = 1;
    self.nameBackView.layer.borderColor = BianKuang.CGColor;
    self.nameBackView.layer.cornerRadius = 5;
    [self.nameBackView.layer setMasksToBounds:YES];
    
    self.addressBackView.layer.borderWidth = 1;
    self.addressBackView.layer.borderColor = BianKuang.CGColor;
    self.addressBackView.layer.cornerRadius = 5;
    [self.addressBackView.layer setMasksToBounds:YES];
    
    self.contactBackView.layer.borderWidth = 1;
    self.contactBackView.layer.borderColor = BianKuang.CGColor;
    self.contactBackView.layer.cornerRadius = 5;
    [self.contactBackView.layer setMasksToBounds:YES];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self.view endEditing:YES];

}



//地址按钮的点击
- (IBAction)addressBtnClick:(UIButton *)sender {
    XDChooseAddressController *address = [[XDChooseAddressController alloc] init];
    address.delegate = self;
    [self.navigationController pushViewController:address animated:YES];
    
}
//联系人按钮的点击
- (IBAction)contactBtnClick:(id)sender {
    
    XDChooseContactController *choose = [[XDChooseContactController alloc] init];
    choose.delegate = self;
    [self.navigationController pushViewController:choose animated:YES];
    
}

//XDChooseContactControllerDelegate
-(void)XDChooseContactControllerWithName:(NSString *)name andPhoneNumb:(NSString *)phone {
    self.contactTextF.text = [NSString stringWithFormat:@"%@ - %@",name,phone];

}
//XDChooseAddressControllerDelegate
- (void)XDChooseAddressControllerWithName:(NSString *)name {

    self.addressTextF.text = name;
    
}



- (IBAction)commitBtnClicke:(UIButton *)sender {
    
    if ([self.nameText.text isEqualToString:@""]) {
        [self clickToAlertViewTitle:@"提交失败" withDetailTitle:@"请输入昵称!" isDelegate:NO];
        return;
    }
    
    NSData *imageData = UIImagePNGRepresentation(self.headImageView.image);
    NSArray *imageArray = [NSArray arrayWithObject:imageData];
    // 提交个人资料
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSString *appMobile = loginModel.userInfo.mobileNumber;
    NSNumber *userId = loginModel.userInfo.userId;
    NSString *token = loginModel.token;
    
    NSDictionary *dic = @{
                          @"appMobile" : appMobile,
                          @"appTokenInfo":token,
                          @"ownerid":userId,
                          @"nickname":self.nameText.text,
                          };
    [MBProgressHUD showActivityMessageInWindow:nil];
    __weak typeof(self) weakSelf = self;
    [[XDAPIManager sharedManager] requestEditPersonalInformationParameters:dic constructingBodyWithBlock:imageArray CompletionHandle:^(id responseObject, NSError *error) {
        [MBProgressHUD hideHUD];
        if (error) {
            [self clickToAlertViewTitle:@"提交失败" withDetailTitle:@"请检查网络设置！" isDelegate:NO];
            return ;
        }
        if ([responseObject[@"resultCode"] isEqualToString:@"0"]) {
            
            NSData *data = UIImagePNGRepresentation(weakSelf.headImageView.image);
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:weakSelf.nameText.text forKey:@"nickName"];
            [ud setObject:data forKey:@"MyHeadImageData"];
            //暂时没用
//            [ud setObject:weakSelf.addressTextF.text forKey:@"commonAddress"];
//            [ud setObject:weakSelf.contactTextF.text forKey:@"commonContact"];
            
            
            [self clickToAlertViewTitle:@"提交成功" withDetailTitle:@"个人信息修改成功！" isDelegate:YES];
        }else {
        
            [self clickToAlertViewTitle:@"提交失败" withDetailTitle:@"请重新提交！" isDelegate:NO];
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
    
    if ([self.delegate respondsToSelector:@selector(XDMyInfoEditControllerWithUsualName:withUsualAddress:withUsualContact:withMyHeadImage:)]) {
        
        [self.delegate XDMyInfoEditControllerWithUsualName:self.nameText.text withUsualAddress:self.addressTextF.text withUsualContact:self.contactTextF.text withMyHeadImage:self.headImageView.image];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}
//头像按钮的点击
- (IBAction)headImageViewBtnClick:(UIButton *)sender {
    
    [self takePhoto];
    
}

#pragma mark - UIAlert
- (void)takePhoto {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet ];
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
    NSDictionary *textAt = @{NSForegroundColorAttributeName : [UIColor blackColor]
                             };
    [imagePicker.navigationBar setTitleTextAttributes:textAt];
    imagePicker.navigationBar.tintColor = [UIColor blackColor];
    imagePicker.delegate = self;
    imagePicker.sourceType = type;
    imagePicker.allowsEditing = YES;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:imagePicker animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }];
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //    返回一个编辑后的图片 UIImagePickerControllerOriginalImage
    UIImage *selectedImage = info[@"UIImagePickerControllerEditedImage"];
    self.headImageView.image = selectedImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
