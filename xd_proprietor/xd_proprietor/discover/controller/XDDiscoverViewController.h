//
//  XDDiscoverViewController.h
//  xd_proprietor
//
//  Created by mason on 2018/8/31.
//  Copyright © 2018年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDDiscoverViewController : UIViewController
@property (assign,nonatomic) NSInteger flag; // 全部 1 关注 2
/** <##> */
@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *relationVcArray;
@end
