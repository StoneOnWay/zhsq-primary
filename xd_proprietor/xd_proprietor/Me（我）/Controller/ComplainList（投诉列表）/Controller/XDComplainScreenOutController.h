//
//  XDComplainScreenOutController.h
//  XD业主
//
//  Created by zc on 2017/6/22.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XDComplainScreenOutControllerDelegate <NSObject>
@optional
-(void)XDComplainScreenOutControllerWithStartTime:(NSString *)startTime endTime:(NSString *)endTime complainType:(NSInteger)complainType;

@end

@interface XDComplainScreenOutController : UIViewController

@property(nonatomic,weak)id<XDComplainScreenOutControllerDelegate>delegate;


@end
