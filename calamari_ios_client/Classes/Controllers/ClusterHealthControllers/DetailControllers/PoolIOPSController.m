//
//  PoolIOPSController.m
//  inWinStackCeph
//
//  Created by Francis on 2015/6/30.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "PoolIOPSController.h"
#import "UIColor+Reader.h"
#import "PoolIOPSView.h"
#import "ClusterData.h"
#import "PoolIOPSViewCell.h"
#import "PoolIOPSViewFlowLayout.h"
#import "DateMaker.h"
#import "ClusterData.h"

@interface PoolIOPSController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) PoolIOPSViewFlowLayout *flowLayout;

@end

@implementation PoolIOPSController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButtonDisplay:YES];
    self.navigationItem.title = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"main_activity_fragment_pool_iops"];
    
    self.flowLayout = [[PoolIOPSViewFlowLayout alloc] init];
    
    self.poolIOPSView = [[PoolIOPSView alloc] initWithFrame:self.view.frame collectionViewLayout:self.flowLayout];
    self.poolIOPSView.delegate = self;
    self.poolIOPSView.dataSource = self;
    self.view = self.poolIOPSView;
    
    [self.poolIOPSView registerClass:[PoolIOPSViewCell class] forCellWithReuseIdentifier:@"PoolIOPSCell"];

}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_pool", [ClusterData shareInstance].clusterArray[0][@"id"]]] count] + 1;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PoolIOPSViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PoolIOPSCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"Aggregate IOPS";
        NSString *poolID = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"ceph.cluster.%@.pool.all", [ClusterData shareInstance].clusterArray[0][@"id"]]];
        cell.chartView.maxLabel.text = [NSString stringWithFormat:@"%@", [ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_pool_iops_max", poolID]]];
        cell.chartView.midYLabel.text = [NSString stringWithFormat:@"%.1f", [[ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_pool_iops_max", poolID]] floatValue] / 2.0];
        [cell.chartView setDataWithDataArray:[ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_pool_iops", poolID]]];
        if ([cell.chartView.maxLabel.text integerValue] > 1000) {
            cell.chartView.maxLabel.text = [[[[ClusterData shareInstance] caculateByte:[[NSString stringWithFormat:@"%@", [ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_pool_iops_max", poolID]]] doubleValue]] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"B" withString:@""];
            cell.chartView.midYLabel.text = [[[[ClusterData shareInstance] caculateByte:[[NSString stringWithFormat:@"%@", [ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_pool_iops_max", poolID]]] doubleValue] / 2.0] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"B" withString:@""];
        }
        
    } else {
        cell.titleLabel.text = [ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_pool", [ClusterData shareInstance].clusterArray[0][@"id"]]][indexPath.row - 1][@"name"];
        NSString *poolID = [NSString stringWithFormat:@"%@", [ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_pool", [ClusterData shareInstance].clusterArray[0][@"id"]]][indexPath.row - 1][@"id"]];
        for (id poolObject in [ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_iops_ID", [ClusterData shareInstance].clusterArray[0][@"id"]]]) {
            if ([[NSString stringWithFormat:@"%@", poolObject[@"text"]] isEqualToString:poolID]) {
                cell.chartView.maxLabel.text = [NSString stringWithFormat:@"%@", [ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_pool_iops_max", poolObject[@"id"]]]];
                cell.chartView.midYLabel.text = [NSString stringWithFormat:@"%.1f", [[ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_pool_iops_max", poolObject[@"id"]]] floatValue] / 2.0];
                [cell.chartView setDataWithDataArray:[ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_pool_iops", poolObject[@"id"]]]];
                if ([cell.chartView.maxLabel.text integerValue] > 1000) {
                    cell.chartView.maxLabel.text = [[[[ClusterData shareInstance] caculateByte:[[NSString stringWithFormat:@"%@", [ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_pool_iops_max", poolID]]] doubleValue]] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"B" withString:@""];
                    cell.chartView.midYLabel.text = [[[[ClusterData shareInstance] caculateByte:[[NSString stringWithFormat:@"%@", [ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_pool_iops_max", poolID]]] doubleValue] / 2.0] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"B" withString:@""];
                }
            }
        }
    }
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    cell.alpha = 0;
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationCurveEaseIn | UIViewAnimationCurveEaseOut | UIViewAnimationCurveEaseInOut animations:^{
        cell.alpha = 1;
    } completion:^(BOOL finished) {
        cell.alpha = 1;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
