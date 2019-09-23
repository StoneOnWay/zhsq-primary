//
//  XDWarrantyWorkProgressTableViewCell.m
//  xd_proprietor
//
//  Created by mason on 2018/9/7.
//Copyright © 2018年 zc. All rights reserved.
//

#import "XDWarrantyWorkProgressTableViewCell.h"
#import "XDImageViewCollectionViewCell.h"

@interface XDWarrantyWorkProgressTableViewCell()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;

/** <##> */
@property (strong, nonatomic) NSArray *imageArray;

@end

@implementation XDWarrantyWorkProgressTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, -10.f, 0);
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XDImageViewCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XDImageViewCollectionViewCell class])];
}

- (void)setWarrantyDetailNetDataModel:(XDWarrantyDetailNetDataModel *)warrantyDetailNetDataModel {
    _warrantyDetailNetDataModel = warrantyDetailNetDataModel;
    self.titleLabel.text = warrantyDetailNetDataModel.repairsType;
    self.statusLabel.text = warrantyDetailNetDataModel.repairsStatus;
    self.contentLabel.text = warrantyDetailNetDataModel.title;
    self.timeLabel.text = warrantyDetailNetDataModel.plandate;
    
    self.imageArray = [warrantyDetailNetDataModel.handerpiclist copy];
    [self.collectionView reloadData];
}

- (void)setDictionary:(NSDictionary *)dictionary {
    _dictionary = dictionary;
    self.titleLabel.text = dictionary[@"title"];
    self.statusLabel.text = dictionary[@"status"];
    self.contentLabel.text = dictionary[@"content"];
    self.timeLabel.text = dictionary[@"time"];
    
    self.imageArray = dictionary[@"images"];
    self.collectionViewHeightConstraint.constant = self.imageArray.count > 0 ? 85.f : 0;
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XDImageViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XDImageViewCollectionViewCell class]) forIndexPath:indexPath];
    NSDictionary *dic = self.imageArray[indexPath.row];
    [cell.imageView setImageWithURL:[NSURL URLWithString:[K_BASE_URL stringByAppendingPathComponent:dic[@"url"]]] placeholder:nil];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat widht = (kScreenWidth - 30.f - 6.f) / 3;
    CGFloat height = widht * 150.f / 226.f;
    return CGSizeMake(widht, height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return DBL_EPSILON;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 3.f;
}



@end

















