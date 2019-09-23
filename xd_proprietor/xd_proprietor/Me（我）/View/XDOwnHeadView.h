//
//  XDOwnHeadView.h
//  XD业主
//
//  Created by zc on 2017/6/16.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDOwnHeadView : UIView
//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
//名字
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

//所有信息都在这个label里面拼接的 地址
@property (weak, nonatomic) IBOutlet UILabel *allTextLabel;



//头部被点击了
@property (copy, nonatomic) void(^headImageClick)();


@end
