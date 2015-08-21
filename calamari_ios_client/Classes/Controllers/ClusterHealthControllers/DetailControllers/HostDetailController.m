//
//  HostDetailController.m
//  inWinStackCeph
//
//  Created by Francis on 2015/7/2.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "HostDetailController.h"
#import "UIColor+Reader.h"
#import "HostDetailView.h"
#import "HostDetailViewCell.h"
#import "HostDetailHeaderView.h"
#import "HostHealthData.h"
#import "CephAPI.h"
#import "UserData.h"
#import "ErrorView.h"
#import "SVProgressHUD.h"

@interface HostDetailController () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, ErrorDelegate> {
    float tempX;
    float endX;
}

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *keyArray;
@property (nonatomic, strong) ErrorView *errorView;
@property (nonatomic) HostDetailType currentType;

@end

@implementation HostDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButtonDisplay:YES];
    self.navigationItem.title = self.navigationTitle;
    self.hostDetailView = [[HostDetailView alloc] initWithFrame:self.view.frame];
    self.view = self.hostDetailView;
    
    self.hostDetailView.hostDetailCollectionView.delegate = self;
    self.hostDetailView.hostDetailCollectionView.dataSource = self;
    [self.hostDetailView.hostDetailCollectionView registerClass:[HostDetailViewCell class] forCellWithReuseIdentifier:@"HostDetailViewCellIdentifier"];
    [self.hostDetailView.headerView.allCPUButton addTarget:self action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.hostDetailView.headerView.summaryButton addTarget:self action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.hostDetailView.headerView.iopsButton addTarget:self action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    self.currentType = HostDetailSummaryType;
    [self.hostDetailView.headerView setHeaderType:self.currentType];
    tempX = 0;
    endX = 0;
    self.errorView = [[ErrorView alloc] initWithFrame:self.view.frame title:@"系統訊息" message:@"連線錯誤"];
    self.errorView.delegate = self;
    
    self.titleArray = @[@"CPU Summary", @"Load Average", @"Memory"];
    self.keyArray = @[@"percent", @"average", @"byte"];
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
    switch (self.currentType) {
        case HostDetailSummaryType: {
            return 3;
            break;
        } case HostDetailAllCpuType: {
            return [[HostHealthData shareInstance].hostDic[[NSString stringWithFormat:@"%@_cpu", self.navigationTitle]] count];
            break;
        } case HostDetailIOPSType: {
            return [[HostHealthData shareInstance].hostDic[[NSString stringWithFormat:@"%@_iostat", self.navigationTitle]] count];
            break;
        }
    }
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HostDetailViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HostDetailViewCellIdentifier" forIndexPath:indexPath];
    switch (self.currentType) {
        case HostDetailAllCpuType: {
            NSString *tempAllCPUKey = [HostHealthData shareInstance].hostAllCPUKeyArray[indexPath.row];
            cell.titleLabel.text = [NSString stringWithFormat:@"%@", [HostHealthData shareInstance].hostDic[[NSString stringWithFormat:@"%@_cpu", self.navigationTitle]][tempAllCPUKey][@"text"]];
            NSString *max = [HostHealthData shareInstance].hostDic[[NSString stringWithFormat:@"%@_cpu_max", tempAllCPUKey]];
            NSString *mid = [NSString stringWithFormat:@"%d", [max intValue] / 2];
            [cell setCurrentType:CPUSquareType maxValue:max midValue:mid dataArray:[HostHealthData shareInstance].hostDic[[NSString stringWithFormat:@"%@_cpu", tempAllCPUKey]] calcalate:NO];
            break;
        } case HostDetailSummaryType: {
            cell.titleLabel.text = self.titleArray[indexPath.row];
            NSString *max = [HostHealthData shareInstance].hostDic[[NSString stringWithFormat:@"%@_%@_max", self.navigationTitle, self.keyArray[indexPath.row]]];
            NSString *mid = [NSString stringWithFormat:@"%lld", [max longLongValue] / 2];

            if (indexPath.row == 1) {
                NSString *midValue = [NSString stringWithFormat:@"%.1f", [max doubleValue] / 2.0];
                [cell setCurrentType:CPUBrokenLineType maxValue:max midValue:midValue dataArray:[HostHealthData shareInstance].hostDic[[NSString stringWithFormat:@"%@_%@", self.navigationTitle, self.keyArray[indexPath.row]]] calcalate:NO];
            } else if (indexPath.row == 2) {
                [cell setCurrentType:CPUBrokenLineFillType maxValue:max midValue:mid dataArray:[HostHealthData shareInstance].hostDic[[NSString stringWithFormat:@"%@_%@", self.navigationTitle, self.keyArray[indexPath.row]]] calcalate:YES];
            } else {
                [cell setCurrentType:CPUBrokenLineFillType maxValue:max midValue:mid dataArray:[HostHealthData shareInstance].hostDic[[NSString stringWithFormat:@"%@_%@", self.navigationTitle, self.keyArray[indexPath.row]]] calcalate:NO];
            }
            break;
        } case HostDetailIOPSType: {
            NSString *max = [NSString stringWithFormat:@"%@", [HostHealthData shareInstance].hostDic[[NSString stringWithFormat:@"%@_cpuiops_max", [HostHealthData shareInstance].hostDic[[NSString stringWithFormat:@"%@_iostat", self.navigationTitle]][indexPath.row][@"id"]]]];
            NSString *mid = [NSString stringWithFormat:@"%d", [max intValue] / 2];
            cell.titleLabel.text = [NSString stringWithFormat:@"%@", [HostHealthData shareInstance].hostDic[[NSString stringWithFormat:@"%@_iostat", self.navigationTitle]][indexPath.row][@"text"]];
            [cell setCurrentType:CPUBrokenLineIOPSType maxValue:max midValue:mid dataArray:[HostHealthData shareInstance].hostDic[[NSString stringWithFormat:@"%@_cpuiops", [HostHealthData shareInstance].hostDic[[NSString stringWithFormat:@"%@_iostat", self.navigationTitle]][indexPath.row][@"id"]]] calcalate:NO];
            break;
        }
    }
    return cell;
}

