//
//  XDCreateOrderFootView.m
//  XD业主
//
//  Created by zc on 2018/3/15.
//  Copyright © 2018年 zc. All rights reserved.
//

#import "XDCreateOrderFootView.h"

@interface XDCreateOrderFootView ()


@property (weak, nonatomic) IBOutlet UILabel *countLabels;

@end

@implementation XDCreateOrderFootView

+ (instancetype)footerViewWithTableView:(UITableView *)tableView 
{
    static NSString *ID=@"XDCreateOrderFootView";
    XDCreateOrderFootView *foot=[tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (foot == nil) {
        foot=[[[NSBundle mainBundle]loadNibNamed:@"XDCreateOrderFootView" owner:nil options:nil]lastObject];
    }
    return foot;
}

- (void)setCountString:(NSString *)countString {
    
    _countString = countString;
    self.countLabels.text = countString;
}

@end
