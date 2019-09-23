//
//  XDCarEditController.m
//  xd_proprietor
//
//  Created by cfsc on 2019/6/15.
//  Copyright © 2019年 zc. All rights reserved.
//

#import "XDCarEditController.h"
#import "XDAddCarConfigModel.h"
#import "XDCarPropertyCell.h"
#import "XDCarPhotoCell.h"
#import "GSPopoverViewController.h"
#import "HZSingleChoiceListView.h"
#import "HZPopView.h"
#import "XDCarCharterCell.h"
#import "XDCarCharterSelView.h"
#import "XDDoPaymentController.h"
#import "XDCarCharterModel.h"

@interface XDCarEditController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    NSMutableArray *plateColorArr;
    NSMutableArray *plateTypeArr;
    NSMutableArray *carColorArr;
    NSMutableArray *carTypeArr;
    XDCarCharterSelView *selView;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *itemArray;
@end

@implementation XDCarEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configDataSource];
    [self configTableView];
    [self initPopArray];
}

- (void)initPopArray {
    NSArray *plateColor = @[@"蓝色", @"黄色", @"白色", @"黑色", @"绿色", @"民航黑色", @"其他颜色"];
    NSArray *plateType = @[@"标准民用车", @"02式民用车", @"武警车", @"警车", @"民用车双行尾牌", @"使馆车", @"农用车", @"摩托车", @"新能源车", @"军车"];
    NSArray *carType = @[@"小型车", @"大型车", @"摩托车", @"其他车"];
    NSArray *carColor = @[@"白色", @"银色", @"灰色", @"黑色", @"红色", @"深蓝色", @"蓝色", @"黄色", @"绿色", @"棕色", @"粉色", @"紫色", @"其他颜色"];
    plateColorArr = [NSMutableArray array];
    plateTypeArr = [NSMutableArray array];
    carColorArr = [NSMutableArray array];
    carTypeArr = [NSMutableArray array];
    for (NSString *str in plateColor) {
        HZSingleChoiceModel *model = [[HZSingleChoiceModel alloc] init];
        model.title = str;
        [plateColorArr addObject:model];
    }
    for (NSString *str in plateType) {
        HZSingleChoiceModel *model = [[HZSingleChoiceModel alloc] init];
        model.title = str;
        [plateTypeArr addObject:model];
    }
    for (NSString *str in carColor) {
        HZSingleChoiceModel *model = [[HZSingleChoiceModel alloc] init];
        model.title = str;
        [carColorArr addObject:model];
    }
    for (NSString *str in carType) {
        HZSingleChoiceModel *model = [[HZSingleChoiceModel alloc] init];
        model.title = str;
        [carTypeArr addObject:model];
    }
}

- (void)configDataSource {
    XDAddCarConfigModel *plateColorModel = [[XDAddCarConfigModel alloc] init];
    plateColorModel.type = CarPropertyTypeOther;
    plateColorModel.title = @"车牌颜色";
    plateColorModel.value = self.carModel.plateColor;
    XDAddCarConfigModel *plateTypeModel = [[XDAddCarConfigModel alloc] init];
    plateTypeModel.type = CarPropertyTypeOther;
    plateTypeModel.title = @"车牌类型";
    plateTypeModel.value = self.carModel.plateType;
    XDAddCarConfigModel *carColorModel = [[XDAddCarConfigModel alloc] init];
    carColorModel.type = CarPropertyTypeOther;
    carColorModel.title = @"车辆颜色";
    carColorModel.value = self.carModel.carColor;
    XDAddCarConfigModel *carTypeModel = [[XDAddCarConfigModel alloc] init];
    carTypeModel.type = CarPropertyTypeOther;
    carTypeModel.title = @"车辆类型";
    carTypeModel.value = self.carModel.carType;
    XDAddCarConfigModel *carPhotoModel = [[XDAddCarConfigModel alloc] init];
    carPhotoModel.type = CarPropertyTypePhoto;
    carPhotoModel.value = self.carModel.carPhoto;
    XDAddCarConfigModel *carCharterModel = [[XDAddCarConfigModel alloc] init];
    carCharterModel.type = CarPropertyTypeCharter;
    carCharterModel.value = self.carModel.charterName;
    [self.itemArray addObject:@[carPhotoModel, plateColorModel, plateTypeModel, carColorModel, carTypeModel]];
    if (self.carModel.charterName) {
        // 没有审核通过时不显示包期
        [self.itemArray addObject:@[carCharterModel]];
    }
}

