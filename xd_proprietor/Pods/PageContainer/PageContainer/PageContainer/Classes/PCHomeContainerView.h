//
//  PCHomeContainerView.h
//  yunshangyi
//
//  Created by mason on 2018/3/28.
//
//

#import <UIKit/UIKit.h>

@protocol PCHomeContainerViewDelegate <NSObject>

- (NSArray *) pageViewControllers;

@optional
- (void) didSelectedIndex:(NSInteger)index;
- (BOOL) switchAnimated;
- (BOOL) swipeGesturesAnimated;

@end

@interface PCHomeContainerView : UIView

@property (weak, nonatomic) id<PCHomeContainerViewDelegate> delegate;

- (void) initPageVC;
- (void) didSelectedItemWithIndex:(NSInteger)index;

@end
