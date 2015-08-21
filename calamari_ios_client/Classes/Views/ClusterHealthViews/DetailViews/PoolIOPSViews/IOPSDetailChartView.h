//
//  IOPSDetailChartView.h
//  inWinStackCeph
//
//  Created by Francis on 2015/6/30.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IOPSDetailChartView : UIView

@property (nonatomic, strong) UILabel *maxLabel;
@property (nonatomic, strong) UILabel *midYLabel;

- (void) setDataWithDataArray:(NSMutableArray*)dataArray;

@end
