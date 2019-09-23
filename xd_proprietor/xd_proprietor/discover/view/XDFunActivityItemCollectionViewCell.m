//
//  XDFunActivityItemCollectionViewCell.m
//  xd_proprietor
//
//  Created by mason on 2018/9/4.
//Copyright © 2018年 zc. All rights reserved.
//

#import "XDFunActivityItemCollectionViewCell.h"

@interface XDFunActivityItemCollectionViewCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstant;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;
- (IBAction)likeButtonClick:(UIButton *)sender;


@property (strong,nonatomic) XDCommentListModel *funActivityModel;
@end

@implementation XDFunActivityItemCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setCellDataWithModel:(XDCommentListModel*)model{
    
    self.funActivityModel = model;
    
    if ([XDUtil isIPad]) {
        self.imageViewHeightConstant.constant = 300;
    }
    
    self.contentLabel.text = [NSString stringWithFormat:@"%@",model.content];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",K_BASE_URL,model.homePicUrl]] placeholderImage:[UIImage imageNamed:@"pic_find_2"]];
    
    self.nameLabel.text = model.ownerName;
    if (model.upNumber.intValue > 0) {
        self.likeButton.selected = YES;
    } else {
        self.likeButton.selected = NO;
    }
    [self.likeButton setTitle:[NSString stringWithFormat:@" %@",model.upNumber] forState:UIControlStateNormal];
    [self.likeButton setTitle:[NSString stringWithFormat:@" %@",model.upNumber] forState:UIControlStateSelected];
    
    NSString *faceUrl = [NSString stringWithFormat:@"%@/%@", K_BASE_URL, model.ownerFace];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:faceUrl] placeholderImage:[UIImage imageNamed:@"iocn_find_user"]];
    self.headerImageView.layer.cornerRadius = 15;
    self.headerImageView.layer.masksToBounds = YES;
}

- (IBAction)likeButtonClick:(UIButton *)sender {
    [self.delegate islikeWithModel:self.funActivityModel];
}
@end
