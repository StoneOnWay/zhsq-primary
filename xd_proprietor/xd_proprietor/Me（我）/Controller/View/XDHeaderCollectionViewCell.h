//
//  XDHeaderCollectionViewCell.h
//  xd_proprietor
//
//  Created by mason on 2018/9/4.
//Copyright © 2018年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDHeaderCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIControl *clickControl;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *idLab;

- (void)setContent;

@end
