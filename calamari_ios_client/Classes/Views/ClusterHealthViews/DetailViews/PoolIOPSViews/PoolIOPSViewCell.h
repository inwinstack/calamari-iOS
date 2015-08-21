//
//  PoolIOPSViewCell.h
//  inWinStackCeph
//
//  Created by Francis on 2015/6/30.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IOPSDetailChartView.h"

@interface PoolIOPSViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) IOPSDetailChartView *chartView;

@end
