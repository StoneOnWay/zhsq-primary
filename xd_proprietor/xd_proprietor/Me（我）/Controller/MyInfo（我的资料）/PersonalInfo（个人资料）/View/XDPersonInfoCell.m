//
//  XDPersonInfoCell.m
//  xd_proprietor
//
//  Created by stone on 14/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDPersonInfoCell.h"
#import "XDPersonalConfigModel.h"

@implementation XDPersonInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setPersonInfo:(XDPersonalConfigModel *)personInfo {
    _personInfo = personInfo;
    self.titleLabel.text = personInfo.title;
    self.subTitleLabel.text = personInfo.subTitle;
    if (personInfo.isImage) {
        self.headImageView.hidden = NO;
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyHeadImageData"];
        if (data == nil) {
            NSString *urlString = nil;
            if ([personInfo.headUrl containsString:@"qq"] || [personInfo.headUrl containsString:@"thirdwx"]) {
                urlString = personInfo.headUrl;
            } else {
                urlString = [NSString stringWithFormat:@"%@/%@?v=%@",K_BASE_URL, personInfo.headUrl, [XDUtil getNowTimeTimestamp]];
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
    } else {
        self.headImageView.hidden = YES;
    }
//    if (personInfo.headImage) {
//        self.headImageView.hidden = NO;
//        self.headImageView.image = personInfo.headImage;
//    } else {
//        if (personInfo.headUrl) {
//            // 拼接版本号防止加载缓存图片
//            NSString *timeStamp = [XDUtil getNowTimeTimestamp];
//            NSString *urlStr = [NSString stringWithFormat:@"%@?v=%@", personInfo.headUrl, timeStamp];
//            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:nil];
//            self.headImageView.hidden = NO;
//        } else {
//            self.headImageView.hidden = YES;
//        }
//    }
    
    if (personInfo.hasArrow) {
        self.arrowImageView.hidden = NO;
        self.subTitleTrailingConstraint.constant = 8;
    } else {
        self.arrowImageView.hidden = YES;
        self.subTitleTrailingConstraint.constant = 0;
    }
}

@end
