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
#import "CephAPI.h"
#import "NotificationData.h"
#import "LocalizationManager.h"

@interface ClusterHealthController ()

@property (nonatomic, strong) NSString *currentTimeString;

@end

@implementation ClusterHealthController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor oceanNavigationBarColor]];
    self.title = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"main_activity_fragment_health"];
    self.navigationController.navigationBar.translucent = NO;
}

- (void) refreshHealthCardAction:(NSNotification*)refreshHealthCardNotification {
    self.currentTimeString = refreshHealthCardNotification.object;
    NSIndexPath *healthIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    [(ClusterHealthViewCell*)[self.clusterHealthView cellForItemAtIndexPath:healthIndexPath] detailLabel].text = [NSString stringWithFormat:@"%@ %@", self.currentTimeString, [ClusterData shareInstance].unitArray[0]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstController"] isEqualToString:@"YES"]) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        [[CephAPI shareInstance] startGetClusterDetailAtBackgroundCompletion:^(BOOL finished) {
            if (finished) {
                [[NotificationData shareInstance] restartTimerWithTimeInterval:10];
                [SVProgressHUD dismiss];
            }
        } error:^(id error) {
            if (error) {
                [[NotificationData shareInstance] restartTimerWithTimeInterval:10];
                [SVProgressHUD dismiss];
                NSLog(@"%@", error);
            }
        }];
    }
    
    [self getData];

    self.currentTimeString = @"0";
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHealthCardAction:) name:@"timeAddAction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAction) name:@"didRefreshAction" object:nil];
    self.navigationController.navigationBar.translucent = NO;
    self.flowLayout = [[ClusterHealthViewFlowLayout alloc] init];
    self.clusterHealthView = [[ClusterHealthView alloc] initWithFrame:self.view.frame collectionViewLayout:self.flowLayout];
    [self.clusterHealthView registerClass:[ClusterHealthViewCell class] forCellWithReuseIdentifier:@"HealthViewCell"];
    self.view = self.clusterHealthView;
    self.clusterHealthView.delegate = self;
    self.clusterHealthView.dataSource = self;
}

