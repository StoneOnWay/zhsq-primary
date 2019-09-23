//
//  XDHeaderCollectionViewCell.m
//  xd_proprietor
//
//  Created by mason on 2018/9/4.
//Copyright © 2018年 zc. All rights reserved.
//

#import "XDHeaderCollectionViewCell.h"
#import "XDLoginUserRoomInfoModel.h"
#import "XDThirdInfoModel.h"

@interface XDHeaderCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@end

@implementation XDHeaderCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.headerImageView.layer setCornerRadius:self.headerImageView.width / 2.f];
    [self.headerImageView.layer setMasksToBounds:YES];
    
    [self.headerImageView.layer setBorderWidth:2.f];
    [self.headerImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self loadHeadImage];
    [self setNameText];
}

- (void)setContent {
    [self loadHeadImage];
    [self setNameText];
    
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    XDLoginUserRoomInfoModel *model = loginModel.roominfo.firstObject;
    self.idLab.text = model.address;
}

- (void)setNameText {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *nickName = [ud objectForKey:@"nickName"];
    if (nickName != nil) {
        self.nameLab.text = nickName;
    } else {
        XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
        NSString *nickName = nil;
        if (loginModel.userInfo.userId) {
            nickName = loginModel.userInfo.nickName;
        } else {
            if (loginModel.thirdInfo) {
                XDThirdInfoModel *thirdInfo = loginModel.thirdInfo.firstObject;
                nickName = thirdInfo.nickname;
            }
        }
        self.nameLab.text = nickName;
    }
}

- (void)loadHeadImage {
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyHeadImageData"];
    if (data == nil) {
        NSString *urlString = nil;
        if (loginModel.userInfo.userId) {
            urlString = [NSString stringWithFormat:@"%@/%@?v=%@",K_BASE_URL, loginModel.userInfo.headImageUrl, [XDUtil getNowTimeTimestamp]];
        } else {
            if (loginModel.thirdInfo) {
                XDThirdInfoModel *thirdInfo = loginModel.thirdInfo.firstObject;
                urlString = thirdInfo.faceImg;
            }
        }
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"wode_touxiang"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if ([urlString containsString:K_BASE_URL]) {
                // 不保存QQ微信头像
                if (image) {
                    NSData *data = UIImagePNGRepresentation(image);
                    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"MyHeadImageData"];
                }
            }
        }];
    } else {
        self.headImageView.image = [UIImage imageWithData:data];
    }
}

@end