- (void) didSelectButton:(UIButton*)selectedButton {
    self.currentType = selectedButton.tag;
    self.hostDetailView.userInteractionEnabled = NO;
    [self.hostDetailView.headerView setHeaderType:self.currentType];
    switch (selectedButton.tag) {
        case HostDetailAllCpuType: {
            [(UIScrollView*)selectedButton.superview scrollRectToVisible:CGRectMake(CGRectGetMidX(selectedButton.superview.frame), 0, CGRectGetWidth(selectedButton.superview.frame), CGRectGetHeight(selectedButton.superview.frame)) animated:YES];
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
            [[CephAPI shareInstance] startGetAllDataWithIP:[UserData shareInstance].ipString Port:[UserData shareInstance].portString nodeID:self.navigationTitle whichType:@"cpu" Completion:^(BOOL finished) {
                if (finished) {
                    [[CephAPI shareInstance] startGetAllCPUDataWithIP:[UserData shareInstance].ipString Port:[UserData shareInstance].portString cpuArray:[HostHealthData shareInstance].hostAllCPUKeyArray Completion:^(BOOL finished) {
                        if (finished) {
                            [SVProgressHUD dismiss];
                            self.hostDetailView.userInteractionEnabled = YES;
                            [self.hostDetailView.hostDetailCollectionView reloadData];
                        }
                    } error:^(id error) {
                        [SVProgressHUD dismiss];
                        self.hostDetailView.userInteractionEnabled = YES;
                        [self.view addSubview:self.errorView];
                        NSLog(@"%@", error);
                    }];
                }
            } error:^(id error) {
                [SVProgressHUD dismiss];
                self.hostDetailView.userInteractionEnabled = YES;
                [self.view addSubview:self.errorView];
                NSLog(@"%@", error);
            }];
            break;
        } case HostDetailSummaryType: {
            [(UIScrollView*)selectedButton.superview scrollRectToVisible:CGRectMake(0, 0, CGRectGetWidth(selectedButton.superview.frame), CGRectGetHeight(selectedButton.superview.frame)) animated:YES];
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
            [[CephAPI shareInstance] startGetCPUSummaryDataWithIP:[UserData shareInstance].ipString Port:[UserData shareInstance].portString nodeID:self.navigationTitle Completion:^(BOOL finished) {
                if (finished) {
                    [SVProgressHUD dismiss];
                    self.hostDetailView.userInteractionEnabled = YES;
                    [self.hostDetailView.hostDetailCollectionView reloadData];
                }
            } error:^(id error) {
                [SVProgressHUD dismiss];
                self.hostDetailView.userInteractionEnabled = YES;
                [self.view addSubview:self.errorView];
                NSLog(@"%@", error);
            }];
            break;
        } case HostDetailIOPSType: {
            [(UIScrollView*)selectedButton.superview scrollRectToVisible:CGRectMake(CGRectGetMaxX(selectedButton.superview.frame), 0, CGRectGetWidth(selectedButton.superview.frame), CGRectGetHeight(selectedButton.superview.frame)) animated:YES];
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
            [[CephAPI shareInstance] startGetAllDataWithIP:[UserData shareInstance].ipString Port:[UserData shareInstance].portString nodeID:self.navigationTitle whichType:@"iostat" Completion:^(BOOL finished) {
                if (finished) {
                    [[CephAPI shareInstance] startGetCPUIOPSDataWithIP:[UserData shareInstance].ipString Port:[UserData shareInstance].portString iopsArray:[HostHealthData shareInstance].hostDic[[NSString stringWithFormat:@"%@_iostat", self.navigationTitle]] Completion:^(BOOL finished) {
                        if (finished) {
                            [SVProgressHUD dismiss];
                            self.hostDetailView.userInteractionEnabled = YES;
                            [self.hostDetailView.hostDetailCollectionView reloadData];
                        }
                    } error:^(id error) {
                        [SVProgressHUD dismiss];
                        self.hostDetailView.userInteractionEnabled = YES;
                        [self.view addSubview:self.errorView];
                        NSLog(@"%@", error);
                    }];
                }
            } error:^(id error) {
                [SVProgressHUD dismiss];
                self.hostDetailView.userInteractionEnabled = YES;
                [self.view addSubview:self.errorView];
                NSLog(@"%@", error);
            }];
            break;
        }
    }
}

- (void) didConfirm {
    [self.errorView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
