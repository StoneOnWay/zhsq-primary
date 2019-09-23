//
//  XDFaceCell.h
//  xd_proprietor
//
//  Created by cfsc on 2019/6/13.
//  Copyright © 2019年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDloginUserInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XDFaceCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *faceImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) XDloginUserInfoModel *userModel;

@end

NS_ASSUME_NONNULL_END
