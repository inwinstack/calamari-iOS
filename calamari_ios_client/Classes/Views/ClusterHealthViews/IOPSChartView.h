//
//  IOPSChartView.h
//  inWinStackCeph
//
//  Created by Francis on 2015/6/17.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IOPSChartView : UIView

@property (nonatomic, strong) UILabel *maxLabel;
@property (nonatomic, strong) UILabel *middleLabel;

- (void) setDataWithDataArray:(NSMutableArray*)dataArray;

@end
