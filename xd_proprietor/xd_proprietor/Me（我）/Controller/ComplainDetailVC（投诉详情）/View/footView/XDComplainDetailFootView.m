//
//  XDComplainDetailFootView.m
//  XD业主
//
//  Created by zc on 2017/6/22.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDComplainDetailFootView.h"

@implementation XDComplainDetailFootView


- (void)awakeFromNib {
    [super awakeFromNib];

    

}
+ (instancetype)footerViewWithTableView:(UITableView *)tableView withType:(NSString *)type
{
    static NSString *ID=@"XDComplainDetailFootView";
    XDComplainDetailFootView *foot=[tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (foot == nil) {
        if ([type isEqualToString:@"是否满意"]) {
            //是否满意
            foot=[[[NSBundle mainBundle]loadNibNamed:@"XDComplainDetailFootView2" owner:nil options:nil]lastObject];
        }else if ([type isEqualToString:@"评价"]) {
            
            //评价
            foot=[[[NSBundle mainBundle]loadNibNamed:@"XDComplainDetailFootView3" owner:nil options:nil]lastObject];
        
        }else if ([type isEqualToString:@"业主是否接受整改"]) {
            //是否整改
            foot=[[[NSBundle mainBundle]loadNibNamed:@"XDComplainDetailFootView" owner:nil options:nil]lastObject];
            
        }else {
            //拒绝方案--是否接受
            foot=[[[NSBundle mainBundle]loadNibNamed:@"XDComplainDetailFootView1" owner:nil options:nil]lastObject];
        
        
        }
        
        
        
        
    }
    
    return foot;
}




#pragma mark -- 接受方案的点击事件
/*********接受方案的**********/
- (IBAction)acceptBtnClicked:(UIButton *)sender {
    
    if (self.compDetailBtnClicked) {
        
        self.compDetailBtnClicked(sender.tag);
    }
    
}

- (IBAction)refuseBtnClicked:(UIButton *)sender {
    
    if (self.compDetailBtnClicked) {
        
        self.compDetailBtnClicked(sender.tag);
    }
    
}

#pragma mark -- 是否满意的点击事件
/*********是否满意**********/
- (IBAction)notGoodBtnClicked:(UIButton *)sender {
    if (self.compDetailBtnClicked) {
        
        self.compDetailBtnClicked(sender.tag);
    }
    
}

- (IBAction)greatBtnClicked:(UIButton *)sender {
    
    if (self.compDetailBtnClicked) {
        
        self.compDetailBtnClicked(sender.tag);
    }
    
}


#pragma mark -- 评价的点击事件
/*********评价的**********/
- (IBAction)evaluateBtnClicked:(UIButton *)sender {
    
    if (self.compDetailBtnClicked) {
        
        self.compDetailBtnClicked(sender.tag);
    }
    
    
}

#pragma mark -- 接受整改的点击事件
/*********接受整改的**********/
- (IBAction)receivedBtnClicked:(UIButton *)sender {
    if (self.compDetailBtnClicked) {
        
        self.compDetailBtnClicked(sender.tag);
    }
    
    
    
}


- (IBAction)repulseBtnClicked:(UIButton *)sender {
    if (self.compDetailBtnClicked) {
        
        self.compDetailBtnClicked(sender.tag);
    }
    
    
    
}













@end
