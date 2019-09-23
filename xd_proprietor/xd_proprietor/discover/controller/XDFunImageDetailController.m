//
//  XDFunImageDetailController.m
//  xd_proprietor
//
//  Created by stone on 28/5/2019.
//  Copyright © 2019 zc. All rights reserved.
//

#import "XDFunImageDetailController.h"

@interface XDFunImageDetailController ()

@end

@implementation XDFunImageDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.contentSize = CGSizeMake(self.imageArray.count * kScreenWidth, kScreenHeight);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    for (int i = 0; i < self.imageArray.count; i++) {
        UIImage *image = self.imageArray[i];
        CGFloat height = kScreenWidth * image.size.height / image.size.width;
        CGFloat y = (kScreenHeight - height) / 2;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreenWidth, y, kScreenWidth, height)];
        imageView.image = image;
        [scrollView addSubview:imageView];
//        imageView.contentMode = UIViewContentModeScaleAspectFill;
//        imageView.layer.masksToBounds = YES;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }];
        [imageView addGestureRecognizer:tap];
    }
    [self.view addSubview:scrollView];
    [scrollView setContentOffset:CGPointMake(kScreenWidth * self.currentIndex, 0)];
}

@end
