//
//  ClusterHealthController.m
//  inWinStackCeph
//
//  Created by Francis on 2015/4/9.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "ClusterHealthController.h"
#import "ClusterHealthView.h"
#import "ClusterHealthViewFlowLayout.h"
#import "ClusterHealthViewCell.h"
#import "ClusterData.h"
#import "ImageData.h"
#import "UIColor+Reader.h"
#import "SVProgressHUD.h"

@interface ClusterHealthController ()

@property (nonatomic, strong) NSMutableDictionary *collectionData;

@end

@implementation ClusterHealthController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor oceanNavigationBarColor]];
    self.title = @"Dashboard";
    self.navigationController.navigationBar.translucent = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self getData];
    self.navigationController.navigationBar.translucent = NO;
    self.flowLayout = [[ClusterHealthViewFlowLayout alloc] init];
    self.clusterHealthView = [[ClusterHealthView alloc] initWithFrame:self.view.frame collectionViewLayout:self.flowLayout];
    [self.clusterHealthView registerClass:[ClusterHealthViewCell class] forCellWithReuseIdentifier:@"HealthViewCell"];
    self.view = self.clusterHealthView;
    self.clusterHealthView.delegate = self;
    self.clusterHealthView.dataSource = self;
}

- (void) collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    cell.alpha = 0;
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationCurveEaseIn | UIViewAnimationCurveEaseOut | UIViewAnimationCurveEaseInOut animations:^{
        cell.alpha = 1;
    } completion:^(BOOL finished) {
        cell.alpha = 1;
    }];
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 8;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ClusterHealthViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HealthViewCell" forIndexPath:indexPath];
    cell.iconImage.image = [UIImage imageNamed:[ImageData shareInstance].imageNameDictionary[@"HealthImages"][indexPath.row]];
    cell.titleLabel.text = [ClusterData shareInstance].serviceNameArray[indexPath.row];
    cell.statusLabel.text = self.collectionData[[ClusterData shareInstance].serviceNameArray[indexPath.row]][0];
    [cell.bottomBar setWarningValue:self.collectionData[[ClusterData shareInstance].serviceNameArray[indexPath.row]][2]];
    [cell.bottomBar setErrorValue:self.collectionData[[ClusterData shareInstance].serviceNameArray[indexPath.row]][3]];
    float height;
    if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
        height = ((CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85) / 2;
    } else {
        height = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;
    }    if (indexPath.row == 0) {
        if ([cell.statusLabel.text isEqualToString:@"OK"]) {
            cell.statusLabel.textColor = [UIColor okGreenColor];
            cell.layer.borderColor = [UIColor okGreenColor].CGColor;
        } else if ([cell.statusLabel.text isEqualToString:@"WARNING"]) {
            cell.statusLabel.textColor = [UIColor warningColor];
            cell.layer.borderColor = [UIColor warningColor].CGColor;
        } else if ([cell.statusLabel.text isEqualToString:@"ERROR"]) {
            cell.statusLabel.textColor = [UIColor errorColor];
            cell.layer.borderColor = [UIColor errorColor].CGColor;
        }
    } else if (indexPath.row == 6) {
        if ([cell.statusLabel.text intValue] >= 85) {
            cell.statusLabel.textColor = [UIColor errorColor];
            cell.layer.borderColor = [UIColor errorColor].CGColor;
        } else if ([cell.statusLabel.text intValue] >= 75) {
            cell.statusLabel.textColor = [UIColor warningColor];
            cell.layer.borderColor = [UIColor warningColor].CGColor;
        } else {
            cell.statusLabel.textColor = [UIColor okGreenColor];
            cell.layer.borderColor = [UIColor okGreenColor].CGColor;
        }
    } else {
        cell.statusLabel.textColor = [UIColor okGreenColor];
        if ([cell.bottomBar.errorLabel.text intValue] > 0) {
            cell.layer.borderColor = [UIColor errorColor].CGColor;
        } else if ([cell.bottomBar.warningLabel.text intValue] > 0) {
            cell.layer.borderColor = [UIColor warningColor].CGColor;
        } else {
            cell.layer.borderColor = [UIColor okGreenColor].CGColor;
        }
    }
    if (indexPath.row == 4) {
        cell.bottomBar.errorTextLabel.text = @"OSD";
        cell.bottomBar.warningTextLabel.text = @"MON";
        cell.layer.borderColor = [UIColor okGreenColor].CGColor;
        cell.bottomBar.errorLabel.textColor = [UIColor defaultGrayColor];
        cell.bottomBar.warningLabel.textColor = [UIColor defaultGrayColor];
    } else if (indexPath.row == 5) {
        cell.bottomBar.errorTextLabel.text = @"Dirty";
        cell.bottomBar.warningTextLabel.text = @"Working";
    } else if (indexPath.row == 6) {
        cell.bottomBar.errorTextLabel.text = @"Available";
        cell.bottomBar.warningTextLabel.text = @"Used";
        cell.bottomBar.errorLabel.textColor = [UIColor okGreenColor];
    } else {
        cell.bottomBar.errorTextLabel.text = @"Errors";
        cell.bottomBar.warningTextLabel.text = @"Warnings";
    }
    
    if (indexPath.row == 7) {
        cell.bottomBar.alpha = 0;
        cell.detailLabel.alpha = 0;
        cell.iopsChartView.alpha = 1;
        
        cell.iopsChartView.maxLabel.text = [NSString stringWithFormat:@"%d", [[ClusterData shareInstance].clusterDetailData[@"iops_max"] intValue]];
        cell.iopsChartView.middleLabel.text = [NSString stringWithFormat:@"%d", [[NSString stringWithFormat:@"%f", ceil([[ClusterData shareInstance].clusterDetailData[@"iops_max"] floatValue] / 2.0)] intValue]];
        [cell.iopsChartView setDataWithDataArray:[ClusterData shareInstance].clusterDetailData[@"iops"]];
        if ([cell.iopsChartView.maxLabel.text integerValue] > 1000) {
            cell.iopsChartView.maxLabel.text = [[[[ClusterData shareInstance] caculateByte:[[NSString stringWithFormat:@"%d", [[ClusterData shareInstance].clusterDetailData[@"iops_max"] intValue]] doubleValue]] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"B" withString:@""];
            cell.iopsChartView.middleLabel.text = [[[[ClusterData shareInstance] caculateByte:[[NSString stringWithFormat:@"%d", [[ClusterData shareInstance].clusterDetailData[@"iops_max"] intValue]] doubleValue] / 2.0] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"B" withString:@""];
        }
    } else {
        cell.bottomBar.alpha = 1;
        cell.detailLabel.alpha = 1;
        cell.iopsChartView.alpha = 0;
        [cell.iopsChartView setDataWithDataArray:nil];
    }
    
    if (indexPath.row == 6) {
        cell.statusLabel.frame = CGRectMake( 0, 140 * cell.frame.size.height  / 340, CGRectGetWidth(cell.frame), height * 20 / 255);
        cell.detailLabel.frame = CGRectMake( 0, CGRectGetMaxY(cell.statusLabel.frame), CGRectGetWidth(cell.frame), height * 20 / 255);
        cell.detailLabel.text = [NSString stringWithFormat:@"%@", [ClusterData shareInstance].unitArray[indexPath.row]];
        [cell addProgress];
        [cell.progress setProgressValue:[cell.statusLabel.text intValue]];
    } else {
        cell.statusLabel.frame = CGRectMake(0, CGRectGetMaxY(cell.lineView.frame) + 35, CGRectGetWidth(cell.frame), height * 20 / 255);
        cell.detailLabel.frame = CGRectMake(0, CGRectGetMaxY(cell.statusLabel.frame), CGRectGetWidth(cell.frame), height * 20 / 255);
        cell.detailLabel.text = [NSString stringWithFormat:@"%@%@", self.collectionData[[ClusterData shareInstance].serviceNameArray[indexPath.row]][1], [ClusterData shareInstance].unitArray[indexPath.row]];
        [cell removeProgress];
    }
    
    cell.bottomBar.frame = CGRectMake(0, CGRectGetHeight(cell.frame) - 60, CGRectGetWidth(cell.frame), 60);

    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate didReceiveIndex:indexPath.row];
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
        if (indexPath.row == 6 || indexPath.row == 7) {
            return CGSizeMake((CGRectGetWidth([UIScreen mainScreen].bounds) - 20) / 2 - 10, (CGRectGetWidth([UIScreen mainScreen].bounds)) / 2.2) ;
        } else {
            return CGSizeMake((CGRectGetWidth([UIScreen mainScreen].bounds) - 20) / 2 - 10, ((CGRectGetWidth([UIScreen mainScreen].bounds) - 20) * 0.85) / 2.7);
        }
    } else {
        if (indexPath.row == 6) {
            return CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 20, CGRectGetWidth([UIScreen mainScreen].bounds)) ;
        } else {
            return CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 20, (CGRectGetWidth([UIScreen mainScreen].bounds) - 20) * 0.7);
        }
    }
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(self.view.frame.size.width, 10);
}

