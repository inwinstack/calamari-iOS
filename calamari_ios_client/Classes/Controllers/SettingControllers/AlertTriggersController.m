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
#import "ClusterData.h"
#import "CephAPI.h"
#import "LocalizationManager.h"
#import "SVProgressHUD.h"

@interface AlertTriggersController () <UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) AlertTriggersView *alertTriggersView;
@property (nonatomic, strong) SettingViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSArray *nameArray;
@property (nonatomic, strong) NSArray *calculatorNameArray;
@property (nonatomic, strong) NSArray *keyNameArray;
@property (nonatomic, strong) NSArray *unitArray;
@property (nonatomic, strong) NSArray *clusterKeyNameArray;
@property (nonatomic, strong) NSArray *minArray;
@property (nonatomic, strong) NSArray *locationWarnKeyArray;
@property (nonatomic, strong) NSArray *locationErrorKeyArray;
@property (nonatomic, strong) NSArray *updateKeyArray;
@property (nonatomic, strong) AlertTriggerCalculatorView *alertCalculatorView;

@end

@implementation AlertTriggersController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    [[CephAPI shareInstance] startGetAlertTriggerApiWithIp:[[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"] port:[[NSUserDefaults standardUserDefaults] objectForKey:@"Port"] Completion:^(BOOL finished) {
        if (finished) {
            [SVProgressHUD dismiss];
        }
    } error:^(id getError) {
        [SVProgressHUD dismiss];
        NSLog(@"%@", getError);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButtonDisplay:YES];
    self.title = @"Alert Triggers";
    
    self.flowLayout = [[SettingViewFlowLayout alloc] init];
    
    self.alertTriggersView = [[AlertTriggersView alloc] initWithFrame:self.view.frame collectionViewLayout:self.flowLayout];
    self.alertTriggersView.delegate = self;
    self.alertTriggersView.dataSource = self;
    self.view = self.alertTriggersView;
    NSString *monitorString = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"alert_triggers_monitor"];
    NSString *usageString = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"alert_triggers_usage"];
    self.nameArray = @[@"OSD", monitorString, @"Placement Group", usageString];
    self.calculatorNameArray = @[@"OSD", monitorString, @"PG", usageString];
    self.keyNameArray = @[@"OSD", @"MON", @"PG", @"Usage"];
    self.unitArray = @[@"OSD", @"MON", @"%", @"%"];
    self.clusterKeyNameArray = @[@"osd", @"mon", @"pg"];
    self.locationErrorKeyArray = @[@"alert_triggers_osd_error_detail", @"alert_triggers_mon_error_detail", @"alert_triggers_pg_error_detail", @"alert_triggers_usage_error_detail"];
    self.locationWarnKeyArray = @[@"alert_triggers_osd_warning_detail", @"alert_triggers_mon_warning_detail", @"alert_triggers_pg_warning_detail", @"alert_triggers_usage_warning_detail"];
    self.minArray = @[@"1", @"1", @"20"];
    self.updateKeyArray = @[@"osd", @"mon", @"pg", @"usage"];
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
    alertTriggerSelectionCell.mainLabel.text = (indexPath.row == 0) ? [[LocalizationManager sharedLocalizationManager] getTextByKey:@"Warnings"] : [[LocalizationManager sharedLocalizationManager] getTextByKey:@"Errors"];
    alertTriggerSelectionCell.rightDetailLabel.frame = CGRectMake(10, CGRectGetMaxY(alertTriggerSelectionCell.mainLabel.frame), CGRectGetWidth(alertTriggerSelectionCell.districtLineView.frame) - 20, 37);
    NSInteger triggerIndex = [self.alertTriggersView indexPathForCell:(UICollectionViewCell*)tableView.superview].row;
    NSString *warnDetailString = [[[LocalizationManager sharedLocalizationManager] getTextByKey:self.locationWarnKeyArray[triggerIndex]] stringByReplacingOccurrencesOfString:@"%1$s" withString:[SettingData shareSettingData].triggerWarnDetailArray[triggerIndex]];
    NSString *errorDetailString = [[[LocalizationManager sharedLocalizationManager] getTextByKey:self.locationErrorKeyArray[triggerIndex]] stringByReplacingOccurrencesOfString:@"%1$s" withString:[SettingData shareSettingData].triggerErrorDetailArray[triggerIndex]];

    alertTriggerSelectionCell.rightDetailLabel.text = (indexPath.row == 0) ? warnDetailString : errorDetailString;
    alertTriggerSelectionCell.rightDetailLabel.textAlignment = NSTextAlignmentLeft;
    return alertTriggerSelectionCell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger triggerIndex = [self.alertTriggersView indexPathForCell:(UICollectionViewCell*)tableView.superview].row;
    if ([self.view.window.subviews indexOfObject:self.alertCalculatorView] > self.view.window.subviews.count) {
        self.alertCalculatorView = [[AlertTriggerCalculatorView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.alertCalculatorView.titleLabel.text = (indexPath.row == 0) ? [NSString stringWithFormat:@"%@ %@", self.calculatorNameArray[triggerIndex], [[LocalizationManager sharedLocalizationManager] getTextByKey:@"Warnings"]] : [NSString stringWithFormat:@"%@ %@", self.calculatorNameArray[triggerIndex], [[LocalizationManager sharedLocalizationManager] getTextByKey:@"Errors"]];
        self.alertCalculatorView.unitLabel.text = self.unitArray[triggerIndex];
        self.alertCalculatorView.numberLabel.text = [NSString stringWithFormat:@"%d", [self getAlertCurrentValueWithKey:self.keyNameArray[triggerIndex] isError:(indexPath.row == 1)]];
        self.alertCalculatorView.infoLabel.text = [self calculatorInfoStringWithIndex:triggerIndex isError:(indexPath.row == 1)];
        self.alertCalculatorView.originalValue = [self calculatorInfoStringWithIndex:triggerIndex isError:(indexPath.row == 1)];
        [self.alertCalculatorView.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [self.alertCalculatorView.saveButton addTarget:self action:@selector(enterAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view.window addSubview:self.alertCalculatorView];
        if (triggerIndex < 3) {
            if (triggerIndex < 2) {
                self.alertCalculatorView.minValue = 1;
                self.alertCalculatorView.maxValue = floor([self totalMaxWithType:triggerIndex] / 2);
            } else {
                self.alertCalculatorView.minValue = 20;
                self.alertCalculatorView.maxValue = 80;
            }
        } else {
            if (indexPath.row == 0) {
                self.alertCalculatorView.minValue = 5;
                self.alertCalculatorView.maxValue = [self getAlertCurrentValueWithKey:self.keyNameArray[triggerIndex] isError:YES];
            } else {
                self.alertCalculatorView.minValue = [self getAlertCurrentValueWithKey:self.keyNameArray[triggerIndex] isError:NO];
                self.alertCalculatorView.maxValue = 85;
            }
        }
        self.alertCalculatorView.currentCount = (triggerIndex < 3) ? [self totalMaxWithType:triggerIndex] : [self getUsageMaxValue];
    }
}

- (void) cancelAction {
    [self.alertCalculatorView removeFromSuperview];
}

- (void) enterAction {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    NSRange tempSearchSpaceRange = [self.alertCalculatorView.titleLabel.text rangeOfString:@" "];
    NSInteger objectIndex = [self.calculatorNameArray indexOfObject:[self.alertCalculatorView.titleLabel.text substringToIndex:tempSearchSpaceRange.location]];
    
    if ([[self.alertCalculatorView.titleLabel.text substringFromIndex:tempSearchSpaceRange.location + tempSearchSpaceRange.length] isEqualToString:[[LocalizationManager sharedLocalizationManager] getTextByKey:@"Warnings"]]) {
        [[CephAPI shareInstance] startPostAlertTriggerApiWithHostIp:[[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"] port:[[NSUserDefaults standardUserDefaults] objectForKey:@"Port"] kind:self.updateKeyArray[objectIndex] warnError:@"warning" fieldName:[NSString stringWithFormat:@"%@_warning", self.updateKeyArray[objectIndex]] value:self.alertCalculatorView.numberLabel.text completion:^(BOOL finished) {
            if (finished) {
                [[CephAPI shareInstance] startGetAlertTriggerApiWithIp:[[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"] port:[[NSUserDefaults standardUserDefaults] objectForKey:@"Port"] Completion:^(BOOL finished) {
                    if (finished) {
                        [SVProgressHUD dismiss];
                        NSIndexPath *reloadPath = [NSIndexPath indexPathForItem:objectIndex inSection:0];
                        [[(SettingViewCell*)[self.alertTriggersView cellForItemAtIndexPath:reloadPath] selectionView] reloadData];
                    }
                } error:^(id getError) {
                    [SVProgressHUD dismiss];
                    NSLog(@"%@", getError);
                }];
            }
        } error:^(id postError) {
            [SVProgressHUD dismiss];
            NSLog(@"%@", postError);
        }];
    } else {
        [[CephAPI shareInstance] startPostAlertTriggerApiWithHostIp:[[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"] port:[[NSUserDefaults standardUserDefaults] objectForKey:@"Port"] kind:self.updateKeyArray[objectIndex] warnError:@"error" fieldName:[NSString stringWithFormat:@"%@_error", self.updateKeyArray[objectIndex]] value:self.alertCalculatorView.numberLabel.text completion:^(BOOL finished) {
            if (finished) {
                [[CephAPI shareInstance] startGetAlertTriggerApiWithIp:[[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"] port:[[NSUserDefaults standardUserDefaults] objectForKey:@"Port"] Completion:^(BOOL finished) {
                    if (finished) {
                        [SVProgressHUD dismiss];
                        NSIndexPath *reloadPath = [NSIndexPath indexPathForItem:objectIndex inSection:0];
                        [[(SettingViewCell*)[self.alertTriggersView cellForItemAtIndexPath:reloadPath] selectionView] reloadData];
                    }
                } error:^(id getError) {
                    [SVProgressHUD dismiss];
                    NSLog(@"%@", getError);
                }];
            }
        } error:^(id postError) {
            [SVProgressHUD dismiss];
            NSLog(@"%@", postError);
        }];
        
    }
    [self.alertCalculatorView removeFromSuperview];
    
}

- (int) totalMaxWithType:(AlertCalculatorType)alertCalculatorType {
    NSString *clusterID = [ClusterData shareInstance].clusterArray[0][@"id"];
    NSString *clusterKey = self.clusterKeyNameArray[alertCalculatorType];
    return [[ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_health_counters", clusterID]][clusterKey][@"ok"][@"count"] intValue] + [[ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_health_counters", clusterID]][clusterKey][@"critical"][@"count"] intValue] + [[ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_health_counters", clusterID]][clusterKey][@"warn"][@"count"] intValue];
}

- (double) getUsageMaxValue {
    NSString *clusterID = [ClusterData shareInstance].clusterArray[0][@"id"];

    return [[ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_space", clusterID]][@"space"][@"capacity_bytes"] doubleValue];
}

- (int) getAlertCurrentValueWithKey:(NSString*)keyName isError:(BOOL)isError {
    int result = (isError) ? [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@TriggerError", [[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"], keyName]] intValue] : [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@TriggerWarn", [[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"], keyName]] intValue];

    return result;
}

- (NSString*) calculatorInfoStringWithIndex:(AlertCalculatorType)calculatorItemIndex isError:(BOOL)isError {
    int tempCount = 0;
    if (calculatorItemIndex < 3) {
        tempCount = [self totalMaxWithType:calculatorItemIndex];
    }
    int alertValue = [self getAlertCurrentValueWithKey:self.keyNameArray[calculatorItemIndex] isError:isError];
     ;
    switch (calculatorItemIndex) {
        case AlertCalculatorOSDType: {
            NSString *osdInfoString = [NSString stringWithFormat:@"MIN 1  MAX %.f", floor([self totalMaxWithType:calculatorItemIndex] / 2)];
            return osdInfoString;
            break;
        } case AlertCalculatorMONType: {
            double monMax = floor([self totalMaxWithType:calculatorItemIndex] / 2);
            NSString *monInfoString = (monMax > 0) ? [NSString stringWithFormat:@"MIN 1  MAX %.f", monMax] : @"MIN 1  MAX 1";
            return monInfoString;
            break;
        } case AlertCalculatorPGType: {
            int alertPg = tempCount * alertValue / 100;
            NSString *pgInfoString = [NSString stringWithFormat:@"%d PGs / %d PGs", alertPg, tempCount];
            return pgInfoString;
            break;
        } case AlertCalculatorUsageType: {
            double usageMax = [self getUsageMaxValue];
            NSString *usageTotalString = [[ClusterData shareInstance] caculateByte:usageMax];
            double alertUsage = usageMax * alertValue / 100;
            NSString *usageAlertString = [[ClusterData shareInstance] caculateByte:alertUsage];
            NSString *usageInfoString = [NSString stringWithFormat:@"%@ / %@", usageAlertString, usageTotalString];
            return usageInfoString;
            break;
        }
    }
    return nil;
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
