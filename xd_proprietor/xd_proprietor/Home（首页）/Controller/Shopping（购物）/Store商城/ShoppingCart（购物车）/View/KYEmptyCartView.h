//
//  KYEmptyCartView.h
//  XD业主
//
//  Created by zc on 2018/3/8.
//  Copyright © 2018年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KYEmptyCartView : UIView

/** 抢购点击回调 */
@property (nonatomic, copy) dispatch_block_t buyingClickBlock;

@end
