//
//  XDFaceManageController.h
//  xd_proprietor
//
//  Created by stone on 23/4/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XDFaceManageController : UIViewController
@property (nonatomic, strong) XDloginUserInfoModel *userModel;
@property (nonatomic, copy) void (^faceDidUpdateSuccess)(UIImage *faceImage);
@end

NS_ASSUME_NONNULL_END