- (void) getData {
    self.collectionData = [NSMutableDictionary dictionary];
    NSString *healthStatus;
    if ([[[ClusterData shareInstance] getCurrentStatusWithID:[ClusterData shareInstance].clusterArray[0][@"id"]] isEqualToString:@"HEALTH_ERROR"]) {
        healthStatus = @"ERROR";
    } else if ([[[ClusterData shareInstance] getCurrentStatusWithID:[ClusterData shareInstance].clusterArray[0][@"id"]] isEqualToString:@"HEALTH_WARN"]) {
        healthStatus = @"WARNING";
    } else {
        healthStatus = @"OK";
    }
    NSString *poolStatus = [[ClusterData shareInstance] getCurrentValueWithStatus:@"ok" service:@"POOLS" clusterID:[ClusterData shareInstance].clusterArray[0][@"id"]];
    NSString *pgStatus = [[ClusterData shareInstance] getCurrentValueWithStatus:@"ok" service:@"PG STATUS" clusterID:[ClusterData shareInstance].clusterArray[0][@"id"]];
    NSString *usageStatus = [[ClusterData shareInstance] getCurrentValueWithStatus:@"ok" service:@"Usage" clusterID:[ClusterData shareInstance].clusterArray[0][@"id"]];
    NSString *osdStatus = [[ClusterData shareInstance] getCurrentValueWithStatus:@"ok" service:@"OSD" clusterID:[ClusterData shareInstance].clusterArray[0][@"id"]];
    NSString *monStatus = [[ClusterData shareInstance] getCurrentValueWithStatus:@"ok" service:@"MONITOR" clusterID:[ClusterData shareInstance].clusterArray[0][@"id"]];
    NSString *hostStatus = [[ClusterData shareInstance] getCurrentValueWithStatus:@"ok" service:@"HOSTS" clusterID:[ClusterData shareInstance].clusterArray[0][@"id"]];
    NSString *lastUpdate = [NSString stringWithFormat:@"%@ ", [[ClusterData shareInstance] getLastUpdateTimeWithID:[ClusterData shareInstance].clusterArray[0][@"id"]]];
    NSString *hostWarning = [[ClusterData shareInstance] getCurrentValueWithStatus:@"Warn" service:@"HOSTS" clusterID:[ClusterData shareInstance].clusterArray[0][@"id"]];
    NSString *hostError = [[ClusterData shareInstance] getCurrentValueWithStatus:@"Error" service:@"HOSTS" clusterID:[ClusterData shareInstance].clusterArray[0][@"id"]];
    NSString *healthWarning = [[ClusterData shareInstance] getCurrentValueWithStatus:@"Warn" service:@"HEALTH" clusterID:[ClusterData shareInstance].clusterArray[0][@"id"]];
    NSString *healthError = [[ClusterData shareInstance] getCurrentValueWithStatus:@"Error" service:@"HEALTH" clusterID:[ClusterData shareInstance].clusterArray[0][@"id"]];
    NSString *osdWarning = [[ClusterData shareInstance] getCurrentValueWithStatus:@"Warn" service:@"OSD" clusterID:[ClusterData shareInstance].clusterArray[0][@"id"]];
    NSString *osdError = [[ClusterData shareInstance] getCurrentValueWithStatus:@"Error" service:@"OSD" clusterID:[ClusterData shareInstance].clusterArray[0][@"id"]];
    NSString *monWarning = [[ClusterData shareInstance] getCurrentValueWithStatus:@"Warn" service:@"MONITOR" clusterID:[ClusterData shareInstance].clusterArray[0][@"id"]];
    NSString *monError = [[ClusterData shareInstance] getCurrentValueWithStatus:@"Error" service:@"MONITOR" clusterID:[ClusterData shareInstance].clusterArray[0][@"id"]];
    NSString *pgWarning = [[ClusterData shareInstance] getCurrentValueWithStatus:@"Warn" service:@"PG STATUS" clusterID:[ClusterData shareInstance].clusterArray[0][@"id"]];
    NSString *pgError = [[ClusterData shareInstance] getCurrentValueWithStatus:@"Error" service:@"PG STATUS" clusterID:[ClusterData shareInstance].clusterArray[0][@"id"]];
    NSString *usageWarning = [[ClusterData shareInstance] getCurrentValueWithStatus:@"Warn" service:@"Usage" clusterID:[ClusterData shareInstance].clusterArray[0][@"id"]];
    NSString *usageError = [[ClusterData shareInstance] getCurrentValueWithStatus:@"Error" service:@"Usage" clusterID:[ClusterData shareInstance].clusterArray[0][@"id"]];
    NSString *iopsTriger = [[ClusterData shareInstance] getCurrentValueWithStatus:@"ok" service:@"IOPS" clusterID:[ClusterData shareInstance].clusterArray[0][@"id"]];
    NSLog(@"%@", iopsTriger);
    [self.collectionData setObject:@[healthStatus, lastUpdate, healthWarning, healthError] forKey:[ClusterData shareInstance].serviceNameArray[0]];
    [self.collectionData setObject:@[osdStatus, @"", osdWarning, osdError] forKey:[ClusterData shareInstance].serviceNameArray[1]];
    [self.collectionData setObject:@[monStatus, @"", monWarning, monError] forKey:[ClusterData shareInstance].serviceNameArray[2]];
    [self.collectionData setObject:@[poolStatus, @"", @"0", @"0"] forKey:[ClusterData shareInstance].serviceNameArray[3]];
    [self.collectionData setObject:@[hostStatus, @"", hostWarning, hostError] forKey:[ClusterData shareInstance].serviceNameArray[4]];
    [self.collectionData setObject:@[pgStatus, @"", pgWarning, pgError] forKey:[ClusterData shareInstance].serviceNameArray[5]];
    [self.collectionData setObject:@[usageStatus, @"", usageWarning, usageError] forKey:[ClusterData shareInstance].serviceNameArray[6]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
