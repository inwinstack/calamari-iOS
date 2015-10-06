//
//  OSDHealthController.m
//  inWinStackCeph
//
//  Created by Francis on 2015/5/18.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "OSDHealthController.h"
#import "UIColor+Reader.h"
#import "OSDHealthView.h"
#import "OSDHealthViewCell.h"
#import "OSDHeaderView.h"
#import "OSDViewFLowLayout.h"
#import "OSDHealthData.h"
#import "OSDDetailController.h"
#import "CephAPI.h"
#import "APIRecord.h"
#import "UserData.h"
#import "ClusterData.h"
#import "ErrorView.h"
#import "SVProgressHUD.h"

@interface OSDHealthController () <DidReceiveButtonDelegate, ErrorDelegate> {
    NSInteger currentIndex;
}

@property (nonatomic, strong) NSMutableArray *warnArray;
@property (nonatomic, strong) NSMutableArray *errorArray;

@end

@implementation OSDHealthController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:[UIColor oceanHealthBarColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButtonDisplay:YES];
    self.navigationItem.title = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"main_activity_fragment_osd_health"];
    
    self.flowLayout = [[OSDViewFLowLayout alloc] init];
    self.osdHealthView = [[OSDHealthView alloc] initWithFrame:self.view.frame collectionViewLayout:self.flowLayout];
    self.osdHealthView.delegate = self;
    self.osdHealthView.dataSource = self;
    self.view = self.osdHealthView;
    [self.osdHealthView registerClass:[OSDHealthViewCell class] forCellWithReuseIdentifier:@"OSDHealthCell"];
    [self.osdHealthView registerClass:[OSDHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"OSDHeaderView"];
    currentIndex = 0;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (currentIndex) {
        case 0: {
            return [[[ClusterData shareInstance] getCurrentValueWithStatus:@"ok" service:@"OSD" clusterID:[[NSUserDefaults standardUserDefaults] objectForKey:@"ClusterID"]] integerValue] + [[[ClusterData shareInstance] getCurrentValueWithStatus:@"Error" service:@"OSD" clusterID:[[NSUserDefaults standardUserDefaults] objectForKey:@"ClusterID"]] integerValue] + [[[ClusterData shareInstance] getCurrentValueWithStatus:@"Warn" service:@"OSD" clusterID:[[NSUserDefaults standardUserDefaults] objectForKey:@"ClusterID"]] integerValue];
            break;
        } case 1: {
            return self.warnArray.count;
            break;
        } case 2: {
            return self.errorArray.count;
            break;
        }
    }
    return -1;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.osdHealthView.userInteractionEnabled = NO;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[CephAPI shareInstance] startGetOSDDataWithIP:[[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"] Port:[[NSUserDefaults standardUserDefaults] objectForKey:@"Port"] ClusterID:[[NSUserDefaults standardUserDefaults] objectForKey:@"ClusterID"] OSDID:[(OSDHealthViewCell*)[collectionView cellForItemAtIndexPath:indexPath] numberLabel].text completion:^(BOOL finished) {
        if (finished) {
            [SVProgressHUD dismiss];
            self.osdHealthView.userInteractionEnabled = YES;
            self.osdDetailController = [[OSDDetailController alloc] init];
            if ([[collectionView cellForItemAtIndexPath:indexPath].backgroundColor isEqual:[UIColor warningColor]]) {
                self.osdDetailController.OSDdetailType = OSDDetailWarnType;
            } else if ([[collectionView cellForItemAtIndexPath:indexPath].backgroundColor isEqual:[UIColor errorColor]]) {
                self.osdDetailController.OSDdetailType = OSDDetailErrorType;
            } else {
                self.osdDetailController.OSDdetailType = OSDDetailOKType;
            }
            self.osdDetailController.currentIndex = [[(OSDHealthViewCell*)[collectionView cellForItemAtIndexPath:indexPath] numberLabel].text integerValue];
            [self.navigationController pushViewController:self.osdDetailController animated:YES];
        }
    } error:^(id error) {
        self.osdHealthView.userInteractionEnabled = YES;
        self.errorView = [[ErrorView alloc] initWithFrame:self.view.frame title:@"系統訊息" message:@"連線錯誤"];
        self.errorView.delegate = self;
        [self.view addSubview:self.errorView];
        NSLog(@"%@", error);
    }];

}

