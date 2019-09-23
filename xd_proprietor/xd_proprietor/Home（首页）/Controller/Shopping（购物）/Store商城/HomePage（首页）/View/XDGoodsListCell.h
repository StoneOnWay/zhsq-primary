//
//  XDGoodsListCell.h
//  XD业主
//
//  Created by zc on 2018/3/7.
//  Copyright © 2018年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^cartBtnBeClicked)(void);

@class XDGoodsListModel;
@interface XDGoodsListCell : UICollectionViewCell

@property (strong, nonatomic) XDGoodsListModel *listModel;

@property (nonatomic, copy) cartBtnBeClicked cartBtnBeClickedBlock;
@end
