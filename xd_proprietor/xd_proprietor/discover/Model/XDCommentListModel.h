//
//  XDCommentListModel.h
//  xd_proprietor
//
//  Created by xielei on 2019/1/26.
//  Copyright © 2019年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NSObject+YYModel.h>
NS_ASSUME_NONNULL_BEGIN

@interface XDCommentListModel : NSObject<YYModel>
@property (strong,nonatomic) NSString *commentList;
@property (strong,nonatomic) NSString *content;
@property (strong,nonatomic) NSString *homePicUrl;
@property (strong,nonatomic) NSString *mid;
@property (strong,nonatomic) NSString *ownerid;
@property (strong,nonatomic) NSString *ownerFace;
@property (strong,nonatomic) NSString *ownerName;
@property (strong,nonatomic) NSArray *picList;
@property (strong,nonatomic) NSString *resourceskey;
@property (strong,nonatomic) NSString *time;
@property (strong,nonatomic) NSString *upNumber;

@end

NS_ASSUME_NONNULL_END
