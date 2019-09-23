//
//  XDSwitchGridCell.h
//  XD业主
//
//  Created by zc on 2018/3/7.
//  Copyright © 2018年 zc. All rights reserved.
//首页XDHomePageController的cell

#import <UIKit/UIKit.h>
@class XDHomeDataModel;
//首页XDHomePageController的cell
@interface XDSwitchGridCell : UICollectionViewCell
@property (nonatomic, strong) XDHomeDataModel *homeModel;
@end
