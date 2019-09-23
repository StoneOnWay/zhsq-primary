//
//  XDAddressFootView.m
//  XD业主
//
//  Created by zc on 2017/6/29.
//  Copyright © 2017年 zc. All rights reserved.
//

#import "XDAddressFootView.h"

#define KBtnHeight 36
#define KBtnPadding 20


@implementation XDAddressFootView

+ (instancetype)footerViewWithTableView:(UITableView *)tableView
{
    static NSString *ID=@"XDAddressFootView";
    XDAddressFootView *foot=[tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (foot == nil) {
        foot=[[XDAddressFootView alloc]initWithReuseIdentifier:ID];
    }
    
    return foot;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithReuseIdentifier:reuseIdentifier]) {
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        lineView.backgroundColor = BianKuang;
        [self addSubview:lineView];
        
        UIView *backView = [[UIView alloc] initWithFrame:self.frame];
        backView.backgroundColor = backColor;
        self.backgroundView = backView;
        
        //新建常用地址
        UIButton *newContactBtn = [self setBtnTitle:@"新建常用地址" andImageName:@"xzlxr_btn_kuang" andMaxY:50 withTag:101];
        [self addSubview:newContactBtn];

        //确认按钮
        CGFloat iphoneMaxY = CGRectGetMaxY(newContactBtn.frame);
        UIButton *newContact = [self setBtnTitle:@"确认" andImageName:@"baoxiu_btn_tijiao" andMaxY:iphoneMaxY+KBtnPadding withTag:102];
        [newContact setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:newContact];
        
        
    }
    
    return self;
}


- (UIButton *)setBtnTitle:(NSString *)title andImageName:(NSString *)string andMaxY:(CGFloat)Y withTag:(NSInteger)tag{
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, Y, kScreenWidth-40, KBtnHeight)];
    [button setBackgroundImage:[UIImage imageNamed:string] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    button.tag = tag;
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = SFont(15);
    
    return button;
    
}

- (void)buttonClicked:(UIButton *)btn {
    
    if (self.btnClicked) {
        
        self.btnClicked(btn.tag);
    }
    
    
}

@end