- (void) collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    cell.alpha = 0;
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationCurveEaseIn | UIViewAnimationCurveEaseOut | UIViewAnimationCurveEaseInOut animations:^{
        cell.alpha = 1;
    } completion:^(BOOL finished) {
        cell.alpha = 1;
    }];
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OSDHealthViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OSDHealthCell" forIndexPath:indexPath];
    switch (currentIndex) {
        case 0: {
            if ([[NSString stringWithFormat:@"%@", [OSDHealthData shareInstance].osdArray[indexPath.row][@"in"]] isEqualToString:@"0"] && [[NSString stringWithFormat:@"%@", [OSDHealthData shareInstance].osdArray[indexPath.row][@"up"]] isEqualToString:@"0"]) {
                cell.backgroundColor = [UIColor errorColor];
            } else if ([[NSString stringWithFormat:@"%@", [OSDHealthData shareInstance].osdArray[indexPath.row][@"in"]] isEqualToString:@"0"] || [[NSString stringWithFormat:@"%@", [OSDHealthData shareInstance].osdArray[indexPath.row][@"up"]] isEqualToString:@"0"]) {
                cell.backgroundColor = [UIColor warningColor];
            } else {
                cell.backgroundColor = [UIColor okGreenColor];
            }
            cell.numberLabel.text = [NSString stringWithFormat:@"%@", [OSDHealthData shareInstance].osdArray[indexPath.row][@"id"]];
            break;
        } case 1: {
            cell.backgroundColor = [UIColor warningColor];
            cell.numberLabel.text = [NSString stringWithFormat:@"%@", self.warnArray[indexPath.row][@"id"]];
            break;
        } case 2: {
            cell.backgroundColor = [UIColor errorColor];
            cell.numberLabel.text = [NSString stringWithFormat:@"%@", self.errorArray[indexPath.row][@"id"]];
            break;
        }
    }
    return cell;
}

- (UICollectionReusableView*) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *collectionReusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        OSDHeaderView *osdHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"OSDHeaderView" forIndexPath:indexPath];
        [osdHeaderView setCurrentButton:currentIndex];
        osdHeaderView.delegate = self;
        collectionReusableView = osdHeaderView;
    }
    return collectionReusableView;
}

- (void) didReceviButton:(UIButton *)button {
    self.warnArray = [NSMutableArray array];
    self.errorArray = [NSMutableArray array];
    currentIndex = button.tag;
    for (id object in [OSDHealthData shareInstance].osdArray) {
        if ([[NSString stringWithFormat:@"%@", object[@"in"]] isEqualToString:@"0"] && [[NSString stringWithFormat:@"%@", object[@"up"]] isEqualToString:@"0"]) {
            [self.errorArray addObject:object];
        } else if ([[NSString stringWithFormat:@"%@", object[@"in"]] isEqualToString:@"0"] || [[NSString stringWithFormat:@"%@", object[@"up"]] isEqualToString:@"0"]) {
            [self.warnArray addObject:object];
        }
    }
    switch (currentIndex) {
        case 0: {
            [self osdHealthOKRemove];
            break;
        } case 1: {
            if (self.warnArray.count == 0) {
                [self osdHealthOKDisplay];
            } else {
                [self osdHealthOKRemove];
            }
            break;
        } case 2: {
            if (self.errorArray.count == 0) {
                [self osdHealthOKDisplay];
            } else {
                [self osdHealthOKRemove];

            }
            break;
        }
    }
    [self.osdHealthView reloadData];
}

- (void) osdHealthOKDisplay {
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationCurveEaseIn | UIViewAnimationCurveEaseOut | UIViewAnimationCurveEaseInOut animations:^{
        self.osdHealthView.okView.alpha = 1;
        self.osdHealthView.okLabel.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void) osdHealthOKRemove {
    
    self.osdHealthView.okView.alpha = 0;
    self.osdHealthView.okLabel.alpha = 0;
}

- (void) didConfirm {
    [self.errorView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
