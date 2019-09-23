//
//  XDPayforScreenController.h
//  XD业主
//
//  Created by zc on 2017/11/14.
//  Copyright © 2017年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol XDPayforScreenControllerDelegate <NSObject>
@optional

-(void)XDPayforScreenControllerWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;

@end
@interface XDPayforScreenController : UIViewController

@property(nonatomic,weak)id<XDPayforScreenControllerDelegate>delegate;

@end
