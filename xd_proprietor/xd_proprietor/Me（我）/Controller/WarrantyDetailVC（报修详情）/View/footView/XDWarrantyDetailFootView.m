//
//  XDWarrantyDetailFootView.m
//  XD业主
//
//  Created by zc on 2017/6/22.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDWarrantyDetailFootView.h"

@implementation XDWarrantyDetailFootView

- (void)awakeFromNib {
    [super awakeFromNib];

    
    
}
+ (instancetype)footerViewWithTableView:(UITableView *)tableView withType:(NSString *)type
{
    static NSString *ID=@"XDWarrantyDetailFootView";
    XDWarrantyDetailFootView *foot=[tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (foot == nil) {
        if ([type isEqualToString:@"评价"]) {
            
            //评价
            foot=[[[NSBundle mainBundle]loadNibNamed:@"XDWarrantyDetailFootView1" owner:nil options:nil]lastObject];
            
           
        }else if ([type isEqualToString:@"是否接受价格"]) {
            
            //费用
            foot=[[[NSBundle mainBundle]loadNibNamed:@"XDWarrantyDetailFootView" owner:nil options:nil]lastObject];
            
        }
    }
    
    return foot;
}




#pragma mark -- 接受方案的点击事件
/*********接受方案的**********/
- (IBAction)acceptPriceBtnClicked:(UIButton *)sender {
    
    if (self.warrantyDetailBtnClicked) {
        
        self.warrantyDetailBtnClicked(sender.tag);
    }
    
}

- (IBAction)refusePriceBtnClicked:(UIButton *)sender {
    
    if (self.warrantyDetailBtnClicked) {
        
        self.warrantyDetailBtnClicked(sender.tag);
    }
    
}


#pragma mark -- 评价的点击事件
/*********评价的**********/
- (IBAction)evaluateBtnClicked:(UIButton *)sender {
    
    if (self.warrantyDetailBtnClicked) {
        
        self.warrantyDetailBtnClicked(sender.tag);
    }
    
    
}



@end
