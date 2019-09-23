//
//  XDOwnHeadView.m
//  XD业主
//
//  Created by zc on 2017/6/16.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDOwnHeadView.h"
#import "UIImageView+WebCache.h"
#import "XDLoginUserRoomInfoModel.h"
@implementation XDOwnHeadView
- (void)awakeFromNib {

    [super awakeFromNib];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyHeadImageData"];
    
    if (data == nil) {
        XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
        NSString *urlString = [NSString stringWithFormat:@"%@/%@",K_BASE_URL,loginModel.userInfo.headImageUrl];
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"wode_touxiang"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                NSData *data = UIImagePNGRepresentation(image);
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"MyHeadImageData"];
            }
        }];
    } else {
        self.headImage.image = [UIImage imageWithData:data];
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *nickName = [ud objectForKey:@"nickName"];
    if (nickName != nil) {
        self.nameLabel.text = nickName;
    }else {
        XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
        NSString *nickName = loginModel.userInfo.nickName;
        self.nameLabel.text = nickName;
    }
    
    NSString *commonAddress = [ud objectForKey:@"commonAddress"];
    if (commonAddress != nil) {
        self.allTextLabel.text = commonAddress;
    }else {
        
        XDLoginUseModel *loginAccout = [XDReadLoginModelTool loginModel];
        XDLoginUserRoomInfoModel *roomIfo = loginAccout.roominfo.firstObject;
        self.allTextLabel.text = roomIfo.address;
    }
    
    self.headImage.layer.cornerRadius = self.headImage.width/2;
    [self.headImage.layer setMasksToBounds:YES];
}

- (IBAction)clickMyHeadBtn:(UIButton *)sender {
    
    if (self.headImageClick) {
        self.headImageClick();
    }
    
}

@end
