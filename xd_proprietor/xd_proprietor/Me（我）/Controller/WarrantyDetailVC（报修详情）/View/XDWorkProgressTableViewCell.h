//
//  XDWorkProgressTableViewCell.h
//  xd_proprietor
//
//  Created by mason on 2018/9/7.
//Copyright © 2018年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDProcessModel.h"
#import "GGLine.h"

@interface XDWorkProgressTableViewCell : UITableViewCell

/** <##> */
@property (strong, nonatomic) XDProcessModel *processModel;

@property (weak, nonatomic) IBOutlet GGLine *aboveLine;
@property (weak, nonatomic) IBOutlet GGLine *belowLine;

@end
