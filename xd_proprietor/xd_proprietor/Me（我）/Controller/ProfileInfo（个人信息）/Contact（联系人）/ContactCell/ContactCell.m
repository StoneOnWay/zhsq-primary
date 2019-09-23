//
//  ContactCell.m
//  XＤ
//
//  Created by zc on 17/4/2.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "ContactCell.h"

@implementation ContactCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"ContactCell";
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactCell" owner:nil options:nil] lastObject];
    }
    return cell;
    
}
- (IBAction)btnClicked:(id)sender {
    if (self.selectContactBtn) {
        self.selectContactBtn();
    }
    
}

@end