- (void)configTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"XDCarPropertyCell" bundle:NSBundle.mainBundle] forCellReuseIdentifier:@"XDCarPropertyCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"XDCarPhotoCell" bundle:NSBundle.mainBundle] forCellReuseIdentifier:@"XDCarPhotoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"XDCarCharterCell" bundle:NSBundle.mainBundle] forCellReuseIdentifier:@"XDCarCharterCell"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = litterBackColor;
}

// 异步提交车辆信息
- (void)commitMyCarUpdateInfoWithModel:(XDAddCarConfigModel *)model oldValue:(id)oldValue {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSMutableArray *imageArray = nil;
    XDLoginUseModel *loginModel = [XDReadLoginModelTool loginModel];
    if (!loginModel.userInfo.userId) {
        [XDUtil showToast:@"登录失效！"];
        return;
    }
    [dic setValue:loginModel.userInfo.userId forKey:@"ownerid"];
    [dic setValue:self.carModel.vehiclecode forKey:@"vehiclecode"];
    NSString *valueStr = nil;
    if ([model.title isEqualToString:@"车牌颜色"]) {
        long value = [self convertPlateColorValue:model.value];
        valueStr = [NSString stringWithFormat:@"%ld", value];
        [dic setValue:valueStr forKey:@"plateColor"];
    } else if ([model.title isEqualToString:@"车牌类型"]) {
        long value = [self convertPlateTypeValue:model.value];
        valueStr = [NSString stringWithFormat:@"%ld", value];
        [dic setValue:valueStr forKey:@"plateType"];
    } else if ([model.title isEqualToString:@"车辆颜色"]) {
        long value = [self convertCarColorValue:model.value];
        valueStr = [NSString stringWithFormat:@"%ld", value];
        [dic setValue:valueStr forKey:@"carColor"];
    } else if ([model.title isEqualToString:@"车辆类型"]) {
        long value = [self convertCarTypeValue:model.value];
        valueStr = [NSString stringWithFormat:@"%ld", value];
        [dic setValue:valueStr forKey:@"carType"];
    } else if (model.type == CarPropertyTypePhoto) {
        if (model.image) {
            imageArray = [NSMutableArray array];
            NSData *imageData = UIImagePNGRepresentation(model.image);
            [imageArray addObject:imageData];
        }
    }
    [[XDAPIManager sharedManager] requestUpdateMyVehicleWithParameters:dic constructingBodyWithBlock:imageArray CompletionHandle:^(id responseObject, NSError *error) {
        if (error) {
            [XDUtil showToast:@"编辑车辆失败！"];
            [self recoverOldDataOnCommitFailed:model oldValue:oldValue];
            return;
        }
        __weak typeof (self)weakSelf = self;
        if ([responseObject[@"resultCode"] integerValue] == 200) {
            if (weakSelf.addCarSuccess) {
                weakSelf.addCarSuccess();
            }
        } else {
            NSString *msg = [NSString stringWithFormat:@"%@", responseObject[@"msg"]];
            [XDUtil showToast:msg];
            [self recoverOldDataOnCommitFailed:model oldValue:oldValue];
        }
    }];
}

// 请求失败后恢复旧数据
- (void)recoverOldDataOnCommitFailed:(XDAddCarConfigModel *)model oldValue:(id)oldValue {
    if (model.type == CarPropertyTypePhoto) {
        model.image = oldValue;
    } else if (model.type == CarPropertyTypeOther) {
        model.value = oldValue;
    }
    [self.tableView reloadData];
}

- (void)choiceItemWithBaseModel:(XDAddCarConfigModel *)model itemArray:(NSArray *)itemArray{
    __block HZPopView *popView = [HZPopView new];
    CGFloat width = 300.f * kScreenWidth / 375.f;
    
    NSString *oldValue = model.value;
    HZSingleChoiceListView *singleChoiceView = [HZSingleChoiceListView new];
    singleChoiceView.itemArray = [itemArray copy];
    @weakify(self)
    [singleChoiceView setChoiceResultBlock:^(id result) {
        @strongify(self)
        HZSingleChoiceModel *singleChioceModel = result;
        model.value = singleChioceModel.title;
        [self.tableView reloadData];
        [self commitMyCarUpdateInfoWithModel:model oldValue:oldValue];
        [popView diss];
        popView = nil;
    }];
    
    [singleChoiceView setChoiceDismissBlock:^{
        [popView diss];
        popView = nil;
    }];
    [popView popViewWithContenView:singleChoiceView inRect:CGRectMake(0, 0, width, width * 5.f / 6) inContainer:nil];
}

