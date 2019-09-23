//
//  XDWarrantyScreenOutController.h
//  XD业主
//
//  Created by zc on 2017/6/22.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol XDWarrantyScreenOutControllerDelegate <NSObject>
@optional
-(void)XDWarrantyScreenOutControllerWithStartTime:(NSString *)startTime endTime:(NSString *)endTime workOrderType:(NSInteger)workOrderType;

@end

@interface XDWarrantyScreenOutController : UIViewController

@property(nonatomic,weak)id<XDWarrantyScreenOutControllerDelegate>delegate;

@end
