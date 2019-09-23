//
//  XDAddProjectController.m
//  xd_proprietor
//
//  Created by cfsc on 2019/9/19.
//  Copyright © 2019年 zc. All rights reserved.
//

#import "XDAddProjectController.h"

@interface XDAddProjectController ()
@property (weak, nonatomic) IBOutlet UITextField *projectName;
@property (weak, nonatomic) IBOutlet UITextField *pushTag;
@property (weak, nonatomic) IBOutlet UITextField *ipLabel;
@property (weak, nonatomic) IBOutlet UITextField *projectAddress;

@end

@implementation XDAddProjectController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addProject:(id)sender {
    XDProjectModel *model = [[XDProjectModel alloc] init];
    model.name = self.projectName.text;
    model.tag = self.pushTag.text;
    model.address = self.projectAddress.text;
    model.ip = self.ipLabel.text;
    if (self.didAddProject) {
        self.didAddProject(model);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
