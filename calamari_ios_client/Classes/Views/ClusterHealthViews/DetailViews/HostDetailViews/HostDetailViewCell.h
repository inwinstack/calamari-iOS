//
//  HostDetailViewCell.h
//  inWinStackCeph
//
//  Created by Francis on 2015/7/3.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CPUChartType) {
    CPUSquareType = 0,
    CPUBrokenLineType,
    CPUBrokenLineFillType,
    CPUBrokenLineIOPSType,
};

@interface HostDetailViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;

- (void) setCurrentType:(CPUChartType)currentType maxValue:(NSString*)maxValue midValue:(NSString*)midValue dataArray:(NSMutableArray*)dataArray calcalate:(BOOL)calculate;

@end
