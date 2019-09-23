//
//  XDMenuItemCollectionViewCell.m
//  xd_proprietor
//
//  Created by mason on 2018/9/3.
//Copyright © 2018年 zc. All rights reserved.
//

#import "XDMenuItemCollectionViewCell.h"

@interface XDMenuItemCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end


@implementation XDMenuItemCollectionViewCell

- (void)setHomeMenuModel:(XDHomeMenuModel *)homeMenuModel {
    _homeMenuModel = homeMenuModel;
    
    self.iconImageView.image = [UIImage imageNamed:homeMenuModel.icon];
    self.titleLabel.text = homeMenuModel.title;
}

@end
