//
//  XDAddMyCarsFootView.m
//  XD业主
//
//  Created by zc on 2017/7/21.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDAddMyCarsFootView.h"

@implementation XDAddMyCarsFootView

+ (instancetype)footerViewWithTableView:(UITableView *)tableView
{
    static NSString *ID=@"XDAddMyCarsFootView";
    XDAddMyCarsFootView *foot=[tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (foot == nil) {
        
        foot=[[[NSBundle mainBundle]loadNibNamed:@"XDAddMyCarsFootView" owner:nil options:nil]lastObject];
        
    }
    
    return foot;
}

- (IBAction)commitBtn:(UIButton *)sender {
    if (self.commitBlock) {
        self.commitBlock();
    }
    
}


@end
