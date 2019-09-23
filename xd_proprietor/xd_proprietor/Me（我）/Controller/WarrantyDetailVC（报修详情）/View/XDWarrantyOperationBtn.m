//
//  XDWarrantyOperationBtn.m
//  xd_proprietor
//
//  Created by mason on 2018/9/7.
//Copyright © 2018年 zc. All rights reserved.
//

#import "XDWarrantyOperationBtn.h"

@interface XDWarrantyOperationBtn()

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *centerBtn;

@end

@implementation XDWarrantyOperationBtn

- (void)awakeFromNib {
    [super awakeFromNib];
    self.leftBtn.layer.cornerRadius = 5.f;
    self.leftBtn.layer.masksToBounds = YES;
    
    self.rightBtn.layer.cornerRadius = 5.f;
    self.rightBtn.layer.masksToBounds = YES;
    
    self.centerBtn.layer.cornerRadius = 5.f;
    self.centerBtn.layer.masksToBounds = YES;
    [self setOperationBtnType:XDWarrantyOperationBtnTypeDouble];
}

- (void)setOperationBtnType:(XDWarrantyOperationBtnType)operationBtnType {
    _operationBtnType = operationBtnType;
    if (operationBtnType == XDWarrantyOperationBtnTypeSingle) {
        self.leftBtn.hidden = YES;
        self.rightBtn.hidden = YES;
        self.centerBtn.hidden = NO;
    } else {
        self.leftBtn.hidden = NO;
        self.rightBtn.hidden = NO;
        self.centerBtn.hidden = YES;
    }
}

- (void)setSingleBtnTitle:(NSString *)singleBtnTitle {
    _singleBtnTitle = singleBtnTitle;
    [self.centerBtn setTitle:singleBtnTitle forState:UIControlStateNormal];
}

- (void)setLeftBtnTitle:(NSString *)leftBtnTitle {
    _leftBtnTitle = leftBtnTitle;
    [self.rightBtn setTitle:leftBtnTitle forState:UIControlStateNormal];
}

- (void)setRightBtnTitle:(NSString *)rightBtnTitle {
    _rightBtnTitle = rightBtnTitle;
    [self.rightBtn setTitle:rightBtnTitle forState:UIControlStateNormal];
}

- (IBAction)clickLeftBtn:(id)sender {
    if (self.clickOperationBlock) {
        self.clickOperationBlock(XDClickTypeLeft);
    }
}

- (IBAction)clickRightBtn:(id)sender {
    if (self.clickOperationBlock) {
        self.clickOperationBlock(XDClickTypeRight);
    }
}

- (IBAction)clickCenterBtn:(id)sender {
    if (self.clickOperationBlock) {
        self.clickOperationBlock(XDClickTypeCenter);
    }
}

@end