#pragma mark - data convert
- (long)convertPlateColorValue:(NSString *)str {
    long plateColor = 0;
    if ([str isEqualToString:@"蓝色"]) {
        plateColor = 0;
    } else if ([str isEqualToString:@"黄色"]) {
        plateColor = 1;
    } else if ([str isEqualToString:@"白色"]) {
        plateColor = 2;
    } else if ([str isEqualToString:@"黑色"]) {
        plateColor = 3;
    } else if ([str isEqualToString:@"绿色"]) {
        plateColor = 4;
    } else if ([str isEqualToString:@"民航黑色"]) {
        plateColor = 5;
    } else if ([str isEqualToString:@"其他颜色"]) {
        plateColor = 255;
    }
    return plateColor;
}

- (long)convertPlateTypeValue:(NSString *)str {
    long plateType = 0;
    if ([str isEqualToString:@"标准民用车"]) {
        plateType = 0;
    } else if ([str isEqualToString:@"02式民用车"]) {
        plateType = 1;
    } else if ([str isEqualToString:@"武警车"]) {
        plateType = 2;
    } else if ([str isEqualToString:@"警车"]) {
        plateType = 3;
    } else if ([str isEqualToString:@"民用车双行尾牌"]) {
        plateType = 4;
    } else if ([str isEqualToString:@"使馆车"]) {
        plateType = 5;
    } else if ([str isEqualToString:@"农用车"]) {
        plateType = 6;
    } else if ([str isEqualToString:@"摩托车"]) {
        plateType = 7;
    } else if ([str isEqualToString:@"新能源车"]) {
        plateType = 8;
    } else if ([str isEqualToString:@"军车"]) {
        plateType = 13;
    }
    return plateType;
}

- (long)convertCarColorValue:(NSString *)str {
    long carColor = 0;
    if ([str isEqualToString:@"其他颜色"]) {
        carColor = 0;
    } else if ([str isEqualToString:@"白色"]) {
        carColor = 1;
    } else if ([str isEqualToString:@"银色"]) {
        carColor = 2;
    } else if ([str isEqualToString:@"灰色"]) {
        carColor = 3;
    } else if ([str isEqualToString:@"黑色"]) {
        carColor = 4;
    } else if ([str isEqualToString:@"红色"]) {
        carColor = 5;
    } else if ([str isEqualToString:@"深蓝色"]) {
        carColor = 6;
    } else if ([str isEqualToString:@"蓝色"]) {
        carColor = 7;
    } else if ([str isEqualToString:@"黄色"]) {
        carColor = 8;
    } else if ([str isEqualToString:@"绿色"]) {
        carColor = 9;
    } else if ([str isEqualToString:@"棕色"]) {
        carColor = 10;
    } else if ([str isEqualToString:@"粉色"]) {
        carColor = 11;
    } else if ([str isEqualToString:@"紫色"]) {
        carColor = 12;
    }
    return carColor;
}

- (long)convertCarTypeValue:(NSString *)str {
    long carType = 0;
    if ([str isEqualToString:@"其他车"]) {
        carType = 0;
    } else if ([str isEqualToString:@"小型车"]) {
        carType = 1;
    } else if ([str isEqualToString:@"大型车"]) {
        carType = 2;
    } else if ([str isEqualToString:@"摩托车"]) {
        carType = 3;
    }
    return carType;
}

