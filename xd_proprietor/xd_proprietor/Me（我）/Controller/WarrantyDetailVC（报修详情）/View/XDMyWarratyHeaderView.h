//
//  XDMyWarratyHeaderView.h
//  XD业主
//
//  Created by zc on 2017/6/22.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDMyWarratyHeaderView : UIView

//头部图片
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
//名字
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//显示地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

//先导物业
@property (weak, nonatomic) IBOutlet UILabel *XDLabel;
//打电话按钮
@property (weak, nonatomic) IBOutlet UIButton *callPhoneBtn;
//名字的约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelConstaint;

//名字
@property (nonatomic ,copy)NSString *nameText;
//电话
@property (nonatomic ,copy)NSString *phoneNumber;
//地址
@property (nonatomic ,copy)NSString *addressText;
//房屋地址
@property (nonatomic ,copy)NSString *roomAddress;

//头像地址
@property (nonatomic ,copy)NSString *iconUrl;
@end
