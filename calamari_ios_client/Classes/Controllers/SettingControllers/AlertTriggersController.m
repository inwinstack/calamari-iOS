//
//  AlertTriggersController.m
//  calamari_ios_client
//
//  Created by Francis on 2015/10/8.
//  Copyright © 2015年 Francis. All rights reserved.
//

#import "AlertTriggersController.h"
#import "AlertTriggersView.h"
#import "SettingViewFlowLayout.h"
#import "SettingViewCell.h"
#import "SelectionViewCell.h"
#import "SettingData.h"
#import "AlertTriggerCalculatorView.h"

@interface AlertTriggersController () <UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) AlertTriggersView *alertTriggersView;
@property (nonatomic, strong) SettingViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSArray *nameArray;
@property (nonatomic, strong) NSArray *calculatorNameArray;
@property (nonatomic, strong) AlertTriggerCalculatorView *alertCalculatorView;

@end

@implementation AlertTriggersController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButtonDisplay:YES];
    self.title = @"Alert Triggers";
    
    self.flowLayout = [[SettingViewFlowLayout alloc] init];
    
    self.alertTriggersView = [[AlertTriggersView alloc] initWithFrame:self.view.frame collectionViewLayout:self.flowLayout];
    self.alertTriggersView.delegate = self;
    self.alertTriggersView.dataSource = self;
    self.view = self.alertTriggersView;
    self.nameArray = @[@"OSD", @"Monitor", @"Placement Group", @"Usage"];
    self.calculatorNameArray = @[@"OSD", @"Monitor", @"PG", @"Usage"];
    [self.alertTriggersView registerClass:[SettingViewCell class] forCellWithReuseIdentifier:@"AlertTriggersCellIdentifer"];
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.nameArray.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectionViewCell *alertTriggerSelectionCell  = [tableView dequeueReusableCellWithIdentifier:@"AlertTriggersSelectionCellIdentifer"];
    if (!alertTriggerSelectionCell) {
        alertTriggerSelectionCell = [[SelectionViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AlertTriggersSelectionCellIdentifer"];
    }
    alertTriggerSelectionCell.checkBoxButton.hidden = YES;
    alertTriggerSelectionCell.districtLineView.frame = CGRectMake(alertTriggerSelectionCell.districtLineView.frame.origin.x, 73, alertTriggerSelectionCell.districtLineView.frame.size.width, alertTriggerSelectionCell.districtLineView.frame.size.height);
    alertTriggerSelectionCell.mainLabel.text = (indexPath.row == 0) ? @"Warnings" : @"Errors";
    alertTriggerSelectionCell.rightDetailLabel.frame = CGRectMake(10, CGRectGetMaxY(alertTriggerSelectionCell.mainLabel.frame), CGRectGetWidth(alertTriggerSelectionCell.districtLineView.frame) - 20, 37);
    NSInteger triggerIndex = [self.alertTriggersView indexPathForCell:(UICollectionViewCell*)tableView.superview].row;
    alertTriggerSelectionCell.rightDetailLabel.text = (indexPath.row == 0) ? [NSString stringWithFormat:@"Trigger alert when %@", [SettingData shareSettingData].triggerWarnDetailArray[triggerIndex]] : [NSString stringWithFormat:@"Trigger alert when %@", [SettingData shareSettingData].triggerErrorDetailArray[triggerIndex]];
    alertTriggerSelectionCell.rightDetailLabel.textAlignment = NSTextAlignmentLeft;
    return alertTriggerSelectionCell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger triggerIndex = [self.alertTriggersView indexPathForCell:(UICollectionViewCell*)tableView.superview].row;

    self.alertCalculatorView = [[AlertTriggerCalculatorView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.alertCalculatorView.titleLabel.text = (indexPath.row == 0) ? [NSString stringWithFormat:@"%@ Warnings", self.calculatorNameArray[triggerIndex]] : [NSString stringWithFormat:@"%@ Errors", self.calculatorNameArray[triggerIndex]];
    self.alertCalculatorView.unitLabel.text = self.calculatorNameArray[triggerIndex];
    [self.alertCalculatorView.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.alertCalculatorView.saveButton addTarget:self action:@selector(enterAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view.window addSubview:self.alertCalculatorView];
}

- (void) cancelAction {
    [self.alertCalculatorView removeFromSuperview];
}

- (void) enterAction {
    [self.alertCalculatorView removeFromSuperview];

}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SettingViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AlertTriggersCellIdentifer" forIndexPath:indexPath];
    cell.settingNameLabel.text = self.nameArray[indexPath.row];
    cell.selectionView.delegate = self;
    cell.selectionView.dataSource = self;
    
    CGRect tempFrame = cell.selectionView.frame;

    cell.selectionView.frame = CGRectMake(tempFrame.origin.x, tempFrame.origin.y, tempFrame.size.width, 148);
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(self.view.frame) - 20, 178);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
