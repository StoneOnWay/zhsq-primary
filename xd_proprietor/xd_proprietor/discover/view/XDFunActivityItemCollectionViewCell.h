//
//  XDFunActivityItemCollectionViewCell.h
//  xd_proprietor
//
//  Created by mason on 2018/9/4.
//Copyright © 2018年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDCommentListModel.h"

@protocol ISLikeDelegate <NSObject>

- (void) islikeWithModel:(XDCommentListModel*)model;

@end


@interface XDFunActivityItemCollectionViewCell : UICollectionViewCell

@property (assign , nonatomic) id<ISLikeDelegate> delegate;

- (void)setCellDataWithModel:(XDCommentListModel*)model;
@end