- (void) refreshAction {
    [self getData];
    [self.clusterHealthView reloadData];
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
    cell.statusLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:[ClusterData shareInstance].serviceNameArray[indexPath.row]][0];
    [cell.bottomBar setWarningValue:[[NSUserDefaults standardUserDefaults] objectForKey:[ClusterData shareInstance].serviceNameArray[indexPath.row]][2]];
    [cell.bottomBar setErrorValue:[[NSUserDefaults standardUserDefaults] objectForKey:[ClusterData shareInstance].serviceNameArray[indexPath.row]][3]];
    float height;
    if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
        height = ((CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85) / 2;
    } else {
        height = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;
    }
    if (indexPath.row == 0) {
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
        cell.bottomBar.warningTextLabel.text = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"health_card_bottombar_mon"];
        cell.layer.borderColor = [UIColor okGreenColor].CGColor;
        cell.bottomBar.errorLabel.textColor = [UIColor defaultGrayColor];
        cell.bottomBar.warningLabel.textColor = [UIColor defaultGrayColor];
    } else if (indexPath.row == 5) {
        cell.bottomBar.errorTextLabel.text = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"health_card_Dirty"];
        cell.bottomBar.warningTextLabel.text = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"health_card_Working"];
    } else if (indexPath.row == 6) {
        cell.bottomBar.errorTextLabel.text = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"health_card_available"];
        cell.bottomBar.warningTextLabel.text = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"health_card_used"];
        cell.bottomBar.errorLabel.textColor = [UIColor okGreenColor];
    } else {
        cell.bottomBar.errorTextLabel.text = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"health_card_errors"];
        cell.bottomBar.warningTextLabel.text = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"health_card_warnings"];
    }
    
    if (indexPath.row == 7) {
        cell.bottomBar.alpha = 0;
        cell.detailLabel.alpha = 0;
        cell.iopsChartView.alpha = 1;

        cell.iopsChartView.maxLabel.text = [NSString stringWithFormat:@"%d", [[[NSUserDefaults standardUserDefaults] objectForKey:@"iops_max"] intValue]];
        cell.iopsChartView.middleLabel.text = [NSString stringWithFormat:@"%d", [[NSString stringWithFormat:@"%f", ceil([[[NSUserDefaults standardUserDefaults] objectForKey:@"iops_max"] floatValue] / 2.0)] intValue]];
        [cell.iopsChartView setDataWithDataArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"iops"]];
        if ([cell.iopsChartView.maxLabel.text integerValue] > 1000) {
            cell.iopsChartView.maxLabel.text = [[[[ClusterData shareInstance] caculateByte:[[NSString stringWithFormat:@"%d", [[[NSUserDefaults standardUserDefaults] objectForKey:@"iops_max"] intValue]] doubleValue]] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"B" withString:@""];
            cell.iopsChartView.middleLabel.text = [[[[ClusterData shareInstance] caculateByte:[[NSString stringWithFormat:@"%d", [[[NSUserDefaults standardUserDefaults] objectForKey:@"iops_max"] intValue]] doubleValue] / 2.0] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"B" withString:@""];
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
        if (indexPath.row == 0) {
            cell.detailLabel.text = [NSString stringWithFormat:@"%@ %@", self.currentTimeString, [ClusterData shareInstance].unitArray[indexPath.row]];
        } else {
            cell.detailLabel.text = [NSString stringWithFormat:@"%@%@", [[NSUserDefaults standardUserDefaults] objectForKey:[ClusterData shareInstance].serviceNameArray[indexPath.row]][1], [ClusterData shareInstance].unitArray[indexPath.row]];
        }
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
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"refresh"] isEqualToString:@"did"] && [ClusterData shareInstance].clusterArray.count > 0) {
        NSString *healthStatus;
        if ([[[ClusterData shareInstance] getCurrentStatusWithID:[ClusterData shareInstance].clusterArray[0][@"id"]] isEqualToString:@"HEALTH_ERROR"]) {
            healthStatus = @"ERROR";
        } else if ([[[ClusterData shareInstance] getCurrentStatusWithID:[ClusterData shareInstance].clusterArray[0][@"id"]] isEqualToString:@"HEALTH_WARN"]) {
            healthStatus = @"WARNING";
        } else {
            healthStatus = @"OK";
        }
        
        NSString *healthServiceKey = [ClusterData shareInstance].serviceNameArray[0];
        NSString *osdServiceKey = [ClusterData shareInstance].serviceNameArray[1];
        NSString *monServiceKey = [ClusterData shareInstance].serviceNameArray[2];
        NSString *poolServiceKey = [ClusterData shareInstance].serviceNameArray[3];
        NSString *hostServiceKey = [ClusterData shareInstance].serviceNameArray[4];
        NSString *pgServiceKey = [ClusterData shareInstance].serviceNameArray[5];
        NSString *usageServiceKey = [ClusterData shareInstance].serviceNameArray[6];
        NSString *iopsServiceKey = [ClusterData shareInstance].serviceNameArray[7];
        
        NSString *poolStatus = [[ClusterData shareInstance] getCurrentValueWithStatus:@"ok" service:poolServiceKey clusterID:[ClusterData shareInstance].clusterArray[0][@"id"]];
        NSString *pgStatus = [[ClusterData shareInstance] getCurrentValueWithStatus:@"ok" service:pgServiceKey clusterID:[ClusterData shareInstance].clusterArray[0][@"id"]];
        NSString *usageStatus = [[ClusterData shareInstance] getCurrentValueWithStatus:@"ok" service:usageServiceKey clusterID:[ClusterData shareInstance].clusterArray[0][@"id"]];
        NSString *osdStatus = [[ClusterData shareInstance] getCurrentValueWithStatus:@"ok" service:osdServiceKey clusterID:[ClusterData shareInstance].clusterArray[0][@"id"]];
        NSString *monStatus = [[ClusterData shareInstance] getCurrentValueWithStatus:@"ok" service:monServiceKey clusterID:[ClusterData shareInstance].clusterArray[0][@"id"]];
        NSString *hostStatus = [[ClusterData shareInstance] getCurrentValueWithStatus:@"ok" service:hostServiceKey clusterID:[ClusterData shareInstance].clusterArray[0][@"id"]];
        NSString *hostWarning = [[ClusterData shareInstance] getCurrentValueWithStatus:@"Warn" service:hostServiceKey clusterID:[ClusterData shareInstance].clusterArray[0][@"id"]];
        NSString *hostError = [[ClusterData shareInstance] getCurrentValueWithStatus:@"Error" service:hostServiceKey clusterID:[ClusterData shareInstance].clusterArray[0][@"id"]];
        NSString *healthWarning = [[ClusterData shareInstance] getCurrentValueWithStatus:@"Warn" service:healthServiceKey clusterID:[ClusterData shareInstance].clusterArray[0][@"id"]];
        NSString *healthError = [[ClusterData shareInstance] getCurrentValueWithStatus:@"Error" service:healthServiceKey clusterID:[ClusterData shareInstance].clusterArray[0][@"id"]];
        NSString *osdWarning = [[ClusterData shareInstance] getCurrentValueWithStatus:@"Warn" service:osdServiceKey clusterID:[ClusterData shareInstance].clusterArray[0][@"id"]];
        NSString *osdError = [[ClusterData shareInstance] getCurrentValueWithStatus:@"Error" service:osdServiceKey clusterID:[ClusterData shareInstance].clusterArray[0][@"id"]];
        NSString *monWarning = [[ClusterData shareInstance] getCurrentValueWithStatus:@"Warn" service:monServiceKey clusterID:[ClusterData shareInstance].clusterArray[0][@"id"]];
        NSString *monError = [[ClusterData shareInstance] getCurrentValueWithStatus:@"Error" service:monServiceKey clusterID:[ClusterData shareInstance].clusterArray[0][@"id"]];
        NSString *pgWarning = [[ClusterData shareInstance] getCurrentValueWithStatus:@"Warn" service:pgServiceKey clusterID:[ClusterData shareInstance].clusterArray[0][@"id"]];
        NSString *pgError = [[ClusterData shareInstance] getCurrentValueWithStatus:@"Error" service:pgServiceKey clusterID:[ClusterData shareInstance].clusterArray[0][@"id"]];
        NSString *usageWarning = [[ClusterData shareInstance] getCurrentValueWithStatus:@"Warn" service:usageServiceKey clusterID:[ClusterData shareInstance].clusterArray[0][@"id"]];
        NSString *usageError = [[ClusterData shareInstance] getCurrentValueWithStatus:@"Error" service:usageServiceKey clusterID:[ClusterData shareInstance].clusterArray[0][@"id"]];
        NSString *iopsTriger = [[ClusterData shareInstance] getCurrentValueWithStatus:@"ok" service:iopsServiceKey clusterID:[ClusterData shareInstance].clusterArray[0][@"id"]];
        NSLog(@"%@", iopsTriger);
        [[NSUserDefaults standardUserDefaults] setObject:@[healthStatus, @"", healthWarning, healthError] forKey:[ClusterData shareInstance].serviceNameArray[0]];
        [[NSUserDefaults standardUserDefaults] setObject:@[osdStatus, @"", osdWarning, osdError] forKey:[ClusterData shareInstance].serviceNameArray[1]];
        [[NSUserDefaults standardUserDefaults] setObject:@[monStatus, @"", monWarning, monError] forKey:[ClusterData shareInstance].serviceNameArray[2]];
        [[NSUserDefaults standardUserDefaults] setObject:@[poolStatus, @"", @"0", @"0"] forKey:[ClusterData shareInstance].serviceNameArray[3]];
        [[NSUserDefaults standardUserDefaults] setObject:@[hostStatus, @"", hostWarning, hostError] forKey:[ClusterData shareInstance].serviceNameArray[4]];
        [[NSUserDefaults standardUserDefaults] setObject:@[pgStatus, @"", pgWarning, pgError] forKey:[ClusterData shareInstance].serviceNameArray[5]];
        [[NSUserDefaults standardUserDefaults] setObject:@[usageStatus, @"", usageWarning, usageError] forKey:[ClusterData shareInstance].serviceNameArray[6]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
