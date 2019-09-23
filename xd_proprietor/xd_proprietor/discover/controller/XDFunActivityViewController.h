//
//  XDFunActivityViewController.h
//  xd_proprietor
//
//  Created by mason on 2018/9/4.
//Copyright © 2018年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDFunActivityViewController : UIViewController
/** controller数组 */
@property (strong, nonatomic) NSMutableArray *viewControllerArray;
/** 当前位置 */
@property (assign, nonatomic) NSInteger currentIndex;
@end
