//
//  XDFaceManageController.m
//  xd_proprietor
//
//  Created by stone on 23/4/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDFaceManageController.h"
#import "XDImagePickerController.h"
#import "XDOverlayView.h"

@interface XDFaceManageController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, XDOverlayViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
@property (weak, nonatomic) IBOutlet UIImageView *faceImageView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) XDOverlayView *overlay;

@end

@implementation XDFaceManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.userModel.name;
    [self setUpFaceImageView];
    [self loadFaceImage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setUpFaceImageView {
    self.faceImageView.layer.cornerRadius = self.faceImageView.frame.size.width / 2;
    self.faceImageView.layer.masksToBounds = YES;
}

- (void)loadFaceImage {
    if (!self.userModel.faceDisUrl) {
        [self.photoBtn setTitle:@"拍照并上传我的人脸" forState:(UIControlStateNormal)];
        self.stateLabel.text = @"人脸照片尚未上传";
    } else {
        self.stateLabel.text = @"人脸上传时间";
        self.timeLabel.text = self.userModel.faceDisTime;
        [self.photoBtn setTitle:@"重新上传" forState:(UIControlStateNormal)];
        [self.faceImageView sd_setImageWithURL:[NSURL URLWithString:self.userModel.faceDisUrl] placeholderImage:[UIImage imageNamed:@"moren_tx_hui"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
        }];
    }
}

- (IBAction)photoAction:(id)sender {
    XDImagePickerController *picker = [[XDImagePickerController alloc] init];
    if ([XDImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.showsCameraControls = NO;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        XDOverlayView *overlay = [[XDOverlayView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.overlay = overlay;
        overlay.picker = picker;
        overlay.delegate = self;
        picker.cameraOverlayView = overlay;
        picker.cameraOverlayView.frame = [UIScreen mainScreen].bounds;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)uploadFaceData:(UIImage *)image {
//    XDLoginUseModel *model = [XDReadLoginModelTool loginModel];
    [MBProgressHUD showActivityMessageInWindow:nil];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"faceCollect.jpg"];
    NSLog(@"face image file path -- %@", filePath);
    
    NSData *imageData = [image compressBySize:CGSizeMake(960, 1280) WithMaxLength:100 * 1024];
    [imageData writeToFile:filePath atomically:YES];

    if (!self.userModel.ownerid || !self.userModel.name) {
        [XDUtil showToast:@"不支持上传人脸！"];
        [MBProgressHUD hideHUD];
        return;
    }
    NSString *userId = [NSString stringWithFormat:@"%@", self.userModel.ownerid];
    NSDictionary *dic = @{
                          @"userId":userId,
                          @"userName":self.userModel.name,
                          };
    [[XDAPIManager sharedManager] requestFaceUploadParameters:dic constructingBodyWithBlock:filePath name:@"imageFile" CompletionHandle:^(NSDictionary *responseObject, NSError *error) {
        if (error) {
            [XDUtil showToast:@"人脸上传失败！"];
            [MBProgressHUD hideHUD];
            return;
        }
        if ([responseObject[@"code"] intValue] == 200) {
            [MBProgressHUD hideHUD];
            NSDictionary *dataDic = responseObject[@"data"];
            self.faceImageView.image = image;
            self.stateLabel.text = @"人脸上传时间";
            self.timeLabel.text = dataDic[@"faceDisTime"];
            [self.photoBtn setTitle:@"重新上传" forState:(UIControlStateNormal)];
            if (self.faceDidUpdateSuccess) {
                self.faceDidUpdateSuccess(image);
            }
//            if (model.userInfo.userId.intValue == self.userModel.ownerid.intValue) {
//                // 修改的是当前登录业主的人脸，需保存
//                model.userInfo.faceDisUrl = dataDic[@"faceDisUrl"];
//                model.userInfo.faceDisTime = dataDic[@"faceDisTime"];
//                [XDReadLoginModelTool save:model];
//            }
        } else {
            [XDUtil showToast:@"人脸上传失败！!"];
            [MBProgressHUD hideHUD];
        }
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.overlay.photoImageView.image = image;
    self.overlay.photoImageView.hidden = NO;
}

- (void)overlayDidSelect {
    [self uploadFaceData:self.overlay.photoImageView.image];
}

@end
