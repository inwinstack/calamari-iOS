//
//  ChartController.m
//  inWinStackCeph
//
//  Created by Francis on 2015/4/15.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "ChartController.h"
#import "ChartView.h"
#import "ChartCell.h"
#import "ChartFlowLayout.h"

@interface ChartController () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation ChartController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.flowlayout = [[ChartFlowLayout alloc] init];
    self.chartView = [[ChartView alloc] initWithFrame:self.view.frame collectionViewLayout:self.flowlayout];
    [self.chartView registerClass:[ChartCell class] forCellWithReuseIdentifier:@"ChartCellIdentifier"];
    self.view = self.chartView;
    self.chartView.delegate = self;
    self.chartView.dataSource = self;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(self.view.frame.size.width, self.tabBarController.tabBar.frame.size.height + 10);
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChartCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChartCellIdentifier" forIndexPath:indexPath];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
