//
//  ClusterHealthViewCell.h
//  inWinStackCeph
//
//  Created by Francis on 2015/4/13.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClusterHealthCellBar.h"
#import "ClusterHealthProgressLayer.h"
#import "IOPSChartView.h"

@interface ClusterHealthViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UIImageView *vectorImage;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) ClusterHealthCellBar *bottomBar;
@property (nonatomic, strong) ClusterHealthProgressLayer *progress;
@property (nonatomic, strong) IOPSChartView *iopsChartView;

- (void) addProgress;
- (void) removeProgress;

@end
