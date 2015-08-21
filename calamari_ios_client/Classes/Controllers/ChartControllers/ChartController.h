//
//  ChartController.h
//  inWinStackCeph
//
//  Created by Francis on 2015/4/15.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChartFlowLayout;
@class ChartView;

@interface ChartController : UIViewController

@property (nonatomic, strong) ChartView *chartView;
@property (nonatomic, strong) ChartFlowLayout *flowlayout;

@end
