//
//  XDSegmentedControlView.h
//  xd_proprietor
//
//  Created by mason on 2018/9/6.
//  Copyright © 2018年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XDSegmentedControlViewDelegate<NSObject>

- (void)didSelectedItemIndex:(NSInteger)index;

@end

@interface XDSegmentedControlView : UIView

/** <##> */
@property (strong, nonatomic) UISegmentedControl *segmentedControl;
@property (weak, nonatomic) id<XDSegmentedControlViewDelegate>delegate;


@end
