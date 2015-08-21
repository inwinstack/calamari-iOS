//
//  PoolListController.m
//  inWinStackCeph
//
//  Created by Francis on 2015/6/30.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "PoolListController.h"
#import "PoolListView.h"
#import "UIColor+Reader.h"
#import "ClusterData.h"
#import "PoolListViewCell.h"

@interface PoolListController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation PoolListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackButtonDisplay:YES];
    self.navigationItem.title = @"Pool List";
    
    self.poolListView = [[PoolListView alloc] initWithFrame:self.view.frame];
    self.poolListView.dataSource = self;
    self.poolListView.delegate = self;
    self.view = self.poolListView;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_pool_list", [ClusterData shareInstance].clusterArray[0][@"id"]]] count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PoolListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PoolListCellIdentifier"];
    if (!cell) {
        cell = [[PoolListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PoolListCellIdentifier"];
    }
    cell.nameLabel.text = [NSString stringWithFormat:@"%@", [ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_pool_list", [ClusterData shareInstance].clusterArray[0][@"id"]]][indexPath.row][@"name"]];
    cell.idLabel.text = [NSString stringWithFormat:@"# %@", [ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_pool_list", [ClusterData shareInstance].clusterArray[0][@"id"]]][indexPath.row][@"id"]];
    cell.replicasNumberLabel.text = [NSString stringWithFormat:@"%@", [ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_pool_list", [ClusterData shareInstance].clusterArray[0][@"id"]]][indexPath.row][@"size"]];
    cell.pgNumberLabel.text = [NSString stringWithFormat:@"%@", [ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_pool_list", [ClusterData shareInstance].clusterArray[0][@"id"]]][indexPath.row][@"pg_num"]];
    [cell reloadLayout];
    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.alpha = 0;
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationCurveEaseIn | UIViewAnimationCurveEaseOut | UIViewAnimationCurveEaseInOut animations:^{
        cell.alpha = 1;
    } completion:^(BOOL finished) {
        cell.alpha = 1;
    }];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CGRectGetWidth([UIScreen mainScreen].bounds) * 0.43;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