#pragma mark - UIAlert
- (void)takePhoto:(NSIndexPath *)indexPath {
    XDCarPhotoCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选取照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet ];
    if ([XDUtil isIPad]) {
        UIPopoverPresentationController *popoverVC = [alert popoverPresentationController];
        popoverVC.sourceView = cell;
        popoverVC.sourceRect = cell.bounds;
    }
    //拍照
    UIAlertAction *Action = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self photoWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }];
    //相机胶卷
    UIAlertAction *Action1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self photoWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    //取消style:UIAlertActionStyleDefault
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:Action];
    [alert addAction:Action1];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)photoWithSourceType:(UIImagePickerControllerSourceType)type{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    NSDictionary *textAt = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    [imagePicker.navigationBar setTitleTextAttributes:textAt];
    imagePicker.navigationBar.tintColor = [UIColor blackColor];
    imagePicker.delegate = self;
    imagePicker.sourceType = type;
    imagePicker.allowsEditing = YES;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *oldImage = nil;
    for (XDAddCarConfigModel *model in self.itemArray.firstObject) {
        oldImage = model.image;
        if (model.type == CarPropertyTypePhoto) {
            model.image = info[@"UIImagePickerControllerEditedImage"];
            [self.tableView reloadData];
            [self commitMyCarUpdateInfoWithModel:model oldValue:oldImage];
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.itemArray[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDAddCarConfigModel *model = self.itemArray[indexPath.section][indexPath.row];
    if (model.type == CarPropertyTypePhoto) {
        XDCarPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XDCarPhotoCell"];
        cell.model = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.addCarPhoto = ^{
            [self takePhoto:indexPath];
        };
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            [self takePhoto:indexPath];
        }];
        [cell.photoImageView addGestureRecognizer:tap];
        cell.photoImageView.userInteractionEnabled = YES;
        return cell;
    } else if (model.type == CarPropertyTypeCharter) {
        XDCarCharterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XDCarCharterCell"];
        cell.carModel = self.carModel;
        __weak typeof(self)weakSelf = self;
        cell.charterBtnClick = ^{
            if ([tableView.tableFooterView isKindOfClass:XDCarCharterSelView.class]) {
                tableView.tableFooterView = [UIView new];
            } else {
                if (!selView) {
                    selView = [XDCarCharterSelView createCarCharterSelView];
                    selView.charterViewClick = ^(CarCharterType type) {
                        NSString *startTime = nil;
                        NSString *endTime = nil;
                        if ([weakSelf.carModel.charterName isEqualToString:@"已包期"]) {
                            // 是要续费的
                            startTime = weakSelf.carModel.startTime;
                            NSDate *date = [XDUtil dateFromDateStr:weakSelf.carModel.endTime WithFormatterStr:CarCharterDateFormatter];
                            endTime = [XDUtil getTimeStrSinceDate:date WithYear:0 month:type - 1000 day:0 formatterStr:CarCharterDateFormatter];
                        } else {
                            startTime = [XDUtil getNowTimeStrWithFormatter:CarCharterDateFormatter];
                            endTime = [XDUtil getTimeStrSinceNowWithYear:0 month:type - 1000 day:0 formatterStr:CarCharterDateFormatter];
                        }
                        XDDoPaymentController *payVC = [[XDDoPaymentController alloc] init];
                        XDCarCharterModel *charter = [[XDCarCharterModel alloc] init];
                        charter.fee = [weakSelf payStrWithType:type];
                        charter.startTime = startTime;
                        charter.endTime = endTime;
                        charter.plateNo = weakSelf.carModel.vehiclecode;
                        payVC.charter = charter;
                        payVC.hasPaidBlock = ^{
                            tableView.tableFooterView = [UIView new];
                            weakSelf.carModel.startTime = startTime;
                            weakSelf.carModel.endTime = endTime;
                            weakSelf.carModel.charterName = @"已包期";
                            [weakSelf.tableView reloadData];
                            if (weakSelf.addCarSuccess) {
                                weakSelf.addCarSuccess();
                            }
                        };
                        [weakSelf.navigationController pushViewController:payVC animated:YES];
                    };
                }
                tableView.tableFooterView = selView;
            }
        };
        return cell;
    }
    XDCarPropertyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XDCarPropertyCell"];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSString *)payStrWithType:(CarCharterType)type {
    if (type == CarCharterTypeMonthOne) {
        return @"218.00";
    } else if (type == CarCharterTypeMonthThree) {
        return @"618.00";
    } else if (type == CarCharterTypeMonthSix) {
        return @"1188.00";
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    XDAddCarConfigModel *model = self.itemArray[indexPath.section][indexPath.row];
    if (model.type == CarPropertyTypePlateNo) {
        return 80;
    } else if (model.type == CarPropertyTypePhoto) {
        return 120;
    }
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    XDAddCarConfigModel *model = self.itemArray[indexPath.section][indexPath.row];
    if ([model.title isEqualToString:@"车牌颜色"]) {
        [self choiceItemWithBaseModel:model itemArray:plateColorArr];
    } else if ([model.title isEqualToString:@"车牌类型"]) {
        [self choiceItemWithBaseModel:model itemArray:plateTypeArr];
    } else if ([model.title isEqualToString:@"车辆颜色"]) {
        [self choiceItemWithBaseModel:model itemArray:carColorArr];
    } else if ([model.title isEqualToString:@"车辆类型"]) {
        [self choiceItemWithBaseModel:model itemArray:carTypeArr];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
        if (!header) {
            header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"UITableViewHeaderFooterView"];
        }
        header.frame = CGRectMake(0, 0, kScreenWidth, 20);
        UIView *view = [[UIView alloc] initWithFrame:header.bounds];
        view.backgroundColor = litterBackColor;
        [header addSubview:view];
        return header;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 20;
    }
    return 0.01;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - lazy load
- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

@end
